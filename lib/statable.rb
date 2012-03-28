require "statable/version"

module Statable

  module ClassMethods
    def statable(key, callbacks)

      # TODO setup redis-object
      # TODO wire callbacks
      callbacks.each do |key, callback|
        p self
        p key
        p callback
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
