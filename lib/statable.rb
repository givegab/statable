require "statable/version"

module Statable

  module ClassMethods

    # type - redis object type
    # attr - attribute name
    # callbacks - active record callbacks
    def statable(type, attr, callbacks = {})

      include Redis::Objects unless self.include?(Redis::Objects)

      # setup redis-object attribute
      self.send type, attr

      # wire callbacks
      callbacks.each do |key, callback|
        self.send key, ->(record) {
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
