class Rental
  attr_accessor :id, :car, :start_Date, :end_date, :distance


  def initialize(params, parsed_input)
    @id = params['id']

    @car = parsed_input.find_car(params['car_id'])

    @start_date = Date.parse(params['start_date'])
    @end_date = Date.parse(params['end_date'])

    @distance = params['distance']
  end

  def price_calculation
    price = ((@end_date - @start_date)+1) * @car.price_per_day + @distance * @car.price_per_km
    return { "id"=>@id, "price"=>price.to_i }
    return { "id"=>@id, "price"=>price.to_i }
  end
end
