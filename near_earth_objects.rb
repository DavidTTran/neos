require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  attr_reader :parsed_data

  def initialize(date)
    @date = date
    @parsed_data = parse_data
  end

  def parse_data
    conn = Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: @date, api_key: ENV['nasa_api_key']}
    )
    conn = conn.get('/neo/rest/v1/feed')
    JSON.parse(conn.body, symbolize_names: true)[:near_earth_objects][:"#{@date}"]
  end

  def largest_asteroid_diameter
    @parsed_data.map do |asteroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end

  def total_number_of_asteroids
    @parsed_data.size
  end

  def self.find_neos_by_date(date)
    neo = NearEarthObjects.new(date)

    # neo.asteroid_info
    # conn = Faraday.new(
    #   url: 'https://api.nasa.gov',
    #   params: { start_date: date, api_key: ENV['nasa_api_key']}
    # )
    # asteroids_list_data = conn.get('/neo/rest/v1/feed')
    #
    # parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
    #
    largest_asteroid_diameter = neo.largest_asteroid_diameter

    total_number_of_asteroids = neo.total_number_of_asteroids
    
    formatted_asteroid_data = neo.parsed_data.map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end

    {
      asteroid_list: formatted_asteroid_data,
      biggest_asteroid: largest_asteroid_diameter,
      total_number_of_asteroids: total_number_of_asteroids
    }
  end
end
