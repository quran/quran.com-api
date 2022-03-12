FactoryBot.define do
  factory :qr_post_tag, class: 'Qr::PostTag' do
    post_id { "MyString" }
    tag_id { "MyString" }
  end
end
