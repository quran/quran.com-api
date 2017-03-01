class VerseLemma < ApplicationRecord
  has_many :verses
  has_many :words, through: :verses
end
