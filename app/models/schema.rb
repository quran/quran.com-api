module Schema
    mattr_accessor :schema_name
    def table_name
        @@schema_name +'.'+ super
    end
end
