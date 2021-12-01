require 'rails_helper'

RSpec.describe Api::V1::NamesController, type: :controller do
    let(:user) { FactoryBot.create(:user) }

    describe 'index' do
        context 'when user is authenticated' do
            before do
                sign_in user
            end

            context 'when user has no names' do
                it 'will return empty response' do
                    get :index

                    expect(response).to have_http_status(:ok)
                    expect(JSON.parse(response.body).pluck('title')).to be_empty
                end
            end

            context 'when user has names' do
                let!(:name) { FactoryBot.create(:name, user: user, list: user.list) }

                it 'will return names of all authenticated users' do
                    get :index

                    expect(response).to have_http_status(:ok)
                    expect(JSON.parse(response.body).pluck('title')).to include(name.title)
                end

                context 'when user serarch a name' do
                    let!(:second_name) { FactoryBot.create(:name, user: user, list: user.list) }

                    it 'will return all searched names' do
                        get :index, params: { q: name.title.first(2) }

                        expect(response).to have_http_status(:ok)
                        expect(JSON.parse(response.body).pluck('title')).to include(name.title)
                    end
                end
            end
        end
    end

    describe 'create' do
        context 'when user is authenticated' do
            before do
                sign_in user
            end

            context 'when name is successfully created' do
                let(:payload) do
                    {
                        name: { title: Faker::Name.name }
                    }
                end

                it 'will return created name object' do
                    post :create, params: payload

                    expect(response).to have_http_status(:created)
                    expect(JSON.parse(response.body)['title']).to eq(payload[:name][:title])
                end
            end

            context 'when name is not successfully created' do
                context 'when params are missing' do
                    it 'will return exception' do
                        post :create

                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(JSON.parse(response.body)['message']).to include('param is missing or the value is empty')
                    end
                end

                context 'when params are present' do
                    let(:name) { FactoryBot.create(:name, user: user, list: user.list) }
                    let(:payload) do
                        {
                            name: { title: name.title }
                        }
                    end

                    it 'will returns exception' do
                        post :create, params: payload

                        expect(response).to have_http_status(:unprocessable_entity)
                        expect(JSON.parse(response.body)['message']).to include('Title has already been taken')
                    end
                end
            end
        end
    end
end
