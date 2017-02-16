module Search
  class Transliterate
    attr_reader :query

    def initialize(query)
      @query = self.convert(query)
    end

# Look into ektub too!
    COMMA = "،"
    SEMI_COLON = "؛"
    QUESTION_MARK = "؟"
    HAMZA = "ء"
    ALEF_MADDA_ABOVE = "آ"
    ALEF_HAMZA_ABOVE = "أ"
    WAW_HAMZA_ABOVE = "ؤ"
    ALEF_HAMZA_BELOW = "إ"
    YEH_HAMZA_ABOVE = "ئ"
    ALEF = "ا"
    BEH = "ب"
    TEH_MARBUTA = "ة"
    TEH = "ت"
    THEH = "ث"
    JEEM = "ج"
    HAH = "ح"
    KHAH = "خ"
    DAL = "د"
    THAL = "ذ"
    REH = "ر"
    ZAIN = "ز"
    SEEN = "س"
    SHEEN = "ش"
    SAD = "ص"
    DAD = "ض"
    TAH = "ط"
    ZAH = "ظ"
    AIN = "ع"
    GHAIN = "غ"
    TATWEEL = "ـ"
    FEH = "ف"
    QAF = "ق"
    KAF = "ك"
    LAM = "ل"
    MEEM = "م"
    NOON = "ن"
    HEH = "ه"
    WAW = "و"
    ALEF_MAKSURA = "ى"
    YEH = "ي"
    FATHATAN = "ً"
    DAMMATAN = "ٌ"
    KASRATAN = "ٍ"
    FATHA = "َ"
    DAMMA = "ُ"
    KASRA = "ِ"
    SHADDA = "ّ"
    SUKUN = "ْ"

protected

    def either_of_2(x, y)
      return "(#{x}|#{y})";
    end

    def either_of_3(x, y, z)
      return "(#{x}|#{y}|#{z})";
    end

    def convert(temp)
      temp = temp.downcase
      # #common words and combinations
      # temp = temp.gsub(/\bAlla(h)?\b/i,ALEF + LAM + LAM + HEH);
      #   # Alla -> ALEF LAM LAM HEH, Allah -> ALEF LAM LAM HEH
      # temp = temp.gsub(/\b(E|I)nshAlla(h)?\b/i,
      #   # EnshAlla, InshAlla, EnshAllah, InshAllah
      #                     ALEF_HAMZA_BELOW + NOON + " " +
      #                     SHEEN + ALEF + HAMZA + " " +
      #                     ALEF + LAM + LAM + HEH);
      # temp = temp.gsub(/llah\b/i,LAM + LAM + HEH);
      #   # final llah -> LAM LAM HEH
      # temp = temp.gsub(/eha\b/i,YEH + HEH + ALEF);
      # temp = temp.gsub(/\b3ala\b/i,AIN + LAM + ALEF_MAKSURA);
      # temp = temp.gsub(/-a/i,ALEF_HAMZA_ABOVE);
      # temp = temp.gsub(/\b(e|a)l\s{1,}|\b(e|a)l/i,ALEF + LAM);
      # temp = temp.gsub(/(an)\b/i,ALEF + NOON);
      # temp = temp.gsub(/\bla\b/i,LAM + ALEF);
      # temp = temp.gsub(/\bbel/i,BEH + ALEF_HAMZA_BELOW + LAM);
      # temp = temp.gsub(/\bwa\b/i, WAW);


      #consonants
      # temp = temp.gsub(/T$/,TEH_MARBUTA);
      # temp = temp.gsub(/(_|\^)t/i,THEH);
      #   # _t -> theh, ^t -> THEH
      # temp = temp.gsub(/[\*|.|_]7|(\*|.)5|_h/,KHAH);
      #   # *7 -> KHAH, .7 -> KHAH, _7 -> KHAH, *5 -> KHAH, .5 -> KHAH, _h -> KHAH
      temp = temp.gsub(/(\.h)|7/i,HAH);
      #   # .h -> HAH, 7 -> HAH
      # temp = temp.gsub(/(\.|\*)d|d(\.|\*)/i,THAL);
      #   # .d -> THAL, *d -> THAL, d. -> THAL, d* -> THAL
      # temp = temp.gsub(/(\.|\*)9|9(\.|\*)|_d/i,DAD);
      #   # .9 -> DAD, *9 -> DAD, 9. -> DAD, 9* -> DAD, _d -> DAD
      # temp = temp.gsub(/\^g/i,JEEM);
      #   # ^g -> JEEM
      # temp = temp.gsub(/\^s/i,SHEEN);
      #   # ^s -> SHEEN
      # temp = temp.gsub(/\.s|9/i,SAD);
      #   # .s -> SAD, 9 -> SAD
      # temp = temp.gsub(/\.6|\*6|6\.|6\*|\.d/i,ZAH);
      #   # .6 -> ZAH, *6 -> ZAH, 6. -> ZAH, 6* -> ZAH
      # temp = temp.gsub(/6|\.t/,TAH);
      #   # 6 -> TAH, .t -> TAH
      temp = temp.gsub(/(\'|`)3|3(\*|\.)|\.z|\.g/i,GHAIN);
      #   # '3 -> GHAIN, `3 -> GHAIN, 3* -> GHAIN, 3. -> GHAIN, .z -> GHAIN, .g -> GHAIN
      temp = temp.gsub(/3|\'/,AIN);
      #   # 3 -> AIN, ' -> AIN
      temp = temp.gsub(/2/i,YEH_HAMZA_ABOVE);
      #   # 2 -> YEH_HAMZA_ABOVE

      temp = temp.gsub(/^pn/i,NOON);
      temp = temp.gsub(/\spn/i," "+NOON);
      temp = temp.gsub(/-pn/i,"-"+NOON);
      # initial pn -> n
      temp = temp.gsub(/ph/i,FEH);
      # ph -> FEH
      temp = temp.gsub(/bb|pp/i,BEH);
      # bb -> BEH, pp -> BEH
      temp = temp.gsub(/b|p/i,BEH);
      # b -> BEH, p -> BEH

      temp = temp.gsub(/cha/i,either_of_2(SHEEN, JEEM)+"a");
      temp = temp.gsub(/che/i,either_of_2(SHEEN, JEEM)+"e");
      temp = temp.gsub(/chi/i,either_of_2(SHEEN, JEEM)+"i");
      temp = temp.gsub(/cho/i,either_of_2(SHEEN, JEEM)+"o");
      temp = temp.gsub(/chu/i,either_of_2(SHEEN, JEEM)+"u");
      temp = temp.gsub(/chy/i,either_of_2(SHEEN, JEEM)+"y");
      # ch vowel -> (SHEEN | JEEM) vowel
      temp = temp.gsub(/^chr/i,KAF+REH);
      temp = temp.gsub(/\schr/i," "+KAF+REH);
      temp = temp.gsub(/-chr/i,"-"+KAF+REH);
      # initial chr -> KAF REH
      temp = temp.gsub(/^chl/i,KAF+LAM);
      temp = temp.gsub(/\schl/i," "+KAF+LAM);
      temp = temp.gsub(/-chl/i,"-"+KAF+LAM);
      # initial chl -> KAF LAM
      temp = temp.gsub(/cce|cci|ccy/i,KAF+SEEN+YEH);
      # cce -> KAF SEEN YEH, cci -> KAF SEEN YEH, ccy -> KAF SEEN YEH
      temp = temp.gsub(/cc/i,either_of_2(KAF,TEH+SHEEN));
      # cc -> KAF or TEH SHEEN
      temp = temp.gsub(/ce|ci|cy/i,SEEN+YEH);
      # ce -> SEEN YEH, ci -> SEEN YEH, cy -> SEEN YEH
      temp = temp.gsub(/sch/i,SEEN+KAF);
      # sch -> SEEN+KAF
      temp = temp.gsub(/tch/i,either_of_2(KAF, TEH+SHEEN));
      # tch -> KAF or TEH SHEEN
      temp = temp.gsub(/ch/i,either_of_2(KAF, TEH+SHEEN));
      # ch -> KAF or TEH SHEEN
      temp = temp.gsub(/ck/i,KAF);
      # ck -> KAF
      temp = temp.gsub(/c/i,KAF);
      # c -> KAF

      temp = temp.gsub(/dd/i,DAL);
      # dd -> DAL
      temp = temp.gsub(/dj/i,JEEM);
      # dj -> JEEM
      temp = temp.gsub(/hd$/,"");
      temp = temp.gsub(/hd\s/," ");
      temp = temp.gsub(/hd-/,"-");
      # final hd -> blank
      temp = temp.gsub(/d/i,DAL);
      # d -> DAL

      temp = temp.gsub(/ff|vv/i,FEH);
      # ff -> FEH, vv -> FEH
      temp = temp.gsub(/f|v/i,FEH);
      # f -> FEH, v -> FEH

      temp = temp.gsub(/^gh/i,QAF);
      temp = temp.gsub(/\sgh/i," "+QAF);
      temp = temp.gsub(/-gh/i,"-"+QAF);
      # initial gh -> QAF
      temp = temp.gsub(/h$/i,either_of_3(FEH, QAF, ""));
      temp = temp.gsub(/h\s/i,either_of_3(FEH, QAF, "") + " ");
      temp = temp.gsub(/h-/i,either_of_3(FEH, QAF, "") + "-");
      # final gh -> FEH or QAF or blank
      temp = temp.gsub(/h/i,either_of_2(QAF, ""));
      # gh -> QAF or blank
      temp = temp.gsub(/g/i,QAF);
      # gg -> QAF
      temp = temp.gsub(/n/i,NOON);
      # gn -> NOON

      # TODO: Not sure why this was here
      # temp = temp.gsub(/$/i,QAF);
      # temp = temp.gsub(/\s/i,QAF+" ");
      # temp = temp.gsub(/-/i,QAF+"-");
      # final g -> QAF
      # temp = temp.gsub(//i,either_of_2(QAF,JEEM));
      # g -> QAF | JEEM


      temp = temp.gsub(/hai/i,HEH+ALEF+YEH);
      # hai -> HEH ALEF YEH
      temp = temp.gsub(/hm$/,"");
      temp = temp.gsub(/hm\s/," ");
      temp = temp.gsub(/hm-/,"-");
      # final hm -> blank
      temp = temp.gsub(/hn$/,"");
      temp = temp.gsub(/hn\s/," ");
      temp = temp.gsub(/hn-/,"-");
      # final hn -> blank
      temp = temp.gsub(/ht$/,"");
      temp = temp.gsub(/ht\s/," ");
      temp = temp.gsub(/ht-/,"-");
      # final ht -> blank
      temp = temp.gsub(/^h/i,"");
      temp = temp.gsub(/\sh/i," ");
      temp = temp.gsub(/-h/i,"-");
      # initial h -> blank
      # the h rule alone appears at the end so that things like sh, th, etc get executed before it

      temp = temp.gsub(/j/i,JEEM);
      # j -> JEEM

      temp = temp.gsub(/kh/i,KHAH);
      # kh -> KHAH
      temp = temp.gsub(/kk/i,KAF);
      # kk -> KAF
      temp = temp.gsub(/^kn/i,NOON);
      temp = temp.gsub(/\skn/i," "+NOON);
      temp = temp.gsub(/-kn/i,"-"+NOON);
      # initial kn -> NOON
      temp = temp.gsub(/k/i,KAF);
      # k -> KAF

      temp = temp.gsub(/^ll/i,YEH);
      temp = temp.gsub(/\sll/i," "+YEH);
      temp = temp.gsub(/-ll/i,"-"+YEH);
      # initial ll -> YEH
      temp = temp.gsub(/ll/i,LAM);
      # ll -> LAM
      temp = temp.gsub(/l/i,LAM);
      # l -> LAM

      temp = temp.gsub(/^mb/i,BEH);
      temp = temp.gsub(/\smb/i," "+BEH);
      temp = temp.gsub(/-mb/i,"-"+BEH);
      # initial mb -> BEH
      temp = temp.gsub(/^mc/i,MEEM+YEH+KAF);
      temp = temp.gsub(/\smc/i," "+MEEM+YEH+KAF);
      temp = temp.gsub(/-mc/i,"-"+MEEM+YEH+KAF);
      # initial mc -> MEEM YEH KAF
      temp = temp.gsub(/mm/i,MEEM);
      # mm -> MEEM
      temp = temp.gsub(/m/i,MEEM);
      # m -> MEEM

      temp = temp.gsub(/nn|nw/i,NOON);
      # nn -> NOON, nw -> NOON
      temp = temp.gsub(/n/i,NOON);
      # n -> NOON

      # for p see b

      temp = temp.gsub(/qu/i,QAF+WAW);
      # qu -> QAF WAW

      # temp = temp.gsub(/qu/i,QAF+WAW+ALEF);
      # # qu -> QAF WAW ALEF
      temp = temp.gsub(/q/i,QAF);
      # q -> QAF

      temp = temp.gsub(/rr/i,REH);
      # rr -> REH
      temp = temp.gsub(/r/i,REH);
      # r -> REH

      temp = temp.gsub(/sh/i,SHEEN);
      # sh -> SHEEN
      temp = temp.gsub(/ss/i,SEEN);
      # ss -> SEEN
      temp = temp.gsub(/^ts/i,SEEN);
      temp = temp.gsub(/\sts/i," "+SEEN);
      temp = temp.gsub(/-ts/i,"-"+SEEN);
      # initial ts -> SEEN
      temp = temp.gsub(/s/i,SEEN);
      # s -> SEEN

      temp = temp.gsub(/T$/,TEH_MARBUTA);
      temp = temp.gsub(/T\s/,TEH_MARBUTA+" ");
      temp = temp.gsub(/T-/,TEH_MARBUTA+"-");
      # final T -> TEH_MARBUTA
      temp = temp.gsub(/^tz/i,ZAIN);
      temp = temp.gsub(/\stz/i," "+ZAIN);
      temp = temp.gsub(/-tz/i,"-"+ZAIN);
      # initial tz -> ZAIN
      temp = temp.gsub(/th$/i,THEH);
      temp = temp.gsub(/th\s/i,THEH+" ");
      temp = temp.gsub(/th-/i,THEH+"-");
      # final th -> THA
      temp = temp.gsub(/th/i,either_of_2(THEH, THAL));
      # th -> THEH or THAL

      # temp = temp.gsub(/th/i,DAL);
      #   # th -> DAL


      temp = temp.gsub(/tt/i,TEH);
      # tt -> TEH
      temp = temp.gsub(/t/i,TEH);
      # t -> TEH

      # for v see f

      temp = temp.gsub(/ww/i,WAW);
      # ww -> WAW
      temp = temp.gsub(/w/i,WAW);
      # w -> WAW

      temp = temp.gsub(/^x/i,ZAIN);
      temp = temp.gsub(/\sx/i," "+ZAIN);
      temp = temp.gsub(/-x/i,"-"+ZAIN);
      # initial x -> ZAIN
      temp = temp.gsub(/x/i,KAF+SEEN);
      # x -> KAF SEEN

      temp = temp.gsub(/zz/i,ZAIN);
      # zz -> ZAIN
      temp = temp.gsub(/z/i,ZAIN);
      # z -> ZAIN

      # this rule must come last so that things like sh, th, etc get executed before it
      temp = temp.gsub(/h/i,HEH);
      # h -> HEH

      #vowels


      # temp = temp.gsub(/_a/i,ALEF_MAKSURA);
      #   # _a -> ALEF_MAKSURA
      # temp = temp.gsub(/~a/i,ALEF_MADDA_ABOVE);
      #   # ~a -> ALEF_MADDA_ABOVE
      # temp = temp.gsub(/~/,"~");
      #   # ~ -> ~
      # temp = temp.gsub(/\Wo$/i,WAW);
      # temp = temp.gsub(/\Wo\s/i,WAW+" ");
      # temp = temp.gsub(/\Wo-/i,WAW+"-");
      #   # final [non-word]o -> WAW
      temp = temp.gsub(/^2|-a/i,ALEF_HAMZA_ABOVE);
      # temp = temp.gsub(/\s2/i," "+ALEF_HAMZA_ABOVE);
      # temp = temp.gsub(/-2/i,"-"+ALEF_HAMZA_ABOVE);
      #   # leading 2 -> ALEF_HAMZA_ABOVE
      #   # -a -> ALEF_HAMZA_ABOVE



      temp = temp.gsub(/^a|^u|^o/i,ALEF_HAMZA_ABOVE);
      temp = temp.gsub(/\sa|\su|\so/i," "+ALEF_HAMZA_ABOVE);
      temp = temp.gsub(/-a|-u|-o/i,"-"+ALEF_HAMZA_ABOVE);
      # leading a -> ALEF_HAMZA_ABOVE
      # leading u -> ALEF_HAMZA_ABOVE
      # leading o -> ALEF_HAMZA_ABOVE
      temp = temp.gsub(/^e|^i/i,ALEF_HAMZA_BELOW);
      temp = temp.gsub(/\se|\si/i," "+ALEF_HAMZA_BELOW);
      temp = temp.gsub(/-e|-i/i,"-"+ALEF_HAMZA_BELOW);
      # leading e -> ALEF_HAMZA_BELOW
      # leading i -> ALEF_HAMZA_BELOW

      temp = temp.gsub(/ai/i,YEH);
      # ai -> YEH
      temp = temp.gsub(/au/i,WAW);
      # au -> WAW
      temp = temp.gsub(/a{2,}|a$/i,ALEF);
      temp = temp.gsub(/a\s/i,ALEF+" ");
      temp = temp.gsub(/a-/i,ALEF+"-");
      # two or more a -> ALEF, final a -> ALEF

      temp = temp.gsub(/e{2,}|e$|ea|ei/i,YEH);
      temp = temp.gsub(/e\s/i,YEH+" ");
      temp = temp.gsub(/e-/i,YEH+"-");
      # two or more e -> YEH, final e -> YEH, ea -> YEH, ei -> YEH

      temp = temp.gsub(/i$|ia|ie/i,YEH);
      temp = temp.gsub(/i\s/i,YEH+" ");
      temp = temp.gsub(/i-/i,YEH+"-");
      # final i -> YEH, ia -> YEH, ie -> YEH
      temp = temp.gsub(/io/i,YEH+WAW);
      # io -> YEH WAW

      temp = temp.gsub(/o{2,}|o$/i,WAW);
      temp = temp.gsub(/o\s/i,WAW+" ");
      temp = temp.gsub(/o-/i,WAW+"-");
      # two or more o -> WAW, final o -> WAW
      temp = temp.gsub(/ou|ow/i,WAW);
      # ou -> WAW, ow -> WAW

      temp = temp.gsub(/uu/i,WAW);
      # uu -> WAW
      temp = temp.gsub(/u/i,WAW);
      # u -> WAW

      temp = temp.gsub(/y/i,YEH);
      # y -> YEH

      temp = temp.gsub(/o|e|a|i/i,"");
      # o -> null, e -> null, a -> null, i -> null


      #special characters
      temp = temp.gsub(/\?/,QUESTION_MARK);
      # ? -> QUESTION_MARK

      return expand(temp);
    end

    def expand(result)
      return result if !result.include?("(")
      alt_start = result.index("(")
      prefix = result[0, alt_start]

      alt_start = alt_start + 1
      alt_end = result.index(")", alt_start)

      alt_string = result[alt_start, (alt_end - alt_start)]
      alt_end = alt_end + 1

      suffix = result[alt_end]
      alt_array = alt_string.split("|")
      expanded_result = ""

      alt_array.each do |alt|
        alternate = expand(prefix + alt + suffix)

        if !alternate.blank?
          if !expanded_result.blank?
            expanded_result += COMMA + " "
          end

          expanded_result += alternate
        end
      end

      return expanded_result
    end
  end
end
