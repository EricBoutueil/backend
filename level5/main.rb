require 'pry-byebug'
require 'json'
require 'date'
require './parser'
require './models/car'
require './models/rental'
require './models/billing'
require './models/option'

class Main
  def initialize(input_file_path, output_file_path)
    @input = Parser.new(input_file_path)
    write_rental_output(output_file_path)
  end

  def write_rental_output(output_file_path)
    output_hash = {rentals: []}
    @input.rentals.each do |rental|
      output_hash[:rentals] << rental.rental_output
    end
    File.open(output_file_path,"w") do |file|
      file.write(JSON.pretty_generate(output_hash))
    end
  end
end

Main.new('data/input.json', 'data/output.json')
