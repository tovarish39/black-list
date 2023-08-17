require 'net/http'

src = 'http://185.17.0.41/api/categories'
url = URI.parse(src)

http = Net::HTTP.new(url.host, url.port)

response = http.get('/')

puts response.body