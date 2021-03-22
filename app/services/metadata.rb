require 'exifr/jpeg'
class Metadata
  def call!
    images = Dir["download/pixapay/images/*/*.jpg"]
    images = images
    images.each.with_index do |image, i|
      meta = load_metadata(image)

      Dir.mkdir("download/pixabay/images/#{i}") unless File.exists?("download/pixabay/images/#{i}")
      File.open("download/pixabay/images/#{i}/meta.txt", "w") { |f| f.write meta }
      FileUtils.cp(image, "download/pixabay/images/#{i}/#{image.split('/').last}")
    end
  end

  def load_metadata image
    data = {}
    data[:width]  = EXIFR::JPEG.new(image).width               # => 2272
    data[:height] = EXIFR::JPEG.new(image).height              # => 1704
    data[:exif]   = EXIFR::JPEG.new(image).exif?               # => true
    data[:model]  = EXIFR::JPEG.new(image).model               # => "Canon PowerShot G3"
    data[:date]   = EXIFR::JPEG.new(image).date_time           # => Fri Feb 09 16:48:54 +0100 2007

    data
  end
end
