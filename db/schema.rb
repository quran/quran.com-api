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

  create_table "arabic_transliterations", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "verse_id"
    t.string "text"
    t.string "indopak_text"
    t.integer "page_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position_x"
    t.integer "position_y"
    t.float "zoom"
    t.string "ur_translation"
    t.boolean "continuous"
    t.index ["verse_id"], name: "index_arabic_transliterations_on_verse_id"
    t.index ["word_id"], name: "index_arabic_transliterations_on_word_id"
  end

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

  create_table "author", primary_key: "author_id", id: :integer, default: -> { "nextval('_author_author_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "url", array: true
    t.text "name", null: false
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ayah", primary_key: "ayah_key", id: :text, force: :cascade do |t|
    t.integer "ayah_index", null: false
    t.integer "surah_id"
    t.integer "ayah_num"
    t.integer "page_num"
    t.integer "juz_num"
    t.integer "hizb_num"
    t.integer "rub_num"
    t.text "text"
    t.text "sajdah"
    t.index ["ayah_index"], name: "ayah_index_key", unique: true
    t.index ["ayah_key"], name: "index_quran.ayah_on_ayah_key"
    t.index ["surah_id", "ayah_num"], name: "surah_ayah_key", unique: true
    t.index ["surah_id"], name: "ayah_surah_id_idx"
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

  create_table "char_type", primary_key: "char_type_id", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.text "description"
    t.integer "parent_id"
    t.index ["name", "parent_id"], name: "char_type_name_parent_id_key", unique: true
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

  create_table "file", primary_key: "file_id", id: :integer, default: -> { "nextval('_file_file_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "recitation_id", null: false
    t.text "ayah_key", null: false
    t.text "format", null: false
    t.float "duration"
    t.text "mime_type", null: false
    t.boolean "is_enabled", default: true, null: false
    t.text "url"
    t.json "segments_stats"
    t.text "segments", array: true
    t.index ["ayah_key"], name: "index_audio.file_on_ayah_key"
    t.index ["recitation_id", "ayah_key", "format"], name: "_file_recitation_id_ayah_key_format_key", unique: true
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

  create_table "image", primary_key: ["resource_id", "ayah_key"], force: :cascade do |t|
    t.integer "resource_id", null: false
    t.text "ayah_key", null: false
    t.text "url", null: false
    t.text "alt", null: false
    t.integer "width", null: false
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.integer "verse_id"
    t.integer "resource_content_id"
    t.integer "width"
    t.string "url"
    t.text "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_content_id"], name: "index_images_on_resource_content_id"
    t.index ["verse_id"], name: "index_images_on_verse_id"
  end

  create_table "juzs", id: :serial, force: :cascade do |t|
    t.integer "juz_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "verse_mapping"
    t.index ["juz_number"], name: "index_juzs_on_juz_number"
  end

  create_table "language", primary_key: "language_code", id: :text, force: :cascade do |t|
    t.text "unicode"
    t.text "english", null: false
    t.text "direction", default: "ltr", null: false
    t.integer "priority", default: 999, null: false
    t.boolean "beta", default: true, null: false
    t.string "es_analyzer_default"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "iso_code"
    t.string "native_name"
    t.string "direction"
    t.string "es_analyzer_default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "es_indexes"
    t.index ["iso_code"], name: "index_languages_on_iso_code"
  end

  create_table "lemma", primary_key: "lemma_id", id: :serial, force: :cascade do |t|
    t.string "value", limit: 50, null: false
    t.string "clean", limit: 50, null: false
    t.index ["value"], name: "lemma_value_key", unique: true
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

  create_table "recitation", primary_key: "recitation_id", id: :serial, force: :cascade do |t|
    t.integer "reciter_id", null: false
    t.integer "style_id"
    t.boolean "is_enabled", default: true, null: false
    t.index ["reciter_id", "style_id"], name: "recitation_reciter_id_style_id_key", unique: true
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

  create_table "reciter", primary_key: "reciter_id", id: :integer, default: -> { "nextval('_reciter_reciter_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "path"
    t.text "slug"
    t.text "english", null: false
    t.text "arabic", null: false
    t.index ["arabic"], name: "_reciter_arabic_key", unique: true
    t.index ["english"], name: "_reciter_english_key", unique: true
    t.index ["path"], name: "_reciter_path_key", unique: true
    t.index ["slug"], name: "_reciter_slug_key", unique: true
  end

  create_table "reciters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resource", primary_key: "resource_id", id: :serial, force: :cascade do |t|
    t.text "type", null: false
    t.text "sub_type", null: false
    t.text "cardinality_type", default: "1_ayah", null: false
    t.text "language_code", null: false
    t.text "slug", null: false
    t.boolean "is_available", default: true, null: false
    t.text "description"
    t.integer "author_id"
    t.integer "source_id"
    t.text "name", null: false
    t.index ["type", "sub_type", "language_code", "slug"], name: "resource_type_sub_type_language_code_slug_key", unique: true
  end

  create_table "resource_api_version", primary_key: "resource_id", id: :integer, default: nil, force: :cascade do |t|
    t.boolean "v1_is_enabled", default: false, null: false
    t.boolean "v1_is_default"
    t.boolean "v1_separator"
    t.boolean "v1_label"
    t.integer "v1_order"
    t.integer "v1_id"
    t.text "v1_name"
    t.boolean "v2_is_enabled", default: false, null: false
    t.boolean "v2_is_default"
    t.float "v2_weighted", default: 0.618, null: false
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
    t.text "description"
    t.string "cardinality_type"
    t.integer "language_id"
    t.string "language_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "mobile_translation_id"
    t.integer "priority"
    t.index ["approved"], name: "index_resource_contents_on_approved"
    t.index ["author_id"], name: "index_resource_contents_on_author_id"
    t.index ["cardinality_type"], name: "index_resource_contents_on_cardinality_type"
    t.index ["data_source_id"], name: "index_resource_contents_on_data_source_id"
    t.index ["language_id"], name: "index_resource_contents_on_language_id"
    t.index ["mobile_translation_id"], name: "index_resource_contents_on_mobile_translation_id"
    t.index ["priority"], name: "index_resource_contents_on_priority"
    t.index ["resource_type"], name: "index_resource_contents_on_resource_type"
    t.index ["slug"], name: "index_resource_contents_on_slug"
    t.index ["sub_type"], name: "index_resource_contents_on_sub_type"
  end

  create_table "root", primary_key: "root_id", id: :serial, force: :cascade do |t|
    t.string "value", limit: 50, null: false
    t.index ["value"], name: "root_value_key", unique: true
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

  create_table "source", primary_key: "source_id", id: :integer, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.text "url"
  end

  create_table "stem", primary_key: "stem_id", id: :serial, force: :cascade do |t|
    t.string "value", limit: 50, null: false
    t.string "clean", limit: 50, null: false
    t.index ["value"], name: "stem_value_key", unique: true
  end

  create_table "stems", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "style", primary_key: "style_id", id: :integer, default: -> { "nextval('_style_style_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "path", null: false
    t.text "slug", null: false
    t.text "english", null: false
    t.text "arabic", null: false
    t.index ["arabic"], name: "_style_arabic_key", unique: true
    t.index ["english"], name: "_style_english_key", unique: true
    t.index ["path"], name: "_style_path_key", unique: true
    t.index ["slug"], name: "_style_slug_key", unique: true
  end

  create_table "surah", primary_key: "surah_id", id: :integer, default: nil, force: :cascade do |t|
    t.integer "ayat", null: false
    t.boolean "bismillah_pre", null: false
    t.integer "revelation_order", null: false
    t.text "revelation_place", null: false
    t.integer "page", null: false, array: true
    t.text "name_complex", null: false
    t.text "name_simple", null: false
    t.text "name_english", null: false
    t.text "name_arabic", null: false
  end

  create_table "surah_infos", id: :serial, force: :cascade do |t|
    t.string "language_code"
    t.text "description"
    t.integer "surah_id"
    t.text "content_source"
    t.text "short_description"
    t.index ["surah_id"], name: "index_content.surah_infos_on_surah_id"
  end

  create_table "tafsir", primary_key: "tafsir_id", id: :integer, default: -> { "nextval('_tafsir_tafsir_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "resource_id", null: false
    t.text "text", null: false
    t.index "resource_id, md5(text)", name: "tafsir_resource_id_md5_idx", unique: true
  end

  create_table "tafsir_ayah", primary_key: ["tafsir_id", "ayah_key"], force: :cascade do |t|
    t.integer "tafsir_id", null: false
    t.text "ayah_key", null: false
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

  create_table "text", primary_key: ["resource_id", "ayah_key"], force: :cascade do |t|
    t.integer "resource_id", null: false
    t.text "ayah_key", null: false
    t.text "text", null: false
  end

  create_table "token", primary_key: "token_id", id: :serial, force: :cascade do |t|
    t.string "value", limit: 50, null: false
    t.string "clean", limit: 50, null: false
    t.index ["value"], name: "token_value_key", unique: true
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

  create_table "translation", primary_key: ["resource_id", "ayah_key"], force: :cascade do |t|
    t.integer "resource_id", null: false
    t.text "ayah_key", null: false
    t.text "text", null: false
    t.index ["ayah_key"], name: "index_content.translation_on_ayah_key"
  end

  create_table "translations", id: :serial, force: :cascade do |t|
    t.integer "language_id"
    t.string "text"
    t.integer "resource_content_id"
    t.integer "verse_id"
    t.string "language_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_name"
    t.integer "priority"
    t.index ["language_id"], name: "index_translations_on_language_id"
    t.index ["priority"], name: "index_translations_on_priority"
    t.index ["resource_content_id"], name: "index_translations_on_resource_content_id"
    t.index ["verse_id"], name: "index_translations_on_verse_id"
  end

  create_table "transliteration", primary_key: ["resource_id", "ayah_key"], force: :cascade do |t|
    t.integer "resource_id", null: false
    t.text "ayah_key", null: false
    t.text "text", null: false
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
    t.text "text_indopak"
    t.text "text_imlaei_simple"
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
    t.string "text_imlaei"
    t.string "text_uthmani_simple"
    t.text "text_uthmani_tajweed"
    t.index ["chapter_id"], name: "index_verses_on_chapter_id"
    t.index ["verse_index"], name: "index_verses_on_verse_index"
    t.index ["verse_key"], name: "index_verses_on_verse_key"
    t.index ["verse_lemma_id"], name: "index_verses_on_verse_lemma_id"
    t.index ["verse_number"], name: "index_verses_on_verse_number"
    t.index ["verse_root_id"], name: "index_verses_on_verse_root_id"
    t.index ["verse_stem_id"], name: "index_verses_on_verse_stem_id"
  end

  create_table "view", primary_key: "view_id", id: :serial, force: :cascade do |t|
  end

  create_table "word", primary_key: "word_id", id: :serial, force: :cascade do |t|
    t.text "ayah_key", null: false
    t.integer "position", null: false
    t.integer "token_id", null: false
    t.string "translation"
    t.string "transliteration"
    t.index ["ayah_key", "position"], name: "word_ayah_key_position_key", unique: true
  end

  create_table "word_corpus", primary_key: "corpus_id", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.string "location"
    t.string "description"
    t.string "transliteration"
    t.string "image_src"
    t.json "segment"
    t.index ["word_id"], name: "index_quran.word_corpus_on_word_id"
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

  create_table "word_font", primary_key: ["resource_id", "ayah_key", "position"], force: :cascade do |t|
    t.integer "resource_id", null: false
    t.text "ayah_key", null: false
    t.integer "position", null: false
    t.integer "word_id"
    t.integer "page_num", null: false
    t.integer "line_num", null: false
    t.integer "code_dec", null: false
    t.text "code_hex", null: false
    t.integer "char_type_id", null: false
    t.index ["ayah_key"], name: "index_quran.word_font_on_ayah_key"
  end

  create_table "word_lemma", primary_key: ["word_id", "lemma_id", "position"], force: :cascade do |t|
    t.integer "word_id", null: false
    t.integer "lemma_id", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "word_lemmas", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "lemma_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lemma_id"], name: "index_word_lemmas_on_lemma_id"
    t.index ["word_id"], name: "index_word_lemmas_on_word_id"
  end

  create_table "word_root", primary_key: ["word_id", "root_id", "position"], force: :cascade do |t|
    t.integer "word_id", null: false
    t.integer "root_id", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "word_roots", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "root_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["root_id"], name: "index_word_roots_on_root_id"
    t.index ["word_id"], name: "index_word_roots_on_word_id"
  end

  create_table "word_stem", primary_key: ["word_id", "stem_id", "position"], force: :cascade do |t|
    t.integer "word_id", null: false
    t.integer "stem_id", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "word_stems", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "stem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stem_id"], name: "index_word_stems_on_stem_id"
    t.index ["word_id"], name: "index_word_stems_on_word_id"
  end

  create_table "word_translation", primary_key: "translation_id", id: :integer, default: -> { "nextval('translation_translation_id_seq1'::regclass)" }, force: :cascade do |t|
    t.integer "word_id", null: false
    t.text "language_code", null: false
    t.text "value", null: false
    t.index ["word_id", "language_code"], name: "translation_word_id_language_code_key", unique: true
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

  create_table "word_transliteration", primary_key: "transliteration_id", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.string "language_code"
    t.string "value"
    t.index ["word_id"], name: "index_quran.word_transliteration_on_word_id"
  end

  create_table "words", id: :serial, force: :cascade do |t|
    t.integer "verse_id"
    t.integer "chapter_id"
    t.integer "position"
    t.text "text_uthmani"
    t.text "text_indopak"
    t.text "text_imlaei_simple"
    t.string "verse_key"
    t.integer "page_number"
    t.string "class_name"
    t.integer "line_number"
    t.integer "code_dec"
    t.string "code_hex"
    t.string "code_hex_v3"
    t.integer "code_dec_v3"
    t.integer "char_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pause_name"
    t.string "audio_url"
    t.text "image_blob"
    t.string "image_url"
    t.integer "token_id"
    t.integer "topic_id"
    t.string "location"
    t.string "char_type_name"
    t.string "text_imlaei"
    t.string "text_uthmani_simple"
    t.string "text_madani_tajweed"
    t.index ["chapter_id"], name: "index_words_on_chapter_id"
    t.index ["char_type_id"], name: "index_words_on_char_type_id"
    t.index ["location"], name: "index_words_on_location"
    t.index ["position"], name: "index_words_on_position"
    t.index ["token_id"], name: "index_words_on_token_id"
    t.index ["topic_id"], name: "index_words_on_topic_id"
    t.index ["verse_id"], name: "index_words_on_verse_id"
    t.index ["verse_key"], name: "index_words_on_verse_key"
  end

  add_foreign_key "ayah", "surah", primary_key: "surah_id", name: "ayah_surah_id_fkey"
  add_foreign_key "char_type", "char_type", column: "parent_id", primary_key: "char_type_id", name: "char_type_parent_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "file", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "_file_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "file", "recitation", primary_key: "recitation_id", name: "_file_recitation_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "image", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "image_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "image", "resource", primary_key: "resource_id", name: "image_resource_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "recitation", "reciter", primary_key: "reciter_id", name: "recitation_reciter_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "recitation", "style", primary_key: "style_id", name: "recitation_style_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "resource", "author", primary_key: "author_id", name: "resource_author_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "resource", "language", column: "language_code", primary_key: "language_code", name: "resource_language_code_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "resource", "source", primary_key: "source_id", name: "resource_source_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "resource_api_version", "resource", primary_key: "resource_id", name: "resource_api_version_resource_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tafsir", "resource", primary_key: "resource_id", name: "tafsir_resource_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tafsir_ayah", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "_tafsir_ayah_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tafsir_ayah", "tafsir", primary_key: "tafsir_id", name: "_tafsir_ayah_tafsir_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "text", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "text_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "text", "resource", primary_key: "resource_id", name: "text_resource_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "translation", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "_translation_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "translation", "resource", primary_key: "resource_id", name: "translation_resource_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "transliteration", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "_transliteration_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "transliteration", "resource", primary_key: "resource_id", name: "transliteration_resource_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "word_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word", "token", primary_key: "token_id", name: "word_token_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_font", "ayah", column: "ayah_key", primary_key: "ayah_key", name: "word_font_ayah_key_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_font", "char_type", primary_key: "char_type_id", name: "word_font_char_type_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_font", "resource", primary_key: "resource_id", name: "word_font_resource_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_font", "word", primary_key: "word_id", name: "word_font_word_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "word_lemma", "lemma", primary_key: "lemma_id", name: "word_lemma_lemma_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_lemma", "word", primary_key: "word_id", name: "word_lemma_word_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_lemmas", "lemmas"
  add_foreign_key "word_lemmas", "words"
  add_foreign_key "word_root", "root", primary_key: "root_id", name: "word_root_root_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_root", "word", primary_key: "word_id", name: "word_root_word_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_stem", "stem", primary_key: "stem_id", name: "word_stem_stem_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_stem", "word", primary_key: "word_id", name: "word_stem_word_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_stems", "stems"
  add_foreign_key "word_stems", "words"
  add_foreign_key "word_translation", "language", column: "language_code", primary_key: "language_code", name: "translation_language_code_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "word_translation", "word", primary_key: "word_id", name: "translation_word_id_fkey", on_update: :cascade, on_delete: :cascade
end
