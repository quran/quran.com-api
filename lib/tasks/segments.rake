# frozen_string_literal: true

namespace :segments do
  task import: :environment do
    # May need this if @cpfair changes the files.
    # files = [
    #   { recitation_id: 1, filename: 'Abdul_Basit_Mujawwad_128kbps.json' },
    #   { recitation_id: 2, filename: 'Abdul_Basit_Murattal_64kbps.json' },
    #   { recitation_id: 3, filename: 'Abdurrahmaan_As-Sudais_192kbps.json' },
    #   { recitation_id: 4, filename: 'Abu_Bakr_Ash-Shaatree_128kbps.json' },
    #   { recitation_id: 5, filename: 'Hani_Rifai_192kbps.json' },
    #   { recitation_id: 7, filename: 'Husary_Muallim_128kbps.json' },
    #   { recitation_id: 8, filename: 'Alafasy_128kbps.json' },
    #   { recitation_id: 9, filename: 'Minshawy_Mujawwad_192kbps.json' },
    #   { recitation_id: 10, filename: 'Minshawy_Murattal_128kbps.json' },
    #   { recitation_id: 11, filename: 'Saood_ash-Shuraym_128kbps.json' },
    #   { recitation_id: 12, filename: 'Mohammad_al_Tablaway_128kbps.json' },
    #   { recitation_id: 13, filename: 'Husary_64kbps.json' },
    # ]
    #
    #
    # Parallel.each(files, in_processes: 4, progress: 'Importing segments') do |file|
    #   begin
    #     puts file[:filename]
    #     json = Oj.load_file("../quran-align-data/#{file[:filename]}")
    #     audio_files = AudioFile.where(recitation_id: file[:recitation_id], segments: nil)
    #
    #     json.each do |ayah_json|
    #       next if ayah_json["segments"].blank?
    #       verse = Verse.find_by_verse_key("#{ayah_json['surah']}:#{ayah_json['ayah']}")
    #       record = audio_files.find_by(resource: verse)
    #       record.update_attribute(:segments, ayah_json["segments"])
    #   end
    #
    #   rescue Exception => e
    #     puts e.message
    #     puts e.backtrace.inspect
    #   end
    # end
  end
end
