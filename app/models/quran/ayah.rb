# == Schema Information
#
# Table name: quran.ayah
#
#  ayah_index :integer          not null
#  surah_id   :integer
#  ayah_num   :integer
#  page_num   :integer
#  juz_num    :integer
#  hizb_num   :integer
#  rub_num    :integer
#  text       :text
#  ayah_key   :text             not null, primary key
#  sajdah     :text
#

# vim: ts=4 sw=4 expandtab
class Quran::Ayah < ActiveRecord::Base
  extend Quran

  self.table_name = 'ayah'
  self.primary_key = 'ayah_key'

  belongs_to :surah, class_name: 'Quran::Surah'

  has_many :words,  class_name: 'Quran::Word',  foreign_key: 'ayah_key'
  has_many :tokens, class_name: 'Quran::Token', through:     :words
  has_many :stems,  class_name: 'Quran::Stem',  through:     :words
  has_many :lemmas, class_name: 'Quran::Lemma', through:     :words
  has_many :roots,  class_name: 'Quran::Root',  through:     :words

  has_many :_tafsir_ayah, class_name: 'Content::TafsirAyah', foreign_key: 'ayah_key'
  has_many :tafsirs,      class_name: 'Content::Tafsir',     through:     :_tafsir_ayah

  has_many :translations,     class_name: 'Content::Translation',     foreign_key: 'ayah_key'
  has_one  :transliteration,   class_name: 'Content::Transliteration', foreign_key: 'ayah_key'

  has_many :audio_files,  class_name: 'Audio::File',     foreign_key: 'ayah_key'
  has_many :texts,  class_name: 'Quran::Text',     foreign_key: 'ayah_key'
  has_one  :text_tashkeel, -> { where(resource_id: 12) }, class_name: 'Quran::Text', foreign_key: 'ayah_key'
  has_many :images, class_name: 'Quran::Image',    foreign_key: 'ayah_key'
  has_many :glyphs, -> {order('position asc') }, class_name: 'Quran::WordFont', foreign_key: 'ayah_key'

  # NOTE the relationships below were created as database-side views for use with elasticsearch
  has_many :text_roots,  class_name: 'Quran::TextRoot',  foreign_key: 'ayah_key'
  has_many :text_lemmas, class_name: 'Quran::TextLemma', foreign_key: 'ayah_key'
  has_many :text_stems,  class_name: 'Quran::TextStem',  foreign_key: 'ayah_key'
  has_one  :text_token,   class_name: 'Quran::TextToken', foreign_key: 'ayah_key'

  def self.by_range(surah_id, from, to)
    where('quran.ayah.surah_id = ?', surah_id)
    .where('quran.ayah.ayah_num >= ?', from)
    .where('quran.ayah.ayah_num <= ?', to)
    .order(:surah_id, :ayah_num)
  end

  def self.by_array(ayahs_keys_array)
    order = sanitize_sql_array(
      ["position(ayah_key::text in ?)", ayahs_keys_array.join(',')]
    )
    where(ayah_key: ayahs_keys_array).order(order)
  end

  def self.get_ayahs_by_page(page)
    where(page_num: page).order('quran.ayah.surah_id, quran.ayah.ayah_num')
  end

  def self.import_options ( options = {} )
    transform = lambda do |a|
      data = a.__elasticsearch__.as_indexed_json
      data.delete( 'text' ) # NOTE we exclude text because it serves no value in the parent mapping
      { index: { _id: "#{a.ayah_key}", data: data } }
    end
    options = { transform: transform, batch_size: 6236 }.merge(options)

    return options
  end

  def self.import ( options = {} )
    self.importing( self.import_options( options ) )
  end

  def content
    translations
  end

  def audio
    current = audio_files.map(&:attributes)
    { ogg: current.find{ |file| file['format'] == 'ogg'}, mp3: current.find{ |file| file['format'] == 'mp3'} }
  end

  def view_json(options = {})
    as_json(options)
  end

  def as_json(options = {})
    super(options)
    .merge(words: glyphs.sort.as_json)
    .merge(text_tashkeel:  text_tashkeel ? text_tashkeel.text : '')
  end

  def self.query(options = {})
    query = {}
    includes = {}

    if options[:content]
      query.merge!(translation: {resource_id: options[:content]})
      includes.merge!(translations: [:resource])
    end

    if options[:audio]
      query.merge!('file.recitation_id' => options[:audio], 'file.is_enabled' => true)
      includes.merge!(audio_files: :reciter)
    end

    Quran::Ayah
      .includes(includes)
      .preload(glyphs: {word: [:corpus]})
      .preload(:text_tashkeel)
      .where(query)
  end

  def view_options(options = {})
    opts = {methods: []}

    opts[:methods].push(:content) if options[:content]
    opts[:methods].push(:audio) if options[:audio]

    opts
  end
end
