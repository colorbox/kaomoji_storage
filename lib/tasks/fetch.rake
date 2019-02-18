require 'twitter_client'

namespace :fetch do
  USER_FETCH_LIMIT = 14
  USER_FETCH_COUNT = 200
  TIMELINE_TWEETS_FETCH_COUNT = 200
  TIMELINE_TWEETS_FETCH_LIMIT = 15

  desc 'fetch users from my followees'
  task users: :environment do
    client = TwitterClient.client

    params = {count: USER_FETCH_COUNT}

    followees = client.friends(params)
    users = followees.attrs[:users]
    USER_FETCH_LIMIT.times do
      params = params.merge(cursor: followees.attrs[:next_cursor])
      followees = client.friends(params)
      users.concat(followees.attrs[:users])
    end

    users.uniq.each do |followee|
      next if User.where(twitter_identifier: followee[:id_str]).first
      User.create(
        twitter_identifier: followee[:id_str],
        screen_name: followee[:screen_name],
        name: followee[:name]
      )
    end
  rescue Twitter::Error::TooManyRequests => error
    pp error.message
    pp error.backtrace
    pp 'sleep 15 minutes'
    sleep(60*15)
    retry
  end


  desc 'fetch tweet from users in storage'
  task tweets: :environment do
    User.not_fetch.each do |user|
      fetch_user_timeline(user)
      pp "#{Time.now.strftime('%Y/%m/%d %H:%M:%S')} #{Tweet.count.to_s(:delimited)}"
    end

  end

  def fetch_user_timeline(user)
    client = TwitterClient.client

    fetch_latest_params = {count: TIMELINE_TWEETS_FETCH_COUNT, user_id: user.twitter_identifier}
    tweets = client.user_timeline(fetch_latest_params)
    return if tweets.blank?
    TIMELINE_TWEETS_FETCH_LIMIT.times do
      fetch_latest_params = fetch_latest_params.merge(max_id: tweets.last.id.to_s)
      tweets.concat(client.user_timeline(fetch_latest_params))
    end

    tweets.uniq.each do |tweet|
      next if user.tweets.find {|t| t.tweet_identifier == tweet.id.to_s}
      user.tweets.create(
        tweet_identifier: tweet.id.to_s,
        text: tweet.text
      )
    end
  rescue Twitter::Error::TooManyRequests => error
    pp error.message
    pp error.backtrace
    pp 'sleep 15 minutes'
    sleep(60*15)
    retry
  end
end
