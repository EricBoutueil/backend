class Option
  attr_accessor :id, :rental, :type, :price_per_day


  def initialize(params, parsed_input)
    @id = params['id']

    @rental = parsed_input.find_rental(params['rental_id'])

    @type = params['type']
    @price_per_day = price_per_day
  end

  def price_per_day
    case self.type
    when "gps"
      500
    when "baby_seat"
      200
    when "additional_insurance"
      1000
    end
  end
end
