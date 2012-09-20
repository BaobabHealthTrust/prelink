require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# TODO: Use rspec-mocks instead of an actual Prelink instance
describe Prelink do
  before(:each) do
    @prelink = Prelink.new
  end

  it "should load credentials" do
    @prelink.soap_header['wsdl:preLinkHeader']['wsdl:PassCode'].should_not be_nil
    @prelink.soap_header['wsdl:preLinkHeader']['wsdl:StationId'].should_not be_nil
  end

  it "should request lab results" do
    @prelink.request_result(nil).should be_nil
    expect { @prelink.request_results(nil) }.to raise_error(ArgumentError, 'No request number(s) given')

=begin
    results = @prelink.request_result('BCR1KC')
    results.should_not be_nil
    results.class.should_be Array
    results[0][:request_number].should == 'BCR1KC'
=end    
  end

  it "should setup namespaces" do
    @prelink.client.wsdl.namespace_uri.should == 'http://www.prelink.co.za/'
  end

  it "should request test codes" do
    @prelink.test_codes.should_not be_nil
  end

  # Prelink#get_new_results
  it "should get new results" do
    expect { @prelink.get_new_results }.to_not raise_error
  end
  
  # Prelink#get_results_by_date(:patient_id => 'P199999999999',
  #                             :start_date => '2012-08-29',
  #                             :end_date => '2012-09-30')
  it "should get results by date" do
    expect { @prelink.get_results_by_date(:patient_id => 'P199999999999',
                                      :start_date => '2012-08-29',
                                      :end_date => '2012-09-30') }.to_not raise_error
  end
  
  # Prelink#get_results_from_request_number(:patient_id => 'P199999999999',
  #                                         :last_request_number => 'BCR1KC')
  it "should get results later than a given request number" do
    expect { @prelink.get_results_from_request_number(:patient_id => 'P199999999999',
                                                      :last_request_number => 'BCR1KC') }.to_not raise_error
  end
  
  # Prelink.filter_response(response, method_name)
  it "should filter response for to get a simple hash"
end

