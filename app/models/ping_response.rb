# frozen_string_literal: true

class PingResponse
  class << self
    def to_json
      {
        message: message,
        versions: versions
      }
    end

    def message
      'الحمد لله api is working fine. Please see the docs for each version for more help.'
    end

    def versions
      {
        v3: 'https://quran.api-docs.io/v3/getting-started/introduction',
        v4: 'https://quran.api-docs.io/v4/getting-started/introduction',
        qdc: 'https://quran.api-docs.io/qdc/getting-started/introduction',
        graphql: 'https://api.quran.com/graphql-playground'
      }
    end
  end

end
