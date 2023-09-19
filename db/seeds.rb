# Create users
User.create!(
  first_name: "Example",
  last_name: "Customer",
  email: "example@example.com",
  password: "123456",
  password_confirmation: "123456",
  address: Faker::Address.full_address,
  phone: Faker::PhoneNumber.cell_phone,
  is_actived: true,
  activation_at: Time.zone.now
)

# Create Categories
category1 = Category.create(name: "Category 1", slug: "category-1")
category2 = Category.create(name: "Category 2", slug: "category-2")
category3 = Category.create(name: "Category 3", slug: "category-3")

# Create Cuisines with Images
cuisine1 = Cuisine.create(
  name: "Cuisine 1",
  slug: "cuisine-1",
  description: "Description for Cuisine 1",
  price: 10,
  discount: 0,
  available: true,
  category: category1
)
cuisine1.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image.jpg')), filename: 'image.jpg')

cuisine2 = Cuisine.create(
  name: "Cuisine 2",
  slug: "cuisine-2",
  description: "Description for Cuisine 2",
  price: 12,
  discount: 0,
  available: true,
  category: category1
)
cuisine2.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image.jpg')), filename: 'image.jpg')

cuisine3 = Cuisine.create(
  name: "Cuisine 3",
  slug: "cuisine-3",
  description: "Description for Cuisine 3",
  price: 12,
  discount: 0,
  available: false,
  category: category1
)
cuisine3.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image.jpg')), filename: 'image.jpg')

cuisine4 = Cuisine.create(
  name: "Cuisine 4",
  slug: "cuisine-4",
  description: "Description for Cuisine 4",
  price: 12,
  discount: 0,
  available: true,
  category: category2
)
cuisine4.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image.jpg')), filename: 'image.jpg')

cuisine5 = Cuisine.create(
  name: "Cuisine 5",
  slug: "cuisine-5",
  description: "Description for Cuisine 5",
  price: 12,
  discount: 0,
  available: false,
  category: category2
)
cuisine5.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image.jpg')), filename: 'image.jpg')

cuisine6 = Cuisine.create(
  name: "Cuisine 6",
  slug: "cuisine-6",
  description: "Description for Cuisine 6",
  price: 12,
  discount: 0,
  available: true,
  category: category3
)
cuisine6.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image.jpg')), filename: 'image.jpg')

# Add more cuisines with unique images as needed
first_name = "Admin"
last_name = "Admin"
email = "admin@gmail.com"
password = "123456"
password_confirmation = "123456"
is_actived = true
phone = Faker::PhoneNumber.cell_phone
address = Faker::Address.full_address
role = 0
User.create(first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password_confirmation, is_actived: is_actived, phone: phone, address: address, role: role)

100.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.email
  password = "123456"
  password_confirmation = "123456"
  is_actived = true
  phone = Faker::PhoneNumber.cell_phone
  address = Faker::Address.full_address
  role = 1
  User.create(first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password_confirmation, is_actived: is_actived, phone: phone, address: address, role: role, created_at: Faker::Date.between(from: 365.days.ago, to: Date.today))
end

#create default category
Category.create(name: "Default", slug: "default")

20.times do
  name = Faker::Food.ethnic_category
  Category.create(name: name, slug: name.parameterize)
end


20.times do
  name = Faker::Food.dish
  description = Faker::Food.description
  price = Faker::Number.between(from: 10000, to: 100000)
  discount = Faker::Number.between(from: 0, to: 50)
  available = true
  slug = name.parameterize
  category_id = Faker::Number.between(from: 1, to: 20)
  created_at = Faker::Date.between(from: 365.days.ago, to: Date.today)

  # Kiểm tra xem slug đã tồn tại hay chưa
  if Cuisine.exists?(slug: slug)
    slug = "#{slug}-#{SecureRandom.hex(2)}" # Thêm một chuỗi ngẫu nhiên vào slug để đảm bảo duy nhất
  end
  
  c = Cuisine.create(name: name, slug: slug, description: description, price: price, discount: discount, available: available, category_id: category_id, created_at: created_at)
  c.image.attach(io: File.open(Rails.root.join('./app/assets/images', 'image.jpg')), filename: 'image.jpg')
  c.save!
end

Cuisine.all.each do |cuisine|
  3.times do |i|
    cuisine.options.create(
      name: "Option #{i + 1}",
      price: rand(5..20) * 1000 
    )
  end
end

#Create orders
50.times do |n|
  order = Order.create!(
    user_id: User.pluck(:id).sample,
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.cell_phone,
    status: rand(0..2)
  )
  rand(1..5).times do |n|
    cuisine_id = Cuisine.pluck(:id).sample
    option_id = Cuisine.find(cuisine_id).options.pluck(:id).sample
    order_item = OrderItem.create!(
      order_id: order.id,
      cuisine_id: cuisine_id,
      quantity: rand(2..5),
      price: Cuisine.find(cuisine_id).price,
      discount: Cuisine.find(cuisine_id).discount,
      option_id: option_id
    )
    order_item.sum = order_item.quantity * order_item.price
    order_item.save!
  end
  order.sum = order.order_items.sum(:sum)
  order.created_at = Faker::Date.between(from: 365.days.ago, to: Date.today)
  order.save!
end

# Create notification
10.times do |n|
  Notification.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    recipient_type: "User",
    content: Faker::Lorem.paragraph_by_chars(number: 128),
    recipient_id: User.pluck(:id).sample
  )
end
