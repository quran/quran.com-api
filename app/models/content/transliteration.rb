# vim: ts=4 sw=4 expandtab
class Content::Transliteration < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'transliteration'
    self.primary_keys = :resource_id, :ayah_key

    # relationships
    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah,     class_name: 'Quran::Ayah'

    # scope
    # default_scope { where resource_id: -1 } # NOTE uncomment or modify to disable/experiment on the elasticsearch import

    def self.import ( options = {} )
        transform = lambda do |a|
            {index: {_id: "#{a.resource_id},#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json}}
        end
        options = { transform: transform, batch_size: 6236 }.merge( options )
        self.importing options
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
