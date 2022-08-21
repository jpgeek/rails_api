FactoryBot.define do
  factory :user do
    password { "sekret" }
    first_name { "Bob" }
    last_name { "Jones" }
    email { "#{first_name}.#{last_name}@example.com".downcase }
  end
end
