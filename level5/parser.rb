class Parser

  attr_accessor :cars, :rentals, :options

  def initialize(input_file_path)
    @cars = []
    @rentals = []
    @options = []
    # binding.pry
    parse_input(input_file_path)
  end

  def parse_input(input_file_path)
    input_parsed = JSON.parse(File.new(input_file_path, 'r').read)
    input_parsed['cars'].each do |car|
      @cars << Car.new(car)
    end
    binding.pry
    input_parsed['rentals'].each do |rental|
      @rentals << Rental.new(rental, self)
    end

    input_parsed['options'].each do |option|
      @options << Option.new(option, self)
    end
  end

  def find_car(id)
    @cars.each do |car|
      if car.id == id
        return car
      end
    end
  end

  def find_rental(id)
    @rentals.each do |rental|
      if rental.id == id
        return rental
      end
    end
  end

  def find_options(rental_id)
    selected_options = []
    @options.each do |option|
      if option.rental_id == rental_id
        selected_options << option
      end
    end
  end
end
