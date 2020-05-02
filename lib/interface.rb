require_relative 'near_earth_objects'
require 'date'

class Interface
  def initialize
    @date = nil
    @neo = nil
  end

  def intro
    puts "___________________________________________________________________________________________________________________"
    puts "Welcome to NEO. Here you will find information about how many meteors, asteroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
    neo_start
  end

  def continue?
    print "Would you like to continue? (Y/N)\n>> "
    response = gets.chomp.downcase
    if response == 'yes' || response == 'y'
      neo_start
    elsif response == 'no' || response == 'n'
      exit
    else
      "Would you like to continue? Type 'Y' for yes, or 'N' for no."
    end
  end

  def exit
    puts "Thank you for using the Near Earth Objects CLI.\nGood bye."
  end

  def get_date
    print "Please enter a date in the following format YYYY-MM-DD.\n>> "
    date = gets.chomp
    until valid_date?(date) || date.downcase == 'quit'
      print "Invalid date; Try another date in the following format YYYY-MM-DD or type 'quit' to exit. \n>> "
      date = gets.chomp
    end
    @date = date
  end

  def valid_date?(date)
    Date.iso8601(date)
    return true
  rescue ArgumentError
    false
  end

  def neo_start
    get_date
    @neo = NearEarthObjects.find_neos_by_date(@date)
    neo_info
    continue?
  end

  def neo_info
    formated_date = DateTime.parse(@date).strftime("%A %b %d, %Y")
    puts "______________________________________________________________________________"
    puts "On #{formated_date}, there were #{@neo[:total_number_of_asteroids]} objects that almost collided with the earth."
    puts "The largest of these was #{@neo[:biggest_asteroid]} ft. in diameter."
    puts "\nHere is a list of objects with details:"
    neo_table
  end

  def neo_table
    puts create_columns[:divider]
    puts create_columns[:header]
    create_rows(@neo[:asteroid_list], create_columns[:column_data])
    puts create_columns[:divider]
  end

  def create_columns
    column_labels = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
    column_data = column_labels.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [@neo[:asteroid_list].map { |asteroid| asteroid[col].size }.max, label.size].max}
    end
    {
      column_data: column_data,
      header: "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |",
      divider: "+-#{ column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"
    }
  end

  def create_rows(asteroid_data, column_info)
    rows = asteroid_data.each { |asteroid| format_row_data(asteroid, column_info) }
  end

  def format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end
end
