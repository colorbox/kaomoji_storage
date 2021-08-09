require 'twitter_client'

namespace :fetch do
  USER_FETCH_LIMIT = 14
  USER_FETCH_COUNT = 200
  TIMELINE_TWEETS_FETCH_COUNT = 200
  TIMELINE_TWEETS_FETCH_LIMIT = 15

  desc 'fetch specific user with screen_name'
  task :user_with_screen_name, [:screen_name] => :environment do |_, argv|
    abort 'there is no user' if argv&.screen_name.blank?

    client = TwitterClient.client
    user = client.user(argv.screen_name)

    abort "There is already #{argv.screen_name}" if User.where(twitter_identifier: user.id.to_s).present?

    User.create(
      twitter_identifier: user.id.to_s,
      screen_name: user.screen_name,
      name: user.name
    )

  rescue Twitter::Error::NotFound => error
    abort "there is no user:#{argv.screen_name}"
  end

  desc 'fetch followers from specific user'
  task :followers_from_screen_name, [:screen_name] => :environment do |_, argv|
    abort 'there is no user' if argv&.screen_name.blank?

    client = TwitterClient.friendly_client

    followers = client.followers(argv.screen_name)

    followers.each do |follower|
      pp "#{follower.screen_name}|#{follower.name}"
      next if User.where(twitter_identifier: follower.id.to_s).present?
      User.create(
        twitter_identifier: follower.id.to_s,
        screen_name: follower.screen_name,
        name: follower.name.nil? ? '' : follower.name
      )
    end
  rescue Twitter::Error::NotFound => error
    abort "there is no user:#{argv.screen_name}"
  rescue ActiveRecord::NotNullViolation => e
    pp e.inspect
    pp e.message
  end

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
    Parallel.each(User.not_fetch) do |user|
      fetch_user_timeline(user)
      if user.tweets.count.zero?
        pp "destroy with no tweets user :#{user.screen_name}|#{user.name}"
        user.destroy!
      else
        pp "#{Time.now.strftime('%Y/%m/%d %H:%M:%S')} #{Tweet.count.to_s(:delimited)} | fetched: @#{user.screen_name}(#{user.name})" if user.persisted?
      end
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
    pp error.inspect
    seconds = error.rate_limit.reset_in.to_i # or client.rate_limit.follower_ids[:reset_in]
    pp "sleep #{seconds} seconds"
    sleep seconds
    retry
  rescue Twitter::Error::Unauthorized, Twitter::Error::NotFound => error
    user.destroy!
    pp "destroy or watch :#{user.screen_name}|#{user.name}"
    pp error.inspect
  rescue Parallel::UndumpableException => e
    pp "something undumpable"
    pp e.message
    pp e.backtrace
    raise e
  rescue => e
    pp e.message
    pp e.backtrace
    raise e
  end
end
