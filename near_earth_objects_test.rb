require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def test_a_date_returns_a_list_of_neos
    results = NearEarthObjects.find_neos_by_date('2019-03-30')
    assert_equal '(2019 GD4)', results[:astroid_list][0][:name]
  end

  def test_largest_asteroid_diameter
    neo = NearEarthObjects.new('2019-03-30')
    assert_equal 10233, neo.largest_asteroid_diameter
  end

  def test_total_number_of_asteroids
    neo = NearEarthObjects.new('2019-03-30')
    assert_equal 12, neo.total_number_of_asteroids
  end

  def test_formatted_asteroid_data
    skip
    neo = NearEarthObjects.new('2019-03-30')
    results = {:name=>"(2019 GD4)",
               :diameter=>"61 ft",
               :miss_distance=>"911947 miles"}
    assert_equal results, neo.formatted_asteroid_data.first
  end
end
