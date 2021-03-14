module Potguide
  require 'csv'
  class Dispensary < Base
    def initialize
      super('https://potguide.com/massachusetts/marijuana-dispensaries/')
    end

    def call!
      # Rails.logger.info "Starting Reading cities"
      # city_parse
      # sleep 2

      Rails.logger.info "Starting Reading dispensaries"
      read

      Rails.logger.info "Starting Writing dispensaries to CSV"
      write
    end

    def write
      headers = ["Dispensary Name", "Dispensary URL", "Brand", "Products"]
      products = YAML.load_file('download/dispensaries.yml')
      file = 'download/data_despensaries.csv'

      CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
        products.each do |product| 
          writer << product.values
        end
      end
    end

    def city_parse
      doc = Nokogiri::HTML(http_client)
      divs = doc.css('div[id^="city_"]')

      ids = divs.map { |div| div.attributes['id'].value }
      File.open('download/city_massachusetts.yml', 'w') {|f| f.write ids.to_yaml }
    end

    def read
      result = []
      cities.each do |city|
        code = city.split('_').last
        next if code.blank?

        url = data_url(code)
        Rails.logger.info "Reading: #{url}"
        jsons = JSON.parse(http_client(url: url))['Data']

        jsons.each do |json|
          data = mapping(json, code)
          result << data
        end
      end

      File.open('download/dispensaries.yml', 'w') {|f| f.write result.to_yaml }
    end

    def cities
      YAML.load_file('download/city_massachusetts.yml')
    end

    def mapping data, code
      {
        dispensary_name: data['StoreName'], # - Dispensary name
        dispensary_url: data['Website'],# - Dispensary URL
        brand: data['Name'], # - Brand
        products: services(data)# - Product name
      }
    end

    def services(data)
      service = {
        "IsServiceMed" => 'Medical Sales',
        "IsServiceRec" => 'Recreational Sales',
        "IsServiceAtmOnsite" => 'ATM On-Site',
        "IsTakesCards" => 'Cards',
        "IsHandicappedAccessible" => 'Handicapped Accessible'
      }

      result = []
      result << service['IsServiceMed'] if data['IsServiceMed'].to_s == 'true'
      result << service['IsServiceRec'] if data['IsServiceRec'].to_s == 'true'
      result << service['IsServiceAtmOnsite'] if data['IsServiceAtmOnsite'].to_s == 'true'
      result << service['IsTakesCards'] if data['IsTakesCards'].to_s == 'true'
      result << service['IsHandicappedAccessible'] if data['IsHandicappedAccessible'].to_s == 'true'

      result.join(', ')
    end
  end
end
