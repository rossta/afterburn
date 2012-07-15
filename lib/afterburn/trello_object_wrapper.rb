require "trello"
require 'redis/objects'

module Afterburn
  class TrelloObjectWrapper
    extend Helpers
    extend Persistence
    include Helpers
    include Persistence

    def self.inherited(base)
      base.send :include, Redis::Objects
      base.value :trello_object_store, :marshal => true
    end

    attr_reader :id

    def self.wrap(wrapper_name)
      @wrapper_name = wrapper_name
      alias_method "trello_#{wrapper_name}", :trello_object
    end

    def self.find(id)
      new(id).load
    end

    def self.fetch(id)
      new(id).fetch
    end

    def self.wrapper_class
      constantize("Trello::#{titleize(wrapper_name.to_s)}")
    end

    def self.wrapper_name
      raise "wrapper_name not defined for #{self}" unless @wrapper_name
      @wrapper_name
    end

    def initialize(trello_id = nil)
      @id = trello_id
    end

    def wrapper_name
      self.class.wrapper_name
    end

    def load
      trello_object
      self
    end

    def fetch
      self.class.wrapper_class.find(id).tap do |fetched_object|
        self.trello_object = fetched_object
      end
      self
    end

    def trello_object=(object)
      trello_object_store.value = object
    end

    def trello_object
      fetch if trello_object_store.value.nil?
      trello_object_store.value
    end
    alias_method :fetch_trello_object, :trello_object

    def redis_key(*values)
      (["#{wrapper_name}:#{id}"] + values).join(":")
    end

  end
end