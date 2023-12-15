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
      filtered = filter_required(entries.flatten)
      if missing_entries.empty?
        filtered
      else
        raise Zoom::ParameterMissing, missing_entries.to_s
      end
    end

    def require_one_of(*keys)
      required_keys = keys
      keys = find_matching_keys(keys.flatten)
      unless keys.any?
        message = required_keys.length > 1 ? "You are missing at least one of #{required_keys}" : required_keys
        raise Zoom::ParameterMissing, message
      end
    end

    def permit(*filters)
      permitted_keys = filters.flatten
    
      # Include required parameters as permitted
      required_params = @parameters.keys - permitted_keys
      permitted_keys.concat(required_params)
    
      non_permitted_params = parameters_keys - permitted_keys
      
      raise Zoom::ParameterNotPermitted, non_permitted_params.to_s unless non_permitted_params.empty?
      self
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
      result = slice(*filter.keys).each do |key, value|
        next unless value
        next unless key? key
        next if filter[key] == EMPTY_ARRAY
        next if filter[key] == EMPTY_HASH
        self.class.new(value).permit(filter[key])
      end
      result.keys
    end

    def filter_required(filters)    
      # Only process filters that are hashes (for nested parameters)
      filters.select { |filter| filter.is_a?(Hash) }.each do |filter|    
        filter.each do |key, nested_filters|
          if self[key].is_a?(Hash)
            nested_params = self.class.new(self[key])
            self[key] = nested_params.filter_required(nested_filters)
          end
        end
      end
      self
    end
    

    def find_missing_entries(*entries)
      entries.flatten.each.with_object([]) do |entry, array|
        if entry.is_a?(Hash)
          entry.keys.each do |k|
            if self[k].nil?
              array << k
              next
            end
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
