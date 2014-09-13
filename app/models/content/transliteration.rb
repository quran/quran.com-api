class Content::Transliteration < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'transliteration'
    self.primary_keys = :resource_id, :ayah_key

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'


    ########## ES FUNCTIONS ##################################################
    document_type "transliteration"
    mapping :_parent => { :type => 'ayah' }, :_routing => { :path => 'ayah_key', :required => true } do
      indexes :resource_id, type: "integer"
      indexes :ayah_key
      indexes :text, term_vector: "with_positions_offsets_payloads"
    end

    def self.import(options = {})
        transform = lambda do |a|
            {index: {_id: "#{a.resource_id},#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json}} 
        end
        options = {transform: transform}.merge(options)
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
# notes:
# - provides a 'text' column
