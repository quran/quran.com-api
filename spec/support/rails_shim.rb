# frozen_string_literal: true

#
# Monkey patch for cast_type which is removed from rails 5
# Source: https://github.com/adammcfadden/shoulda-matchers/commit/9af2999ed0adf524abb845ee95d86afcb37af6e0
#
module Shoulda
  module Matchers
    class RailsShim
      def self.serialized_attributes_for(model)
        if defined?(::ActiveRecord::Type::Serialized)
          # Rails 5+
          model.columns.select do |column|
            model.type_for_attribute(column.name).is_a?(::ActiveRecord::Type::Serialized)
          end.inject({}) do |hash, column|
            hash[column.name.to_s] = model.type_for_attribute(column.name).coder.object_class
            hash
          end
        else
          model.serialized_attributes
        end
      end
    end
  end
end
