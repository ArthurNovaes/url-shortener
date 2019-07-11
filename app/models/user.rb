class User < ApplicationRecord
  has_many :hits, dependent: :nullify

  validates_presence_of :name
end
