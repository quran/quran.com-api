# vim: ts=4 sw=4 expandtab
module Searchable
  extend ActiveSupport::Concern

  included do |mod|
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mod.class_eval do
      index_name document_type # e.g. translation
      document_type 'data'     # e.g. rename from translation to just "data"
    end

    # Initial the paging gem, Kaminari
    Kaminari::Hooks.init
    Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari

    class << self
      alias_method :importing, :import
      alias_method :searching, :search

      def delete_index
        # delete all the translation-* indices if the argument was
        # just 'translation'
        if class_name.downcase == 'translation'
          begin
            __elasticsearch__.client.cat.indices(
              index: 'translation-*', h: ['index'], format: 'json'
            ).each do |d|
              if __elasticsearch__.client.indices.exists index: d['index']
                __elasticsearch__.client.indices.delete index: d['index']
              end
            end
          rescue
            Rails.logger.warn 'no translation-* indices'
          end
        else
          if __elasticsearch__.client.indices.exists index: index_name
            __elasticsearch__.client.indices.delete index: index_name
          end
        end
      end

      def import_index(options = {})
        import(options.merge(force: true))
      end

      def setup_index
        delete_index
        import_index force: true
      end
    end
  end
end
