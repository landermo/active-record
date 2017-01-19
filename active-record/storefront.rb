require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: '/Users/lmontgomery/RubymineProjects/active-record/active-record/store.sqlite3'

)

class Address < ActiveRecord::Base
 belongs_to :user
end

class Item < ActiveRecord::Base
  has_many :orders
end

class Order < ActiveRecord::Base
  belongs_to :item
  has_many :users
  has_many :items
  has_many :addresses, through: :users
end

class User < ActiveRecord::Base
  has_many :addresses
end

puts "How many users are there?"

puts "Answer: #{User.count}"

puts "What are the 5 most expensive items?"

puts "Answer: #{Item.order('price DESC').limit(5).pluck :title}"

puts "What's the cheapest book?"

puts "Answer: #{Item.where("category LIKE '%Books%'").order('price ASC').limit(1).pluck :title}"

puts "Who lives at '6439 Zetta Hills, Willmouth, WY'? Do they have another address?"

person = User.includes(:addresses).where('addresses.street' => '6439 Zetta Hills').first
puts "Answer: #{person.first_name} #{person.last_name}"

puts "Do they have another address?"

other = Address.where("user_id = 40").last
puts "Answer: The other address is #{other.street}, #{other.city}, #{other.state}, #{other.zip}"

puts "Correct Virginie Mitchell's address to 'New York, NY, 10108'"
another = Address.where("user_id = 40")
another.update_all(city: 'New York', state: 'NY', zip: 10108)
puts  "The addresses: #{another.pluck :street, :city, :state, :zip}"

puts "How much would it cost to buy one of each tool?"
puts "#{Item.where("category LIKE '%tools%'").sum(:price)}"



