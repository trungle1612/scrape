module Pixapay
  require "uri"
  require "net/http"
  require 'down'

  class Base
    # def initialize url
    #   @url = url
    #   @driver = Selenium::WebDriver.for :chrome
    # end
    #
    # def http_client url: @url
    #   driver = nil
    #   begin
    #     @driver.navigate.to @url
    #     sleep 2
    #     @driver.page_source
    #   rescue => e
    #     Rails.logger.error "Message: #{e.message} \n at: #{url}"
    #   end
    # end
    #
    # def load_image
    #   doc = Nokogiri::HTML(http_client)
    #   imgs = doc.css('.item > a > img')
    #   urls = []
    #   image = {}
    #   imgs.each do |img|
    #     url = nil
    #     alt = ''
    #     url = img.attributes['data-lazy']&.value
    #     url = img.attributes['src']&.value if url.nil?
    #     alt = img.attributes['alt']&.value
    #     urls << { alt: alt, url: url }
    #   end
    #
    #   @driver.quit
    #   File.open('download/pixapay.yml', 'w') {|f| f.write urls.to_yaml }
    # end
    #
    # class << self
    #   def load_image
    #     images = YAML.load_file('download/pixapay.yml')
    #     images.each.with_index do |img, i|
    #       dowload_image(i, img[:url], img[:alt])
    #     end
    #   end
    #
    #   def dowload_image(i, url, alt)
    #     Rails.logger.info "Download: #{url}"
    #
    #     name = url.split('/')[-1]
    #     directory_name = "download/pixapay/images/#{i}"
    #     Dir.mkdir(directory_name) unless File.exists?(directory_name)
    #
    #     Down.download(url, destination: "#{directory_name}/#{name}")
    #     File.open("#{directory_name}/alt.txt", "w") { |f| f.write alt }
    #   end
    # end
  end
end
