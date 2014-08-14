class Content::Translation < ActiveRecord::Base
    extend Content



    self.table_name = 'translation'
    self.primary_keys = :resource_id, :ayah_key

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'


    def self.searching(params)

    	self.search(query: {match: {text: params[:query]} }).results.total
    		
    	
    end
end
# notes:
# - provides a 'text' column
