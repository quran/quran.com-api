# == Schema Information
# Schema version: 20220123232023
#
# Table name: verses
#
#  id                      :integer          not null, primary key
#  chapter_id              :integer
#  verse_number            :integer
#  verse_index             :integer
#  verse_key               :string
#  text_uthmani            :string
#  text_indopak            :string
#  text_imlaei_simple      :string
#  juz_number              :integer
#  hizb_number             :integer
#  rub_el_hizb_number      :integer
#  sajdah_type             :string
#  sajdah_number           :integer
#  page_number             :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  image_url               :text
#  image_width             :integer
#  verse_root_id           :integer
#  verse_lemma_id          :integer
#  verse_stem_id           :integer
#  text_imlaei             :string
#  text_uthmani_simple     :string
#  text_uthmani_tajweed    :text
#  code_v1                 :string
#  code_v2                 :string
#  v2_page                 :integer
#  text_qpc_hafs           :string
#  words_count             :integer
#  text_indopak_nastaleeq  :string
#  pause_words_count       :integer          default("0")
#  mushaf_pages_mapping    :jsonb            default("{}")
#  text_qpc_nastaleeq      :string
#  ruku_number             :integer
#  surah_ruku_number       :integer
#  manzil_number           :integer
#  text_qpc_nastaleeq_hafs :string
#
# Indexes
#
#  index_verses_on_chapter_id          (chapter_id)
#  index_verses_on_hizb_number         (hizb_number)
#  index_verses_on_juz_number          (juz_number)
#  index_verses_on_manzil_number       (manzil_number)
#  index_verses_on_rub_el_hizb_number  (rub_el_hizb_number)
#  index_verses_on_ruku_number         (ruku_number)
#  index_verses_on_verse_index         (verse_index)
#  index_verses_on_verse_key           (verse_key)
#  index_verses_on_verse_lemma_id      (verse_lemma_id)
#  index_verses_on_verse_number        (verse_number)
#  index_verses_on_verse_root_id       (verse_root_id)
#  index_verses_on_verse_stem_id       (verse_stem_id)
#  index_verses_on_words_count         (words_count)
#

class VerseKey < Verse
  include QuranNavigationSearchable
end
