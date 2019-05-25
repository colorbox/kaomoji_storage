namespace :filter do
  desc 'filter raw_kaomojis'
  task raw_kaomojis: :environment do
    Tweet.not_bracket_filtered.find_in_batches(batch_size: 100_000) do |tweets|
      Parallel.each(tweets) do|tweet|
        tweet.create_raw_kaomojis
        pp "#{tweet.id}|#{Kaomoji.count}|#{tweet.kaomojis.map(&:kaomoji)}" if tweet.kaomojis.count > 0
      end
      Tweet.where(id:tweets.map(&:id)).update_all(bracket_filtered_at: DateTime.now)
    end
  end
end
