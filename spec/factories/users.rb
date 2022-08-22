FactoryBot.define do
  factory :user do
    password { "sekret" }
    first_name { "Bob" }
    last_name { "Jones" }
    email { "#{first_name}.#{last_name}@example.com".downcase }
    role { 'user' }

    factory :admin_user do
      first_name { "Admin" }
      last_name { "User" }
      role { 'admin' }
    end
  end
end
