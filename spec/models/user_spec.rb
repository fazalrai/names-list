require 'rails_helper'

RSpec.describe User, type: :model do
  describe('associations') do
    it { should have_many(:names).dependent(:destroy) }
    it { should have_one(:list) }
    it { should have_one(:recent_list) }
  end

  describe('callbacks') do
    context('.create_list') do
        context('when user is created successfully') do
            let(:user) { FactoryBot.create(:user) }

            it('will populate associated list object') do
                expect(user.list.user_id).to eq(user.id)
            end
        end
    end

    context('.populate_recent_list') do
        context('when user is created successfully') do
            let(:user) { FactoryBot.create(:user) }

            it('will populate associated recent list object') do
                expect(user.recent_list.user_id).to eq(user.id)
            end
        end
    end
  end
end
