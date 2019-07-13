require 'rails_helper'

RSpec.describe Url, type: :model do

  it { should have_many(:hits).dependent(:destroy) }
  it { should validate_presence_of(:original) }
end
