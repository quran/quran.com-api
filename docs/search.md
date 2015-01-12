# search
## ui/ux vision

results are presented as a series of hits, and each hit is an ayah. in context of the ayah, we want to break it down into 3 different layers to contextually constitute what users are interested in:
1. reading context: what they normally prefer to read (i.e. their selected content)
2. match context: why/where/how there query matched, i.e. content that matched with match terms highlighted that is otherwise outside of the scope of what is already presented in the reading context
3. similarity context: what ayahs are similar to that ayah in meaning/concept i.e. navigation

```
:-------------------------------------------------:
: :---------------------------------------------: : | always expanded
: : reading context                             : : | see note 1
: : :-----------------------------------------: : :
: : : quran word for word font                : : :
: : :-----------------------------------------: : :
: : :-----------------------------------------: : :
: : : selected translations                   : : :
: : :-----------------------------------------: : :
: :---------------------------------------------: :
: :---------------------------------------------: : | click to expand down
: : match context                               : : | see note 2 and 3
: :---------------------------------------------: : |
: :---------------------------------------------: : | click to expand down
: : similar ayahs                               : : | see note 2, 4 and 5
: :---------------------------------------------: : |
:-------------------------------------------------:
```

- note 1: if a user has particular content selected and that content also had matches, then the highlighted text is presented instead of the normal text. if that content did not match, we still present it as it would normally render if they were just reading in the traditional view
- note 2: match context and similar ayahs are collapsed by default. analogous to recent google "material design" interfaces, i.e. think of how threads and messages in threads are nested and presented as collapsed but expandable layers in inbox.google.com
- note 3: resembles selected translations, main difference being that the matching text is highlighted in bold
- note 4: could be as simple as an unordered list of links, i.e. /1/2, /2/3, ..., or more creative ux or an interactive visualization
- note 5: not yet implemented, just a future vision to account for in today's design

## request parameters and structure of json response

### request parameters

- q: the query text
- p: the page number
- s: the size of each page, i.e. results per page
- any option used with the bucket/ayat controller to control what items are returned in the context of each ayah, e.g. 'content' and 'audio' are valid options. so if the user has content items 18 and 19 selected, content should be appended to the query string as 'content=18,19' as it normally is on the bucket controller

### structure of json response

```
[
  {
    "key": "24:35",
    "index": 2826,
    "surah": 24,
    "ayah": 35,
    "score": 116.64196,
    "match": {
      "hits": 6,
      "best": [
        {
          "id": 20,
          "name": "Shakir",
          "slug": "shakir",
          "lang": "en",
          "dir": "ltr",
          "text": "<em class=\"hlt3\">Allah</em> is the <em class=\"hlt4\">light</em> of the heavens and the earth; a likeness of His <em class=\"hlt4\">light</em> is as a niche in which is a lamp, the lamp is in a glass, (and) the glass is as it were a brightly shining star, lit from a blessed olive-tree, neither eastern nor western, the oil whereof almost gives <em class=\"hlt4\">light</em> though fire touch it not-- <em class=\"hlt4\">light</em> upon <em class=\"hlt4\">light</em>-- <em class=\"hlt3\">Allah</em> guides to His <em class=\"hlt4\">light</em> whom He pleases, and <em class=\"hlt3\">Allah</em> sets forth parables for men, and <em class=\"hlt3\">Allah</em> is Cognizant of all things.",
          "score": 116.64196
        },
        { ... },
        ...
      ]
    },
    "bucket": {
      "quran": [
        {
          "char": {
            "page": 354,
            "font": "p354",
            "code_hex": "fba8",
            "type_id": 4,
            "type": "rub-el-hizb",
            "code_dec": 64424,
            "line": 9,
            "code": "&#xfba8;"
          }
        },
        {
          "word": {
            "id": 45531,
            "arabic": "اللَّهُ",
            "translation": "Allah"
          },
          "char": {
            "page": 354,
            "font": "p354",
            "code_hex": "fba9",
            "type_id": 1,
            "type": "word",
            "code_dec": 64425,
            "line": 9,
            "code": "&#xfba9;"
          }
        },
        ...,
        {
          "char": {
            "page": 354,
            "font": "p354",
            "code_hex": "fc01",
            "type_id": 2,
            "type": "end",
            "code_dec": 64513,
            "line": 14,
            "code": "&#xfc01;"
          }
        }
      ],
      "content": [
        {
          "id": 17,
          "name": "Muhsin Khan",
          "slug": "muhsin_khan",
          "lang": "en",
          "dir": "ltr",
          "text": "<em class=\"hlt3\">Allah</em> is the <em class=\"hlt4\">Light</em> of the heavens and the earth. The parable of His <em class=\"hlt4\">Light</em> is as (if there were) a niche and within it a lamp, the lamp is in glass, the glass as it were a brilliant star, lit from a blessed tree, an olive, neither of the east (i.e. neither it gets sun-rays only in the morning) nor of the west (i.e. nor it gets sun-rays only in the afternoon, but it is exposed to the sun all day long), whose oil would almost glow forth (of itself), though no fire touched it. <em class=\"hlt4\">Light</em> upon <em class=\"hlt4\">Light</em>! <em class=\"hlt3\">Allah</em> guides to His <em class=\"hlt4\">Light</em> whom He wills. And <em class=\"hlt3\">Allah</em> sets forth parables for mankind, and <em class=\"hlt3\">Allah</em> is All-Knower of everything."
        },
        {
          "id": 18,
          "name": "Pickthall",
          "slug": "pickthall",
          "lang": "en",
          "dir": "ltr",
          "text": "<em class=\"hlt3\">Allah</em> is the <em class=\"hlt4\">Light</em> of the heavens and the earth. The similitude of His <em class=\"hlt4\">light</em> is as a niche wherein is a lamp. The lamp is in a glass. The glass is as it were a shining star. (This lamp is) kindled from a blessed tree, an olive neither of the East nor of the West, whose oil would almost glow forth (of itself) though no fire touched it. <em class=\"hlt4\">Light</em> upon <em class=\"hlt4\">light</em>. <em class=\"hlt3\">Allah</em> guideth unto His <em class=\"hlt4\">light</em> whom He will. And <em class=\"hlt3\">Allah</em> speaketh to mankind in allegories, for <em class=\"hlt3\">Allah</em> is Knower of all things."
        }
      ],
      "audio": {
        "ogg": {
          "url": "htt    }
  }p://audio.quran.com:9999/AbdulBaset/Mujawwad/ogg/024035.ogg",
          "duration": 174.956,
          "mime_type": "audio/ogg"
        },
        "mp3": {
          "url": "http://audio.quran.com:9999/AbdulBaset/Mujawwad/mp3/024035.mp3",
          "duration": 174.99,
          "mime_type": "audio/mpeg"
        }
      }
    }
  },
  { ... },
  ...
]
```

## elasticsearch setup and initial import
## elasticsearch update import

