# frozen_string_literal: true
require 'delegate'

module Zoom
  class Params < SimpleDelegator
    def initialize(parameters = {})
      @parameters = parameters
      super
    end

    def require(*entries)
      missing_entries = find_missing_entries(entries)
      return filter_required(entries.flatten) if missing_entries.empty?
      raise Zoom::ParameterMissing, missing_entries.to_s
    end

    def require_one_of(*keys)
      required_keys = keys
      keys = find_matching_keys(keys.flatten)
      unless keys.any?
        message = required_keys.length > 1 ? "You are missing atleast one of #{required_keys}" : required_keys
        raise Zoom::ParameterMissing, message
      end
    end

    def permit(*filters)
      permitted_keys = filters.flatten.each.with_object([]) do |filter, array|
                         case filter
                         when Symbol, String
                           array << filter
                         when Hash
                           array << hash_filter(filter)
                         end
                       end
      non_permitted_params = parameters_keys - permitted_keys.flatten
      raise Zoom::ParameterNotPermitted, non_permitted_params.to_s unless non_permitted_params.empty?
    end

    def except(*keys)
      dup.except!(keys.flatten)
    end

    def except!(keys)
      keys.each { |key| delete(key) }
      self
    end

    EMPTY_ARRAY = [].freeze
    EMPTY_HASH  = {}.freeze

    def hash_filter(filter)
      # Slicing filters out non-declared keys.
      slice(*filter.keys).each do |key, value|
        next unless value
        next unless key? key
        next if filter[key] == EMPTY_ARRAY
        next if filter[key] == EMPTY_HASH
        # Declaration { user: :name } or { user: [:name, :age, { address: ... }] }.
        self.class.new(value).permit(filter[key])
      end
      filter.keys
    end

    def filter_required(filters)
      # Unless value is a hash, filter
      filters.each.with_object(self.class.new(except(filters.flatten))) do |filter, params|
        case filter
        when Symbol, String
          params.delete(filter)
        when Hash
          filter.each do |k, v|
            nested_filter = self.class.new(self[k]).filter_required(v)
            if nested_filter.empty?
              params.delete(k)
            else
              params[k] = nested_filter
            end
          end
        end
      end
    end

    def find_missing_entries(*entries)
      entries.flatten.each.with_object([]) do |entry, array|
        if entry.is_a?(Hash)
          entry.keys.each do |k|
            array << k && next if self[k].nil?
            missing_entries = self.class.new(self[k]).find_missing_entries(*entry[k])
            array << { k => missing_entries } unless missing_entries.empty?
          end
        elsif self[entry].nil?
          array << entry
        end
      end
    end

    def find_matching_keys(keys)
      keys.flatten.each_with_object([]) do |key, array|
        array << key if self[key]
      end
    end

    def permit_value(key, values)
      value = @parameters[key]
      unless !value || values.include?(value)
        raise Zoom::ParameterValueNotPermitted, "#{key}: #{value}"
      end
    end

    def parameters_keys
      if @parameters.kind_of?(Array)
        @parameters.map(&:keys).flatten.uniq
      else
        @parameters.keys
      end
    end
  end
end
