require "statable/version"
require "statable/version"

module Statable

  module ClassMethods
    def statable(attr, callbacks)

      include Redis::Objects unless self.include?(Redis::Objects)

      # setup redis-object attribute
      # TODO: add support for different types
      self.send :value, attr
      #p self.counter(attr)

      # wire callbacks
      callbacks.each do |key, callback|
        self.send key, -> do
          result = callback.call
        end
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
