# frozen_string_literal: true

class Hash
  def with_defaults(defaults)
    merge(defaults) { |_key, old, new| old.nil? ? new : old }
  end

  def with_defaults!(defaults)
    merge!(defaults) { |_key, old, new| old.nil? ? new : old }
  end
end
