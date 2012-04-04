require "statable/version"

module Statable

  module ClassMethods

    # type - redis object type
    # attr - attribute name
    # options - additional options
    def statable(type, attr, options = {})

      include Redis::Objects unless self.include?(Redis::Objects)

      callbacks = options[:callbacks] || {}
      scope = options[:scope] || self
      root_class = self

      # setup redis-object attribute
      self.send type, attr

      # wire callbacks
      callbacks.each do |key, callback|
        scope.send key, ->(record) {
          record = record.send root_class.name.downcase unless root_class == scope
          redis_obj = record.send attr
          value = callback.call

          # TODO: refactor to InstanceMethods
          case type
            when :counter
              if value > 0
                redis_obj.increment(value)
              else
                redis_obj.decrement(value * -1)
              end
            when :value
              redis_obj.value = value
          end
        }
      end
    end
  end

  module InstanceMethods
  end

  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
end

class ActiveRecord::Base
  include Statable
end
