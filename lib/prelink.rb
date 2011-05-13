require 'savon'
# = Prelink - SOAP Web Service Client for interacting with PreLink Lab System
#
# Adapted from:
# https://github.com/mikeymckay/mateme/blob/specimen_labeling/app/models/prelink.rb
#
class Prelink

  @@config = YAML.load_file(
    File.dirname(__FILE__) + '/../config/prelink.yml'
  ) rescue {}


  WSDL_URL  = @@config['wsdl_url']
  STATION_ID = @@config['station_id']
  PASS_CODE  = @@config['pass_code']


  attr_reader :client
  attr_reader :soap_header

  def initialize
    # load Prelink Lab Details

    @client = Savon::Client.new do |wsdl|
      wsdl.document = WSDL_URL
    end

    @soap_header = {'wsdl:preLinkHeader' => {'wsdl:StationId' => STATION_ID,
                                             'wsdl:PassCode'  => PASS_CODE}}
  end

  def order_request(encounter, options = {})
    patient = encounter.patient

    test_codes = options[:TestCodes] || encounter.observations.map do |o|
      o.answer_string
    end

    soap_body = {:dto => {'PriorityCode'  => options[:priority_code] || 'R',
      'DateCollected' => options[:date_collected] || DateTime.now,
      'DateReceived' => options[:date_received] || DateTime.now,
      'FolioNumber' => options[:folio_number] || encounter.encounter_id,
      'PatientFirstName' => options[:patient_first_name] || patient.first_name,
      'PatientLastName' => options[:patient_last_name] || patient.last_name,
      'PatientIdNumber' => options[:patient_id_number] || patient.national_id,
      'PatientAge' => options[:patient_age] || patient.person.age,
      'PatientDateOfBirth' => options[:patient_date_of_birth] || patient.person.birthdate,
      'GenderCode' => options[:gender_code] || patient.person.gender,
      'DoctorLocationCode' => options[:doctor_location_code] || encounter.location_id,
      'TestCodes' => {:string => test_codes}
    }}

    response = @client.request :wsdl, :order_request do |soap|
      soap.header = @soap_header
      soap.body = soap_body
    end
    response.to_hash[:order_request_response][:order_request_result] unless response.soap_fault?
  end

  def test_codes
    response = @client.request :get_test_codes do |soap|
      soap.header = @soap_header
    end

    return nil if response.soap_fault?
    # This looks nasty. That's soap for you
    # First we drill down through the xml response until we get to the elements
    # we care about
    useful_elements = response.to_hash[:get_test_codes_response][:get_test_codes_result][:diffgram][:document_element][:dynamic_list]
    # Then we end up with an array of hashes with lots of extra stuff in them
    # So we call map on that array and then on each hash we reject the stuff we
    # are not interested in
    # We get an array of hashes with test codes and names
    array_of_hashes = useful_elements.map do |test|
      test.reject do |key,value|
        (key != :test_code) and (key != :test_name)
      end
    end
    # We make this more useful by converting it to a single hash with the test_name as key and the test_code as value
    # Google for "create hash with inject" to understand how this works
    array_of_hashes.inject({}) do |new_hash, array_hash|
      new_hash[array_hash[:test_name]]=array_hash[:test_code]
      new_hash
    end
  end

  def request_result(request_number)
    self.request_results [request_number]
  end

  def request_results(request_numbers)
    request_numbers << '' if request_numbers.length == 1
    begin
      response = @client.request :wsdl, :get_request_results do |soap|
        soap.header = @soap_header
        soap.body = { :request_number => {:string => request_numbers} }
      end
      response.to_hash[:get_request_results_response][:get_request_results_result][:diffgram][:document_element][:view_export_results]
    rescue #Savon::Error => error
      #TODO: log the error
      nil
    end

  end

end

