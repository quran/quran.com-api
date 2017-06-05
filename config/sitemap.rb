# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://quran.com"
SitemapGenerator::Sitemap.sitemaps_host = "http://static.quran.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
  Chapter.find_each do |chapter|
    add "/#{chapter.chapter_number}", priority: 1
    
    # Add chapter info for available languages
    ['en', 'ur', 'ml', 'ta'].each do |local|
      add "/#{chapter.chapter_number}/info/#{local}", priority: 1
    end
  end


  # Add all chapters
  Chapter.find_each do |chapter|
    add "/#{chapter.chapter_number}", priority: 1
  
    # Add chapter info for available languages
    ['en', 'ur', 'ml', 'ta'].each do |local|
      add "/#{chapter.chapter_number}/info/#{local}", priority: 1
    end
  end

  available_translations = ResourceContent.includes(:language).translations.one_verse.approved
  available_tafsirs      = ResourceContent.includes(:language).tafsirs.one_verse.approved

  # Add all verses
  Verse.find_each do |verse|
    verse_path = verse.verse_key.tr(':', '/')
    
    add "/#{verse_path}",  priority: 0.8
    
    # Add available translation for each verse
    available_translations.each do |trans|
      add "/#{verse_path}?translations=#{trans.slug || trans.id}",  priority: 0.8
    end
    
    # Add available tafsirs for each verse
    available_tafsirs.each do |tafsir|
      add "/#{verse_path}/tafsirs/#{tafsir.slug || tafsir.id}",  priority: 0.8
    end
  end

  # Static pages
  %w(about contactus contact donations contributions search).each do |url|
    add "/#{url}", priority: 0.3
  end
  
  # Add site locals
  %w(en ar ur id tr fr).each do |local|
    add "/?local=#{local}", priority: 0.3
  end
  
  add '/ayatul-kursi', priority: 1
end
