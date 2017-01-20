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

puts "How many total items did we sell?"
puts "#{Order.sum(:quantity)}"

puts "How much was spent on books?"

total = Order.joins(:item).where("category LIKE '%Books%'").sum("quantity * price")
puts total

puts "Simulate buying an item by inserting a User for yourself and an Order for that User."
# User.create(first_name: "Laura", last_name: "Montgomery", email: "laura@bbbc.com")
# lm = User.where("user_id = 51")
# puts "#{lm.first_name} #{lm.last_name}"
#
# order = Order.create(user_id: 51, item_id: 58, quantity: 1, created_at: Time.now)
# puts order

# OR lm.orders << Order.new(item: item, quantity: 23)

puts "What item was ordered most often?"

puts "#{Order.group(:item_id).having('COUNT(*) >= 9').pluck :item_id}"

  often = Order.group(:item).sum(:quantity).max_by{|key, value| value}
  puts "#{often.first.title}"

puts "Grossed the most money?"

totals = Order.group(:item).joins(:item).order('sum_quantity_all_price desc').limit(1).sum("quantity * price")
puts  "#{totals.keys.first.title}"

puts "What user spent the most?"
total = Order.joins(:item).sum("quantity * price")

spent = User.all.max_by{|key, total| total}
puts "#{spent.first_name} #{spent.last_name}"


puts "What were the top 3 highest grossing categories?"
category = Item.joins(:orders).group(:category).order("sum_price_all_quantity DESC").limit(3).sum("price * quantity")
puts "#{category}"