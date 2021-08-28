# == Schema Information
#
# Table name: verses
#
#  id                   :integer          not null, primary key
#  code_v1              :string
#  code_v2              :string
#  hizb_number          :integer
#  image_url            :text
#  image_width          :integer
#  juz_number           :integer
#  page_number          :integer
#  qpc_uthmani_bazzi    :string
#  qpc_uthmani_doori    :string
#  qpc_uthmani_hafs     :string
#  qpc_uthmani_qaloon   :string
#  qpc_uthmani_qumbul   :string
#  qpc_uthmani_shouba   :string
#  qpc_uthmani_soosi    :string
#  qpc_uthmani_warsh    :string
#  rub_number           :integer
#  sajdah_number        :integer
#  sajdah_type          :string
#  text_imlaei          :string
#  text_imlaei_simple   :string
#  text_indopak         :string
#  text_uthmani         :string
#  text_uthmani_simple  :string
#  text_uthmani_tajweed :text
#  v2_page              :integer
#  verse_index          :integer
#  verse_key            :string
#  verse_number         :integer
#  words_count          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  chapter_id           :integer
#  verse_lemma_id       :integer
#  verse_root_id        :integer
#  verse_stem_id        :integer
#
# Indexes
#
#  index_verses_on_chapter_id      (chapter_id)
#  index_verses_on_verse_index     (verse_index)
#  index_verses_on_verse_key       (verse_key)
#  index_verses_on_verse_lemma_id  (verse_lemma_id)
#  index_verses_on_verse_number    (verse_number)
#  index_verses_on_verse_root_id   (verse_root_id)
#  index_verses_on_verse_stem_id   (verse_stem_id)
#  index_verses_on_words_count     (words_count)
#
class VerseKey < Verse
  include QuranNavigationSearchable
end
