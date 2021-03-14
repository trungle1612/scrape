module Potguide
  require "uri"
  require "net/http"

  class Base
    def initialize url
      @url = url
    end

    def http_client url: @url
      begin
        url = URI url
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request["Cookie"] = "__RequestVerificationToken=ZcF_i7QVVBQkWOc_wKv9MvymfEQ1iYkRjp8l1qUuJ7nWFDTAj-SbqDGTWNlpz2QWm9FADJY_veAoU6Cp6YVHhl-qRwE1"
        response = https.request(request)
        response.read_body
      rescue => e
        Rails.logger.error "Message: #{e.message} \n at: #{url}"
        sleep 5
      end
    end

    def data_url city_code
      "https://potguide.com/umbraco/Surface/StoreSurface/GetListForContainer?token=KdFlqi2PIPmFzl9MGJ1nwKUZRXW10YGOA5XFOpXIopQ&containerNodeId=#{city_code}&pageNumber=1&pageSize=200"
    end

    def parse; end

    def request

    end
  end
end
