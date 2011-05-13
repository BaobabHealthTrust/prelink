require 'rubygems'
require 'savon'
require 'rspec'
require File.dirname(__FILE__) + '/../lib/prelink'

describe Prelink do
  before(:each) do
    @prelink = Prelink.new
  end

  it "should load credentials" do
    @prelink.soap_header['wsdl:preLinkHeader']['wsdl:PassCode'].should_not be_nil
    @prelink.soap_header['wsdl:preLinkHeader']['wsdl:StationId'].should_not be_nil
  end

  it "should request lab results" do
    @prelink.request_result('BCR1KC')
    results = @prelink.request_result(nil)
    results.should be_nil

    results = @prelink.request_result('BCR1KC')
    results.should_not be_nil
    results.class.should == Array
    results[0][:request_number].should == 'BCR1KC'
  end

  it "should setup namespaces" do
    @prelink.client.wsdl.namespace.should == 'http://www.prelink.co.za/'
  end

  it "should request test codes" do
    @prelink.test_codes.should_not be_nil
  end

  it "should request lab order"
end

