Example of the search_string stuff.
```
{
  "indices_boost": {
    "translation-ar": 3,
    "translation-en": 4,
    "translation-fi": 3,
    "translation-el": 3,
    "translation-he": 3,
    "translation-hu": 4,
    "translation-no": 4,
    "translation-pl": 4,
    "translation-es": 3,
    "translation-nl": 1,
    "translation-pt": 2,
    "translation-sv": 1,
    "translation-it": 2,
    "translation-ko": 1
  },
  "highlight": {
    "fields": {
      "text": {
        "type": "fvh",
        "matched_fields": [
          "text.root",
          "text.stem_clean",
          "text.lemma_clean",
          "text.stemmed",
          "text"
        ],
        "number_of_fragments": 0
      }
    },
    "tags_schema": "styled"
  },
  "query": {
    "query_string": {
      "query": "noah OR stick",
      "default_field": "_all",
      "fuzziness": 1,
      "fields": [
        "text^1.6",
        "text.stemmed",
        "_all"
      ],
      "minimum_should_match": "62%"
    }
  },
  "aggs": {
    "by_ayah_key": {
      "terms": {
        "field": "ayah.ayah_key",
        "size": 6236,
        "order": {
          "max_score": "desc"
        }
      },
      "aggs": {
        "max_score": {
          "max": {
            "script": "_score"
          }
        }
      }
    }
  },
  "size": 0
}
```
Version two

```
{
  "highlight": {
    "fields": {
      "text": {
        "type": "fvh",
        "matched_fields": [
          "text.root",
          "text.stem_clean",
          "text.lemma_clean",
          "text.stemmed",
          "text"
        ],
        "number_of_fragments": 0
      }
    },
    "tags_schema": "styled"
  },
  "query": {
    "query_string": {
      "query": "jesus OR heaven",
      "fuzziness": 1,
      "fields": [
        "text^1.6",
        "text.stemmed"
      ],
      "minimum_should_match": "75%"
    }
  },
  "_source": [
    "text",
    "ayah.*",
    "resource.*",
    "language.*"
  ],
  "fields": [
    "ayah.ayah_key",
    "ayah.ayah_num",
    "ayah.surah_id",
    "ayah.ayah_index",
    "text"
  ],
  "aggregations": {
    "by_ayah_key": {
      "terms": {
        "field": "ayah.ayah_key",
        "size": 6236,
        "order": {
          "average_score": "desc"
        }
      },
      "aggregations": {
        "max_score": {
          "max": {
            "script": "_score"
          }
        },
        "average_score": {
          "avg": {
            "script": "_score"
          }
        }
      }
    }
  }
}
```


Version 3
```
{
  "highlight": {
    "fields": {
      "text": {
        "type": "fvh",
        "matched_fields": [
          "text.root",
          "text.stem_clean",
          "text.lemma_clean",
          "text.stemmed",
          "text"
        ],
        "number_of_fragments": 0
      }
    },
    "tags_schema": "styled"
  },
  "query": {
    "query_string": {
      "query": "jesus OR heaven",
      "fuzziness": 1,
      "fields": [
        "text^1.6",
        "text.stemmed"
      ],
      "minimum_should_match": "75%"
    }
  },
  "_source": [
    "text",
    "ayah.*",
    "resource.*",
    "language.*"
  ],
  "fields": [
    "ayah.ayah_key",
    "ayah.ayah_num",
    "ayah.surah_id",
    "ayah.ayah_index",
    "text"
  ],
  "aggregations": {
    "by_ayah_key": {
      "terms": {
        "field": "ayah.ayah_key",
        "size": 6236,
        "order": {
          "average_score": "desc"
        }
      },
      "aggregations": {
        "resources": {
          "top_hits": {
            "highlight": {
              "fields": {
                "text": {
                  "type": "fvh",
                  "matched_fields": [
                    "text.root",
                    "text.stem_clean",
                    "text.lemma_clean",
                    "text.stemmed",
                    "text"
                  ],
                  "number_of_fragments": 0
                }
              },
              "tags_schema": "styled"
            },
            "sort": [
              {
                "_score": {
                  "order": "desc"
                }
              }
            ],
            "_source": {
              "include": [
                "text",
                "ayah.*",
                "resource.*",
                "language.*"
              ]
            },
            "size": 1
          }
        },
        "max_score": {
          "max": {
            "script": "_score"
          }
        },
        "average_score": {
          "avg": {
            "script": "_score"
          }
        }
      }
    }
  },
  "size": 0
}
```


```
{
  "query": {
    "query_string": {
      "query": "jesus OR heaven",
      "fuzziness": 1,
      "fields": [
        "text^1.6",
        "text.stemmed"
      ],
      "minimum_should_match": "75%"
    }
  },
  "aggregations": {
    "by_ayah_key": {
      "terms": {
        "field": "ayah.ayah_key",
        "size": 6236,
        "order": {
          "max_score": "desc"
        }
      },
      "aggregations": {
        "match": {
          "top_hits": {
            "highlight": {
              "fields": {
                "text": {
                  "type": "fvh",
                  "matched_fields": [
                    "text.root",
                    "text.stem_clean",
                    "text.lemma_clean",
                    "text.stemmed",
                    "text"
                  ],
                  "number_of_fragments": 0
                }
              },
              "tags_schema": "styled"
            },
            "sort": [
              {
                "_score": {
                  "order": "desc"
                }
              }
            ],
            "_source": {
              "include": [
                "text",
                "ayah.*",
                "resource.*",
                "language.*"
              ]
            },
            "size": 5
          }
        },
        "max_score": {
          "max": {
            "script": "_score"
          }
        },
        "average_score": {
          "avg": {
            "script": "_score"
          }
        }
      }
    }
  },
  "size": 0
}
```
