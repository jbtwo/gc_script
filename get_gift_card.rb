require 'faraday'
require 'json'

conn =
  Faraday.new(
    url: 'https://{{ ADD SHOP NAME HERE }}.myshopify.com',
    headers: {
      'Content-Type' => 'application/json',
      'X-Shopify-Access-Token' => '{{ PASTE API SECRET HERE }}',
    },
  )

f = File.open('./input.txt')

f_lines = f.read.split("\n")

f_lines.each do |gc_code|
  response =
    conn.post('/admin/api/2021-07/checkouts.json') do |req|
      req.body = {
        'checkout': {
          'gift_cards': [{ 'code': gc_code }],
        },
      }.to_json
    end

  gc = JSON.parse(response.body)

  new_write = "#{gc_code.to_s},#{gc['checkout']['gift_cards'][0]['id'].to_s}\n"
  
  File.write('./output.csv', new_write, mode: 'a')

end
