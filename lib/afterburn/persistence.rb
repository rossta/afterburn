module Afterburn
  module Persistence
    include Marshal

    def redis
      Afterburn.redis
    end

    def marshal_dump(value)
      case value
      when String, Fixnum, Bignum, Float
        value
      else
        dump(value)
      end
    end

    def marshal_load(value)
      case value
      when Array
        value.collect{|v| marshal_load(v)}
      when Hash
        value.inject({}) { |h, (k, v)| h[k] = marshal_load(v); h }
      else
        load(value) rescue value
      end
    end

  end
end