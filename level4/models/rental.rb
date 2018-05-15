class Rental
  attr_accessor :id, :car, :start_date, :end_date, :distance


  def initialize(params, parsed_input)
    @id = params['id']

    @car = parsed_input.find_car(params['car_id'])

    @start_date = Date.parse(params['start_date'])
    @end_date = Date.parse(params['end_date'])

    @distance = params['distance']

    @billing = Billing.new(self)
  end

  def duration
    @end_date - @start_date + 1
  end

  def price
    duration_price = 0
    (1..duration).each do |day|
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
    price.to_i
  end

  def commission
    @billing.commission
  end

  def driver_debit
    @billing.driver_debit
  end

  def owner_credit
    @billing.owner_credit
  end

  def rental_output
    { "id"=>@id,
      "actions"=>[
        {
          "who"=>"driver",
          "type"=>"debit",
          "amount"=>driver_debit
        },
        {
          "who"=>"owner",
          "type"=>"credit",
          "amount"=>owner_credit
        },
        {
          "who"=>"insurance",
          "type"=>"credit",
          "amount"=>commission["insurance_fee"]
        },
        {
          "who"=>"assistance",
          "type"=>"credit",
          "amount"=>commission["assistance_fee"]
        },
        {
          "who"=>"drivy",
          "type"=>"credit",
          "amount"=>commission["drivy_fee"]
        }
      ]
    }
  end
end
