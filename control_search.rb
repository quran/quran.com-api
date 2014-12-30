def control_search( params = {}, headers = {}, session = {} )
  reload!
  params[:q] = params[:q].force_encoding( 'utf-8' )
  SearchController.query( params, headers, session )
end
