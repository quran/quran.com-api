class ChangeTextFontView < ActiveRecord::Migration
    def up
        execute <<-SQL
            drop view quran.text_font
        SQL
        execute <<-SQL
            create view quran.text_font as
            SELECT concat_ws(':'::text, '1', s.surah_id, s.ayah_num) AS id,
               concat_ws(':'::text, s.surah_id, s.ayah_num) AS ayah_key,
               s.surah_id,
               s.ayah_num,
               true AS is_hidden,
               string_agg(s.lhs::text, ' '::text ORDER BY s."position") AS text
              FROM ( SELECT ayah.surah_id,
                       ayah.ayah_num,
                       w.word_id::text lhs,
                       c."position"
                      FROM resource
                        JOIN word_font c USING (resource_id)
                        JOIN ayah USING (ayah_key)
                        JOIN char_type ct ON ct.char_type_id = c.char_type_id and ct.name = 'word'
                        JOIN word w USING (word_id)
                        JOIN token t using (token_id)
                     WHERE resource.resource_id = 1
                     ORDER BY ayah.surah_id, ayah.ayah_num, c."position") s
             GROUP BY s.surah_id, s.ayah_num
             ORDER BY s.surah_id, s.ayah_num
        SQL
    end
    def down
        execute <<-SQL
            drop view quran.text_font
        SQL
        execute <<-SQL
            create view quran.text_font as
            SELECT concat_ws(':'::text, '1', s.surah_id, s.ayah_num) AS id,
               concat_ws(':'::text, s.surah_id, s.ayah_num) AS ayah_key,
               s.surah_id,
               s.ayah_num,
               true AS is_hidden,
               string_agg(s.lhs, ' '::text ORDER BY s."position") AS text
              FROM ( SELECT ayah.surah_id,
                       ayah.ayah_num,
                       concat_ws('-'::text, c.page_num, c.code_hex) AS lhs,
                       c."position"
                      FROM resource
                        JOIN word_font c USING (resource_id)
                        JOIN ayah USING (ayah_key)
                        JOIN char_type ct ON ct.char_type_id = c.char_type_id
                        LEFT JOIN word w ON w.word_id = c.word_id
                     WHERE resource.resource_id = 1
                     ORDER BY ayah.surah_id, ayah.ayah_num, c."position") s
             GROUP BY s.surah_id, s.ayah_num
             ORDER BY s.surah_id, s.ayah_num
        SQL
    end

end
