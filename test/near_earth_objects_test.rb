require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/near_earth_objects.rb'

class NearEarthObjectsTest < Minitest::Test
  def setup
    @results = NearEarthObjects.find_neos_by_date('2019-03-30')
    @neo = NearEarthObjects.new('2019-03-30')
  end

  def test_a_date_returns_a_list_of_neos
    assert_equal '(2019 GD4)', @results[:asteroid_list][0][:name]
  end

  def test_largest_asteroid_diameter
    assert_equal 10233, @neo.largest_asteroid_diameter
  end

  def test_total_number_of_asteroids
    assert_equal 12, @neo.total_number_of_asteroids
  end

  def test_it_can_return_formatted_asteroid_data
    asteroid_list_first = {:name=>"(2019 GD4)",
               :diameter=>"61 ft",
               :miss_distance=>"911947 miles"}
    asteroid_list_last = {:name=>"(2019 UZ)",
               :diameter=>"51 ft",
               :miss_distance=>"37755577 miles"}

    number_of_asteroids = 12
    largest_asteroid = 10233

    assert_equal asteroid_list_first, @neo.formatted_asteroid_data[:asteroid_list].first
    assert_equal asteroid_list_last, @neo.formatted_asteroid_data[:asteroid_list].last
    assert_equal number_of_asteroids, @neo.formatted_asteroid_data[:total_number_of_asteroids]
    assert_equal largest_asteroid, @neo.formatted_asteroid_data[:biggest_asteroid]
  end
end
