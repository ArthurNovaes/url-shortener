class Url < ApplicationRecord
  has_many :hits, dependent: :nullify

  validates_presence_of :original
end
