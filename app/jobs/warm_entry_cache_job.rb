class WarmEntryCacheJob < ApplicationJob
  include CacheableEntry

  queue_as :caching
  sidekiq_options retry: 5

  def perform
    category = GetCategory.new(category_entry_id: ENV["CONTENTFUL_DEFAULT_CATEGORY_ENTRY_ID"]).call
    sections = GetSectionsFromCategory.new(category: category).call
    steps = sections.map { |section| GetStepsFromSection.new(section: section).call }

    # TODO: Cache category and sections too
    [steps].flatten.each do |entry|
      store_in_cache(cache: cache, key: "contentful:entry:#{entry.id}", entry: entry)
    end
  rescue GetStepsFromSection::RepeatEntryDetected
    cache.extend_ttl_on_all_entries
  end

  private

  def cache
    @cache ||= Cache.new(
      enabled: ENV.fetch("CONTENTFUL_ENTRY_CACHING"),
      ttl: ENV.fetch("CONTENTFUL_ENTRY_CACHING_TTL", 60 * 60 * 72)
    )
  end
end
