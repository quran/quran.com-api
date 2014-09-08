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


    # When this module is included, callback this function
    def self.included(mod)
        Rails.logger.info mod
        # Then add a callback function `self.extended` to the module that
        # includes schema module
        mod.instance_eval do 
            # Create method `self.extended` on the child module
            def extended(mod)
                # Include the elasticsearch concern
                mod.include(Searchable)

                # This is commented out but you can, if you wish, invoke a function
                # this function would be in the Schema.rb file and would be an instance
                # function to the child module
                # mod.send :include_elasticsearch, mod
            end
        end
    end
end
