require 'rubygems'
require 'savon'
require 'shoulda'
require File.dirname(__FILE__) + '/../lib/prelink'

# TODO: use savon_spec to mock the tests

class PrelinkTest < Test::Unit::TestCase

  context "Prelink" do

    setup do
      @prelink = Prelink.new
    end

    should "load credentials" do
      assert_not_nil @prelink.soap_header['wsdl:preLinkHeader']['wsdl:PassCode']
      assert_not_nil @prelink.soap_header['wsdl:preLinkHeader']['wsdl:StationId']
    end

    should "setup namespaces" do
      assert_equal 'http://www.prelink.co.za/', @prelink.client.wsdl.namespace
    end
    
    should "request lab results" do
      results = @prelink.request_result(nil)
      assert_nil results

      results = @prelink.request_result('BCR1KC')
      assert_not_nil results
      assert_equal Array, results.class
      assert_equal 'BCR1KC', results[0][:request_number]

    end

    should "request test codes" do
      assert_not_nil @prelink.test_codes
    end

    should "request lab order" 
  end
end

