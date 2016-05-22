# == Schema Information
#
# Table name: audio.recitation
#
#  recitation_id :integer          not null, primary key
#  reciter_id    :integer          not null
#  style_id      :integer
#  is_enabled    :boolean          default(TRUE), not null
#

class Audio::Recitation < ActiveRecord::Base
  extend Audio

  self.table_name = 'recitation'
  self.primary_key = 'recitation_id'

  belongs_to :reciter, class_name: 'Audio::Reciter'
  belongs_to :style,   class_name: 'Audio::Style'

  has_many :audio, class_name: 'Audio::File', foreign_key: 'recitation_id'

  def self.list_audio_options
    self.joins(:reciter).joins("LEFT JOIN audio.style using ( style_id )")
        .select([:recitation_id, :reciter_id, :style_id].map{ |term| "audio.recitation.#{term}" }.join(', ') + ", audio.style.slug AS style_slug, audio.reciter.slug AS reciter_slug, concat_ws( ' ', audio.reciter.english, case when ( audio.style.english is not null ) then concat( '(', audio.style.english, ')' ) end ) name_english, concat_ws( ' ', audio.reciter.arabic, case when ( audio.style.arabic is not null ) then concat( '(', audio.style.arabic, ')' ) end ) name_arabic")
        .where("audio.recitation.is_enabled = 't'")
        .order("audio.reciter.english, audio.style.english, audio.recitation.recitation_id")
  end

  def as_json(options = {})
    super(only: [], include: [
      {
        reciter: {
          only: [:path, :slug, :english, :arabic]
        }
      },
      {
        style: {
          only: [:path, :slug, :english, :arabic]
        }
      }
    ]).merge(id: recitation_id)
  end
end
