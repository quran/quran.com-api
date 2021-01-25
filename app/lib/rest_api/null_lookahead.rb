# frozen_string_literal: true

class RestApi::NullLookahead < RestApi::ParamLookahead
  # No inputs required here.
  def initialize
  end

  def selected?
    false
  end

  def selects?(*)
    false
  end

  def selection(*)
    NULL_LOOKAHEAD
  end

  def selections(*)
    []
  end

  def inspect
    '#<RestApi::NullLookahead>'
  end
end
