FactoryBot.define do
  factory :qr_author, class: 'Qr::Author' do
    name { "MyString" }
    verified { false }
    avatar_url { "MyString" }
    bio { "MyString" }
    user_type { "MyString" }
  end
end
