# vim: ts=4 sw=4 expandtab
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    settings YAML.load(
        File.read(
            File.expand_path(
                "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__
            )
        )
    )

    # Initial the paging gem, Kaminari
    Kaminari::Hooks.init
    Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari
  end
end
