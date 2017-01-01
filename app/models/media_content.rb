# == Schema Information
#
# Table name: media_contents
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  url                 :text
#  embed_text          :text
#  provider            :string
#  language_id         :integer
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class MediaContent < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :language
  belongs_to :resource_content

  validates :url, presence: true

  after_create :update_embed_code_and_metadata

  protected
  def update_embed_code_and_metadata
    video = VideoInfo.new(self.url.to_s, referer: 'https://quran.com/')

    if video.available?
      #self.duration = video.duration
      self.embed_text = video.embed_code(url_attributes: url_attributes(video.provider))
      self.provider = video.provider
      self.save
    end
  rescue Exception => e
    nil
  end

  def url_attributes(provider)
    case provider.to_s.downcase
      when 'dailymotion'
        {skin: 'default', autoplay: 1, no_tabs: 0}
      when 'youtube'
        {enablejsapi: 1, wmode: 'transparent', iv_load_policy: 3, origin: 'https://quran.com', rel: 0, autohide: 1, autoplay: 1}
      else
        {}
    end
  end
end
