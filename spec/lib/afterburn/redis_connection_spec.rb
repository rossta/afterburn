require 'spec_helper'

describe Afterburn::RedisConnection do

  module RedisConnectionTest
    extend Afterburn::RedisConnection
  end

  let(:subject) { RedisConnectionTest }

  it { subject.redis.should be_a(Redis::Namespace) }
  it { subject.redis.namespace.should eq(:afterburn) }
end
