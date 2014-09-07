class Content::Translation < ActiveRecord::Base
    extend Content
    extend Batchelor
    

    self.table_name = 'translation'
    self.primary_keys = :ayah_key, :resource_id # composite primary key which is a combination of ayah_key & resource_id

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'



    mapping :_parent => { :type => 'ayah' } do
      indexes :resource_id, type: "integer"
      indexes :ayah_key
      indexes :text
    end

    


    def self.searching
        query = {
            query: {
                has_parent: {
                    parent_type: "ayah",
                    query: {
                        match: {
                            ayah_index: 6147
                        }    
                    }
                    
                }
               
            }
        }
        self.search(query)
    end



end
# notes:
# - provides a 'text' column
# transform = lambda do |a|
#              {index: {_id: a.id, _parent: a.author_id, data: a.__elasticsearch__.as_indexed_json}}
#            end


