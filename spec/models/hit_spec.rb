require 'rails_helper'

RSpec.describe Hit, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:url) }
end
