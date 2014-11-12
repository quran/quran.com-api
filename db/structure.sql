--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: audio; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audio;


--
-- Name: content; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA content;


--
-- Name: i18n; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA i18n;


--
-- Name: quran; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA quran;


SET search_path = audio, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: file; Type: TABLE; Schema: audio; Owner: -; Tablespace: 
--

CREATE TABLE file (
    file_id integer NOT NULL,
    recitation_id integer NOT NULL,
    ayah_key text NOT NULL,
    format text NOT NULL,
    duration real NOT NULL,
    mime_type text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


--
-- Name: _file_file_id_seq; Type: SEQUENCE; Schema: audio; Owner: -
--

CREATE SEQUENCE _file_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _file_file_id_seq; Type: SEQUENCE OWNED BY; Schema: audio; Owner: -
--

ALTER SEQUENCE _file_file_id_seq OWNED BY file.file_id;


--
-- Name: reciter; Type: TABLE; Schema: audio; Owner: -; Tablespace: 
--

CREATE TABLE reciter (
    reciter_id integer NOT NULL,
    path text NOT NULL,
    slug text NOT NULL,
    english text NOT NULL,
    arabic text NOT NULL
);


--
-- Name: _reciter_reciter_id_seq; Type: SEQUENCE; Schema: audio; Owner: -
--

CREATE SEQUENCE _reciter_reciter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _reciter_reciter_id_seq; Type: SEQUENCE OWNED BY; Schema: audio; Owner: -
--

ALTER SEQUENCE _reciter_reciter_id_seq OWNED BY reciter.reciter_id;


--
-- Name: style; Type: TABLE; Schema: audio; Owner: -; Tablespace: 
--

CREATE TABLE style (
    style_id integer NOT NULL,
    path text NOT NULL,
    slug text NOT NULL,
    english text NOT NULL,
    arabic text NOT NULL
);


--
-- Name: _style_style_id_seq; Type: SEQUENCE; Schema: audio; Owner: -
--

CREATE SEQUENCE _style_style_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _style_style_id_seq; Type: SEQUENCE OWNED BY; Schema: audio; Owner: -
--

ALTER SEQUENCE _style_style_id_seq OWNED BY style.style_id;


--
-- Name: recitation; Type: TABLE; Schema: audio; Owner: -; Tablespace: 
--

CREATE TABLE recitation (
    recitation_id integer NOT NULL,
    reciter_id integer NOT NULL,
    style_id integer,
    is_enabled boolean DEFAULT true NOT NULL
);


--
-- Name: recitation_recitation_id_seq; Type: SEQUENCE; Schema: audio; Owner: -
--

CREATE SEQUENCE recitation_recitation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recitation_recitation_id_seq; Type: SEQUENCE OWNED BY; Schema: audio; Owner: -
--

ALTER SEQUENCE recitation_recitation_id_seq OWNED BY recitation.recitation_id;


--
-- Name: reciter_reciter_id_seq; Type: SEQUENCE; Schema: audio; Owner: -
--

CREATE SEQUENCE reciter_reciter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET search_path = content, pg_catalog;

--
-- Name: author; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE author (
    author_id integer NOT NULL,
    url text[],
    name text NOT NULL
);


--
-- Name: _author_author_id_seq; Type: SEQUENCE; Schema: content; Owner: -
--

CREATE SEQUENCE _author_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _author_author_id_seq; Type: SEQUENCE OWNED BY; Schema: content; Owner: -
--

ALTER SEQUENCE _author_author_id_seq OWNED BY author.author_id;


--
-- Name: tafsir; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE tafsir (
    tafsir_id integer NOT NULL,
    resource_id integer NOT NULL,
    text text NOT NULL
);


--
-- Name: _tafsir_tafsir_id_seq; Type: SEQUENCE; Schema: content; Owner: -
--

CREATE SEQUENCE _tafsir_tafsir_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _tafsir_tafsir_id_seq; Type: SEQUENCE OWNED BY; Schema: content; Owner: -
--

ALTER SEQUENCE _tafsir_tafsir_id_seq OWNED BY tafsir.tafsir_id;


--
-- Name: resource_resource_id_seq; Type: SEQUENCE; Schema: content; Owner: -
--

CREATE SEQUENCE resource_resource_id_seq
    START WITH 255
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE resource (
    resource_id integer DEFAULT nextval('resource_resource_id_seq'::regclass) NOT NULL,
    type text NOT NULL,
    sub_type text NOT NULL,
    cardinality_type text DEFAULT '1_ayah'::text NOT NULL,
    language_code text NOT NULL,
    slug text NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    description text,
    author_id integer,
    source_id integer,
    name text NOT NULL
);


--
-- Name: resource_api_version; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE resource_api_version (
    resource_id integer NOT NULL,
    v1_is_enabled boolean DEFAULT false NOT NULL,
    v1_is_default boolean,
    v1_separator boolean,
    v1_label boolean,
    v1_order integer,
    v1_id integer,
    v1_name text,
    v2_is_enabled boolean DEFAULT false NOT NULL,
    v2_is_default boolean,
    v2_weighted real DEFAULT 0.618 NOT NULL
);


--
-- Name: source; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE source (
    source_id integer NOT NULL,
    name text NOT NULL,
    url text
);


--
-- Name: tafsir_ayah; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE tafsir_ayah (
    tafsir_id integer NOT NULL,
    ayah_key text NOT NULL
);


--
-- Name: translation; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE translation (
    resource_id integer NOT NULL,
    ayah_key text NOT NULL,
    text text NOT NULL
);


--
-- Name: transliteration; Type: TABLE; Schema: content; Owner: -; Tablespace: 
--

CREATE TABLE transliteration (
    resource_id integer NOT NULL,
    ayah_key text NOT NULL,
    text text NOT NULL
);


SET search_path = i18n, pg_catalog;

--
-- Name: language; Type: TABLE; Schema: i18n; Owner: -; Tablespace: 
--

CREATE TABLE language (
    language_code text NOT NULL,
    unicode text,
    english text NOT NULL,
    direction text DEFAULT 'ltr'::text NOT NULL,
    priority integer DEFAULT 999 NOT NULL,
    beta boolean DEFAULT true NOT NULL
);


SET search_path = quran, pg_catalog;

--
-- Name: arabic_arabic_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE arabic_arabic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ayah; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE ayah (
    ayah_index integer NOT NULL,
    surah_id integer,
    ayah_num integer,
    page_num integer,
    juz_num integer,
    hizb_num integer,
    rub_num integer,
    text pg_catalog.text,
    ayah_key pg_catalog.text NOT NULL,
    sajdah pg_catalog.text
);


--
-- Name: char_type; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE char_type (
    char_type_id integer NOT NULL,
    name pg_catalog.text NOT NULL,
    description pg_catalog.text,
    parent_id integer
);


--
-- Name: char_type_char_type_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE char_type_char_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: char_type_char_type_id_seq; Type: SEQUENCE OWNED BY; Schema: quran; Owner: -
--

ALTER SEQUENCE char_type_char_type_id_seq OWNED BY char_type.char_type_id;


--
-- Name: image; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE image (
    resource_id integer NOT NULL,
    ayah_key pg_catalog.text NOT NULL,
    url pg_catalog.text NOT NULL,
    alt pg_catalog.text NOT NULL,
    width integer NOT NULL
);


--
-- Name: lemma; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE lemma (
    lemma_id integer NOT NULL,
    value character varying(50) NOT NULL,
    clean character varying(50) NOT NULL
);


--
-- Name: lemma_lemma_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE lemma_lemma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lemma_lemma_id_seq1; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE lemma_lemma_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lemma_lemma_id_seq1; Type: SEQUENCE OWNED BY; Schema: quran; Owner: -
--

ALTER SEQUENCE lemma_lemma_id_seq1 OWNED BY lemma.lemma_id;


--
-- Name: root; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE root (
    root_id integer NOT NULL,
    value character varying(50) NOT NULL
);


--
-- Name: root_root_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE root_root_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: root_root_id_seq1; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE root_root_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: root_root_id_seq1; Type: SEQUENCE OWNED BY; Schema: quran; Owner: -
--

ALTER SEQUENCE root_root_id_seq1 OWNED BY root.root_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: stem; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE stem (
    stem_id integer NOT NULL,
    value character varying(50) NOT NULL,
    clean character varying(50) NOT NULL
);


--
-- Name: stem_stem_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE stem_stem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stem_stem_id_seq1; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE stem_stem_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stem_stem_id_seq1; Type: SEQUENCE OWNED BY; Schema: quran; Owner: -
--

ALTER SEQUENCE stem_stem_id_seq1 OWNED BY stem.stem_id;


--
-- Name: surah; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE surah (
    surah_id integer NOT NULL,
    ayat integer NOT NULL,
    bismillah_pre boolean NOT NULL,
    revelation_order integer NOT NULL,
    revelation_place pg_catalog.text NOT NULL,
    page integer[] NOT NULL,
    name_complex pg_catalog.text NOT NULL,
    name_simple pg_catalog.text NOT NULL,
    name_english pg_catalog.text NOT NULL,
    name_arabic pg_catalog.text NOT NULL
);


--
-- Name: text; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE text (
    resource_id integer NOT NULL,
    ayah_key pg_catalog.text NOT NULL,
    text pg_catalog.text NOT NULL
);


--
-- Name: text_lemma; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE text_lemma (
    id pg_catalog.text,
    ayah_key pg_catalog.text,
    surah_id integer,
    ayah_num integer,
    is_hidden boolean,
    text pg_catalog.text
);


--
-- Name: text_root; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE text_root (
    id pg_catalog.text,
    ayah_key pg_catalog.text,
    surah_id integer,
    ayah_num integer,
    is_hidden boolean,
    text pg_catalog.text
);


--
-- Name: text_stem; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE text_stem (
    id pg_catalog.text,
    ayah_key pg_catalog.text,
    surah_id integer,
    ayah_num integer,
    is_hidden boolean,
    text pg_catalog.text
);


--
-- Name: text_token; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE text_token (
    id pg_catalog.text,
    ayah_key pg_catalog.text,
    surah_id integer,
    ayah_num integer,
    is_hidden boolean,
    text pg_catalog.text
);


--
-- Name: token; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE token (
    token_id integer NOT NULL,
    value character varying(50) NOT NULL,
    clean character varying(50) NOT NULL
);


--
-- Name: token_token_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE token_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: token_token_id_seq; Type: SEQUENCE OWNED BY; Schema: quran; Owner: -
--

ALTER SEQUENCE token_token_id_seq OWNED BY token.token_id;


--
-- Name: translation_translation_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE translation_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: word_translation; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE word_translation (
    translation_id integer NOT NULL,
    word_id integer NOT NULL,
    language_code pg_catalog.text NOT NULL,
    value pg_catalog.text NOT NULL
);


--
-- Name: translation_translation_id_seq1; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE translation_translation_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: translation_translation_id_seq1; Type: SEQUENCE OWNED BY; Schema: quran; Owner: -
--

ALTER SEQUENCE translation_translation_id_seq1 OWNED BY word_translation.translation_id;


--
-- Name: word; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE word (
    word_id integer NOT NULL,
    ayah_key pg_catalog.text NOT NULL,
    "position" integer NOT NULL,
    token_id integer NOT NULL
);


--
-- Name: word_font; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE word_font (
    resource_id integer NOT NULL,
    ayah_key pg_catalog.text NOT NULL,
    "position" integer NOT NULL,
    word_id integer,
    page_num integer NOT NULL,
    line_num integer NOT NULL,
    code_dec integer NOT NULL,
    code_hex pg_catalog.text NOT NULL,
    char_type_id integer NOT NULL
);


--
-- Name: word_lemma; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE word_lemma (
    word_id integer NOT NULL,
    lemma_id integer NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: word_root; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE word_root (
    word_id integer NOT NULL,
    root_id integer NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: word_stem; Type: TABLE; Schema: quran; Owner: -; Tablespace: 
--

CREATE TABLE word_stem (
    word_id integer NOT NULL,
    stem_id integer NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: word_word_id_seq; Type: SEQUENCE; Schema: quran; Owner: -
--

CREATE SEQUENCE word_word_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: word_word_id_seq; Type: SEQUENCE OWNED BY; Schema: quran; Owner: -
--

ALTER SEQUENCE word_word_id_seq OWNED BY word.word_id;


SET search_path = audio, pg_catalog;

--
-- Name: file_id; Type: DEFAULT; Schema: audio; Owner: -
--

ALTER TABLE ONLY file ALTER COLUMN file_id SET DEFAULT nextval('_file_file_id_seq'::regclass);


--
-- Name: recitation_id; Type: DEFAULT; Schema: audio; Owner: -
--

ALTER TABLE ONLY recitation ALTER COLUMN recitation_id SET DEFAULT nextval('recitation_recitation_id_seq'::regclass);


--
-- Name: reciter_id; Type: DEFAULT; Schema: audio; Owner: -
--

ALTER TABLE ONLY reciter ALTER COLUMN reciter_id SET DEFAULT nextval('_reciter_reciter_id_seq'::regclass);


--
-- Name: style_id; Type: DEFAULT; Schema: audio; Owner: -
--

ALTER TABLE ONLY style ALTER COLUMN style_id SET DEFAULT nextval('_style_style_id_seq'::regclass);


SET search_path = content, pg_catalog;

--
-- Name: author_id; Type: DEFAULT; Schema: content; Owner: -
--

ALTER TABLE ONLY author ALTER COLUMN author_id SET DEFAULT nextval('_author_author_id_seq'::regclass);


--
-- Name: tafsir_id; Type: DEFAULT; Schema: content; Owner: -
--

ALTER TABLE ONLY tafsir ALTER COLUMN tafsir_id SET DEFAULT nextval('_tafsir_tafsir_id_seq'::regclass);


SET search_path = quran, pg_catalog;

--
-- Name: char_type_id; Type: DEFAULT; Schema: quran; Owner: -
--

ALTER TABLE ONLY char_type ALTER COLUMN char_type_id SET DEFAULT nextval('char_type_char_type_id_seq'::regclass);


--
-- Name: lemma_id; Type: DEFAULT; Schema: quran; Owner: -
--

ALTER TABLE ONLY lemma ALTER COLUMN lemma_id SET DEFAULT nextval('lemma_lemma_id_seq1'::regclass);


--
-- Name: root_id; Type: DEFAULT; Schema: quran; Owner: -
--

ALTER TABLE ONLY root ALTER COLUMN root_id SET DEFAULT nextval('root_root_id_seq1'::regclass);


--
-- Name: stem_id; Type: DEFAULT; Schema: quran; Owner: -
--

ALTER TABLE ONLY stem ALTER COLUMN stem_id SET DEFAULT nextval('stem_stem_id_seq1'::regclass);


--
-- Name: token_id; Type: DEFAULT; Schema: quran; Owner: -
--

ALTER TABLE ONLY token ALTER COLUMN token_id SET DEFAULT nextval('token_token_id_seq'::regclass);


--
-- Name: word_id; Type: DEFAULT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word ALTER COLUMN word_id SET DEFAULT nextval('word_word_id_seq'::regclass);


--
-- Name: translation_id; Type: DEFAULT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_translation ALTER COLUMN translation_id SET DEFAULT nextval('translation_translation_id_seq1'::regclass);


SET search_path = audio, pg_catalog;

--
-- Name: _file_pkey; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY file
    ADD CONSTRAINT _file_pkey PRIMARY KEY (file_id);


--
-- Name: _file_recitation_id_ayah_key_format_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY file
    ADD CONSTRAINT _file_recitation_id_ayah_key_format_key UNIQUE (recitation_id, ayah_key, format);


--
-- Name: _reciter_arabic_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reciter
    ADD CONSTRAINT _reciter_arabic_key UNIQUE (arabic);


--
-- Name: _reciter_english_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reciter
    ADD CONSTRAINT _reciter_english_key UNIQUE (english);


--
-- Name: _reciter_path_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reciter
    ADD CONSTRAINT _reciter_path_key UNIQUE (path);


--
-- Name: _reciter_pkey; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reciter
    ADD CONSTRAINT _reciter_pkey PRIMARY KEY (reciter_id);


--
-- Name: _reciter_slug_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reciter
    ADD CONSTRAINT _reciter_slug_key UNIQUE (slug);


--
-- Name: _style_arabic_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY style
    ADD CONSTRAINT _style_arabic_key UNIQUE (arabic);


--
-- Name: _style_english_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY style
    ADD CONSTRAINT _style_english_key UNIQUE (english);


--
-- Name: _style_path_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY style
    ADD CONSTRAINT _style_path_key UNIQUE (path);


--
-- Name: _style_pkey; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY style
    ADD CONSTRAINT _style_pkey PRIMARY KEY (style_id);


--
-- Name: _style_slug_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY style
    ADD CONSTRAINT _style_slug_key UNIQUE (slug);


--
-- Name: recitation_pkey; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recitation
    ADD CONSTRAINT recitation_pkey PRIMARY KEY (recitation_id);


--
-- Name: recitation_reciter_id_style_id_key; Type: CONSTRAINT; Schema: audio; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recitation
    ADD CONSTRAINT recitation_reciter_id_style_id_key UNIQUE (reciter_id, style_id);


SET search_path = content, pg_catalog;

--
-- Name: _author_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT _author_pkey PRIMARY KEY (author_id);


--
-- Name: _tafsir_ayah_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tafsir_ayah
    ADD CONSTRAINT _tafsir_ayah_pkey PRIMARY KEY (tafsir_id, ayah_key);


--
-- Name: _tafsir_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tafsir
    ADD CONSTRAINT _tafsir_pkey PRIMARY KEY (tafsir_id);


--
-- Name: _translation_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY translation
    ADD CONSTRAINT _translation_pkey PRIMARY KEY (resource_id, ayah_key);


--
-- Name: _transliteration_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transliteration
    ADD CONSTRAINT _transliteration_pkey PRIMARY KEY (resource_id, ayah_key);


--
-- Name: resource_api_version_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_api_version
    ADD CONSTRAINT resource_api_version_pkey PRIMARY KEY (resource_id);


--
-- Name: resource_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (resource_id);


--
-- Name: resource_type_sub_type_language_code_slug_key; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_type_sub_type_language_code_slug_key UNIQUE (type, sub_type, language_code, slug);


--
-- Name: source_pkey; Type: CONSTRAINT; Schema: content; Owner: -; Tablespace: 
--

ALTER TABLE ONLY source
    ADD CONSTRAINT source_pkey PRIMARY KEY (source_id);


SET search_path = i18n, pg_catalog;

--
-- Name: language_pkey; Type: CONSTRAINT; Schema: i18n; Owner: -; Tablespace: 
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_pkey PRIMARY KEY (language_code);


SET search_path = quran, pg_catalog;

--
-- Name: _image_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY image
    ADD CONSTRAINT _image_pkey PRIMARY KEY (resource_id, ayah_key);


--
-- Name: _text_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY text
    ADD CONSTRAINT _text_pkey PRIMARY KEY (resource_id, ayah_key);


--
-- Name: ayah_index_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ayah
    ADD CONSTRAINT ayah_index_key UNIQUE (ayah_index);


--
-- Name: ayah_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ayah
    ADD CONSTRAINT ayah_pkey PRIMARY KEY (ayah_key);


--
-- Name: char_type_name_parent_id_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY char_type
    ADD CONSTRAINT char_type_name_parent_id_key UNIQUE (name, parent_id);


--
-- Name: char_type_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY char_type
    ADD CONSTRAINT char_type_pkey PRIMARY KEY (char_type_id);


--
-- Name: lemma_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lemma
    ADD CONSTRAINT lemma_pkey PRIMARY KEY (lemma_id);


--
-- Name: lemma_value_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lemma
    ADD CONSTRAINT lemma_value_key UNIQUE (value);


--
-- Name: root_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY root
    ADD CONSTRAINT root_pkey PRIMARY KEY (root_id);


--
-- Name: root_value_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY root
    ADD CONSTRAINT root_value_key UNIQUE (value);


--
-- Name: stem_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stem
    ADD CONSTRAINT stem_pkey PRIMARY KEY (stem_id);


--
-- Name: stem_value_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stem
    ADD CONSTRAINT stem_value_key UNIQUE (value);


--
-- Name: surah_ayah_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ayah
    ADD CONSTRAINT surah_ayah_key UNIQUE (surah_id, ayah_num);


--
-- Name: surah_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY surah
    ADD CONSTRAINT surah_pkey PRIMARY KEY (surah_id);


--
-- Name: token_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY token
    ADD CONSTRAINT token_pkey PRIMARY KEY (token_id);


--
-- Name: token_value_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY token
    ADD CONSTRAINT token_value_key UNIQUE (value);


--
-- Name: translation_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_translation
    ADD CONSTRAINT translation_pkey PRIMARY KEY (translation_id);


--
-- Name: translation_word_id_language_code_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_translation
    ADD CONSTRAINT translation_word_id_language_code_key UNIQUE (word_id, language_code);


--
-- Name: word_ayah_key_position_key; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word
    ADD CONSTRAINT word_ayah_key_position_key UNIQUE (ayah_key, "position");


--
-- Name: word_font_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_font
    ADD CONSTRAINT word_font_pkey PRIMARY KEY (resource_id, ayah_key, "position");


--
-- Name: word_lemma_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_lemma
    ADD CONSTRAINT word_lemma_pkey PRIMARY KEY (word_id, lemma_id, "position");


--
-- Name: word_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word
    ADD CONSTRAINT word_pkey PRIMARY KEY (word_id);


--
-- Name: word_root_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_root
    ADD CONSTRAINT word_root_pkey PRIMARY KEY (word_id, root_id, "position");


--
-- Name: word_stem_pkey; Type: CONSTRAINT; Schema: quran; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_stem
    ADD CONSTRAINT word_stem_pkey PRIMARY KEY (word_id, stem_id, "position");


SET search_path = content, pg_catalog;

--
-- Name: tafsir_resource_id_md5_idx; Type: INDEX; Schema: content; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX tafsir_resource_id_md5_idx ON tafsir USING btree (resource_id, md5(text));


SET search_path = quran, pg_catalog;

--
-- Name: ayah_surah_id_idx; Type: INDEX; Schema: quran; Owner: -; Tablespace: 
--

CREATE INDEX ayah_surah_id_idx ON ayah USING btree (surah_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: quran; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: _RETURN; Type: RULE; Schema: quran; Owner: -
--

CREATE RULE "_RETURN" AS
    ON SELECT TO text_root DO INSTEAD  SELECT concat_ws(':'::pg_catalog.text, 'quran', 'root', 'ayah', a.ayah_key) AS id, 
    a.ayah_key, 
    a.surah_id, 
    a.ayah_num, 
    true AS is_hidden, 
    string_agg((t.value)::pg_catalog.text, ' '::pg_catalog.text ORDER BY w."position", j."position") AS text
   FROM (((word w
   JOIN ayah a USING (ayah_key))
   JOIN word_root j USING (word_id))
   JOIN root t USING (root_id))
  GROUP BY a.ayah_key
  ORDER BY a.surah_id, a.ayah_num;


--
-- Name: _RETURN; Type: RULE; Schema: quran; Owner: -
--

CREATE RULE "_RETURN" AS
    ON SELECT TO text_lemma DO INSTEAD  SELECT concat_ws(':'::pg_catalog.text, 'quran', 'lemma', 'ayah', a.ayah_key) AS id, 
    a.ayah_key, 
    a.surah_id, 
    a.ayah_num, 
    true AS is_hidden, 
    string_agg((t.value)::pg_catalog.text, ' '::pg_catalog.text ORDER BY w."position", j."position") AS text
   FROM (((word w
   JOIN ayah a USING (ayah_key))
   JOIN word_lemma j USING (word_id))
   JOIN lemma t USING (lemma_id))
  GROUP BY a.ayah_key
  ORDER BY a.surah_id, a.ayah_num;


--
-- Name: _RETURN; Type: RULE; Schema: quran; Owner: -
--

CREATE RULE "_RETURN" AS
    ON SELECT TO text_stem DO INSTEAD  SELECT concat_ws(':'::pg_catalog.text, 'quran', 'stem', 'ayah', a.ayah_key) AS id, 
    a.ayah_key, 
    a.surah_id, 
    a.ayah_num, 
    true AS is_hidden, 
    string_agg((t.value)::pg_catalog.text, ' '::pg_catalog.text ORDER BY w."position", j."position") AS text
   FROM (((word w
   JOIN ayah a USING (ayah_key))
   JOIN word_stem j USING (word_id))
   JOIN stem t USING (stem_id))
  GROUP BY a.ayah_key
  ORDER BY a.surah_id, a.ayah_num;


--
-- Name: _RETURN; Type: RULE; Schema: quran; Owner: -
--

CREATE RULE "_RETURN" AS
    ON SELECT TO text_token DO INSTEAD  SELECT concat_ws(':'::pg_catalog.text, 'quran', 'token', 'ayah', a.ayah_key) AS id, 
    a.ayah_key, 
    a.surah_id, 
    a.ayah_num, 
    true AS is_hidden, 
    string_agg((t.value)::pg_catalog.text, ' '::pg_catalog.text ORDER BY w."position") AS text
   FROM ((word w
   JOIN ayah a USING (ayah_key))
   JOIN token t USING (token_id))
  GROUP BY a.ayah_key
  ORDER BY a.surah_id, a.ayah_num;


SET search_path = audio, pg_catalog;

--
-- Name: _file_ayah_key_fkey; Type: FK CONSTRAINT; Schema: audio; Owner: -
--

ALTER TABLE ONLY file
    ADD CONSTRAINT _file_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _file_recitation_id_fkey; Type: FK CONSTRAINT; Schema: audio; Owner: -
--

ALTER TABLE ONLY file
    ADD CONSTRAINT _file_recitation_id_fkey FOREIGN KEY (recitation_id) REFERENCES recitation(recitation_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recitation_reciter_id_fkey; Type: FK CONSTRAINT; Schema: audio; Owner: -
--

ALTER TABLE ONLY recitation
    ADD CONSTRAINT recitation_reciter_id_fkey FOREIGN KEY (reciter_id) REFERENCES reciter(reciter_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recitation_style_id_fkey; Type: FK CONSTRAINT; Schema: audio; Owner: -
--

ALTER TABLE ONLY recitation
    ADD CONSTRAINT recitation_style_id_fkey FOREIGN KEY (style_id) REFERENCES style(style_id) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = content, pg_catalog;

--
-- Name: _tafsir_ayah_ayah_key_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY tafsir_ayah
    ADD CONSTRAINT _tafsir_ayah_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _tafsir_ayah_tafsir_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY tafsir_ayah
    ADD CONSTRAINT _tafsir_ayah_tafsir_id_fkey FOREIGN KEY (tafsir_id) REFERENCES tafsir(tafsir_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _translation_ayah_key_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY translation
    ADD CONSTRAINT _translation_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _transliteration_ayah_key_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY transliteration
    ADD CONSTRAINT _transliteration_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES quran.ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_api_version_resource_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY resource_api_version
    ADD CONSTRAINT resource_api_version_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_author_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_author_id_fkey FOREIGN KEY (author_id) REFERENCES author(author_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_language_code_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_language_code_fkey FOREIGN KEY (language_code) REFERENCES i18n.language(language_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_source_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_source_id_fkey FOREIGN KEY (source_id) REFERENCES source(source_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tafsir_resource_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY tafsir
    ADD CONSTRAINT tafsir_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: translation_resource_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY translation
    ADD CONSTRAINT translation_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: transliteration_resource_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY transliteration
    ADD CONSTRAINT transliteration_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = quran, pg_catalog;

--
-- Name: ayah_surah_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY ayah
    ADD CONSTRAINT ayah_surah_id_fkey FOREIGN KEY (surah_id) REFERENCES surah(surah_id);


--
-- Name: char_type_parent_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY char_type
    ADD CONSTRAINT char_type_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES char_type(char_type_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: image_ayah_key_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image_resource_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES content.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: text_ayah_key_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY text
    ADD CONSTRAINT text_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: text_resource_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY text
    ADD CONSTRAINT text_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES content.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: translation_language_code_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_translation
    ADD CONSTRAINT translation_language_code_fkey FOREIGN KEY (language_code) REFERENCES i18n.language(language_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: translation_word_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_translation
    ADD CONSTRAINT translation_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_ayah_key_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word
    ADD CONSTRAINT word_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_font_ayah_key_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_font
    ADD CONSTRAINT word_font_ayah_key_fkey FOREIGN KEY (ayah_key) REFERENCES ayah(ayah_key) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_font_char_type_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_font
    ADD CONSTRAINT word_font_char_type_id_fkey FOREIGN KEY (char_type_id) REFERENCES char_type(char_type_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_font_resource_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_font
    ADD CONSTRAINT word_font_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES content.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_font_word_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_font
    ADD CONSTRAINT word_font_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: word_lemma_lemma_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_lemma
    ADD CONSTRAINT word_lemma_lemma_id_fkey FOREIGN KEY (lemma_id) REFERENCES lemma(lemma_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_lemma_word_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_lemma
    ADD CONSTRAINT word_lemma_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_root_root_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_root
    ADD CONSTRAINT word_root_root_id_fkey FOREIGN KEY (root_id) REFERENCES root(root_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_root_word_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_root
    ADD CONSTRAINT word_root_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_stem_stem_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_stem
    ADD CONSTRAINT word_stem_stem_id_fkey FOREIGN KEY (stem_id) REFERENCES stem(stem_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_stem_word_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word_stem
    ADD CONSTRAINT word_stem_word_id_fkey FOREIGN KEY (word_id) REFERENCES word(word_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: word_token_id_fkey; Type: FK CONSTRAINT; Schema: quran; Owner: -
--

ALTER TABLE ONLY word
    ADD CONSTRAINT word_token_id_fkey FOREIGN KEY (token_id) REFERENCES token(token_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO quran,"$user",content,audio,i18n,public;

INSERT INTO schema_migrations (version) VALUES ('20141108131819');
