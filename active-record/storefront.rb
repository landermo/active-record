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

end

puts "How many users are there?"

puts "Answer: #{User.count}"

puts "What are the 5 most expensive items?"

puts "Answer: #{Item.order('price DESC').limit(5).pluck :title}"

puts "What's the cheapest book?"

puts "Answer: #{Item.where("category LIKE '%Books%'").order('price ASC').limit(1).pluck :title}"

puts "Who lives at '6439 Zetta Hills, Willmouth, WY'? Do they have another address?"

puts "Answer: #{}"