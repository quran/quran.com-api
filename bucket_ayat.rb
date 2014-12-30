def bucket_ayat( params = {}, headers = {}, session = {} )
  reload!
  params[:surah]   = params[:surah].to_s.force_encoding( 'utf-8' )   if params[:surah] != nil
  params[:range]   = params[:range].to_s.force_encoding( 'utf-8' )   if params[:range] != nil
  params[:quran]   = params[:quran].to_s.force_encoding( 'utf-8' )   if params[:quran] != nil
  params[:content] = params[:content].to_s.force_encoding( 'utf-8' ) if params[:content] != nil
  Bucket::AyatController.index( params, headers, session )
end
