module SearchPrepareQuery
  extend ActiveSupport::Concern

  included do
    attr_accessor :query
    before_filter :prepare_query
  end

  def transliteration_rules
    [
      ['oo', 'u']
      ['-', '']
      ['aa', 'a']
      [' ', '']
      ['ia', 'i']
      ['7', 'h']
    ]
  end

  def transliteration_clean(query)
    query = query.downcase

    transliteration_rules.each do |rule|
      query.gsub(rule[0], rule[1])
    end

    return query
  end

  def prepare_query
    @query = params[:q]

    @query = transliteration_clean(@query)
  end
end


# var decode = [
#   [COMMA, ", "], # unicode 060c
#   [SEMI_COLON, "; "], # unicode 061b
#   [QUESTION_MARK, "? "], # unicode 061f
#   [HAMZA, "hamza "], # unicode 0621
#   [ALEF_MADDA_ABOVE, "alef-madda-above "], # unicode 0622
#   [ALEF_HAMZA_ABOVE, "alef-hamza-above "], # unicode 0623
#   [WAW_HAMZA_ABOVE, "waw-hamza-above "], # unicode 0624
#   [ALEF_HAMZA_BELOW, "alef-hamza-below "], # unicode 0625
#   [YEH_HAMZA_ABOVE, "yeh-hamza-above "], # unicode 0626
#   [ALEF, "alef "], # unicode 0627
#   [BEH, "beh "], # unicode 0628
#   [TEH_MARBUTA, "teh-marbuta "], # unicode 0629
#   [TEH, "teh "], # unicode 062a
#   [THEH, "theh "], # unicode 062b
#   [JEEM, "jeem "], # unicode 062c
#   [HAH, "hah "], # unicode 062d
#   [KHAH, "khah "], # unicode 062e
#   [DAL, "dal "], # unicode 062f
#   [THAL, "thal "], # unicode 0630
#   [REH, "reh "], # unicode 0631
#   [ZAIN, "zain "], # unicode 0632
#   [SEEN, "seen "], # unicode 0633
#   [SHEEN, "sheen "], # unicode 0634
#   [SAD, "sad "], # unicode 0635
#   [DAD, "dad "], # unicode 0636
#   [TAH, "tah "], # unicode 0637
#   [ZAH, "zah "], # unicode 0638
#   [AIN, "ain "], # unicode 0639
#   [GHAIN, "ghain "], # unicode 063a
#   [TATWEEL, "tatweel "], # unicode 0640
#   [FEH, "feh "], # unicode 0641
#   [QAF, "qaf "], # unicode 0642
#   [KAF, "kaf "], # unicode 0643
#   [LAM, "lam "], # unicode 0644
#   [MEEM, "meem "], # unicode 0645
#   [NOON, "noon "], # unicode 0646
#   [HEH, "heh "], # unicode 0647
#   [WAW, "waw "], # unicode 0648
#   [ALEF_MAKSURA, "alef-maksura "], # unicode 0649
#   [YEH, "yeh "], # unicode 064a
#   [FATHATAN, "fathatan "], # unicode 064b
#   [DAMMATAN, "dammatan "], # unicode 064c
#   [KASRATAN, "kasratan "], # unicode 064d
#   [FATHA, "fatha "], # unicode 064e
#   [DAMMA, "damma "], # unicode 064f
#   [KASRA, "kasra "], # unicode 0650
#   [SHADDA, "shadda "], # unicode 0651
#   [SUKUN, "sukun "], # unicode 0652
#   ["  ", "&nbsp;&nbsp;&nbsp;"]
# ];
#
# {COMMA: "،", SEMI_COLON: "؛", QUESTION_MARK: "؟", HAMZA: "ء", ALEF_MADDA_ABOVE: "آ"…}AIN: "ع"ALEF: "ا"ALEF_HAMZA_ABOVE: "أ"ALEF_HAMZA_BELOW: "إ"ALEF_MADDA_ABOVE: "آ"ALEF_MAKSURA: "ى"BEH: "ب"COMMA: "،"DAD: "ض"DAL: "د"DAMMA: "ُ"DAMMATAN: "ٌ"FATHA: "َ"FATHATAN: "ً"FEH: "ف"GHAIN: "غ"HAH: "ح"HAMZA: "ء"HEH: "ه"JEEM: "ج"KAF: "ك"KASRA: "ِ"KASRATAN: "ٍ"KHAH: "خ"LAM: "ل"MEEM: "م"NOON: "ن"QAF: "ق"QUESTION_MARK: "؟"REH: "ر"SAD: "ص"SEE: "س"SEMI_COLON: "؛"SHADDA: "ّ"SHEEN: "ش"SUKUN: "ْ"TAH: "ط"TATWEEL: "ـ"TEH: "ت"TEH_MARBUTA: "ة"THAL: "ذ"THEH: "ث"WAW: "و"WAW_HAMZA_ABOVE: "ؤ"YEH: "ي"YEH_HAMZA_ABOVE: "ئ"ZAH: "ظ"ZAIN: "ز"__proto__: Object
#
# // see http://unicode.org/Public/MAPPINGS/ISO8859/8859-6.TXT
#
# function Either2(x, y) {
#   return "(" + x + "|" + y + ")";
# }
#
# function Either3(x, y, z) {
#   return "(" + x + "|" + y + "|" + z + ")";
# }
#
# function convertNow(temp) {
#
# /*
#     //common words and combinations
#     temp = temp.replace(/\bAlla(h)?\b/gi,ALEF + LAM + LAM + HEH);
#       // Alla -> ALEF LAM LAM HEH, Allah -> ALEF LAM LAM HEH
#     temp = temp.replace(/\b(E|I)nshAlla(h)?\b/gi,
#       // EnshAlla, InshAlla, EnshAllah, InshAllah
#                         ALEF_HAMZA_BELOW + NOON + " " +
#                         SHEEN + ALEF + HAMZA + " " +
#                         ALEF + LAM + LAM + HEH);
#     temp = temp.replace(/llah\b/gi,LAM + LAM + HEH);
#       // final llah -> LAM LAM HEH
#     temp = temp.replace(/eha\b/gi,YEH + HEH + ALEF);
#     temp = temp.replace(/\b3ala\b/gi,AIN + LAM + ALEF_MAKSURA);
#     temp = temp.replace(/-a/gi,ALEF_HAMZA_ABOVE);
#     temp = temp.replace(/\b(e|a)l\s{1,}|\b(e|a)l/gi,ALEF + LAM);
#     temp = temp.replace(/(an)\b/gi,ALEF + NOON);
#     temp = temp.replace(/\bla\b/gi,LAM + ALEF);
#     temp = temp.replace(/\bbel/gi,BEH + ALEF_HAMZA_BELOW + LAM);
#     temp = temp.replace(/\bwa\b/gi, WAW);
# */
#
# 			//consonants
#
# /*
#     temp = temp.replace(/T$/g,TEH_MARBUTA);
#     temp = temp.replace(/(_|\^)t/gi,THEH);
#       // _t -> theh, ^t -> THEH
#     temp = temp.replace(/[\*|.|_]7|(\*|.)5|_h/g,KHAH);
#       // *7 -> KHAH, .7 -> KHAH, _7 -> KHAH, *5 -> KHAH, .5 -> KHAH, _h -> KHAH
#     temp = temp.replace(/(\.h)|7/gi,HAH);
#       // .h -> HAH, 7 -> HAH
#     temp = temp.replace(/(\.|\*)d|d(\.|\*)/gi,THAL);
#       // .d -> THAL, *d -> THAL, d. -> THAL, d* -> THAL
#     temp = temp.replace(/(\.|\*)9|9(\.|\*)|_d/gi,DAD);
#       // .9 -> DAD, *9 -> DAD, 9. -> DAD, 9* -> DAD, _d -> DAD
#     temp = temp.replace(/\^g/gi,JEEM);
#       // ^g -> JEEM
#     temp = temp.replace(/\^s/gi,SHEEN);
#       // ^s -> SHEEN
#     temp = temp.replace(/\.s|9/gi,SAD);
#       // .s -> SAD, 9 -> SAD
#     temp = temp.replace(/\.6|\*6|6\.|6\*|\.d/gi,ZAH);
#       // .6 -> ZAH, *6 -> ZAH, 6. -> ZAH, 6* -> ZAH
#     temp = temp.replace(/6|\.t/g,TAH);
#       // 6 -> TAH, .t -> TAH
#     temp = temp.replace(/(\'|`)3|3(\*|\.)|\.z|\.g/gi,GHAIN);
#       // '3 -> GHAIN, `3 -> GHAIN, 3* -> GHAIN, 3. -> GHAIN, .z -> GHAIN, .g -> GHAIN
#     temp = temp.replace(/3|\'/g,AIN);
#       // 3 -> AIN, ' -> AIN
#     temp = temp.replace(/2/gi,YEH_HAMZA_ABOVE);
#       // 2 -> YEH_HAMZA_ABOVE
# */
#
#     temp = temp.replace(/^pn/gi,NOON);
#     temp = temp.replace(/\spn/gi," "+NOON);
#     temp = temp.replace(/-pn/gi,"-"+NOON);
#       // initial pn -> n
#     temp = temp.replace(/ph/gi,FEH);
#       // ph -> FEH
#     temp = temp.replace(/bb|pp/gi,BEH);
#       // bb -> BEH, pp -> BEH
#     temp = temp.replace(/b|p/gi,BEH);
#       // b -> BEH, p -> BEH
#
#     temp = temp.replace(/cha/gi,Either2(SHEEN, JEEM)+"a");
#     temp = temp.replace(/che/gi,Either2(SHEEN, JEEM)+"e");
#     temp = temp.replace(/chi/gi,Either2(SHEEN, JEEM)+"i");
#     temp = temp.replace(/cho/gi,Either2(SHEEN, JEEM)+"o");
#     temp = temp.replace(/chu/gi,Either2(SHEEN, JEEM)+"u");
#     temp = temp.replace(/chy/gi,Either2(SHEEN, JEEM)+"y");
#       // ch vowel -> (SHEEN | JEEM) vowel
#     temp = temp.replace(/^chr/gi,KAF+REH);
#     temp = temp.replace(/\schr/gi," "+KAF+REH);
#     temp = temp.replace(/-chr/gi,"-"+KAF+REH);
#       // initial chr -> KAF REH
#     temp = temp.replace(/^chl/gi,KAF+LAM);
#     temp = temp.replace(/\schl/gi," "+KAF+LAM);
#     temp = temp.replace(/-chl/gi,"-"+KAF+LAM);
#       // initial chl -> KAF LAM
#     temp = temp.replace(/cce|cci|ccy/gi,KAF+SEEN+YEH);
#       // cce -> KAF SEEN YEH, cci -> KAF SEEN YEH, ccy -> KAF SEEN YEH
#     temp = temp.replace(/cc/gi,Either2(KAF,TEH+SHEEN));
#       // cc -> KAF or TEH SHEEN
#     temp = temp.replace(/ce|ci|cy/gi,SEEN+YEH);
#       // ce -> SEEN YEH, ci -> SEEN YEH, cy -> SEEN YEH
#     temp = temp.replace(/sch/gi,SEEN+KAF);
#       // sch -> SEEN+KAF
#     temp = temp.replace(/tch/gi,Either2(KAF, TEH+SHEEN));
#       // tch -> KAF or TEH SHEEN
#     temp = temp.replace(/ch/gi,Either2(KAF, TEH+SHEEN));
#       // ch -> KAF or TEH SHEEN
#     temp = temp.replace(/ck/gi,KAF);
#       // ck -> KAF
#     temp = temp.replace(/c/gi,KAF);
#       // c -> KAF
#
#     temp = temp.replace(/dd/gi,DAL);
#       // dd -> DAL
#     temp = temp.replace(/dj/gi,JEEM);
#       // dj -> JEEM
#     temp = temp.replace(/hd$/g,"");
#     temp = temp.replace(/hd\s/g," ");
#     temp = temp.replace(/hd-/g,"-");
#       // final hd -> blank
#     temp = temp.replace(/d/gi,DAL);
#       // d -> DAL
#
#     temp = temp.replace(/ff|vv/gi,FEH);
#       // ff -> FEH, vv -> FEH
#     temp = temp.replace(/f|v/gi,FEH);
#       // f -> FEH, v -> FEH
#
#     temp = temp.replace(/^gh/gi,QAF);
#     temp = temp.replace(/\sgh/gi," "+QAF);
#     temp = temp.replace(/-gh/gi,"-"+QAF);
#       // initial gh -> QAF
#     temp = temp.replace(/gh$/gi,Either3(FEH, QAF, ""));
#     temp = temp.replace(/gh\s/gi,Either3(FEH, QAF, "") + " ");
#     temp = temp.replace(/gh-/gi,Either3(FEH, QAF, "") + "-");
#       // final gh -> FEH or QAF or blank
#     temp = temp.replace(/gh/gi,Either2(QAF, ""));
#       // gh -> QAF or blank
#     temp = temp.replace(/gg/gi,QAF);
#       // gg -> QAF
#     temp = temp.replace(/gn/gi,NOON);
#       // gn -> NOON
#     temp = temp.replace(/g$/gi,QAF);
#     temp = temp.replace(/g\s/gi,QAF+" ");
#     temp = temp.replace(/g-/gi,QAF+"-");
#       // final g -> QAF
#     temp = temp.replace(/g/gi,Either2(QAF,JEEM));
#       // g -> QAF | JEEM
#
#     temp = temp.replace(/hai/gi,HEH+ALEF+YEH);
#       // hai -> HEH ALEF YEH
#     temp = temp.replace(/hm$/g,"");
#     temp = temp.replace(/hm\s/g," ");
#     temp = temp.replace(/hm-/g,"-");
#       // final hm -> blank
#     temp = temp.replace(/hn$/g,"");
#     temp = temp.replace(/hn\s/g," ");
#     temp = temp.replace(/hn-/g,"-");
#       // final hn -> blank
#     temp = temp.replace(/ht$/g,"");
#     temp = temp.replace(/ht\s/g," ");
#     temp = temp.replace(/ht-/g,"-");
#       // final ht -> blank
#     temp = temp.replace(/^h/gi,"");
#     temp = temp.replace(/\sh/gi," ");
#     temp = temp.replace(/-h/gi,"-");
#       // initial h -> blank
#     // the h rule alone appears at the end so that things like sh, th, etc get executed before it
#
#     temp = temp.replace(/j/gi,JEEM);
#       // j -> JEEM
#
#     temp = temp.replace(/kh/gi,KHAH);
#       // kh -> KHAH
#     temp = temp.replace(/kk/gi,KAF);
#       // kk -> KAF
#     temp = temp.replace(/^kn/gi,NOON);
#     temp = temp.replace(/\skn/gi," "+NOON);
#     temp = temp.replace(/-kn/gi,"-"+NOON);
#       // initial kn -> NOON
#     temp = temp.replace(/k/gi,KAF);
#       // k -> KAF
#
#     temp = temp.replace(/^ll/gi,YEH);
#     temp = temp.replace(/\sll/gi," "+YEH);
#     temp = temp.replace(/-ll/gi,"-"+YEH);
#       // initial ll -> YEH
#     temp = temp.replace(/ll/gi,LAM);
#       // ll -> LAM
#     temp = temp.replace(/l/gi,LAM);
#       // l -> LAM
#
#     temp = temp.replace(/^mb/gi,BEH);
#     temp = temp.replace(/\smb/gi," "+BEH);
#     temp = temp.replace(/-mb/gi,"-"+BEH);
#       // initial mb -> BEH
#     temp = temp.replace(/^mc/gi,MEEM+YEH+KAF);
#     temp = temp.replace(/\smc/gi," "+MEEM+YEH+KAF);
#     temp = temp.replace(/-mc/gi,"-"+MEEM+YEH+KAF);
#       // initial mc -> MEEM YEH KAF
#     temp = temp.replace(/mm/gi,MEEM);
#       // mm -> MEEM
#     temp = temp.replace(/m/gi,MEEM);
#       // m -> MEEM
#
#     temp = temp.replace(/nn|nw/gi,NOON);
#       // nn -> NOON, nw -> NOON
#     temp = temp.replace(/n/gi,NOON);
#       // n -> NOON
#
#     // for p see b
#
#     temp = temp.replace(/qu/gi,QAF+WAW);
#       // qu -> QAF WAW
# /*
#     temp = temp.replace(/qu/gi,QAF+WAW+ALEF);
#       // qu -> QAF WAW ALEF
# */
#     temp = temp.replace(/q/gi,QAF);
#       // q -> QAF
#
#     temp = temp.replace(/rr/gi,REH);
#       // rr -> REH
#     temp = temp.replace(/r/gi,REH);
#       // r -> REH
#
#     temp = temp.replace(/sh/gi,SHEEN);
#       // sh -> SHEEN
#     temp = temp.replace(/ss/gi,SEEN);
#       // ss -> SEEN
#     temp = temp.replace(/^ts/gi,SEEN);
#     temp = temp.replace(/\sts/gi," "+SEEN);
#     temp = temp.replace(/-ts/gi,"-"+SEEN);
#       // initial ts -> SEEN
#     temp = temp.replace(/s/gi,SEEN);
#       // s -> SEEN
#
#     temp = temp.replace(/T$/g,TEH_MARBUTA);
#     temp = temp.replace(/T\s/g,TEH_MARBUTA+" ");
#     temp = temp.replace(/T-/g,TEH_MARBUTA+"-");
#       // final T -> TEH_MARBUTA
#     temp = temp.replace(/^tz/gi,ZAIN);
#     temp = temp.replace(/\stz/gi," "+ZAIN);
#     temp = temp.replace(/-tz/gi,"-"+ZAIN);
#       // initial tz -> ZAIN
#     temp = temp.replace(/th$/gi,THEH);
#     temp = temp.replace(/th\s/gi,THEH+" ");
#     temp = temp.replace(/th-/gi,THEH+"-");
#       // final th -> THA
#     temp = temp.replace(/th/gi,Either2(THEH, THAL));
#       // th -> THEH or THAL
# /*
#     temp = temp.replace(/th/gi,DAL);
#       // th -> DAL
# */
#
#     temp = temp.replace(/tt/gi,TEH);
#       // tt -> TEH
#     temp = temp.replace(/t/gi,TEH);
#       // t -> TEH
#
#     // for v see f
#
#     temp = temp.replace(/ww/gi,WAW);
#       // ww -> WAW
#     temp = temp.replace(/w/gi,WAW);
#       // w -> WAW
#
#     temp = temp.replace(/^x/gi,ZAIN);
#     temp = temp.replace(/\sx/gi," "+ZAIN);
#     temp = temp.replace(/-x/gi,"-"+ZAIN);
#       // initial x -> ZAIN
#     temp = temp.replace(/x/gi,KAF+SEEN);
#       // x -> KAF SEEN
#
#     temp = temp.replace(/zz/gi,ZAIN);
#       // zz -> ZAIN
#     temp = temp.replace(/z/gi,ZAIN);
#       // z -> ZAIN
#
#     // this rule must come last so that things like sh, th, etc get executed before it
#     temp = temp.replace(/h/gi,HEH);
#       // h -> HEH
#
#     //vowels
#
# /*
#     temp = temp.replace(/_a/gi,ALEF_MAKSURA);
#       // _a -> ALEF_MAKSURA
#     temp = temp.replace(/~a/gi,ALEF_MADDA_ABOVE);
#       // ~a -> ALEF_MADDA_ABOVE
#     temp = temp.replace(/~/,"~");
#       // ~ -> ~
#     temp = temp.replace(/\Wo$/gi,WAW);
#     temp = temp.replace(/\Wo\s/gi,WAW+" ");
#     temp = temp.replace(/\Wo-/gi,WAW+"-");
#       // final [non-word]o -> WAW
#     temp = temp.replace(/^2|-a/gi,ALEF_HAMZA_ABOVE);
#     temp = temp.replace(/\s2/gi," "+ALEF_HAMZA_ABOVE);
#     temp = temp.replace(/-2/gi,"-"+ALEF_HAMZA_ABOVE);
#       // leading 2 -> ALEF_HAMZA_ABOVE
#       // -a -> ALEF_HAMZA_ABOVE
# */
#
#
#     temp = temp.replace(/^a|^u|^o/gi,ALEF_HAMZA_ABOVE);
#     temp = temp.replace(/\sa|\su|\so/gi," "+ALEF_HAMZA_ABOVE);
#     temp = temp.replace(/-a|-u|-o/gi,"-"+ALEF_HAMZA_ABOVE);
#       // leading a -> ALEF_HAMZA_ABOVE
#       // leading u -> ALEF_HAMZA_ABOVE
#       // leading o -> ALEF_HAMZA_ABOVE
#     temp = temp.replace(/^e|^i/gi,ALEF_HAMZA_BELOW);
#     temp = temp.replace(/\se|\si/gi," "+ALEF_HAMZA_BELOW);
#     temp = temp.replace(/-e|-i/gi,"-"+ALEF_HAMZA_BELOW);
#       // leading e -> ALEF_HAMZA_BELOW
#       // leading i -> ALEF_HAMZA_BELOW
#
#     temp = temp.replace(/ai/gi,YEH);
#       // ai -> YEH
#     temp = temp.replace(/au/gi,WAW);
#       // au -> WAW
#     temp = temp.replace(/a{2,}|a$/gi,ALEF);
#     temp = temp.replace(/a\s/gi,ALEF+" ");
#     temp = temp.replace(/a-/gi,ALEF+"-");
#       // two or more a -> ALEF, final a -> ALEF
#
#     temp = temp.replace(/e{2,}|e$|ea|ei/gi,YEH);
#     temp = temp.replace(/e\s/gi,YEH+" ");
#     temp = temp.replace(/e-/gi,YEH+"-");
#       // two or more e -> YEH, final e -> YEH, ea -> YEH, ei -> YEH
#
#     temp = temp.replace(/i$|ia|ie/gi,YEH);
#     temp = temp.replace(/i\s/gi,YEH+" ");
#     temp = temp.replace(/i-/gi,YEH+"-");
#       // final i -> YEH, ia -> YEH, ie -> YEH
#     temp = temp.replace(/io/gi,YEH+WAW);
#       // io -> YEH WAW
#
#     temp = temp.replace(/o{2,}|o$/gi,WAW);
#     temp = temp.replace(/o\s/gi,WAW+" ");
#     temp = temp.replace(/o-/gi,WAW+"-");
#       // two or more o -> WAW, final o -> WAW
#     temp = temp.replace(/ou|ow/gi,WAW);
#      // ou -> WAW, ow -> WAW
#
#     temp = temp.replace(/uu/gi,WAW);
#       // uu -> WAW
#     temp = temp.replace(/u/gi,WAW);
#      // u -> WAW
#
#     temp = temp.replace(/y/gi,YEH);
#       // y -> YEH
#
#    temp = temp.replace(/o|e|a|i/gi,"");
#      // o -> null, e -> null, a -> null, i -> null
#
#
#     //special characters
#     temp = temp.replace(/\?/g,QUESTION_MARK);
#       // ? -> QUESTION_MARK
#
#     return Expand(temp);
# }
#
# function Expand(result) {
#   var altStart = result.indexOf("(");
#   if (altStart == -1) {
#     return result;
#   }
#   var prefix = result.substr(0, altStart);
#   altStart++; // get past the (
#   var altEnd = result.indexOf(")", altStart);
#   var altString = result.substr(altStart, altEnd-altStart);
#   altEnd++; // get past the )
#   var suffix = result.substr(altEnd);
#   var altArray = altString.split("|");
#   var expandedResult = "";
#   for (var i=0; i<altArray.length; i++) {
#     var alt = altArray[i];
#     var alternate = Expand(prefix+alt+suffix);
#     if (alternate != "") {
#       if (expandedResult != "") {
#         expandedResult += COMMA + " ";
#       }
#       expandedResult += alternate;
#     }
#   }
#   return expandedResult;
# }
