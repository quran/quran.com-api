module Schema
    @@schema_name = Hash.new
    def table_name
        # This is the old way of doing it. I think we will no longer use this
        # @@schema_name[self.name.split("::").first.downcase] +'.'+ super
        
        # New way
        self.name.split("::").first.downcase << '.' << super
    end

    def self.schema_name
        @@schema_name
    end

    # When this module is included, callback this function
    def self.included( mod )
        Rails.logger.info "included Schema in #{ mod }"
        # Then add a callback function `self.extended` to the module that
        # includes schema module
        mod.instance_eval do
            # Create method `self.extended` on the child module
            def extended( mod )
                Rails.logger.info "included Searchable in #{ mod }"
                # Include the elasticsearch concern
                mod.include( Searchable )
                mod.extend( Searchable )

                # This is commented out but you can, if you wish, invoke a function
                # this function would be in the Schema.rb file and would be an instance
                # function to the child module
                # mod.send :include_elasticsearch, mod
            end
        end
    end
end
