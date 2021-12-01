require 'rails_helper'

RSpec.describe RecentList, type: :model do
  describe('associations') do
    it { should belong_to(:user) }
    it { should belong_to(:list) }
  end
end
