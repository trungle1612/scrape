class DownFaviconsController < ApplicationController
  def download
    url = params[:url]
    size = 32
    type = 'favicon'
    track = Tracking.find_or_initialize_by(tracking_type: type)

    if url.present? && track.count.to_i < 50
      file_name = DownFavicon.download(url, size)
      file = Rails.root.join(file_name)
      send_file(file)

      count = 1
      track.count = track.count.to_i + 1
      track.save
    else
      @maximum = 'you can only download 50 times'
    end
  end
end
