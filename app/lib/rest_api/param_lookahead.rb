# frozen_string_literal: true

class RestApi::ParamLookahead
  attr_reader :params

  # A singleton, so that misses don't come with overhead.
  NULL_LOOKAHEAD = RestApi::NullLookahead.new

  def initialize(params)
    @params = params
  end

  def selected?
    params.present?
  end

  def selects?(attribute)
    selection(attribute).selected?
  end

  def selection(attribute)
    query = params[attribute]

    if query
      case query
      when Hash
        RestApi::ParamLookahead.new(params[attribute])
      when String
        if ActiveRecord::Type::Boolean::FALSE_VALUES.include?(query)
          NULL_LOOKAHEAD
        else
          RestApi::ParamLookahead.new(query)
        end
      when Array
        RestApi::ParamLookahead.new(query)
      end
    else
      NULL_LOOKAHEAD
    end
  end
end
