namespace :db do
    task setup: :environment do
        Rails.logger              = Logger.new( STDOUT )
        ActiveRecord::Base.logger = Logger.new( STDOUT )
        connection = ActiveRecord::Base.connection
        config     = Rails.configuration.database_configuration
        database   = config[ Rails.env ]["database"]

        Rails.logger.info( "correcting search path on #{ database }" )

        ActiveRecord::Base.transaction do
            connection.execute <<-SQL
                alter database #{ database } set search_path = "$user", quran, content, audio, i18n, public
            SQL
        end
    end
end

