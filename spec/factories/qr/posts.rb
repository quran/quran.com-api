FactoryBot.define do
  factory :qr_post, class: 'Qr::Post' do
    post_type { 1 }
    author_id { 1 }
    likes_count { 1 }
    language_id { 1 }
    language_name { "MyString" }
    views_count { "MyString" }
  end
end
