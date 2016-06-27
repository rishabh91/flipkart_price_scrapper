
require 'nokogiri'

require 'rubygems'

require "open-uri"

require 'csv'

number =1 # Each flipkart page shows 20 products , so for iterating to the next page adding 20 for every iteration 


def flipkart_scrapper(product_name)
	begin
		while number<1502
			product_name=product_name.gsub(/\s+/, "") ## Stripping whitespaces from the product name 
			page_to_scrape= "http://www.flipkart.com/lc/pr/pv1/spotList1/spot1/productList?sid=6bo&filterNone=true&start="+"#{number}"+"&q='#{product_name}'&ajax=true&_=1460191601982"
			product_name_array=[] # this array will hold the product name 
			product_price_array=[] # this array will hold product prices
			parse_page=Nokogiri::HTML(open(page_to_scrape))
			sleep 5
			parse_page.css('.pu-details.lastUnit').css('.pu-title.fk-font-13').each do |a|
				content=a.content.strip
				product_name_array.push(content)
			end
	
			parse_page.xpath("//div[@class='pu-price']//span[1]").each do |x|
				content=x.content.strip
				product_price_array.push(x.content)
				
			end

			number+=20 
		end
		table = [product_name_array, product_price_array]
		CSV.open('csvfile.csv', 'ab') do |csv|
    	table.each do |row|
        	csv << row
    	end
    rescue Exception => e 
    	puts "The Scrapping failed , Exception Caught : #{e.message}"
    end
end
puts "Enter the product name you are looking for "
flipkart_product_name = $stdin.gets.chomp
puts "The Scrapping is starting .............. Check the results in the"
flipkart_scrapper(flipkart_product_name)





