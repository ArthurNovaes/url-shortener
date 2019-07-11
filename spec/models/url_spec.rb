require 'rails_helper'

RSpec.describe Url, type: :model do
  it { should validate_presence_of(:original) }
  it { should validate_presence_of(:short) }
  it { should validate_presence_of(:sanitize) }
end
