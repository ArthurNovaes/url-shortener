class Url < ApplicationRecord
  validates_presence_of :original, :short, :sanitize
end
