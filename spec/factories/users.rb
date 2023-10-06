FactoryBot.define do
  factory :user, class: "User" do
    # Định nghĩa các thuộc tính thông thường cho user, như name, email, password, ...
    first_name { "Customer" }
    last_name { "Customer" }
    email { "customer@gmail.com" }
    password { "123456" }
    password_confirmation { "123456" }
    is_actived { true }
    phone { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.full_address }
    role { 1 }
  end

  factory :admin_user, class: "User" do
    # Định nghĩa thêm các thuộc tính cho user admin
    first_name { "Admin" }
    last_name { "Admin" }
    email { "admin@gmail.com" }
    password { "123456" }
    password_confirmation { "123456" }
    is_actived { true }
    phone { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.full_address }
    role { 0 }
  end
end
