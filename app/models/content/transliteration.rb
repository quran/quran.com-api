# vim: ts=4 sw=4 expandtab
class Content::Transliteration < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'transliteration'
    self.primary_keys = :resource_id, :ayah_key

    # relationships
    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

    # scope
    # default_scope { where resource_id: -1 } # NOTE uncomment or modify to disable/experiment on the elasticsearch import

    def self.import ( options = {} )
        Content::Transliteration.connection.cache do
            transform = lambda do |a|
                this_data = a.__elasticsearch__.as_indexed_json
                ayah_data = a.ayah.__elasticsearch__.as_indexed_json
                resource_data = a.resource.__elasticsearch__.as_indexed_json
                language_data = a.resource.language.__elasticsearch__.as_indexed_json
                this_data.delete( 'ayah_key' )
                ayah_data.delete( 'text' )
                ayah_data[ 'ayah_key' ].gsub!( /:/, '_' )
                { index:      {
                    _id:      "#{a.resource_id}_#{ayah_data[ 'ayah_key' ]}",
                    data:     this_data.merge({ayah: ayah_data, resource:  resource_data, language: language_data})
                } }
            end
            options = { transform: transform, batch_size: 6236 }.merge( options )
            self.importing options
        end
    end

    require 'levenshtein'

def self.compareText(ayahtext, query)
   str = ''

   best = 0
   cutoff = 80
   minPercent = 70

   # adjust percentage for short queries against long ayahs
   factor = ayahtext.length / query.length
   if (factor > 10)
      minPercent = minPercent - (factor / 2)
   end

   val = 0
   ayah = ayahtext
   while (true)
      if ayah.length == 1
         return 0
      end
      ayah = ayah[val..-1]

      if val == 0
         val = 1
      end

      if ((ayah[0] != query[0]) and (ayah.index(query[0]) == nil))
         return best
      end

      ayah = ayah[ayah.index(query[0])..-1]
      len = [ayah.length, query.length].min
      truncated = ayah[0..len]

      print 'comparing ' + query + ' vs ' + truncated + "\n"
      distance = Levenshtein.distance query, truncated
      print 'got ' + distance.to_s + "\n"
      percent = 100 * (1.0 - (distance.to_f / truncated.length))
      print "percent: " + percent.to_s + "\n"
      if percent > minPercent
         if percent > best
            best = percent
         end

         if best > cutoff
            return best
         end
      end
   end

   return best
end

def self.prepareText(str)
   return str.gsub('oo', 'u')
             .gsub('-', '')
             .downcase
             .gsub('aa', 'a')
             .gsub(' ', '')
             .gsub('ia', 'i')
             .gsub('7', 'h')
end


    # def as_indexed_json(options={})
    #     self.as_json(
    #         # methods: [:resource_info],
    #         include: {
    #             resource: {
    #                 only: [:slug, :name, :type]
    #             }
    #         }
    #     )
    # end
end
