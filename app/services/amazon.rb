class Amazon
  class << self

    def call! url
      doc = read_url(url)
      byebug
      title = title_selector(doc)
      image = image_selector(doc)
      star  = star_selector(doc)
    end

    def read_url(url)
      retries = 0
      begin
        uri = URI url
        Rails.logger.info "Reading: #{uri}"
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(uri)
        request["cache-control"] = 'no-cache'
        request["user-agent"] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36'

        response = https.request(request)
        Nokogiri::HTML(response.body)
      rescue => e
        byebug
        retry if (retries += 1) < 2
      end
    end

    def title_selector doc
      doc.css("#title > span").first.text
    end

    def image_selector doc
      doc.css("#img-canvas > img").first.values.select {|x| x.match? /https:\/\//}
    end

    def star_selector doc
      doc.css("#averageCustomerReviews > span").first.text.gsub("\n", "")
    end

    def other_books_selector doc
    end
  end
end
