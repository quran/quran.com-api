def control_search( params = {}, headers = {}, session = {} )
  reload!
  params.each do |k,v|
      params[k]=v.to_s.force_encoding( 'utf-8' )
  end

  params[:q] = params[:q].force_encoding( 'utf-8' )
  SearchController.query( params, headers, session )
end
