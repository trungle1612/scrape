class Base
  class << self
    def read_url(url)
      retries = 0
      begin
        url_download = URI download_favicon(url)
        Rails.logger.info "Reading: #{url_download}"
        https = Net::HTTP.new(url_download.host, url_download.port)
        #https.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["cache-control"] = 'no-cache'
        request["user-agent"] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36'

        response = https.request(request)
        byebug
        data = JSON.parse(response.body)
        data['icons'].first.src
      rescue => e
        byebug
        retry if (retries += 1) < 2
      end
      #Nokogiri::HTML(response.body)
    end

    def download_favicon(url)
      URI(url).host
      favicongrabber + URI(url).host
    end

    def favicons url
      "https://www.google.com/s2/favicons?sz=#{size}domain=" + url
    end

    def test
      url = favicons('tiki.vn')
      open('image.png', 'wb') do |file|
        file << open(url).read
      end
    end
  end
end
