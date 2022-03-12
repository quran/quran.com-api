FactoryBot.define do
  factory :qr_comment, class: 'Qr::Comment' do
    body { "MyString" }
    html_body { "MyString" }
    post_id { "MyString" }
    parent_id { "MyString" }
  end
end
