# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_23_205626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audio_files", id: :serial, force: :cascade do |t|
    t.integer "verse_id"
    t.text "url"
    t.integer "duration"
    t.text "segments"
    t.string "mime_type"
    t.string "format"
    t.boolean "is_enabled"
    t.integer "recitation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_enabled"], name: "index_audio_files_on_is_enabled"
    t.index ["recitation_id"], name: "index_audio_files_on_recitation_id"
    t.index ["verse_id"], name: "index_audio_files_on_verse_id"
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapter_infos", id: :serial, force: :cascade do |t|
    t.integer "chapter_id"
    t.text "text"
    t.string "source"
    t.text "short_text"
    t.integer "language_id"
    t.integer "resource_content_id"
    t.string "language_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_chapter_infos_on_chapter_id"
    t.index ["language_id"], name: "index_chapter_infos_on_language_id"
    t.index ["resource_content_id"], name: "index_chapter_infos_on_resource_content_id"
  end

  create_table "chapters", id: :serial, force: :cascade do |t|
    t.boolean "bismillah_pre"
    t.integer "revelation_order"
    t.string "revelation_place"
    t.string "name_complex"
    t.string "name_arabic"
    t.string "name_simple"
    t.string "pages"
    t.integer "verses_count"
    t.integer "chapter_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_number"], name: "index_chapters_on_chapter_number"
  end

  create_table "char_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_char_types_on_parent_id"
  end

  create_table "data_sources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foot_notes", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.text "text"
    t.integer "language_id"
    t.string "language_name"
    t.integer "resource_content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_foot_notes_on_language_id"
    t.index ["resource_content_id"], name: "index_foot_notes_on_resource_content_id"
    t.index ["resource_type", "resource_id"], name: "index_foot_notes_on_resource_type_and_resource_id"
  end

  create_table "juzs", id: :serial, force: :cascade do |t|
    t.integer "juz_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "verse_mapping"
    t.index ["juz_number"], name: "index_juzs_on_juz_number"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "iso_code"
    t.string "native_name"
    t.string "direction"
    t.string "es_analyzer_default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iso_code"], name: "index_languages_on_iso_code"
  end

  create_table "lemmas", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_contents", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.text "url"
    t.string "duration"
    t.text "embed_text"
    t.string "provider"
    t.integer "language_id"
    t.string "language_name"
    t.string "author_name"
    t.integer "resource_content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_media_contents_on_language_id"
    t.index ["resource_content_id"], name: "index_media_contents_on_resource_content_id"
    t.index ["resource_type", "resource_id"], name: "index_media_contents_on_resource_type_and_resource_id"
  end

  create_table "recitation_styles", id: :serial, force: :cascade do |t|
    t.string "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recitations", id: :serial, force: :cascade do |t|
    t.integer "reciter_id"
    t.integer "resource_content_id"
    t.integer "recitation_style_id"
    t.string "reciter_name"
    t.string "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recitation_style_id"], name: "index_recitations_on_recitation_style_id"
    t.index ["reciter_id"], name: "index_recitations_on_reciter_id"
    t.index ["resource_content_id"], name: "index_recitations_on_resource_content_id"
  end

  create_table "reciters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resource_content_stats", id: :serial, force: :cascade do |t|
    t.integer "resource_content_id"
    t.integer "download_count"
    t.string "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform"], name: "index_resource_content_stats_on_platform"
    t.index ["resource_content_id"], name: "index_resource_content_stats_on_resource_content_id"
  end

  create_table "resource_contents", id: :serial, force: :cascade do |t|
    t.boolean "approved"
    t.integer "author_id"
    t.integer "data_source_id"
    t.string "author_name"
    t.string "resource_type"
    t.string "sub_type"
    t.string "name"
    t.integer "mobile_translation_id"
    t.text "description"
    t.string "cardinality_type"
    t.integer "language_id"
    t.string "language_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["approved"], name: "index_resource_contents_on_approved"
    t.index ["author_id"], name: "index_resource_contents_on_author_id"
    t.index ["cardinality_type"], name: "index_resource_contents_on_cardinality_type"
    t.index ["data_source_id"], name: "index_resource_contents_on_data_source_id"
    t.index ["language_id"], name: "index_resource_contents_on_language_id"
    t.index ["mobile_translation_id"], name: "index_resource_contents_on_mobile_translation_id"
    t.index ["resource_type"], name: "index_resource_contents_on_resource_type"
    t.index ["slug"], name: "index_resource_contents_on_slug"
    t.index ["sub_type"], name: "index_resource_contents_on_sub_type"
  end

  create_table "roots", id: :serial, force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slugs", force: :cascade do |t|
    t.bigint "chapter_id"
    t.string "slug"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id", "slug"], name: "index_slugs_on_chapter_id_and_slug"
    t.index ["chapter_id"], name: "index_slugs_on_chapter_id"
  end

  create_table "stems", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tafsirs", id: :serial, force: :cascade do |t|
    t.integer "verse_id"
    t.integer "language_id"
    t.text "text"
    t.string "language_name"
    t.integer "resource_content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_name"
    t.string "verse_key"
    t.index ["language_id"], name: "index_tafsirs_on_language_id"
    t.index ["resource_content_id"], name: "index_tafsirs_on_resource_content_id"
    t.index ["verse_id"], name: "index_tafsirs_on_verse_id"
    t.index ["verse_key"], name: "index_tafsirs_on_verse_key"
  end

  create_table "tokens", id: :serial, force: :cascade do |t|
    t.string "text_uthmani"
    t.string "text_imlaei_simple"
    t.string "text_indopak"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "text_imlaei"
    t.string "text_uthmani_tajweed"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_topics_on_parent_id"
  end

  create_table "translated_names", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "language_id"
    t.string "name"
    t.string "language_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_priority"
    t.index ["language_id"], name: "index_translated_names_on_language_id"
    t.index ["language_priority"], name: "index_translated_names_on_language_priority"
    t.index ["resource_type", "resource_id"], name: "index_translated_names_on_resource_type_and_resource_id"
  end

  create_table "translations", id: :serial, force: :cascade do |t|
    t.integer "language_id"
    t.integer "verse_id"
    t.text "text"
    t.integer "resource_content_id"
    t.string "language_name"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_name"
    t.index ["language_id"], name: "index_translations_on_language_id"
    t.index ["priority"], name: "index_translations_on_priority"
    t.index ["resource_content_id"], name: "index_translations_on_resource_content_id"
    t.index ["verse_id"], name: "index_translations_on_verse_id"
  end

  create_table "transliterations", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "language_id"
    t.text "text"
    t.string "language_name"
    t.integer "resource_content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_transliterations_on_language_id"
    t.index ["resource_content_id"], name: "index_transliterations_on_resource_content_id"
    t.index ["resource_type", "resource_id"], name: "index_transliterations_on_resource_type_and_resource_id"
  end

  create_table "verse_lemmas", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verse_roots", id: :serial, force: :cascade do |t|
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verse_stems", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verses", id: :serial, force: :cascade do |t|
    t.integer "chapter_id"
    t.integer "verse_number"
    t.integer "verse_index"
    t.string "verse_key"
    t.text "text_uthmani"
    t.text "text_uthmani_simple"
    t.text "text_uthmani_tajweed"
    t.text "text_indopak"
    t.text "text_imlaei_simple"
    t.text "text_imlaei"
    t.integer "juz_number"
    t.integer "hizb_number"
    t.integer "rub_number"
    t.string "sajdah_type"
    t.integer "sajdah_number"
    t.integer "page_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "image_url"
    t.integer "image_width"
    t.integer "verse_root_id"
    t.integer "verse_lemma_id"
    t.integer "verse_stem_id"
    t.index ["chapter_id"], name: "index_verses_on_chapter_id"
    t.index ["verse_index"], name: "index_verses_on_verse_index"
    t.index ["verse_key"], name: "index_verses_on_verse_key"
    t.index ["verse_lemma_id"], name: "index_verses_on_verse_lemma_id"
    t.index ["verse_number"], name: "index_verses_on_verse_number"
    t.index ["verse_root_id"], name: "index_verses_on_verse_root_id"
    t.index ["verse_stem_id"], name: "index_verses_on_verse_stem_id"
  end

  create_table "word_corpuses", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.string "location"
    t.text "description"
    t.string "image_src"
    t.json "segments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_id"], name: "index_word_corpuses_on_word_id"
  end

  create_table "word_lemmas", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "lemma_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lemma_id"], name: "index_word_lemmas_on_lemma_id"
    t.index ["word_id"], name: "index_word_lemmas_on_word_id"
  end

  create_table "word_roots", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "root_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["root_id"], name: "index_word_roots_on_root_id"
    t.index ["word_id"], name: "index_word_roots_on_word_id"
  end

  create_table "word_stems", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "stem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stem_id"], name: "index_word_stems_on_stem_id"
    t.index ["word_id"], name: "index_word_stems_on_word_id"
  end

  create_table "word_translations", force: :cascade do |t|
    t.integer "word_id"
    t.string "text"
    t.string "language_name"
    t.integer "language_id"
    t.integer "resource_content_id"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_word_translations_on_priority"
    t.index ["word_id", "language_id"], name: "index_word_translations_on_word_id_and_language_id"
  end

  create_table "words", id: :serial, force: :cascade do |t|
    t.integer "verse_id"
    t.integer "chapter_id"
    t.integer "position"
    t.string "text_uthmani"
    t.string "text_indopak"
    t.string "text_imlaei_simple"
    t.string "text_imlaei"
    t.string "verse_key"
    t.integer "page_number"
    t.string "class_name"
    t.integer "line_number"
    t.integer "code_dec"
    t.string "code_hex"
    t.string "code_hex_v3"
    t.integer "code_dec_v3"
    t.integer "char_type_id"
    t.string "location"
    t.string "audio_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pause_name"
    t.integer "token_id"
    t.integer "topic_id"
    t.string "char_type_name"
    t.string "text_uthmani_tajweed"
    t.string "text_uthmani_simple"
    t.string "en_transliteration"
    t.index ["chapter_id"], name: "index_words_on_chapter_id"
    t.index ["char_type_id"], name: "index_words_on_char_type_id"
    t.index ["location"], name: "index_words_on_location"
    t.index ["position"], name: "index_words_on_position"
    t.index ["token_id"], name: "index_words_on_token_id"
    t.index ["topic_id"], name: "index_words_on_topic_id"
    t.index ["verse_id"], name: "index_words_on_verse_id"
    t.index ["verse_key"], name: "index_words_on_verse_key"
  end

  add_foreign_key "word_lemmas", "lemmas"
  add_foreign_key "word_lemmas", "words"
  add_foreign_key "word_stems", "stems"
  add_foreign_key "word_stems", "words"
end
