FactoryBot.define do
  factory :cuisine do
    name { Faker::Food.dish } # Tên món ăn giả lập bằng Faker
    description { Faker::Food.description } # Mô tả giả lập bằng Faker
    price { Faker::Number.between(from: 10000, to: 100000) } # Giá giả lập bằng Faker
    discount { Faker::Number.between(from: 0, to: 50) } # Giảm giá giả lập bằng Faker
    available { true } # Trạng thái sẵn có (có thể điều chỉnh theo logic ứng dụng của bạn)

    # Thêm các thuộc tính khác của Cuisine nếu cần

    # Định nghĩa mối quan hệ nếu có
    trait :category do
      association :category, factory: :category
    end

    # Định nghĩa một hình ảnh giả lập nếu cần
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'example.jpg'), 'image/jpeg') }

    # Nếu có thêm mối quan hệ hoặc logic tạo dữ liệu khác, bạn có thể thêm vào đây

    # Định nghĩa một sequence cho slug (để tránh trùng lặp)
    sequence(:slug) { |n| "cuisine-#{n}" }
  end
end
