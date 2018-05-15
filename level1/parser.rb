class Parser

  attr_accessor :cars, :rentals

  def initialize(input_file_path)
    @cars = []
    @rentals = []

    parse_input(input_file_path)
  end

  def parse_input(input_file_path)
    input_parsed = JSON.parse(File.new(input_file_path, 'r').read)
    input_parsed['cars'].each do |car|
      @cars << Car.new(car)
    end

    input_parsed['rentals'].each do |rental|
      @rentals << Rental.new(rental, self)
    end
  end

  def find_car(id)
    @cars.each do |car_hash|
      if car_hash.id == id
        return car_hash
      end
    end
  end

  def find_rental(id)
    @rentals.each do |rental_hash|
      if rental_hash.id == id
        return rental_hash
      end
    end
  end
end
