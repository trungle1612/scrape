class DownFavicon
  class << self
    def download url, size
      size = 32

      url_down = favicons(url: url, size: size)
      name = URI(url).host || URI(url).path
      name = name.split('.').join('-')

      file_name = "#{size}x#{size}-#{name}.png"
      open(file_name, 'wb') do |file|
        file << open(url_down).read
      end
      file_name
    end

    def favicons url:, size:
      site = URI(url).host || URI(url).path

      "https://www.google.com/s2/favicons?sz=#{size}&domain=" + site
    end
  end
end

