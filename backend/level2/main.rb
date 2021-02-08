require "json"
require "date"

class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end
end

class Rental
  attr_accessor :id, :car, :start_date, :end_date, :distance

  def initialize(id, car, start_date, end_date, distance)
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def rental_duration
    duration = Date.parse(@end_date) - Date.parse(@start_date)
    return duration.to_i + 1
  end

  def decreasing_rental_price
    if rental_duration > 10
      rental_price = (1 + 3 * 0.9 + 6 * 0.7 + ((rental_duration - 10) * 0.5)) * @car.price_per_day
    elsif rental_duration > 4 
      rental_price = (1 + 3 * 0.9 + ((rental_duration - 4) * 0.7)) * @car.price_per_day
    elsif rental_duration > 1
      rental_price = ( 1 + (rental_duration - 1) * 0.9) * @car.price_per_day
    else
      rental_price = rental_duration * @car.price_per_day
    end
  end

  def price
    distance_price = @distance * @car.price_per_km
    return distance_price + decreasing_rental_price.round
  end
end


file = File.read("data/input.json")
data = JSON.parse(file)

cars = []
data["cars"].each do |car|
  cars << Car.new(car['id'], car['price_per_day'], car['price_per_km'])
end

rentals_arr = []
data["rentals"].each do |rental|
  car = cars.find { |car| car.id == rental["car_id"]}
  rentals_arr << Rental.new(rental["id"], car, rental["start_date"], rental["end_date"], rental["distance"])
end


rentals =  { "rentals" => [] }
rentals_arr.each do |rental|
  rental_price = {
    id: rental.id,
    price: rental.price
  }
  rentals["rentals"] << rental_price
end

output = JSON.pretty_generate(rentals)
File.write('output.json', output)