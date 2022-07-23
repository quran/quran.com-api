# frozen_string_literal: true

class JuzsPresenter < BasePresenter
  def all
    mushaf_juzs
  end

  def find
    mushaf_juzs.find_by(juz_number: juz_number)
  end

  def exists?
    find.present?
  end

  protected
  def juz_number
    params[:id] || params[:juz_number]
  end

  def mushaf_juzs
    list = if get_mushaf.indopak?
             MushafJuz.indopak
           else
             MushafJuz.madani
           end

    list.order('juz_number ASC')
  end
end
