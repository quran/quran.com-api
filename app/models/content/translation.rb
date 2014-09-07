class Content::Translation < ActiveRecord::Base
    extend Content
    extend Batchelor
    

    self.table_name = 'translation'
    self.primary_keys = :ayah_key, :resource_id # composite primary key which is a combination of ayah_key & resource_id

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'

    mapping :_parent => { :type => 'ayah' }, :_routing => { :path => 'ayah_key', :required => true } do
      indexes :resource_id, type: "integer"
      indexes :ayah_key
      indexes :text
    end

    
    def self.importing (options = {})
        transform = lambda do |a|
            {index: {_id: "#{a.resource_id},#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json}} 
        end
        options = {transform: transform}.merge(options)
        self.import options 
    end


    def self.searching ( ayat = [] )
        msearch_body = [ {
            search: {
#            highlight: {
#                fields: {
#                    text: {
#                        type: 'fvh',
#                        number_of_fragments: 1,
#                        fragment_size: 1024
#                    }
#                },
#                tags_schema => 'styled'
#            },
                query: {
                    bool: {
                        must: [ {
                            term: {
                                _parent: {
                                    value: "100:5"
                                }
                            }
                        }, {
                            match: {
                                text: {
                                    query: "armikut",
                                    operator: 'or',
                                    minimum_should_match: '3<62%'
                                }
                            }
                        } ]
                    }
                }
            }
        }, {
            search: {
#            highlight: {
#                fields: {
#                    text: {
#                        type: 'fvh',
#                        number_of_fragments: 1,
#                        fragment_size: 1024
#                    }
#                },
#                tags_schema => 'styled'
#            },
                query: {
                    bool: {
                        must: [ {
                            term: {
                                _parent: {
                                    value: "100:6"
                                }
                            }
                        }, {
                            match: {
                                text: {
                                    query: "armikut",
                                    operator: 'or',
                                    minimum_should_match: '3<62%'
                                }
                            }
                        } ]
                    }
                }
            }

        } ]
        msearch_query = {
            index: 'quran2',
            body: msearch_body
        }
        self.__elasticsearch__.client.msearch( msearch_query )
    end



end
# notes:
# - provides a 'text' column
# transform = lambda do |a|
#              {index: {_id: a.id, _parent: a.author_id, data: a.__elasticsearch__.as_indexed_json}}
#            end


