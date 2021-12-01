require 'rails_helper'

RSpec.describe Name, type: :model do
  describe('associations') do
    it { should belong_to(:user) }
    it { should belong_to(:list) }
  end

  describe('validations') do
    it { should validate_presence_of(:title) }
  end
end
