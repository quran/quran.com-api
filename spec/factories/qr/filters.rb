FactoryBot.define do
  factory :qr_filter, class: 'Qr::Filter' do
    book_id { "MyString" }
    topic_id { "MyString" }
    chapter_id { "MyString" }
    from { "MyString" }
    to { "MyString" }
  end
end
