require "nokogiri"
require "httparty"

def scraper
    url = "https://www.amazon.pl/s/ref=nb_sb_noss?__mk_pl_PL=%C3%85M%C3%85%C5%BD%C3%95%C3%91&url=search-alias%3Darts-crafts&field-keywords=&ref=nb_sb_noss&crid=2B0MCNP7Z4MFZ&sprefix=%2Carts-crafts%2C75"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    products = Array.new
    items = parsed_page.css('li.octopus-pc-item')
    items.each do |item|
        item_inside =item.css('div.a-section.octopus-pc-asin-title').first
        puts item_inside.css('span.a-price-whole')
        product = {
            name: item_inside.css('span.a-size-base.a-color-base').first.text.gsub("\n", "").gsub("            ", ""),
            price: item.css('span.a-price-whole').first.text + item.css('span.a-price-decimal').first.text.gsub(",,", ",") + item.css('span.a-price-fraction').first.text + item.css('span.a-price-symbol').first.text
        }
    
        products << product 
    end
    puts products
end

scraper
