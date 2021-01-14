# frozen_string_literal: true

module QuranUtils
  module StrongMemoize
    # Instead of writing patterns like this:
    #
    #     def load_translations
    #       return @translations if defined?(@translations)
    #
    #       @translations = Translation.first(3)
    #     end
    #
    # We could write it like:
    #
    #     include QuranUtils::StrongMemoize
    #
    #     def load_translations
    #       strong_memoize(:load_translations) do
    #         Translation.first(3)
    #       end
    #     end
    #
    def strong_memoize(name)
      if strong_memoized?(name)
        instance_variable_get(ivar(name))
      else
        instance_variable_set(ivar(name), yield)
      end
    end

    def strong_cache_memoize(name)
      Rails.cache.fetch(cache_key(name), expires_in: cache_expiry_period, force: cache_expiry_period.blank?) do
        yield
      end
    end

    def strong_memoized?(name)
      instance_variable_defined?(ivar(name))
    end

    def clear_memoization(name)
      remove_instance_variable(ivar(name)) if instance_variable_defined?(ivar(name))
    end

    def cache_expiry_period
      6.hours
    end

    private

    def cache_key(name)
      "#{self.class.name}_#{name}".parameterize.underscore
    end

    def ivar(name)
      "@#{name}"
    end
  end
end
