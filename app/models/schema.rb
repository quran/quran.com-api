module Schema
    # mattr_accessor :schema_name


    @@schema_name = Hash.new
    def table_name
        @@schema_name[self.name.split("::").first.downcase] +'.'+ super
        # Rails.logger.ap self.name.split("::").first.downcase
        # Rails.logger.ap @@schema_name[self.name.split("::").first.downcase]
        
    end

    def self.schema_name
        @@schema_name
    end

    def self.schema_name=(schema_name)
        @@schema_name["#{schema_name}"] = schema_name
    end
end
