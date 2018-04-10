# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token do
  context 'with columns and indexes' do
    columns = {
      text_madani: :string,
      text_clean: :string,
      text_indopak: :string
    }

    it_behaves_like 'modal with column', columns
  end
end
