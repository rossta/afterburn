module Afterburn
  module ApiWrapper
    module ClassMethods

      def wrap(wrapper_name)
        @wrapper_name = wrapper_name

        value :trello_object, :marshal => true

        define_method("trello_#{wrapper_name}") do
          trello_object.value
        end
      end

      def find(id)
        new(id).load
      end

      def fetch(id)
        new(id).fetch
      end

      def wrapper_class
        constantize("Trello::#{titleize(wrapper_name.to_s)}")
      end

      def wrapper_name
        raise "wrapper_name not defined for #{self}" unless @wrapper_name
        @wrapper_name
      end
    end

    module InstanceMethods

      attr_reader :id

      def initialize(trello_id = nil)
        @id = trello_id
      end

      def wrapper_name
        self.class.wrapper_name
      end

      def load
        fetch if trello_object.value.nil?
        self
      end

      def fetch
        self.class.wrapper_class.find(id).tap do |fetched_object|
          trello_object.value = fetched_object
        end
        self
      end

      def redis_key(*values)
        (["#{wrapper_name}:#{id}"] + values).join(":")
      end
    end

    def self.included(base)
      base.send :include, Redis::Objects

      base.extend         Helpers
      base.extend         Persistence
      base.send :include, Helpers
      base.send :include, Persistence

      base.extend         ClassMethods
      base.send :include, InstanceMethods
    end
  end
end
