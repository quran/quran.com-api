# vim: ts=4 sw=4 expandtab
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

    def self.schema_name(module_name, schema_name)
        @@schema_name[ "#{module_name}" ] = schema_name
    end

    # When this module is included, callback this function
    def self.included( inc_mod )
        # Rails.logger.info "#{ inc_mod } included Schema"
        # Then add a callback function `self.extended` to the module that
        # includes schema module
        inc_mod.instance_eval do
            # Create method `self.extended` on the child module
            def extended( ext_mod )
                # Rails.logger.info "#{ ext_mod } extended"
                # Include the elasticsearch concern
                ext_mod.include( Searchable )
                ext_mod.extend( Searchable ) # TODO recall why we're both including and extending? was this experimental?
            end
        end
    end
end
