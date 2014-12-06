class AddEsAnalyzerColumnToLanguageTable < ActiveRecord::Migration
    def change
        change_table :language do |t|
            t.string :es_analyzer_default
            reversible do |r|
                hashmap = {
                    Arabic:      'arabic',
                    Armenian:    'armenian',
                    Basque:      'basque',
                    Brazilian:   'brazilian',
                    Bulgarian:   'bulgarian',
                    Catalan:     'catalan',
                    Chinese:     'chinese',
                    Czech:       'czech',
                    Danish:      'danish',
                    Dutch:       'dutch',
                    English:     'english',
                    Finnish:     'finnish',
                    French:      'french',
                    Galician:    'galician',
                    German:      'german',
                    Greek:       'greek',
                    Hindi:       'hindi',
                    Hungarian:   'hungarian',
                    Indonesian:  'indonesian',
                    Irish:       'irish',
                    Italian:     'italian',
                    Japanese:    'cjk',
                    Korean:      'cjk',
                    Kurdish:     'sorani',
                    Latvian:     'latvian',
                    Norwegian:   'norwegian',
                    Persian:     'persian',
                    Portuguese:  'portuguese',
                    Romanian:    'romanian',
                    Russian:     'russian',
                    Spanish:     'spanish',
                    Swedish:     'swedish',
                    Turkish:     'turkish',
                    Thai:        'thai'
                }

                r.up do
                    hashmap.each do |english, es_analyzer_default|
                        language = Locale::Language.where( 'english ~* :english', { english: english } )
                        language.update_all( es_analyzer_default: es_analyzer_default ) if language
                    end
                end

                r.down do
                    hashmap.each do |english, es_analyzer_default|
                        language = Locale::Language.where( 'english ~* :english', { english: english } )
                        language.update_all( es_analyzer_default: nil ) if language
                    end
                end
            end
        end
    end
end
