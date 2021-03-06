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
    number_of_days = @end_date - @start_date + 1

    duration_price = 0
    (1..number_of_days).each do |day|
      if day == 1
        duration_price += @car.price_per_day
      # price per day decreases by 10% after 1 day
      elsif day.between?(2,4)
        duration_price += @car.price_per_day * 0.9
      # price per day decreases by 30% after 4 days
      elsif day.between?(5,10)
        duration_price += @car.price_per_day * 0.7
      # price per day decreases by 50% after 10 days
      else
        duration_price += @car.price_per_day * 0.5
      end
    end

    price = duration_price + @distance * @car.price_per_km
    return { "id"=>@id, "price"=>price.to_i }
  end
end


