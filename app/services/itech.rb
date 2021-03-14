class Itech
  def call
    data = []
    product = {}
    urls = get_url_products.slice(0, 2)
    urls.each do |url|
      doc = Base.read_url(url)

      product[:category_url] = doc.css(category_url_css).value
      product[:product_url] = url
      product[:category] = doc.css(category_css).text
      product[:sub_category] = ''
      product[:product_name] = doc.css(product_name_css).text
      product[:default_price] = doc.css(default_price_css).text
      product[:selling_price] = doc.css(selling_price_css).text
      product[:discount_price] = doc.css(selling_price_css).text
    end
  end

  def fields
    %w[
    category_url
    product_url
    category
    sub_category
    product_name
    selling_price
    discount_price
    sku
    mpn_upc
    brand
    manufacturer_link
    availability
    warranty
    ]
  end

  def category_url_css
    # get .attribute['href'].value
    # '.breadcrumbs > .items > .category > a'
    'body > div.page-wrapper > div > div > ul > li.item.category > a'
  end

  def product_url_css
    self
  end

  def category_css
    # get text
    #'.breadcrumbs > .items > .category > a'
    'body > div.page-wrapper > div > div > ul > li:nth-child(2)'
  end

  def sub_category_css
    # get text
    'body > div.page-wrapper > div > div > ul > li:nth-child(3)'
  end

  def product_name_css #(title)
    # Get text
    'body > div.page-wrapper > div > div > ul > li.item.product > a'
  end

  def default_price_css
    '.price-final_price > .price'
  end

  def selling_price_css
    '.old-price > .price'
  end

  def discount_price_css
    '.special-price > .price'
  end

  def sku_css
    '.product.attribute.sku > div'
    '#maincontent > div.columns.col1-layout > div > div > div > div.column.main > div.row > div.col-lg-6.col-md-6.info-box-detail > div > div.product-info-attributes > div.product.attribute.sku > div'
  end

  def mpn_upc_css
    '#maincontent > div.columns.col1-layout > div > div > div > div.column.main > div.row > div.col-lg-6.col-md-6.info-box-detail > div > div.product-info-attributes > div.product.attribute.vpn > div'
  end

  def brand_css
    '#maincontent > div.columns.col1-layout > div > div > div > div.column.main > div.row > div.col-lg-6.col-md-6.info-box-detail > div > div.product-info-attributes > div.product.attribute.brand > div'
  end

  def manufacturer_link_css
    '#maincontent > div.columns.col1-layout > div > div > div > div.column.main > div.row > div.col-lg-6.col-md-6.info-box-detail > div > div.product-info-attributes > div.product.attribute.manufacturer_link > a'
  end

  def availability_css
    '#maincontent > div.columns.col1-layout > div > div > div > div.column.main > div.row > div.col-lg-6.col-md-6.info-box-detail > div > div.product-info-attributes > div.product.attribute.availability > div'
  end

  def warranty_css
    '#maincontent > div.columns.col1-layout > div > div > div > div.column.main > div.row > div.col-lg-6.col-md-6.info-box-detail > div > div.product-info-attributes > div.product.attribute.warranty > div'
  end

  def get_url_products
    YAML.load_file('download/new_arrival_5.yml')[:url]
  end
end
