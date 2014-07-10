# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"

  create_table "author", primary_key: "author_id", force: true do |t|
    t.text "url",               array: true
    t.text "name", null: false
  end

  create_table "ayah", id: false, force: true do |t|
    t.integer "ayah_index", null: false
    t.integer "surah_id"
    t.integer "ayah_num"
    t.integer "page_num"
    t.integer "juz_num"
    t.integer "hizb_num"
    t.integer "rub_num"
    t.text    "text"
    t.text    "ayah_key",   null: false
    t.text    "sajdah"
  end

  add_index "ayah", ["ayah_index"], name: "ayah_index_key", unique: true, using: :btree
  add_index "ayah", ["surah_id", "ayah_num"], name: "surah_ayah_key", unique: true, using: :btree
  add_index "ayah", ["surah_id"], name: "ayah_surah_id_idx", using: :btree

  create_table "char_type", primary_key: "char_type_id", force: true do |t|
    t.text    "name",        null: false
    t.text    "description"
    t.integer "parent_id"
  end

  add_index "char_type", ["name", "parent_id"], name: "char_type_name_parent_id_key", unique: true, using: :btree

# Could not dump table "file" because of following StandardError
#   Unknown type 'format' for column 'format'

  create_table "image", id: false, force: true do |t|
    t.integer "resource_id", null: false
    t.text    "ayah_key",    null: false
    t.text    "url",         null: false
    t.text    "alt",         null: false
    t.integer "width",       null: false
  end

  create_table "language", id: false, force: true do |t|
    t.text    "language_code",                 null: false
    t.text    "unicode"
    t.text    "english",                       null: false
    t.text    "direction",     default: "ltr", null: false
    t.integer "priority",      default: 999,   null: false
    t.boolean "beta",          default: true,  null: false
  end

  create_table "lemma", primary_key: "lemma_id", force: true do |t|
    t.string "value", limit: 50, null: false
    t.string "clean", limit: 50, null: false
  end

  add_index "lemma", ["value"], name: "lemma_value_key", unique: true, using: :btree

  create_table "recitation", primary_key: "recitation_id", force: true do |t|
    t.integer "reciter_id",                null: false
    t.integer "style_id"
    t.boolean "is_enabled", default: true, null: false
  end

  add_index "recitation", ["reciter_id", "style_id"], name: "recitation_reciter_id_style_id_key", unique: true, using: :btree

  create_table "reciter", primary_key: "reciter_id", force: true do |t|
    t.text "path",    null: false
    t.text "slug",    null: false
    t.text "english", null: false
    t.text "arabic",  null: false
  end

  add_index "reciter", ["arabic"], name: "_reciter_arabic_key", unique: true, using: :btree
  add_index "reciter", ["english"], name: "_reciter_english_key", unique: true, using: :btree
  add_index "reciter", ["path"], name: "_reciter_path_key", unique: true, using: :btree
  add_index "reciter", ["slug"], name: "_reciter_slug_key", unique: true, using: :btree

  create_table "resource", primary_key: "resource_id", force: true do |t|
    t.text    "type",                                null: false
    t.text    "sub_type",                            null: false
    t.text    "cardinality_type", default: "1_ayah", null: false
    t.text    "language_code",                       null: false
    t.text    "slug",                                null: false
    t.boolean "is_available",     default: true,     null: false
    t.text    "description"
    t.integer "author_id"
    t.integer "source_id"
    t.text    "name",                                null: false
  end

  add_index "resource", ["type", "sub_type", "language_code", "slug"], name: "resource_type_sub_type_language_code_slug_key", unique: true, using: :btree

  create_table "resource_api_version", id: false, force: true do |t|
    t.integer "resource_id",                   null: false
    t.boolean "v1_is_enabled", default: false, null: false
    t.boolean "v1_is_default"
    t.boolean "v1_separator"
    t.boolean "v1_label"
    t.integer "v1_order"
    t.integer "v1_id"
    t.text    "v1_name"
    t.boolean "v2_is_enabled", default: false, null: false
    t.boolean "v2_is_default"
    t.float   "v2_weighted",   default: 0.618, null: false
  end

  create_table "root", primary_key: "root_id", force: true do |t|
    t.string "value", limit: 50, null: false
  end

  add_index "root", ["value"], name: "root_value_key", unique: true, using: :btree

  create_table "source", id: false, force: true do |t|
    t.integer "source_id", null: false
    t.text    "name",      null: false
    t.text    "url"
  end

  create_table "stem", primary_key: "stem_id", force: true do |t|
    t.string "value", limit: 50, null: false
    t.string "clean", limit: 50, null: false
  end

  add_index "stem", ["value"], name: "stem_value_key", unique: true, using: :btree

  create_table "style", primary_key: "style_id", force: true do |t|
    t.text "path",    null: false
    t.text "slug",    null: false
    t.text "english", null: false
    t.text "arabic",  null: false
  end

  add_index "style", ["arabic"], name: "_style_arabic_key", unique: true, using: :btree
  add_index "style", ["english"], name: "_style_english_key", unique: true, using: :btree
  add_index "style", ["path"], name: "_style_path_key", unique: true, using: :btree
  add_index "style", ["slug"], name: "_style_slug_key", unique: true, using: :btree

# Could not dump table "surah" because of following StandardError
#   Unknown type 'place' for column 'revelation_place'

  create_table "tafsir", primary_key: "tafsir_id", force: true do |t|
    t.integer "resource_id", null: false
    t.text    "text",        null: false
  end

  add_index "tafsir", ["resource_id"], name: "tafsir_resource_id_md5_idx", unique: true, using: :btree

  create_table "tafsir_ayah", id: false, force: true do |t|
    t.integer "tafsir_id", null: false
    t.text    "ayah_key",  null: false
  end

  create_table "text", id: false, force: true do |t|
    t.integer "resource_id", null: false
    t.text    "ayah_key",    null: false
    t.text    "text",        null: false
  end

  create_table "token", primary_key: "token_id", force: true do |t|
    t.string "value", limit: 50, null: false
    t.string "clean", limit: 50, null: false
  end

  add_index "token", ["value"], name: "token_value_key", unique: true, using: :btree

  create_table "translation", id: false, force: true do |t|
    t.integer "resource_id", null: false
    t.text    "ayah_key",    null: false
    t.text    "text",        null: false
  end

  create_table "transliteration", id: false, force: true do |t|
    t.integer "resource_id", null: false
    t.text    "ayah_key",    null: false
    t.text    "text",        null: false
  end

  create_table "word", primary_key: "word_id", force: true do |t|
    t.text    "ayah_key", null: false
    t.integer "position", null: false
    t.integer "token_id", null: false
  end

  add_index "word", ["ayah_key", "position"], name: "word_ayah_key_position_key", unique: true, using: :btree

  create_table "word_font", id: false, force: true do |t|
    t.integer "resource_id",  null: false
    t.text    "ayah_key",     null: false
    t.integer "position",     null: false
    t.integer "word_id"
    t.integer "page_num",     null: false
    t.integer "line_num",     null: false
    t.integer "code_dec",     null: false
    t.text    "code_hex",     null: false
    t.integer "char_type_id", null: false
  end

  create_table "word_lemma", id: false, force: true do |t|
    t.integer "word_id",              null: false
    t.integer "lemma_id",             null: false
    t.integer "position", default: 1, null: false
  end

  create_table "word_root", id: false, force: true do |t|
    t.integer "word_id",              null: false
    t.integer "root_id",              null: false
    t.integer "position", default: 1, null: false
  end

  create_table "word_stem", id: false, force: true do |t|
    t.integer "word_id",              null: false
    t.integer "stem_id",              null: false
    t.integer "position", default: 1, null: false
  end

  create_table "word_translation", primary_key: "translation_id", force: true do |t|
    t.integer "word_id",       null: false
    t.text    "language_code", null: false
    t.text    "value",         null: false
  end

  add_index "word_translation", ["word_id", "language_code"], name: "translation_word_id_language_code_key", unique: true, using: :btree

end
