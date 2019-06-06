namespace :filter do
  desc 'filter raw_kaomojis'
  task raw_kaomojis: :environment do
    Tweet.not_bracket_filtered.find_in_batches(batch_size: 100_000) do |tweets|
      Parallel.each(tweets) do|tweet|
        tweet.create_raw_kaomojis
        pp "#{tweet.id}|#{Kaomoji.count}|#{tweet.kaomojis.map(&:kaomoji)}:#{tweet.text}" if tweet.kaomojis.count > 0
      end

      Tweet.where(id:tweets.map(&:id)).update_all(bracket_filtered_at: DateTime.now)
    end
  end

  desc 'filter with unicode'
  task unicode_kaomojis: :environment do
    Tweet.not_unicode_filtered.find_in_batches(batch_size: 100_000) do |tweets|
      Parallel.each(tweets, in_processes: 8) do|tweet|
        tweet.create_unicode_kaomojis
        # pp "#{tweet.id}|#{Kaomoji.count}|#{tweet.kaomojis.map(&:kaomoji)}" if tweet.kaomojis.count > 0
        # pp "#{tweet.id}|#{Kaomoji.count}|#{tweet.kaomojis.map(&:kaomoji)}:#{tweet.text}" if tweet.kaomojis.count > 0
      end

      pp "#{tweets.last.id}|#{Kaomoji.count}|#{Time.current}"
      Tweet.where(id:tweets.map(&:id)).update_all(unicode_filtered_at: DateTime.now)
    end
  end

  desc 'filter with bracket and line break'
  task has_bracket: :environment do
    brackets = '()（）'
    Kaomoji.find_each do |kaomoji|
      kaomoji.has_bracket = true if brackets.chars.map{|b|kaomoji.kaomoji.include?(b)}.any?
      kaomoji.has_line_break = true if kaomoji.kaomoji.count("\n") > 0
      kaomoji.save!
    end
  end
end
