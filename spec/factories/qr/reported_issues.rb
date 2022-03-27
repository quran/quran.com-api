FactoryBot.define do
  factory :qr_reported_issue, class: 'Qr::ReportedIssue' do
    post_id { "MyString" }
    body { "MyString" }
    synced_with_qr { false }
  end
end
