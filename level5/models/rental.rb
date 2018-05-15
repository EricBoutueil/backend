class Rental
  attr_accessor :id, :selected_car, :start_date, :end_date, :distance


  def initialize(params, parsed_input)
    @id = params['id']

    @selected_car = parsed_input.find_car(params['car_id'])

    @start_date = Date.parse(params['start_date'])
    @end_date = Date.parse(params['end_date'])

    @distance = params['distance']

    @billing = Billing.new(self)

    @selected_options = selected_options(parsed_input.options)
  end

  def duration
    @end_date - @start_date + 1
  end

  # calculating price excluding options
  def price_excl_options
    duration_price = 0
    (1..duration).each do |day|
      if day == 1
        duration_price += @selected_car.price_per_day
      # price per day decreases by 10% after 1 day
      elsif day.between?(2,4)
        duration_price += @selected_car.price_per_day * 0.9
      # price per day decreases by 30% after 4 days
      elsif day.between?(5,10)
        duration_price += @selected_car.price_per_day * 0.7
      # price per day decreases by 50% after 10 days
      else
        duration_price += @selected_car.price_per_day * 0.5
      end
    end

    price_excl_options = duration_price + @distance * @selected_car.price_per_km
    price_excl_options.to_i
  end

  # calculating options prices

  def selected_options(all_options)
    selected_options = []
    all_options.each do |option|
      if option.rental_id == self.id
        selected_options << option
      end
    end
  end

  def price_gps
    # binding.pry
    @selected_options.each do |option|
      if option.type == "gps"
        price_gps = option.price_per_day * duration
      end
    end
    return price_gps
  end

  def price_baby_seat
    @selected_options.each do |option|
      if option.type == "baby_seat"
        price_baby_seat = option.price_per_day * duration
      end
    end
    return price_baby_seat
  end

  def price_additional_insurance
    @selected_options.each do |option|
      if option.type == "additional_insurance"
        price_additional_insurance = option.price_per_day * duration
      end
    end
    return price_additional_insurance
  end

  def price_options
    price_options = price_gps + price_baby_seat + price_additional_insurance
  end

  def price
    price = price_excl_options + price_options
  end


  # retrieving data for output json
  def list_selected_options
    list_selected_options = []
    @selected_options.each do |option|
      list_selected_options << option.type
    end
    return list_selected_options
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


  # output json
  def rental_output
    { "id"=>@id,
      "options"=>list_selected_options,
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
