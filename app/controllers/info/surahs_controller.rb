class Info::SurahsController < ApplicationController
  def index

    @results = Quran::Surah
    .order("quran.surah.surah_id")
  end
  def show
    @surah = Quran::Surah.find(params[:id])
  end
end




 # qq|
 #            select s.surah_id id
 #                 , s.ayat
 #                 , s.bismillah_pre
 #                 , s.revelation_order
 #                 , s.revelation_place
 #                 , s.page
 #                 , s.name_complex
 #                 , s.name_simple
 #                 , s.name_english
 #                 , s.name_arabic
 #              from quran.surah s |.( ( not $vars{surah} ) ? '' : 'where surah_id = ?' ).qq|
 #             order by s.surah_id