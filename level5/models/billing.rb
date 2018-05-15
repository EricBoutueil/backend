class Billing
  attr_accessor :rental, :insurance_fee, :assistance_fee, :drivy_fee

  def initialize(rental)
    @rental = rental
  end

  def commission
    total_commission = @rental.price_excl_options * 0.3

    # half goes to the insurance
    @insurance_fee = (total_commission * 0.5).to_i
    # 1€/day goes to the roadside assistance
    @assistance_fee = (@rental.duration * 100).to_i
    # the rest goes to us
    @drivy_fee = (total_commission - @insurance_fee - @assistance_fee).to_i
    # Additional Insurance: 10€/day, all the money goes to Drivy
    @drivy_fee += @rental.price_additional_insurance

    {"insurance_fee"=>@insurance_fee, "assistance_fee"=>@assistance_fee, "drivy_fee"=>@drivy_fee}
  end

  def owner_credit
    @owner_credit = (@rental.price_excl_options * 0.7).to_i
    # GPS: 5€/day, all the money goes to the owner
    # Baby Seat: 2€/day, all the money goes to the owner
    # binding.pry
    @owner_credit += @rental.price_gps.first.to_i + @rental.price_baby_seat.first.to_i
  end

  def driver_debit
    @driver_debit = (@rental.price_excl_options).to_i
  end




end
