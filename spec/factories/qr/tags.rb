FactoryBot.define do
  factory :qr_tag, class: 'Qr::Tag' do
    name { "MyString" }
    approved { false }
  end
end
