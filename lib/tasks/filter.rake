namespace :filter do
  desc 'filter raw_kaomojis'
  task raw_kaomojis: :environment do
    Tweet.not_filtered.find_in_batches(batch_size: 100_000) do |tweets|
      Parallel.each(tweets) do |tweet|
        tweet.create_raw_kaomojis
        pp tweet.kaomojis.map(&:kaomoji) if tweet.kaomojis.count > 0
      end
    end
  end
end
