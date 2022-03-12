FactoryBot.define do
  factory :qr_post_filter, class: 'Qr::PostFilter' do
    post_id { "MyString" }
    filter_id { "MyString" }
  end
end
