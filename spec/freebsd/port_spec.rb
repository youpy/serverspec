require 'spec_helper'

include Serverspec::Helper::FreeBSD

describe port(80) do
  it { should be_listening }
  its(:command) { should eq 'sockstat -46l -p 80 | grep -- :80\\ ' }
end

describe port('invalid') do
  it { should_not be_listening }
end

describe port(80) do
  it { should be_listening.with("tcp") }
  its(:command) { should eq 'netstat -tunl | grep -- \\^tcp\\ .\\*:80\\ ' }
end

describe port(123) do
  it { should be_listening.with("udp") }
  its(:command) { should eq 'netstat -tunl | grep -- \\^udp\\ .\\*:123\\ ' }
end

describe port(80) do
  it { 
    expect {
      should be_listening.with('not implemented')
    }.to raise_error(ArgumentError, %r/\A`be_listening` matcher doesn\'t support/)
  }
end
