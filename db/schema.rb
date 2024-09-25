# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_09_18_072240) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_client_request_stats", force: :cascade do |t|
    t.integer "api_client_id"
    t.date "date"
    t.integer "requests_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_api_client_request_stats_on_api_client_id"
    t.index ["date"], name: "index_api_client_request_stats_on_date"
  end

  create_table "api_clients", force: :cascade do |t|
    t.string "name"
    t.string "api_key", null: false
    t.string "kalimat_api_key"
    t.boolean "internal_api", default: false
    t.boolean "active", default: true
    t.integer "request_quota"
    t.integer "requests_count"
    t.integer "current_period_requests_count"
    t.datetime "current_period_ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_api_clients_on_active"
    t.index ["api_key"], name: "index_api_clients_on_api_key"
  end

  create_table "audio_change_logs", force: :cascade do |t|
    t.integer "audio_recitation_id"
    t.datetime "date", precision: nil
    t.text "mini_desc"
    t.text "rss_desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audio_chapter_audio_files", force: :cascade do |t|
    t.integer "chapter_id"
    t.integer "audio_recitation_id"
    t.integer "total_files"
    t.integer "stream_count"
    t.integer "download_count"
    t.float "file_size"
    t.integer "bit_rate"
    t.integer "duration"
    t.string "file_name"
    t.string "format"
    t.string "mime_type"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration_ms"
    t.string "audio_url"
    t.string "timing_percentiles", array: true
    t.index ["audio_recitation_id"], name: "index_audio_chapter_audio_files_on_audio_recitation_id"
    t.index ["chapter_id"], name: "index_audio_chapter_audio_files_on_chapter_id"
    t.index ["format"], name: "index_audio_chapter_audio_files_on_format"
  end

  create_table "audio_files", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.text "url"
    t.integer "duration"
    t.text "segments"
    t.string "mime_type"
    t.string "format"
    t.boolean "is_enabled"
    t.integer "recitation_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "verse_key"
    t.integer "chapter_id"
    t.integer "verse_number"
    t.integer "juz_number"
    t.integer "hizb_number"
    t.integer "rub_el_hizb_number"
    t.integer "page_number"
    t.integer "ruku_number"
    t.integer "surah_ruku_number"
    t.integer "manzil_number"
    t.index ["chapter_id", "verse_number"], name: "index_audio_files_on_chapter_id_and_verse_number"
    t.index ["chapter_id"], name: "index_audio_files_on_chapter_id"
    t.index ["hizb_number"], name: "index_audio_files_on_hizb_number"
    t.index ["is_enabled"], name: "index_audio_files_on_is_enabled"
    t.index ["juz_number"], name: "index_audio_files_on_juz_number"
    t.index ["manzil_number"], name: "index_audio_files_on_manzil_number"
    t.index ["page_number"], name: "index_audio_files_on_page_number"
    t.index ["recitation_id"], name: "index_audio_files_on_recitation_id"
    t.index ["resource_type", "resource_id"], name: "index_audio_files_on_resource"
    t.index ["rub_el_hizb_number"], name: "index_audio_files_on_rub_el_hizb_number"
    t.index ["ruku_number"], name: "index_audio_files_on_ruku_number"
    t.index ["verse_key"], name: "index_audio_files_on_verse_key"
  end

  create_table "audio_recitations", force: :cascade do |t|
    t.string "name"
    t.string "arabic_name"
    t.string "relative_path"
    t.string "format"
    t.integer "section_id"
    t.text "description"
    t.integer "files_count"
    t.integer "priority"
    t.integer "resource_content_id"
    t.integer "recitation_style_id"
    t.integer "reciter_id"
    t.boolean "approved", default: false
    t.boolean "lock_segments", default: false
    t.integer "segment_locked"
    t.float "files_size"
    t.integer "home"
    t.integer "qirat_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_audio_recitations_on_approved"
    t.index ["name"], name: "index_audio_recitations_on_name"
    t.index ["priority"], name: "index_audio_recitations_on_priority"
    t.index ["qirat_type_id"], name: "index_audio_recitations_on_qirat_type_id"
    t.index ["recitation_style_id"], name: "index_audio_recitations_on_recitation_style_id"
    t.index ["reciter_id"], name: "index_audio_recitations_on_reciter_id"
    t.index ["relative_path"], name: "index_audio_recitations_on_relative_path"
    t.index ["resource_content_id"], name: "index_audio_recitations_on_resource_content_id"
    t.index ["section_id"], name: "index_audio_recitations_on_section_id"
  end

  create_table "audio_related_recitations", force: :cascade do |t|
    t.integer "audio_recitation_id"
    t.integer "related_audio_recitation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_recitation_id", "related_audio_recitation_id"], name: "index_audio_related_recitation"
  end

  create_table "audio_sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audio_segments", force: :cascade do |t|
    t.bigint "audio_file_id"
    t.bigint "audio_recitation_id"
    t.bigint "chapter_id"
    t.bigint "verse_id"
    t.string "verse_key"
    t.integer "verse_number"
    t.integer "timestamp_from"
    t.integer "timestamp_to"
    t.integer "timestamp_median"
    t.jsonb "segments", default: []
    t.jsonb "relative_segments", default: []
    t.integer "duration"
    t.integer "silent_duration"
    t.integer "relative_silent_duration"
    t.float "percentile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_file_id", "verse_number"], name: "index_audio_segments_on_audio_file_id_and_verse_number", unique: true
    t.index ["audio_file_id"], name: "index_audio_segments_on_audio_file_id"
    t.index ["audio_recitation_id", "chapter_id", "verse_id", "timestamp_median"], name: "index_on_audio_segments_median_time"
    t.index ["audio_recitation_id"], name: "index_audio_segments_on_audio_recitation_id"
    t.index ["chapter_id"], name: "index_audio_segments_on_chapter_id"
    t.index ["verse_id"], name: "index_audio_segments_on_verse_id"
    t.index ["verse_number"], name: "index_audio_segments_on_verse_number"
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ayah_themes", force: :cascade do |t|
    t.integer "chapter_id"
    t.integer "verse_number_from"
    t.integer "verse_number_to"
    t.string "verse_key_from"
    t.string "verse_key_to"
    t.integer "verse_id_from"
    t.integer "verse_id_to"
    t.integer "verses_count"
    t.string "theme"
    t.jsonb "keywords"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_ayah_themes_on_book_id"
    t.index ["chapter_id"], name: "index_ayah_themes_on_chapter_id"
    t.index ["verse_id_from"], name: "index_ayah_themes_on_verse_id_from"
    t.index ["verse_id_to"], name: "index_ayah_themes_on_verse_id_to"
    t.index ["verse_number_from"], name: "index_ayah_themes_on_verse_number_from"
    t.index ["verse_number_to"], name: "index_ayah_themes_on_verse_number_to"
  end

  create_table "books", force: :cascade do |t|
    t.string "name"
    t.string "description"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "rukus_count"
    t.integer "hizbs_count"
    t.integer "rub_el_hizbs_count"
    t.index ["chapter_number"], name: "index_chapters_on_chapter_number"
  end

  create_table "char_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["parent_id"], name: "index_char_types_on_parent_id"
  end

  create_table "corpus_word_forms", force: :cascade do |t|
    t.bigint "word_id"
    t.string "name"
    t.string "arabic"
    t.string "arabic_simple"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_id"], name: "index_corpus_word_forms_on_word_id"
  end

  create_table "corpus_word_grammars", force: :cascade do |t|
    t.bigint "word_id"
    t.integer "position"
    t.string "text"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_id", "position"], name: "index_corpus_word_grammars_on_word_id_and_position"
    t.index ["word_id"], name: "index_corpus_word_grammars_on_word_id"
  end

  create_table "country_language_preferences", force: :cascade do |t|
    t.string "country"
    t.string "user_device_language", null: false
    t.integer "default_mushaf_id"
    t.string "default_translation_ids"
    t.integer "default_tafsir_id"
    t.string "default_wbw_language"
    t.integer "default_reciter"
    t.string "ayah_reflections_languages"
    t.string "learning_plan_languages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_sources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "dictionary_root_definitions", force: :cascade do |t|
    t.integer "definition_type"
    t.text "description"
    t.bigint "word_root_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_root_id"], name: "index_dict_word_definition"
  end

  create_table "dictionary_root_examples", force: :cascade do |t|
    t.string "word_arabic"
    t.string "word_translation"
    t.string "segment_arabic"
    t.string "segment_translation"
    t.integer "segment_first_word_id"
    t.integer "segment_last_word_id"
    t.integer "segment_first_word_timestamp"
    t.integer "segment_last_word_timestamp"
    t.integer "word_id"
    t.integer "verse_id"
    t.bigint "word_root_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["verse_id"], name: "index_dictionary_root_examples_on_verse_id"
    t.index ["word_id"], name: "index_dictionary_root_examples_on_word_id"
    t.index ["word_root_id"], name: "index_on_dict_word_example_id"
  end

  create_table "dictionary_word_roots", force: :cascade do |t|
    t.integer "frequency"
    t.integer "root_number"
    t.string "english_trilateral"
    t.string "arabic_trilateral"
    t.string "cover_url"
    t.text "description"
    t.integer "root_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arabic_trilateral"], name: "index_dictionary_word_roots_on_arabic_trilateral"
    t.index ["english_trilateral"], name: "index_dictionary_word_roots_on_english_trilateral"
    t.index ["root_id"], name: "index_dictionary_word_roots_on_root_id"
    t.index ["root_number"], name: "index_dictionary_word_roots_on_root_number"
  end

  create_table "foot_notes", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.text "text"
    t.integer "language_id"
    t.string "language_name"
    t.integer "resource_content_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["language_id"], name: "index_foot_notes_on_language_id"
    t.index ["resource_content_id"], name: "index_foot_notes_on_resource_content_id"
    t.index ["resource_type", "resource_id"], name: "index_foot_notes_on_resource"
  end

  create_table "hizbs", force: :cascade do |t|
    t.integer "hizb_number"
    t.integer "verses_count"
    t.jsonb "verse_mapping"
    t.integer "first_verse_id"
    t.integer "last_verse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_verse_id", "last_verse_id"], name: "index_hizbs_on_first_verse_id_and_last_verse_id"
    t.index ["hizb_number"], name: "index_hizbs_on_hizb_number"
  end

  create_table "juzs", id: :serial, force: :cascade do |t|
    t.integer "juz_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "verse_mapping"
    t.integer "first_verse_id"
    t.integer "last_verse_id"
    t.integer "verses_count"
    t.index ["first_verse_id"], name: "index_juzs_on_first_verse_id"
    t.index ["juz_number"], name: "index_juzs_on_juz_number"
    t.index ["last_verse_id"], name: "index_juzs_on_last_verse_id"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "iso_code"
    t.string "native_name"
    t.string "direction"
    t.string "es_analyzer_default"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["iso_code"], name: "index_languages_on_iso_code", unique: true
    t.index ["translations_count"], name: "index_languages_on_translations_count"
  end

  create_table "lemmas", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "words_count"
    t.integer "uniq_words_count"
  end

  create_table "manzils", force: :cascade do |t|
    t.integer "manzil_number"
    t.integer "verses_count"
    t.json "verse_mapping"
    t.integer "first_verse_id"
    t.integer "last_verse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_verse_id", "last_verse_id"], name: "index_manzils_on_first_verse_id_and_last_verse_id"
    t.index ["manzil_number"], name: "index_manzils_on_manzil_number"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["language_id"], name: "index_media_contents_on_language_id"
    t.index ["resource_content_id"], name: "index_media_contents_on_resource_content_id"
    t.index ["resource_type", "resource_id"], name: "index_media_contents_on_resource"
  end

  create_table "morphology_derived_words", force: :cascade do |t|
    t.bigint "verse_id"
    t.bigint "word_id"
    t.bigint "derived_word_id"
    t.bigint "word_verb_from_id"
    t.string "form_name"
    t.string "en_transliteration"
    t.string "en_translation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["derived_word_id"], name: "index_morphology_derived_words_on_derived_word_id"
    t.index ["verse_id"], name: "index_morphology_derived_words_on_verse_id"
    t.index ["word_id"], name: "index_morphology_derived_words_on_word_id"
    t.index ["word_verb_from_id"], name: "index_morphology_derived_words_on_word_verb_from_id"
  end

  create_table "morphology_grammar_concepts", force: :cascade do |t|
    t.string "english"
    t.string "arabic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arabic"], name: "index_morphology_grammar_concepts_on_arabic"
    t.index ["english"], name: "index_morphology_grammar_concepts_on_english"
  end

  create_table "morphology_grammar_patterns", force: :cascade do |t|
    t.string "english"
    t.string "arabic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arabic"], name: "index_morphology_grammar_patterns_on_arabic"
    t.index ["english"], name: "index_morphology_grammar_patterns_on_english"
  end

  create_table "morphology_grammar_terms", force: :cascade do |t|
    t.string "category"
    t.string "term"
    t.string "arabic_grammar_name"
    t.string "english_grammar_name"
    t.string "urdu_grammar_name"
    t.text "arabic_description"
    t.text "english_description"
    t.text "urdu_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_morphology_grammar_terms_on_category"
    t.index ["term"], name: "index_morphology_grammar_terms_on_term"
  end

  create_table "morphology_word_grammar_concepts", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "grammar_concept_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grammar_concept_id"], name: "index_morphology_word_grammar_concepts_on_grammar_concept_id"
    t.index ["word_id"], name: "index_morphology_word_grammar_concepts_on_word_id"
  end

  create_table "morphology_word_segments", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "root_id"
    t.bigint "topic_id"
    t.bigint "lemma_id"
    t.bigint "grammar_concept_id"
    t.bigint "grammar_role_id"
    t.bigint "grammar_sub_role_id"
    t.bigint "grammar_term_id"
    t.string "grammar_term_key"
    t.string "grammar_term_name"
    t.string "part_of_speech_key"
    t.string "part_of_speech_name"
    t.integer "position"
    t.string "text_uthmani"
    t.string "grammar_term_desc_english"
    t.string "grammar_term_desc_arabic"
    t.string "pos_tags"
    t.string "root_name"
    t.string "lemma_name"
    t.string "verb_form"
    t.boolean "hidden", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grammar_concept_id"], name: "index_morphology_word_segments_on_grammar_concept_id"
    t.index ["grammar_role_id"], name: "index_morphology_word_segments_on_grammar_role_id"
    t.index ["grammar_sub_role_id"], name: "index_morphology_word_segments_on_grammar_sub_role_id"
    t.index ["grammar_term_id"], name: "index_morphology_word_segments_on_grammar_term_id"
    t.index ["lemma_id"], name: "index_morphology_word_segments_on_lemma_id"
    t.index ["part_of_speech_key"], name: "index_morphology_word_segments_on_part_of_speech_key"
    t.index ["pos_tags"], name: "index_morphology_word_segments_on_pos_tags"
    t.index ["position"], name: "index_morphology_word_segments_on_position"
    t.index ["root_id"], name: "index_morphology_word_segments_on_root_id"
    t.index ["topic_id"], name: "index_morphology_word_segments_on_topic_id"
    t.index ["word_id"], name: "index_morphology_word_segments_on_word_id"
  end

  create_table "morphology_word_verb_forms", force: :cascade do |t|
    t.bigint "word_id"
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_morphology_word_verb_forms_on_name"
    t.index ["word_id"], name: "index_morphology_word_verb_forms_on_word_id"
  end

  create_table "morphology_words", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "verse_id"
    t.bigint "grammar_pattern_id"
    t.bigint "grammar_base_pattern_id"
    t.integer "words_count_for_root"
    t.integer "words_count_for_lemma"
    t.integer "words_count_for_stem"
    t.string "location"
    t.text "description"
    t.string "case"
    t.string "case_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grammar_base_pattern_id"], name: "index_morphology_words_on_grammar_base_pattern_id"
    t.index ["grammar_pattern_id"], name: "index_morphology_words_on_grammar_pattern_id"
    t.index ["location"], name: "index_morphology_words_on_location"
    t.index ["verse_id"], name: "index_morphology_words_on_verse_id"
    t.index ["word_id"], name: "index_morphology_words_on_word_id"
  end

  create_table "mushaf_juzs", force: :cascade do |t|
    t.integer "mushaf_type"
    t.integer "mushaf_id"
    t.integer "juz_id"
    t.jsonb "verse_mapping"
    t.integer "juz_number"
    t.integer "verses_count"
    t.integer "first_verse_id"
    t.integer "last_verse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_verse_id"], name: "index_mushaf_juzs_on_first_verse_id"
    t.index ["juz_id"], name: "index_mushaf_juzs_on_juz_id"
    t.index ["juz_number"], name: "index_mushaf_juzs_on_juz_number"
    t.index ["last_verse_id"], name: "index_mushaf_juzs_on_last_verse_id"
    t.index ["mushaf_id"], name: "index_mushaf_juzs_on_mushaf_id"
    t.index ["mushaf_type"], name: "index_mushaf_juzs_on_mushaf_type"
  end

  create_table "mushaf_pages", force: :cascade do |t|
    t.integer "page_number"
    t.integer "mushaf_id"
    t.integer "first_verse_id"
    t.integer "last_verse_id"
    t.integer "verses_count"
    t.json "verse_mapping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "first_word_id"
    t.integer "last_word_id"
    t.index ["mushaf_id"], name: "index_mushaf_pages_on_mushaf_id"
    t.index ["page_number"], name: "index_mushaf_pages_on_page_number"
  end

  create_table "mushaf_words", force: :cascade do |t|
    t.integer "mushaf_id"
    t.integer "word_id"
    t.integer "verse_id"
    t.string "text"
    t.integer "char_type_id"
    t.string "char_type_name"
    t.integer "line_number"
    t.integer "page_number"
    t.integer "position_in_verse"
    t.integer "position_in_line"
    t.integer "position_in_page"
    t.string "css_style"
    t.string "css_class"
    t.index ["mushaf_id", "verse_id", "position_in_page"], name: "index_on_mushaf_word_position"
    t.index ["mushaf_id", "word_id"], name: "index_mushaf_words_on_mushaf_id_and_word_id"
  end

  create_table "mushafs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "lines_per_page"
    t.boolean "is_default", default: false
    t.string "default_font_name"
    t.bigint "resource_content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pages_count"
    t.integer "qirat_type_id"
    t.boolean "enabled"
    t.index ["enabled"], name: "index_mushafs_on_enabled"
    t.index ["is_default"], name: "index_mushafs_on_is_default"
    t.index ["qirat_type_id"], name: "index_mushafs_on_qirat_type_id"
    t.index ["resource_content_id"], name: "index_mushafs_on_resource_content_id"
  end

  create_table "navigation_search_records", force: :cascade do |t|
    t.string "result_type"
    t.string "searchable_record_type"
    t.bigint "searchable_record_id"
    t.string "name"
    t.string "key"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["result_type"], name: "index_navigation_search_records_on_result_type"
    t.index ["searchable_record_type", "searchable_record_id"], name: "index_navigation_search_records_on_searchable_record"
    t.index ["text"], name: "index_navigation_search_records_on_text"
  end

  create_table "qirat_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "audio_recitations_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qr_authors", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.boolean "verified"
    t.string "avatar_url"
    t.text "bio"
    t.integer "user_type"
    t.integer "followers_count", default: 0
    t.integer "followings_count", default: 0
    t.integer "posts_count", default: 0
    t.integer "comments_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_type"], name: "index_qr_authors_on_user_type"
    t.index ["username"], name: "index_qr_authors_on_username"
    t.index ["verified"], name: "index_qr_authors_on_verified"
  end

  create_table "qr_comments", force: :cascade do |t|
    t.text "body"
    t.text "html_body"
    t.integer "replies_count", default: 0
    t.integer "post_id"
    t.integer "parent_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_qr_comments_on_author_id"
    t.index ["parent_id"], name: "index_qr_comments_on_parent_id"
    t.index ["post_id"], name: "index_qr_comments_on_post_id"
  end

  create_table "qr_filters", force: :cascade do |t|
    t.integer "book_id"
    t.integer "topic_id"
    t.integer "chapter_id"
    t.integer "verse_number_from"
    t.integer "verse_number_to"
    t.string "verse_key_from"
    t.string "verse_key_to"
    t.integer "verse_id_from"
    t.integer "verse_id_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_qr_filters_on_chapter_id"
    t.index ["verse_id_from"], name: "index_qr_filters_on_verse_id_from"
    t.index ["verse_id_to"], name: "index_qr_filters_on_verse_id_to"
    t.index ["verse_number_from"], name: "index_qr_filters_on_verse_number_from"
    t.index ["verse_number_to"], name: "index_qr_filters_on_verse_number_to"
  end

  create_table "qr_post_filters", force: :cascade do |t|
    t.integer "post_id"
    t.integer "filter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "filter_id"], name: "index_qr_post_filters_on_post_id_and_filter_id"
  end

  create_table "qr_post_tags", force: :cascade do |t|
    t.integer "post_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "tag_id"], name: "index_qr_post_tags_on_post_id_and_tag_id"
  end

  create_table "qr_posts", force: :cascade do |t|
    t.integer "post_type"
    t.integer "author_id"
    t.boolean "verified"
    t.integer "likes_count", default: 0
    t.integer "comments_count", default: 0
    t.integer "views_count", default: 0
    t.integer "language_id"
    t.integer "ranking_weight"
    t.string "language_name"
    t.string "url"
    t.json "referenced_ayahs"
    t.text "body"
    t.text "html_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id"
    t.integer "room_post_status"
    t.index ["author_id"], name: "index_qr_posts_on_author_id"
    t.index ["language_id"], name: "index_qr_posts_on_language_id"
    t.index ["post_type"], name: "index_qr_posts_on_post_type"
    t.index ["ranking_weight"], name: "index_qr_posts_on_ranking_weight"
    t.index ["room_post_status"], name: "index_qr_posts_on_room_post_status"
    t.index ["verified"], name: "index_qr_posts_on_verified"
  end

  create_table "qr_reported_issues", force: :cascade do |t|
    t.integer "post_id"
    t.integer "comment_id"
    t.string "name"
    t.string "email"
    t.text "body"
    t.boolean "synced_with_qr", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qr_rooms", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qr_tags", force: :cascade do |t|
    t.string "name"
    t.boolean "approved", default: true
    t.integer "posts_count"
    t.integer "comments_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_qr_tags_on_approved"
    t.index ["name"], name: "index_qr_tags_on_name"
    t.index ["posts_count"], name: "index_qr_tags_on_posts_count"
  end

  create_table "radio_station_audio_files", force: :cascade do |t|
    t.integer "radio_station_id"
    t.integer "chapter_audio_file_id"
    t.integer "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["radio_station_id", "chapter_audio_file_id", "chapter_id"], name: "index_on_radio_audio_files"
  end

  create_table "radio_stations", force: :cascade do |t|
    t.string "name"
    t.string "cover_image"
    t.string "profile_picture"
    t.text "description"
    t.integer "audio_recitation_id"
    t.integer "parent_id"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_recitation_id"], name: "index_radio_stations_on_audio_recitation_id"
    t.index ["parent_id"], name: "index_radio_stations_on_parent_id"
    t.index ["priority"], name: "index_radio_stations_on_priority"
  end

  create_table "recitation_styles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "arabic"
    t.string "slug"
    t.integer "recitations_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["slug"], name: "index_recitation_styles_on_slug"
  end

  create_table "recitations", id: :serial, force: :cascade do |t|
    t.integer "reciter_id"
    t.integer "resource_content_id"
    t.integer "recitation_style_id"
    t.string "reciter_name"
    t.string "style"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "qirat_type_id"
    t.index ["qirat_type_id"], name: "index_recitations_on_qirat_type_id"
    t.index ["recitation_style_id"], name: "index_recitations_on_recitation_style_id"
    t.index ["reciter_id"], name: "index_recitations_on_reciter_id"
    t.index ["resource_content_id"], name: "index_recitations_on_resource_content_id"
  end

  create_table "reciters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "recitations_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "profile_picture"
    t.string "cover_image"
    t.text "bio"
  end

  create_table "related_topics", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "related_topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_related_topics_on_topic_id"
  end

  create_table "resource_content_stats", id: :serial, force: :cascade do |t|
    t.integer "resource_content_id"
    t.integer "download_count"
    t.string "platform"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["platform"], name: "index_resource_content_stats_on_platform"
    t.index ["resource_content_id"], name: "index_resource_content_stats_on_resource_content_id"
  end

  create_table "resource_contents", id: :serial, force: :cascade do |t|
    t.boolean "approved"
    t.integer "author_id"
    t.integer "data_source_id"
    t.string "author_name"
    t.string "resource_type_name"
    t.string "sub_type"
    t.string "name"
    t.integer "mobile_translation_id"
    t.text "description"
    t.string "cardinality_type"
    t.integer "language_id"
    t.string "language_name"
    t.integer "records_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.string "resource_type"
    t.string "sqlite_db"
    t.datetime "sqlite_db_generated_at", precision: nil
    t.index ["approved"], name: "index_resource_contents_on_approved"
    t.index ["author_id"], name: "index_resource_contents_on_author_id"
    t.index ["cardinality_type"], name: "index_resource_contents_on_cardinality_type"
    t.index ["data_source_id"], name: "index_resource_contents_on_data_source_id"
    t.index ["language_id"], name: "index_resource_contents_on_language_id"
    t.index ["mobile_translation_id"], name: "index_resource_contents_on_mobile_translation_id"
    t.index ["resource_type_name"], name: "index_resource_contents_on_resource_type_name"
    t.index ["slug"], name: "index_resource_contents_on_slug"
    t.index ["sub_type"], name: "index_resource_contents_on_sub_type"
  end

  create_table "roots", id: :serial, force: :cascade do |t|
    t.string "text_clean"
    t.string "text_uthmani"
    t.string "english_trilateral"
    t.string "arabic_trilateral"
    t.string "dictionary_image_path"
    t.json "en_translations"
    t.json "ur_translations"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "words_count"
    t.integer "uniq_words_count"
    t.index ["arabic_trilateral"], name: "index_roots_on_arabic_trilateral"
    t.index ["english_trilateral"], name: "index_roots_on_english_trilateral"
    t.index ["text_clean"], name: "index_roots_on_text_clean"
    t.index ["text_uthmani"], name: "index_roots_on_text_uthmani"
  end

  create_table "rub_el_hizbs", force: :cascade do |t|
    t.integer "rub_el_hizb_number"
    t.integer "verses_count"
    t.json "verse_mapping"
    t.integer "first_verse_id"
    t.integer "last_verse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_verse_id", "last_verse_id"], name: "index_rub_el_hizbs_on_first_verse_id_and_last_verse_id"
    t.index ["rub_el_hizb_number"], name: "index_rub_el_hizbs_on_rub_el_hizb_number"
  end

  create_table "rukus", force: :cascade do |t|
    t.integer "ruku_number"
    t.integer "surah_ruku_number"
    t.json "verse_mapping"
    t.integer "verses_count"
    t.integer "first_verse_id"
    t.integer "last_verse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_verse_id", "last_verse_id"], name: "index_rukus_on_first_verse_id_and_last_verse_id"
    t.index ["ruku_number"], name: "index_rukus_on_ruku_number"
  end

  create_table "slugs", force: :cascade do |t|
    t.bigint "chapter_id"
    t.string "slug"
    t.string "locale"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.integer "language_priority"
    t.integer "language_id"
    t.index ["chapter_id", "slug"], name: "index_slugs_on_chapter_id_and_slug"
    t.index ["chapter_id"], name: "index_slugs_on_chapter_id"
    t.index ["language_id"], name: "index_slugs_on_language_id"
    t.index ["language_priority"], name: "index_slugs_on_language_priority"
  end

  create_table "stems", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "words_count"
    t.integer "uniq_words_count"
  end

  create_table "tafsirs", id: :serial, force: :cascade do |t|
    t.integer "verse_id"
    t.integer "language_id"
    t.text "text"
    t.string "language_name"
    t.integer "resource_content_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "resource_name"
    t.string "verse_key"
    t.integer "chapter_id"
    t.integer "verse_number"
    t.integer "juz_number"
    t.integer "hizb_number"
    t.integer "rub_el_hizb_number"
    t.integer "page_number"
    t.string "group_verse_key_from"
    t.string "group_verse_key_to"
    t.integer "group_verses_count"
    t.integer "group_tafsir_id"
    t.integer "start_verse_id"
    t.integer "end_verse_id"
    t.integer "ruku_number"
    t.integer "surah_ruku_number"
    t.integer "manzil_number"
    t.index ["chapter_id", "verse_number"], name: "index_tafsirs_on_chapter_id_and_verse_number"
    t.index ["chapter_id"], name: "index_tafsirs_on_chapter_id"
    t.index ["end_verse_id"], name: "index_tafsirs_on_end_verse_id"
    t.index ["hizb_number"], name: "index_tafsirs_on_hizb_number"
    t.index ["juz_number"], name: "index_tafsirs_on_juz_number"
    t.index ["language_id"], name: "index_tafsirs_on_language_id"
    t.index ["manzil_number"], name: "index_tafsirs_on_manzil_number"
    t.index ["page_number"], name: "index_tafsirs_on_page_number"
    t.index ["resource_content_id"], name: "index_tafsirs_on_resource_content_id"
    t.index ["rub_el_hizb_number"], name: "index_tafsirs_on_rub_el_hizb_number"
    t.index ["ruku_number"], name: "index_tafsirs_on_ruku_number"
    t.index ["start_verse_id"], name: "index_tafsirs_on_start_verse_id"
    t.index ["verse_id"], name: "index_tafsirs_on_verse_id"
    t.index ["verse_key"], name: "index_tafsirs_on_verse_key"
  end

  create_table "tokens", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.string "text_indopak"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "text"
    t.integer "resource_content_id"
    t.integer "record_id"
    t.string "record_type"
    t.integer "uniq_token_count"
    t.index ["record_type", "record_id"], name: "index_tokens_on_record_type_and_record_id"
    t.index ["resource_content_id"], name: "index_tokens_on_resource_content_id"
    t.index ["text"], name: "index_tokens_on_text"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "wikipedia_link"
    t.string "arabic_name"
    t.boolean "ontology"
    t.boolean "thematic"
    t.integer "depth", default: 0
    t.string "ayah_range"
    t.integer "relatd_topics_count", default: 0
    t.integer "childen_count", default: 0
    t.text "description"
    t.integer "ontology_parent_id"
    t.integer "thematic_parent_id"
    t.integer "resource_content_id"
    t.index ["depth"], name: "index_topics_on_depth"
    t.index ["name"], name: "index_topics_on_name"
    t.index ["ontology"], name: "index_topics_on_ontology"
    t.index ["ontology_parent_id"], name: "index_topics_on_ontology_parent_id"
    t.index ["parent_id"], name: "index_topics_on_parent_id"
    t.index ["thematic"], name: "index_topics_on_thematic"
    t.index ["thematic_parent_id"], name: "index_topics_on_thematic_parent_id"
  end

  create_table "translated_names", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "language_id"
    t.string "name"
    t.string "language_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "language_priority"
    t.index ["language_id"], name: "index_translated_names_on_language_id"
    t.index ["language_priority"], name: "index_translated_names_on_language_priority"
    t.index ["resource_type", "resource_id"], name: "index_translated_names_on_resource"
  end

  create_table "translations", id: :serial, force: :cascade do |t|
    t.integer "language_id"
    t.integer "verse_id"
    t.text "text"
    t.integer "resource_content_id"
    t.string "language_name"
    t.integer "priority"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "resource_name"
    t.string "verse_key"
    t.integer "chapter_id"
    t.integer "verse_number"
    t.integer "juz_number"
    t.integer "hizb_number"
    t.integer "rub_el_hizb_number"
    t.integer "page_number"
    t.integer "ruku_number"
    t.integer "surah_ruku_number"
    t.integer "manzil_number"
    t.index ["chapter_id", "verse_number"], name: "index_translations_on_chapter_id_and_verse_number"
    t.index ["chapter_id"], name: "index_translations_on_chapter_id"
    t.index ["hizb_number"], name: "index_translations_on_hizb_number"
    t.index ["juz_number"], name: "index_translations_on_juz_number"
    t.index ["language_id"], name: "index_translations_on_language_id"
    t.index ["manzil_number"], name: "index_translations_on_manzil_number"
    t.index ["page_number"], name: "index_translations_on_page_number"
    t.index ["priority"], name: "index_translations_on_priority"
    t.index ["resource_content_id"], name: "index_translations_on_resource_content_id"
    t.index ["rub_el_hizb_number"], name: "index_translations_on_rub_el_hizb_number"
    t.index ["ruku_number"], name: "index_translations_on_ruku_number"
    t.index ["verse_id"], name: "index_translations_on_verse_id"
    t.index ["verse_key"], name: "index_translations_on_verse_key"
  end

  create_table "transliterations", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "language_id"
    t.text "text"
    t.string "language_name"
    t.integer "resource_content_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["language_id"], name: "index_transliterations_on_language_id"
    t.index ["resource_content_id"], name: "index_transliterations_on_resource_content_id"
    t.index ["resource_type", "resource_id"], name: "index_transliterations_on_resource"
  end

  create_table "verse_lemmas", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "verse_pages", force: :cascade do |t|
    t.integer "verse_id"
    t.integer "page_id"
    t.integer "page_number"
    t.integer "mushaf_id"
    t.index ["page_number", "mushaf_id"], name: "index_verse_pages_on_page_number_and_mushaf_id"
    t.index ["verse_id"], name: "index_verse_pages_on_verse_id"
  end

  create_table "verse_roots", id: :serial, force: :cascade do |t|
    t.text "value"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "verse_stems", id: :serial, force: :cascade do |t|
    t.string "text_madani"
    t.string "text_clean"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "verse_topics", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "verse_id"
    t.jsonb "topic_words", default: []
    t.boolean "ontology"
    t.boolean "thematic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_verse_topics_on_topic_id"
    t.index ["verse_id"], name: "index_verse_topics_on_verse_id"
  end

  create_table "verses", id: :serial, force: :cascade do |t|
    t.integer "chapter_id"
    t.integer "verse_number"
    t.integer "verse_index"
    t.string "verse_key"
    t.text "text_madani"
    t.text "text_uthmani_simple"
    t.text "text_uthmani_tajweed"
    t.text "text_indopak"
    t.text "text_simple"
    t.text "text_imlaei"
    t.integer "juz_number"
    t.integer "hizb_number"
    t.integer "rub_el_hizb_number"
    t.string "sajdah"
    t.integer "sajdah_number"
    t.integer "page_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "image_url"
    t.integer "image_width"
    t.integer "verse_root_id"
    t.integer "verse_lemma_id"
    t.integer "verse_stem_id"
    t.string "code_v1"
    t.string "code_v2"
    t.integer "v2_page"
    t.string "text_indopak_nastaleeq"
    t.string "text_qpc_nastaleeq"
    t.string "text_qpc_nastaleeq_hafs"
    t.integer "words_count"
    t.integer "pause_words_count", default: 0
    t.jsonb "mushaf_pages_mapping", default: {}
    t.integer "ruku_number"
    t.integer "surah_ruku_number"
    t.integer "manzil_number"
    t.jsonb "mushaf_juzs_mapping", default: {}
    t.index ["chapter_id"], name: "index_verses_on_chapter_id"
    t.index ["hizb_number"], name: "index_verses_on_hizb_number"
    t.index ["juz_number"], name: "index_verses_on_juz_number"
    t.index ["manzil_number"], name: "index_verses_on_manzil_number"
    t.index ["rub_el_hizb_number"], name: "index_verses_on_rub_el_hizb_number"
    t.index ["ruku_number"], name: "index_verses_on_ruku_number"
    t.index ["verse_index"], name: "index_verses_on_verse_index"
    t.index ["verse_key"], name: "index_verses_on_verse_key"
    t.index ["verse_lemma_id"], name: "index_verses_on_verse_lemma_id"
    t.index ["verse_number"], name: "index_verses_on_verse_number"
    t.index ["verse_root_id"], name: "index_verses_on_verse_root_id"
    t.index ["verse_stem_id"], name: "index_verses_on_verse_stem_id"
    t.index ["words_count"], name: "index_verses_on_words_count"
  end

  create_table "word_corpuses", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.string "location"
    t.text "description"
    t.string "image_src"
    t.jsonb "segments_data", default: {}
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["word_id"], name: "index_word_corpuses_on_word_id"
  end

  create_table "word_lemmas", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "lemma_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["lemma_id"], name: "index_word_lemmas_on_lemma_id"
    t.index ["word_id"], name: "index_word_lemmas_on_word_id"
  end

  create_table "word_roots", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "root_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["root_id"], name: "index_word_roots_on_root_id"
    t.index ["word_id"], name: "index_word_roots_on_word_id"
  end

  create_table "word_stems", id: :serial, force: :cascade do |t|
    t.integer "word_id"
    t.integer "stem_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["priority"], name: "index_word_translations_on_priority"
    t.index ["word_id", "language_id"], name: "index_word_translations_on_word_id_and_language_id"
  end

  create_table "words", id: :serial, force: :cascade do |t|
    t.integer "verse_id"
    t.integer "chapter_id"
    t.integer "position"
    t.string "text_madani"
    t.string "text_indopak"
    t.string "text_simple"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "pause_name"
    t.integer "token_id"
    t.integer "topic_id"
    t.string "char_type_name"
    t.string "code_v1"
    t.string "code_v2"
    t.integer "v2_page"
    t.string "text_indopak_nastaleeq"
    t.string "text_qpc_nastaleeq"
    t.string "text_qpc_nastaleeq_hafs"
    t.index ["chapter_id"], name: "index_words_on_chapter_id"
    t.index ["char_type_id"], name: "index_words_on_char_type_id"
    t.index ["location"], name: "index_words_on_location"
    t.index ["position"], name: "index_words_on_position"
    t.index ["token_id"], name: "index_words_on_token_id"
    t.index ["topic_id"], name: "index_words_on_topic_id"
    t.index ["verse_id"], name: "index_words_on_verse_id"
    t.index ["verse_key"], name: "index_words_on_verse_key"
  end

  add_foreign_key "country_language_preferences", "languages", column: "default_wbw_language", primary_key: "iso_code", on_delete: :cascade
  add_foreign_key "country_language_preferences", "languages", column: "user_device_language", primary_key: "iso_code", on_delete: :cascade
  add_foreign_key "country_language_preferences", "mushafs", column: "default_mushaf_id", on_delete: :cascade
  add_foreign_key "country_language_preferences", "reciters", column: "default_reciter", on_delete: :cascade
  add_foreign_key "country_language_preferences", "resource_contents", column: "default_tafsir_id", on_delete: :cascade
  add_foreign_key "morphology_derived_words", "verses"
  add_foreign_key "morphology_derived_words", "words"
  add_foreign_key "morphology_word_grammar_concepts", "words"
  add_foreign_key "morphology_word_segments", "lemmas"
  add_foreign_key "morphology_word_segments", "roots"
  add_foreign_key "morphology_word_segments", "topics"
  add_foreign_key "morphology_word_segments", "words"
  add_foreign_key "morphology_word_verb_forms", "words"
  add_foreign_key "morphology_words", "verses"
  add_foreign_key "morphology_words", "words"
  add_foreign_key "word_lemmas", "lemmas"
  add_foreign_key "word_lemmas", "words"
  add_foreign_key "word_stems", "stems"
  add_foreign_key "word_stems", "words"
end
