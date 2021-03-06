require "trello"
require 'redis/objects'

module Afterburn
  class TrelloObjectWrapper
    extend Helpers
    include Helpers

    def self.inherited(base)
      base.send :include, RedisObjects
      base.value :trello_object_store, :marshal => true
    end

    attr_reader :id

    def self.wrap(wrapper_name)
      @wrapper_name = wrapper_name
      alias_method "trello_#{wrapper_name}", :trello_object
    end

    def self.find(id)
      return nil if id.nil?
      new(id).load
    end

    def self.fetch(id)
      return nil if id.nil?
      new(id).fetch
    end

    def self.initialize_from_trello_object(trello_object)
      new { |board| board.trello_object = trello_object }
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
      yield self if block_given?
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
      return nil if object.nil?
      @id = object.id
      trello_object_store.value = object
    end

    def trello_object
      return nil if id.nil?
      fetch if trello_object_store.value.nil?
      trello_object_store.value
    end

    def redis_key(*values)
      (["#{wrapper_name}:#{id}"] + values).join(":")
    end

  end
end
