# == Schema Information
#
# Table name: surah
#
#  surah_id         :integer          not null, primary key
#  ayat             :integer          not null
#  bismillah_pre    :boolean          not null
#  revelation_order :integer          not null
#  revelation_place :text             not null
#  page             :integer          not null, is an Array
#  name_complex     :text             not null
#  name_simple      :text             not null
#  name_english     :text             not null
#  name_arabic      :text             not null
#

class Quran::Surah < ActiveRecord::Base
  self.table_name = 'surah'

  has_many :ayahs, class_name: 'Quran::Ayah', foreign_key: 'surah_id'
  has_many :surah_infos, class_name: 'Content::SurahInfo'

  def get_surah_info_for_language(language_code)
    language = Locale::Language.find_by_language_code(language_code) || Locale::Language.find('en')

    surah_infos.find_by(language: language)
  end

  def name
    {
      complex: name_complex,
      simple: name_simple,
      english: name_english,
      arabic: name_arabic
    }
  end

  def revelation
    {
      place: revelation_place,
      order: revelation_order
    }
  end

  def as_json(options = {})
    super(methods: [:name, :revelation]).merge(id: surah_id)
  end
end
