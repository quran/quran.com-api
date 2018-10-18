# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharType do

  context 'with associations' do
    it { is_expected.to belong_to(:parent)
                          .class_name('CharType')
    }
    it { is_expected.to have_many(:children)
                          .class_name('CharType')
                          .with_foreign_key('parent_id')
    }
  end

  context 'with columns and indexes' do
    columns = {
      name: :string,
      parent_id: :integer,
      description: :text
    }

    it_behaves_like 'modal with column', columns
    it { is_expected.to have_db_index ['parent_id'] }
  end
end
