require_relative "../main"

describe Main do
  it "creates a json of a collection of input rentals with their ids and total prices " do
    Main.new('data/input.json', 'data/output.json')

    input_parsed = Parser.new('data/input.json')
    input_first_rental_id = input_parsed.rentals.first.id
    input_first_rental = input_parsed.find_rental(input_first_rental_id)
    input_first_rental_price = input_first_rental.price_calculation['price']
    # binding.pry

    output_parsed = JSON.parse(File.new('data/output.json', 'r').read)
    output_first_rental_price = output_parsed['rentals'].first['price']
    # binding.pry

    expected_output_parsed = JSON.parse(File.new('data/expected_output.json', 'r').read)
    expected_output_first_rental_price = expected_output_parsed['rentals'].first['price']

    expect(output_first_rental_price).to eq(input_first_rental_price)
    expect(output_first_rental_price).to eq(expected_output_first_rental_price)

  end
end
