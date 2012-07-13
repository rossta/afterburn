module Afterburn
  module ApiWrapper
    module ClassMethods

      def wrap(wrapper_name)
        @wrapper_name = wrapper_name

        attr_reader :trello_object
        define_method("trello_#{wrapper_name}") do
          @trello_object
        end
      end

      def save(instance)
        instance.tap do
          trello_object = instance.trello_object
          redis.set("#{wrapper_name}:#{trello_object.id}", marshal_dump(trello_object))
        end
      end

      def find(id)
        if marshaled?(id)
          load(id)
        else
          fetch(id)
        end
      end

      def fetch(id)
        save(new(wrapper_class.find(id)))
      end

      def load(id)
        new(marshal_load(marshaled_trello_object(id)))
      end

      def marshaled_trello_object(id)
        redis.get("#{wrapper_name}:#{id}")
      end

      def marshaled?(id)
        redis.exists("#{wrapper_name}:#{id}")
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

      def initialize(trello_object)
        @trello_object = trello_object
      end

      def id
        @trello_object.id
      end

      def save
        self.class.save(self)
      end

      def wrapper_name
        self.class.wrapper_name
      end

      def fetch
        self.class.fetch(id)
      end
    end

    def self.included(base)
      base.extend         Helpers
      base.extend         Persistence
      base.send :include, Helpers
      base.send :include, Persistence
      base.extend         ClassMethods
      base.send :include, InstanceMethods
    end
  end
end
