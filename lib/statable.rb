require "statable/version"

module Statable

  module ClassMethods

    # attr - attribute name
    # options - additional options
    def statable(attr, options = {})
      include Redis::Objects unless self.include?(Redis::Objects)

      # set defaults
      callbacks = options[:callbacks] || {}
      scope = options[:scope] || self
      type = options[:type] || :counter
      conditions = options[:conditions] || {}
      root_class = self

      # setup redis-object attribute
      self.send type, attr

      # process callbacks
      callbacks.each do |callback_name, callback|
        method = "#{callback_name}_#{attr}".to_sym

        # stop if method already belongs to scope
        return if scope.instance_methods(false).include?(method)

        # create callback method
        scope.send :define_method, method do
          if root_class.evaluate_conditions(self, conditions)

            record = root_class == scope ? self : self.send(root_class.name.downcase)
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
        end

        # wire callback name with callback method
        scope.send callback_name, method
      end
    end

    def evaluate_conditions(record, conditions)
      return conditions.all? { |c| record.send(c[0]) == c[1] }
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
