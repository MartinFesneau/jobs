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

  def price
    rental_day_price = rental_duration * @car.price_per_day
    p rental_day_price
    distance_price = @distance * @car.price_per_km
    p distance_price
    return rental_day_price + distance_price
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
p rentals_arr
rentals_arr.each do |rental|
  rental_price = {
    id: rental.id,
    price: rental.price
  }
  rentals["rentals"] << rental_price
end

output = JSON.pretty_generate(rentals)
File.write('output.json', output)