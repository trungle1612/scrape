class Base
  class << self
    def read_url(url)
      url = URI url
      Rails.logger.info "Reading: #{url}"
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["Cookie"] = "PHPSESSID=n2jrrg7qikluqca5kjm8ko6q04"

      response = https.request(request)
      Nokogiri::HTML(response.body)
    end
  end
end
