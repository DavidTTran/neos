# require 'faraday'
# require 'figaro'
# require 'pry'
#
# # Load ENV vars via Figaro
# Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('./config/application.yml', __FILE__))
# Figaro.load
#
# class NeoApi
#   def self.parse_data(date)
#     conn = Faraday.new(
#       url: 'https://api.nasa.gov',
#       params: { start_date: date, api_key: ENV['nasa_api_key']}
#     )
#     conn = conn.get('/neo/rest/v1/feed')
#     require "pry"; binding.pry
#     JSON.parse(conn.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
#   end
# end
