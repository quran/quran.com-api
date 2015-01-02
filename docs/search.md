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

### structure of json response TODO RESUME HERE

- key
- ayah
- surah
- index
- score
- match
  - hits
  - best (list)
    - id
    - name
    - slug
    - lang
    - dir
    - text
    - score
- bucket
  - ayah
  - surah
  - quran (list)
    - ayah_key
    - word
      - id
      - arabic
      - translation
    - char
      - page
      - font
      - code_hex
      - type_id
      - type
      - code_dec
      - line
      - code
  - content (list)
    - id
    - name
    - slug
    - lang
    - dir
    - text
  - audio
    - ogg
        - url
        - duration
        - mime_type
    - mp3
        - url
        - duration
        - mime_type

## elasticsearch setup and initial import

## elasticsearch update import

