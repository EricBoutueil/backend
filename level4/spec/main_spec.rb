require_relative "../main"

describe Main do
  it "returns calculated rental price" do
    Main.new('data/input.json', 'data/output.json')

    input_parsed = Parser.new('data/input.json')
    input_first_rental_id = input_parsed.rentals.first.id
    input_first_rental = input_parsed.find_rental(input_first_rental_id)
    input_first_rental_price = input_first_rental.price
    # binding.pry

    output_parsed = JSON.parse(File.new('data/output.json', 'r').read)
    output_first_rental_price = output_parsed['rentals'].first['actions'].first['amount']
    # binding.pry

    expect(output_first_rental_price).to eq(input_first_rental_price)
  end
  it "returns calculated rental drivy fee" do
    Main.new('data/input.json', 'data/output.json')

    input_parsed = Parser.new('data/input.json')
    input_first_rental_id = input_parsed.rentals.first.id
    input_first_rental = input_parsed.find_rental(input_first_rental_id)
    input_first_rental_commission = input_first_rental.commission["drivy_fee"]
    # binding.pry

    output_parsed = JSON.parse(File.new('data/output.json', 'r').read)
    output_first_rental_commission = output_parsed['rentals'].first['actions'].last['amount']
    # binding.pry

    expect(output_first_rental_commission).to eq(input_first_rental_commission)
  end
  it "matches expected output" do
    Main.new('data/input.json', 'data/output.json')

    output_parsed = JSON.parse(File.new('data/output.json', 'r').read)

    expected_output_parsed = JSON.parse(File.new('data/expected_output.json', 'r').read)

    expect(output_parsed).to eq(expected_output_parsed)
  end
end
