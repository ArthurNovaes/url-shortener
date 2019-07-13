class Url < ApplicationRecord
  has_many :hits, dependent: :destroy

  validates_presence_of :original
end
