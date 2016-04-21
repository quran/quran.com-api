# == Schema Information
#
# Table name: quran.surah
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
  extend Quran

  self.table_name = 'surah'
  self.primary_key = 'surah_id'

  has_many :ayahs, class_name: 'Quran::Ayah', foreign_key: 'surah_id'

  def name
    {
      complex: name_complex,
      simple: name_simple,
      english: name_english,
      arabic: name_arabic
    }
  end

  def as_json(options = {})
    super(methods: :name).merge(id: surah_id)
  end
end
