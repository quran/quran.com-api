# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170101154110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audio_files", force: :cascade do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.text     "url"
    t.integer  "duration"
    t.text     "segments"
    t.string   "mime_type"
    t.string   "format"
    t.boolean  "is_enabled"
    t.integer  "recitation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["is_enabled"], name: "index_audio_files_on_is_enabled", using: :btree
    t.index ["recitation_id"], name: "index_audio_files_on_recitation_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_audio_files_on_resource_type_and_resource_id", using: :btree
  end

  create_table "authors", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapter_infos", force: :cascade do |t|
    t.integer  "chapter_id"
    t.text     "text"
    t.string   "source"
    t.text     "short_text"
    t.integer  "language_id"
    t.integer  "resource_content_id"
    t.string   "language_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["chapter_id"], name: "index_chapter_infos_on_chapter_id", using: :btree
    t.index ["language_id"], name: "index_chapter_infos_on_language_id", using: :btree
    t.index ["resource_content_id"], name: "index_chapter_infos_on_resource_content_id", using: :btree
  end

  create_table "chapters", force: :cascade do |t|
    t.boolean  "bismillah_pre"
    t.integer  "revelation_order"
    t.string   "revelation_place"
    t.string   "name_complex"
    t.string   "name_arabic"
    t.string   "name_simple"
    t.string   "pages"
    t.integer  "verses_count"
    t.integer  "chapter_number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["chapter_number"], name: "index_chapters_on_chapter_number", using: :btree
  end

  create_table "char_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["parent_id"], name: "index_char_types_on_parent_id", using: :btree
  end

  create_table "data_sources", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foot_notes", force: :cascade do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.text     "text"
    t.integer  "language_id"
    t.string   "language_name"
    t.integer  "resource_content_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["language_id"], name: "index_foot_notes_on_language_id", using: :btree
    t.index ["resource_content_id"], name: "index_foot_notes_on_resource_content_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_foot_notes_on_resource_type_and_resource_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.string   "iso_code"
    t.string   "native_name"
    t.string   "direction"
    t.string   "es_analyzer_default"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["iso_code"], name: "index_languages_on_iso_code", using: :btree
  end

  create_table "media_contents", force: :cascade do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.text     "url"
    t.string   "duration"
    t.text     "embed_text"
    t.string   "provider"
    t.integer  "language_id"
    t.string   "language_name"
    t.string   "author_name"
    t.integer  "resource_content_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["language_id"], name: "index_media_contents_on_language_id", using: :btree
    t.index ["resource_content_id"], name: "index_media_contents_on_resource_content_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_media_contents_on_resource_type_and_resource_id", using: :btree
  end

  create_table "recitation_styles", force: :cascade do |t|
    t.string   "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recitations", force: :cascade do |t|
    t.integer  "reciter_id"
    t.integer  "resource_content_id"
    t.integer  "recitation_style_id"
    t.string   "reciter_name"
    t.string   "style"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["recitation_style_id"], name: "index_recitations_on_recitation_style_id", using: :btree
    t.index ["reciter_id"], name: "index_recitations_on_reciter_id", using: :btree
    t.index ["resource_content_id"], name: "index_recitations_on_resource_content_id", using: :btree
  end

  create_table "reciters", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resource_contents", force: :cascade do |t|
    t.boolean  "approved"
    t.integer  "author_id"
    t.integer  "data_source_id"
    t.string   "author_name"
    t.string   "resource_type"
    t.string   "sub_type"
    t.string   "name"
    t.text     "description"
    t.string   "cardinality_type"
    t.integer  "language_id"
    t.string   "language_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["approved"], name: "index_resource_contents_on_approved", using: :btree
    t.index ["author_id"], name: "index_resource_contents_on_author_id", using: :btree
    t.index ["cardinality_type"], name: "index_resource_contents_on_cardinality_type", using: :btree
    t.index ["data_source_id"], name: "index_resource_contents_on_data_source_id", using: :btree
    t.index ["language_id"], name: "index_resource_contents_on_language_id", using: :btree
    t.index ["resource_type"], name: "index_resource_contents_on_resource_type", using: :btree
    t.index ["sub_type"], name: "index_resource_contents_on_sub_type", using: :btree
  end

  create_table "tafsirs", force: :cascade do |t|
    t.integer  "verse_id"
    t.integer  "language_id"
    t.text     "text"
    t.string   "language_name"
    t.integer  "resource_content_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["language_id"], name: "index_tafsirs_on_language_id", using: :btree
    t.index ["resource_content_id"], name: "index_tafsirs_on_resource_content_id", using: :btree
    t.index ["verse_id"], name: "index_tafsirs_on_verse_id", using: :btree
  end

  create_table "translated_names", force: :cascade do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "language_id"
    t.string   "name"
    t.string   "language_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["language_id"], name: "index_translated_names_on_language_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_translated_names_on_resource_type_and_resource_id", using: :btree
  end

  create_table "translations", force: :cascade do |t|
    t.integer  "language_id"
    t.string   "text"
    t.integer  "resource_content_id"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "language_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["language_id"], name: "index_translations_on_language_id", using: :btree
    t.index ["resource_content_id"], name: "index_translations_on_resource_content_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_translations_on_resource_type_and_resource_id", using: :btree
  end

  create_table "transliterations", force: :cascade do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "language_id"
    t.text     "text"
    t.string   "language_name"
    t.integer  "resource_content_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["language_id"], name: "index_transliterations_on_language_id", using: :btree
    t.index ["resource_content_id"], name: "index_transliterations_on_resource_content_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_transliterations_on_resource_type_and_resource_id", using: :btree
  end

  create_table "verses", force: :cascade do |t|
    t.integer  "chapter_id"
    t.integer  "verse_number"
    t.integer  "verse_index"
    t.string   "verse_key"
    t.text     "text_madani"
    t.text     "text_indopak"
    t.text     "text_simple"
    t.text     "text_root"
    t.text     "text_stem"
    t.text     "text_token"
    t.text     "text_lemma"
    t.integer  "juz_number"
    t.integer  "hizb_number"
    t.integer  "rub_number"
    t.string   "sajdah"
    t.integer  "sajdah_number"
    t.integer  "page_number"
    t.string   "image_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["chapter_id"], name: "index_verses_on_chapter_id", using: :btree
    t.index ["verse_index"], name: "index_verses_on_verse_index", using: :btree
    t.index ["verse_key"], name: "index_verses_on_verse_key", using: :btree
    t.index ["verse_number"], name: "index_verses_on_verse_number", using: :btree
  end

  create_table "words", force: :cascade do |t|
    t.integer  "verse_id"
    t.integer  "chapter_id"
    t.integer  "position"
    t.text     "text_madani"
    t.text     "text_indopak"
    t.text     "text_simple"
    t.text     "text_root"
    t.text     "text_stem"
    t.text     "text_lemma"
    t.text     "text_token"
    t.json     "corpus"
    t.string   "verse_key"
    t.integer  "page_number"
    t.string   "class_name"
    t.integer  "line_number"
    t.integer  "code_dec"
    t.string   "code_hex"
    t.string   "code_hex_v3"
    t.integer  "code_dec_v3"
    t.integer  "char_type_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["chapter_id"], name: "index_words_on_chapter_id", using: :btree
    t.index ["char_type_id"], name: "index_words_on_char_type_id", using: :btree
    t.index ["position"], name: "index_words_on_position", using: :btree
    t.index ["verse_id"], name: "index_words_on_verse_id", using: :btree
    t.index ["verse_key"], name: "index_words_on_verse_key", using: :btree
  end

end
