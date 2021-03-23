require 'csv'
class Labor
  def call!
    agent= Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    form = agent.get("https://statistics.labor.ny.gov/directb2.asp?ind=72").form_with(name: 'contact')
    form['county'] = '000001'
    result = agent.submit form
    doc = Nokogiri::HTML(result.body)
    links = doc.css('.data-table > tbody > tr > td > a')
    results = []
    links.each do |link|
      results << {
        county: 'Albany',
        text: link.text,
        url: default_url + link.attributes['href'].value
      }
    end

    File.open('result.yml', 'w') {|f| f.write results.to_yaml } #Store
  end


  def default_url
    'https://statistics.labor.ny.gov/'
  end

  def load_business
    data = YAML.load_file('result.yml').slice(0, 200)
    results = []
    headers =['County', 'City',  'Company Name',  'Adress',  'URL', 'City, State, Zip', 'Contact, Name and Title', 'Phone', 'Fax', 'Industry', 'Employment Range']

    data.each do |dt|
      doc = crawl dt[:url]
      result = read_data(doc)
      results << result
    end
    File.open('labor_results.yml', 'w') {|f| f.write results.to_yaml } #Store
  end

  def crawl site
    Rails.logger.info "Reading: #{site}"
    url = URI(site)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    response = http.request(request)

    Nokogiri::HTML(response.body)
  end

  def read_data doc
    data = {'county' => 'Albany'}
    data['city']         = doc.css('table > tr:nth-child(3) > td:nth-child(2)').text.to_s.split(',').first
    data['company_name'] = doc.css('table > tr:nth-child(1) > td:nth-child(2)').text
    data['address']      =  doc.css('table > tr:nth-child(2) > td:nth-child(2)').text
    data['url']          = doc.css('table > tr:nth-child(7) > td:nth-child(2) > a')&.last&.attributes['href'].value
    data['city_state_zip'] = doc.css('table > tr:nth-child(3) > td:nth-child(2)').text
    data['contact']        = doc.css('table > tr:nth-child(4) > td:nth-child(2)').text
    data['phone']          = doc.css('table > tr:nth-child(5) > td:nth-child(2)').text
    data['fax']            = doc.css('table > tr:nth-child(6) > td:nth-child(2)').text
    data['induxtry']       = doc.css('table > tr:nth-child(8) > td:nth-child(2)').text
    data['em_range']       = doc.css('table > tr:nth-child(9) > td:nth-child(2)').text

    data
  end

  def write_csv
    headers =['County','City','Company Name','Adress','URL','City,State,Zip','Contact, Name and Title', 'Phone', 'Fax', 'Industry', 'Employment Range']
    data = YAML.load_file('labor_results.yml')

    CSV.open('labor.csv', 'wb') do |csv|
		  csv << headers
		  data.each do |dt|
        csv << dt.values
		  end
		end
  end
end
