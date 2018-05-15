require 'pry-byebug'
require 'json'
require 'date'
require './parser'
require './models/car'
require './models/rental'


class Main
  def initialize(input_file_path, output_file_path)
    @input = Parser.new(input_file_path)
    # binding.pry
    output_rental_prices(output_file_path)
  end

  def output_rental_prices(output_file_path)
    output_hash = {rentals: []}
    @input.rentals.each do |rental|
      output_hash[:rentals] << rental.price_calculation
    end
    File.open(output_file_path,"w") do |file|
      file.write(JSON.pretty_generate(output_hash))
    end
  end
end

Main.new('data/input.json', 'data/output.json')
