class Au
  class << self
    def call
      get_products(5)
    end

    def get_categories
      url = URI("https://www.i-tech.com.au")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["Cookie"] = "PHPSESSID=n2jrrg7qikluqca5kjm8ko6q04"

      response = https.request(request)
      doc = Nokogiri::HTML(response.body)
      # doc.xpath('//*[@id="sm_megamenu_menu603631d9df25b"]/div[2]/div/ul/li')
      #
      #a = doc.css(".sm_megamenu_menu li a").first
      #a.text, a.attributes['href'].value
      cts = []
      categories = doc.css(".sm_megamenu_menu li a")
      categories.each do |ct|
        if ct.text.match? /^\s.* $/
          cts << {name: ct.text, url: ct.attributes['href'].value, sub: []}
        else
          cts.last[:sub] = cts.last[:sub] << { name: ct.text, url: ct.attributes['href'].value }
        end
      end

      File.open('categories_1.yml', 'w') {|f| f.write cts.to_yaml }
    end

    def get_products(page)
      #categories = YAML.load_file('categories_1.yml')
      begin
        urls = []

        page.times.each do |p|
          url = "https://www.i-tech.com.au/new-arrival.html?p=#{p.to_i + 1}"
          doc = Base.read_url(url)

          products_filter = doc.css('.product-item-info a')
          products_filter.each do |product|
            name = product.text
            url  = product.attributes["href"].value
            if url.to_s.match? /https:/
              urls << url
            end
          end
        end

        products = {url: urls.uniq.slice(0, 50)}
        File.open("download/new_arrival_#{page}.yml", 'w') {|f| f.write products.to_yaml }
      rescue Exception => e
        Rails.logger.error "Error #{e.message}"
        Rails.logger.error "Slepping"
        sleep 5
      end
    end
  end
end
