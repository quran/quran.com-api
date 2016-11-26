namespace :importer do

  task import_surah_detail: :environment do
    Content::SurahInfo.delete_all

    1.upto(114) do |surah_number|
      puts "Importing Surah##{surah_number}"
      url = "https://raw.githubusercontent.com/quran/quran.com-frontend/master/src/components/SurahInfo/htmls/#{surah_number}.html.js"
      content = HTTParty.get(url)
      formatted_content = content.gsub("export default `", '').strip.chop

      surah = Quran::Surah.find(surah_number)
      #elastic search is breaking. DO we need to index this content ?
      surah_info = Content::SurahInfo.where(surah: surah, language: Locale::Language.find('en')).first_or_create
      surah_info.description = formatted_content
      surah_info.content_source = "Sayyid Abul Ala Maududi - Tafhim al-Qur'an - The Meaning of the Quran"
      surah_info.short_description = get_short_description(surah_number)
      surah_info.save
    end
  end

  def get_short_description(sura_number)
    {
        1 => 'This Surah is named Al-Fatihah because of its subject-matter. Fatihah is that which opens a subject or a book or any other thing. In other words, Al-Fatihah is a sort of preface.',
        2 => 'Al-Baqarah (the Cow) has been so named from the story of the Cow occurring in this Surah (vv. 67-73). It has not, however, been used as a title to indicate the subject of the Surah. It will, therefore, be as wrong to translate the name Al-Baqarah into "The Cow" or "The Heifer" as to translate any English name, say Mr. Baker, Mr. Rice, Mr. Wolf etc., into their equivalents in other languages or vice versa, because this would imply that the Surah dealt with the subject of "The Cow". Many more Surahs of the Quran have been named in the same way because no comprehensive words exist in Arabic (in spite of its richness) to denote the wide scope of the subject discussed in them. As a matter of fact all human languages suffer from the same limitation.',
        3 =>'This Surah takes its name from v.33. Al-i-Imran, like the names of many other surahs, is merely a name to distinguish it from other surahs and does not imply that the family of Imran has been discussed in it.',
        4 =>'This Surah comprises several discourses which were revealed on different occasions during the period ranging probably between the end of A.H. 3 and the end of A.H. 4 or the beginning of A.H. 5. Although it is difficult to determine the exact dates of their revelations, yet it is possible to assign to them a fairly correct period with the help of the Commandments and the events mentioned therein and the Traditions concerning them.',
        5 =>"This Surah takes its' name from verse 112 in which the word mai'dah occurs. Like the names of many other surahs, this name has no special relation to the subject of the Surah but has been used merely as a symbol to distinguish it from other surahs.",
        6 =>"This Surah takes its name from vv. 136, 138 and 139 in which some superstitious beliefs of the idolatrous Arabs concerning the lawfulness of some cattle (an`am) and the unlawfulness of some others have been refuted.",
        7 =>"This Surah takes its name from vv. 46-47 in which mention of A'araf occurs.",
        8 =>"The Surah takes its name Al-Anfal (The Bounties) from the first verse.",
        9 =>"This Surah is known by two names -- At-Taubah and Al-Bara'at. It is called At-Taubah because it enunciates the nature of taubah (repentance) and mentions the conditions of its acceptance.(vv. 102. 118). The second name Bara'at (Release) is taken from the first word of the Surah.",
        10 =>"The Surah takes its name from V. 98, in which there is a reference to Prophet Yunus (Jonah). The name, as usual, is symbolical and does not indicate that the Surah deals with the story of Prophet Jonah.",
        11 =>"This Surah has been named after Prophet Hud whose story has been related in vv. 50-60.",
        12 =>"The subject matter of this Surah indicates that it was revealed during the last stage of the Holy Prophet's residence at Makkah, when the Quraish were considering the question of killing or exiling or imprisoning him. At that time some of the unbelievers put this question (probably at the instigation of the Jews) to test him :'Why did the Israelites go to Egypt?'' This question was asked because they knew that their story was not known to the Arabs for there was no mention of it whatever in their traditions and the Holy Prophet had never even referred to it before.",
        13 =>"This Surah takes its name from the word (ar-Ra'ad) (thunder) that occurs in v. 13. It is merely the symbolic name of the Surah and does not in any way mean that the Surah deals with the scientific problems connected with thunder.",
        14 =>"The Surah takes its name from v. 35 in which mention has been made of Prophet Ibrahim (Abraham). But it does not mean that it contains the life story of Prophet Abraham. The name is merely a symbol lid the names of many other surahs, i.e., the Surah in which Abraham's mention has been made.",
        15 =>"This Surah takes its name from v. 80.",
        16 =>"The name, An-Nahl, of this Surah has been taken from v. 68. This is merely to distinguish it from other Surahs.",
        17 =>"This Surah takes its name (Bani Israil) from v. 4. But this name is merely a distinctive appellation like the names of many other surahs and not a descriptive title, and does not mean that 'Bani Isra'il' is the theme of this Surah.",
        18 =>"This Surah takes its name from v. 9 in which the word (al-kahf) occurs.",
        19 =>"It takes its name from v. 16.",
        20 =>"This Surah takes its name from its 'first word 'Ta Ha.' This name, like the names of many other Surahs, is merely symbolic.",
        21 =>"The name of this Surah has not been taken from any verse but it has been called Al-Anbiyaa because it contains a continuous account of many Anbiyaa (Prophets). Nevertheless, it is a symbolic name and not a title.",
        22 =>"This Surah takes its name from v. 27.",
        23 =>"The surah takes its name, Al-Mu'minun, from the first verse.",
        24 =>"This Surah takes its name, An Nur, from verse 35.",
        25 =>"The Surah takes its name 'Al-Furqan' from the first verse. Though it is symbolic like the names of many other Surahs, it has a close relation to its subject matter.",
        26 =>"The Surah takes its name from verse 224 in which the word Ash-Shu`araa' occurs.",
        27 =>"The Surah takes its name from the phrase wad-in-naml which occurs in verse 18, implying that it is a Surah in which the story of An-Naml (the Ant) has been related.",
        28 =>"The Surah takes its name from verse 25 in which the word Al-Qasas occurs. Lexically, qasas means to relate events in their proper sequence. Thus, from the viewpoint of the meaning too, this word can be a suitable title for this Surah, for in it the detailed story of the Prophet Moses has been related.",
        29 =>"The Surah takes its name from verse 41 in which the word Ankabut (Spider) has occurred.",
        30 =>"The Surah takes its name Ar-Rum from the second verse in which the words ghulibat-ir-Rum have occurred.",
        31 =>"The Surah has been named Luqman after Luqman the Sage, whose admonitions to his son have been related in vv. 12-19 of this Surah.",
        32 =>"The Surah has been entitled As-Sajdah after the theme of Sajdah (prostration) as expressed in verse 15.",
        33 =>"The Surah derives its name Al-Ahzab from verse 20.",
        34 =>"The Surah takes its name from verse 15 in which the word Saba has occurred, which implies that it is the Surah in which mention has been made of Saba (i. e. the Sabaeans).",
        35 =>"The word Fatir of the first very verse is the title given to this Surah, which simply means that it is a Surah in which the word Fatir has occurred. The other name is Al Malaika, which also occurs in the first verse.",
        36 =>"The Surah takes its name from the two letters of the alphabet with which it begins. It is written in English as Yasin, Ya-sin or Yaseen.",
        37 =>"The name is derived from the word was saaffat with which the Surah begins.",
        38 =>"The Surah takes its name from the alphabetic letter Suad with which it begins.",
        39 =>"The Surah derives its name from verse 71 and 73 in which the word zumar has occurred.",
        40 =>"The Surah takes its name Al Mu'min from verse 28, implying thereby, that it is a Surah in which Al Mu'min (the Believer of Pharaoh's people) has been mentioned.",
        41 =>"The name of this Surah is composed of two words, Ha-Mim and As-Sajdah, which implies that it is a Surah which begins with Ha-Mim and in which a verse requiring the performance of sajdah (prostration) has occurred.",
        42 =>"It is derived frog the sentence, wa amru-hum shura baina hum, of verse 38, implying thereby that it is a Surah in which the word shura has occurred.",
        43 =>"It is derived from the word zukhruf-an which occurs in verse 33 of this Surah.",
        44 =>"The Surah takes its name from the word dukhan which occurs in verse 10.",
        45 =>"It is derived from the sentence wa tartt kullu ummat- in jathiyat-un of verse 28, implying thereby that it is the Surah in which the word jathiyah has occurred.",
        46 =>"It is derived from the sentence idh andhara qauma-hu bil Ahqaf-i of verse 21.",
        47 =>"The Surah derives its name from the sentence wa amanu bi-ma nuzzila ala Muhammad-in of verse 2, thereby implying that it is the Surah in which the holy name of Muhammad (upon wham be Allah's peace and blessings) has occurred. Besides, it has another well known name 'al-Qital' also, which is derived from the sentence wa dhukira fi-hal-qital of verse 20.",
        48 =>"It is derived from the words Inna fatah-na laka fat-han mubina of the very first verse. This is not only a name of the Surah but also its title in view of the subject matter, for it deals with the great victory that Allah granted to the Holy Prophet and the Muslims in the form of the Truce of Hudaibiyah.",
        49 =>"The Surah takes its name from verse 4 in which the word hujurat has occurred.",
        50 =>"The Surah derives its name from the initial letter Qaf, thereby implying that it is the Surah which opens with the alphabetic letter Qaf.",
        51 =>"It is derived from the very first word wadh-dhariyat, which implies that it is a Surah which begins with the word adh-dhariyat.",
        52 =>"It is derived from the very first cord 'Wat Tur-i.'",
        53 =>"The Surah derives its name from the very first word wan Najm. This title also does not relate to the subject matter, but is a name given to the Surah as a symbol.",
        54 =>"The Surah takes its name from the very first verse Wan shaqq al-Qamar, thereby implying that it is a Surah in which the word al-Qamar has occurred.",
        55 =>"This Surah is entitled Ar Rahman, the word with which it begins. This title, however, deeply relates to the subject matter of the Surah too, for in it, from the beginning to the end, the manifestations and fruits of Allah's attribute of mercy and grace have been mentioned.",
        56 =>"The Surah takes its name from the word al-waqi`ah of the very first verse.",
        57 =>"The Surah takes its title from the sentence, Wa anzalna' l-hadida, of verse 25.",
        58 =>"This Surah is entitled Al Mujadalah as well as Al Mujadilah, the title being derived from the word tujadiluka of the very first verse. As at the outset mention has been made of the woman who pleaded with the Holy Prophet (upon whom be Allah's peace) the case of zihar pronounced by her husband and urged him to suggest a way out of the difficult situation in order to save her and, her children's life from ruin, and Allah has described her pleading by the word 'mujadalah', the Surah came to be known by this very title. If it is read as 'mujadalah', it would mean 'pleading and arguing', and if it is read as 'mujadilah', it would mean 'the woman who pleaded and argued.'",
        59 =>"The Surah derives its name from the mention of the word al-hashr in verse thereby implying that it is the Surah in which the word al-hashr has occurred.",
        60 =>"In verse 10 of this Surah it has been enjoined that the women who emigrate to dar al-Islam (the Islamic State) and claim to be Muslims, should be examined hence the title Al-Mumtahinah. The word is pronounced both as mumtahinah and as mumtahanah, the meaning according to the first pronunciation being 'the Surah which examines', and according to the second, 'the woman who is examined.'",
        61 =>"The Surah derives its name from the sentence yuqatiluna fi sabil-i- hlsaff-an of verse 4; thereby implying that it is a Surah in which the word saff occurred.",
        62 =>"It is derived from the sentence idha nudiya-lis-salat-imin-yaum-il- Jumu'ati of verse 9. Although in this Surah injunctions about the Friday congregational Prayer also have been given, yet 'Jumu'ah' is not the title of its subject-matter as a whole, but this name too, like the names of other Surahs, is only a symbolic title.",
        63 =>"The Surah takes its name from the sentence Idha jaa kal-munafiquna of verse 1. This is the name of the Surah as well as the title of its subject matter, for in it a review has been made of the conduct and attitude of the hypocrites themselves.",
        64 =>"The Surah takes its name from the sentence Dhalika yaum-ut taghabun of verse 9, thereby implying that it is the Surah in which the word at taghabun has occurred.",
        65 =>"At-Talaq is not only the name of this Surah but also the title of its subject matter, for it contains commandments about Talaq (divorce) itself. Hadrat `Abdullah bin Mas`ud has described it as Surah an-Nisa al-qusra also, i.e. the shorter Surah an-Nisa.",
        66 =>"The Surah derived its name from the words lima tuharrimu of the very first verse. This too is not a title of its subject matter, but the name implies that it is the Surah in which the incident of tahrim (prohibition, forbiddance) has been mentioned.",
        67 =>"The Surah takes its name al-Mulk from the very first sentence.",
        68 =>"This Surah is called Nun as well as Al-Qalam, the words with which it begins.",
        69 =>"The Surah takes its name from the word al-Haaqqah with which it opens.",
        70 =>"The Surah takes its name from the word dhil Ma'arij in verse 3.",
        71 =>"'Nuh' is the name of this Surah as well as the title of its subject matter, for in it, from beginning to the end, the story of the Prophet Noah has been related.",
        72 =>"'Al-Jinn' is the name of this Surah as well as the title of its subject matter, for in it the event of the Jinn's hearing the Qur'an and returning to their people to preach Islam to them, has been related in detail.",
        73 =>"The Surah has been so designated after the word al-muzzammil occurring in the very first verse. This is only a name and not a title of its subject matter.",
        74 =>"The Surah takes its name from the word al-muddaththir in the first verse. This also is only a name, not a title of its subject matter.",
        75 =>"The Surah has been so named after the word al-Qiyamah in the first verse. This is not only the name but also the title of this Surah, for it is devoted to Resurrection itself.",
        76 =>"This Surah is called Ad-Dahr as well as Al-Insan after the words occurring in the first verse.",
        77 =>"The Surah takes its name from the word wal-mursalat in the first verse.",
        78 =>"The Surah derived its name from the word an-Naba in the second verse. This is not only a name but also a title of its subject matter, for Naba implies the news of Resurrection and Hereafter and the whole Surah is devoted to the same theme.",
        79 =>"It is derived from the word wan-nazi`at with which the Surah opens.",
        80 =>"The Surah is so designated after the word `abasa with which it opens.",
        81 =>"It is derived from the word kuwwirat in the first verse. Kuwwirat is passive voice from takvir in the past tense, and means 'that which is folded up', thereby implying that it is a Surah in which the 'folding up' has been mentioned.",
        82 =>"It is derived from the word infatarat in the first verse. Infitar is an infinitive which means to cleave or split asunder, thereby implying that it is the Surah in which the splitting asunder of the sky has been mentioned.",
        83 =>"It is derived from the very first verse; Wayl-ul-lil mutaffifin.",
        84 =>"It is derived from the word inshaqqat in the first verse. Inshaqqat is infinitive which means to split asunder, thereby implying that it is the Surah in which mention has been made of the splitting asunder of the heavens.",
        85 =>"The Surah is so designated after the word al buruj appearing in the first verse.",
        86 =>"The Surah taken its name from the word at-tariq in its first verse.",
        87 =>"The Surah takes its name from the word al-A`la in the very first verse.",
        88 =>"The Surah takes its name from the word al-ghishiyah in the first verse.",
        89 =>"The Surah is so designated after the word wal-fajr with which it opens.",
        90 =>"The Surah has been so named after the word al balad in the first verse.",
        91 =>"The Surah has been so designated after the word ash-shams with which it opens.",
        92 =>"The Surah takes its name from the word wal-lail with which it opens.",
        93 =>"The Surah takes its name Ad-Duha from the very first word.",
        94 =>"The Surah is so designated after the first sentence.",
        95 =>"The Surah has been so named after the very first word at-tin.",
        96 =>"The Surah is so entitled after the word `alaq in the second verse.",
        97 =>"The Surah has been so designated after the word al-qadr in the very first verse.",
        98 =>"The Surah is so designated after the word al-bayyinah occurring at the end of the first verse.",
        99 =>"It is derived from the word zilzal in the first verse.",
        100 =>"The Surah has been so entitled after the word al `adiyat with which it opens.",
        101 =>"The Surah takes its name from its first word al-qari`ah. This is not only a name but also the title of its subject matter, for the Surah is devoted to Resurrection.",
        102 =>"The Surah taken its name from the word at takathur in the first verse.",
        103 =>"The Surah takes its name from the word al-`asr occurring in the first verse.",
        104 =>"The Surah takes its name from the word humazah occurring in the first verse.",
        105 =>"The Surah derives its name from the word ashab al fil in the very first verse.",
        106 =>"The Surah has been so entitled after the word Quraish in the very first verse.",
        107 =>"The Surah has been so designated after the word al-ma`un occurring at the end of the last verse.",
        108 =>"The Surah has been so designated after the word al-kauthar occurring in the first verse.",
        109 =>"The Surah takes its name from the word al-kafirun occurring in the first verse.",
        110 =>"The Surah takes its name from the word nasr occurring in the first verse.",
        111 =>"The Surah takes its name from the word Lahab in the first verse.",
        112 =>"Al-Ikhlas is not merely the name of this Surah but also the title of its contents, for it deals exclusively with Tauhid. The other Surahs of the Quran generally have been designated after a word occurring in them, but in this Surah the word Ikhlas has occurred nowhere. It has been given this name in view of its meaning and subject matter. Whoever understands it and believes in its teaching, will get rid of shirk (polytheism) completely.",
        113 =>"Although these two Surahs of the Qur'an are separate entities and are written in the Mushaf also under separate names, yet they are so deeply related mutually and their contents so closely resemble each other's that they have been designated by a common name Mu'awwidhatayn (the two Surahs in which refuge with Allah has been sought). Imam Baihaqi in Dala'il an-Nubuwwat has written that these Surahs were revealed together, that is why the combined name of both is Mu'awwidhatayn. We are writing the same one Introduction to both, for they discuss and deal with just the same matters and topics. However, they will be explained and commented on separately below.",
        114 =>"Although these two Surahs of the Qur'an are separate entities and are written in the Mushaf also under separate names, yet they are so deeply related mutually and their contents so closely resemble each other's that they have been designated by a common name Mu'awwidhatayn (the two Surahs in which refuge with Allah has been sought). Imam Baihaqi in Dala'il an-Nubuwwat has written that these Surahs were revealed together, that is why the combined name of both is Mu'awwidhatayn. We are writing the same one Introduction to both, for they discuss and deal with just the same matters and topics. However, they will be explained and commented on separately below."
    }[sura_number]
  end
end

