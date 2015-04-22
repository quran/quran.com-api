module TransliterationScore
  def compareText(ayahtext, query)
     str = ''

     best = 0
     cutoff = 80
     minPercent = 70

     # adjust percentage for short queries against long ayahs
     factor = ayahtext.length / query.length
     if (factor > 10)
        minPercent = minPercent - (factor / 2)
     end

     val = 0
     ayah = ayahtext
     while (true)
        if ayah.length == 1
           return 0
        end
        ayah = ayah[val..-1]

        if val == 0
           val = 1
        end

        if ((ayah[0] != query[0]) and (ayah.index(query[0]) == nil))
           return best
        end

        ayah = ayah[ayah.index(query[0])..-1]
        len = [ayah.length, query.length].min
        truncated = ayah[0..len]

  print 'comparing ' + query + ' vs ' + truncated + "\n"
        distance = Levenshtein.distance query, truncated
  print 'got ' + distance.to_s + "\n"
        percent = 100 * (1.0 - (distance.to_f / truncated.length))
  print "percent: " + percent.to_s + "\n"
        if percent > minPercent
           if percent > best
              best = percent
           end

           if best > cutoff
              return best
           end
        end
     end

     return best
  end

  def prepareText(str)
     return str.gsub('oo', 'u')
               .gsub('-', '')
               .downcase
               .gsub('aa', 'a')
               .gsub(' ', '')
               .gsub('ia', 'i')
               .gsub('7', 'h')
  end
end
# ayah = 'bismillahirrahmanirraheem' # from db
#print compareText(ayah, prepareText('ra7man'))
