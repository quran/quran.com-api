#!/usr/bin/env ruby

# this script was used to update the segments_encrypted column on the audio.file table

require 'pg'
require 'gibberish'
require 'base64'

begin

  secret = ENV['SEGMENTS_KEY'] || '¯\_(ツ)_/¯'
  cipher = Gibberish::AES.new(secret)

  con = PG.connect :dbname => 'quran_dev', :user => 'quran_dev'

  rs = con.exec "select f.file_id, a.ayah_key, f.url, coalesce(f.segments, '[]') segments from file f join ayah a using (ayah_key) where f.segments is not null order by f.file_id"

  con.prepare 'update_row', "update file set segments_encrypted=$1 where file_id=$2"

  n = 1;
  rs.each do |row|
    puts "updating file #{n} (#{row['file_id']}) ayah #{row['ayah_key']}#{if row['url'] then " url #{row['url']}" else '' end}..."
    scrambled = Base64.encode64(cipher.encrypt((if row['segments'] then row['segments'] else '[]' end)))
    scrambled = scrambled.gsub(/\n/, '')
    #puts "scrambed is #{scrambled}"
    update_rs = con.exec_prepared 'update_row', [scrambled, row['file_id']]
    n += 1
  end

rescue PG::Error => e
  puts 'PG Error', e.message

ensure
  con.close if con
end

exit

