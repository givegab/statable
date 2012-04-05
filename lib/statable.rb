require "statable/version"

module Statable

  module ClassMethods

    # attr - attribute name
    # options - additional options
    def statable(attr, options = {})

      include Redis::Objects unless self.include?(Redis::Objects)

      callbacks = options[:callbacks] || {}
      scope = options[:scope] || self
      type = options[:type] || :counter
      conditions = options[:conditions] || {}

      root_class = self

      # setup redis-object attribute
      self.send type, attr

      # wire callbacks
      callbacks.each do |key, callback|
        scope.send key, lambda { |record|
          if root_class.evaluate_conditions(record, conditions)

            record = record.send root_class.name.downcase unless root_class == scope
            redis_obj = record.send attr
            value = callback.is_a?(Proc) ? callback.call : callback

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
          end

        }
      end
    end

    def evaluate_conditions(record, conditions)
      conditions.all? { |c| record.send(c[0]) == c[1] }
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
