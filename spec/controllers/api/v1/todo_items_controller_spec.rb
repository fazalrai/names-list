require 'rails_helper'

RSpec.describe Api::V1::NamesController, type: :controller do
  render_views
  describe 'index' do
    let!(:user_with_names) { FactoryBot.create(:user_with_names) }
    context 'when authenticated' do
      it 'displays the current users todo items' do
        sign_in user_with_names
        get :index, format: :json
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(JSON.parse(user_with_names.names.to_json))
      end
    end
    context 'when not authenticated' do
      it 'returns unauthorized' do
        get :index, format: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'show' do
    let!(:user_with_names) { FactoryBot.create(:user_with_names) }
    let!(:another_user_with_names) { FactoryBot.create(:user_with_names) }
    context 'when authenticated' do
      it 'returns a todo_item' do
        todo_item = user_with_names.names.first
        sign_in user_with_names
        get :show, format: :json, params: { id: todo_item.id }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(JSON.parse(todo_item.to_json))
      end
      it "does not allow a user to view other's names" do
        another_users_todo_item = another_user_with_names.names.first
        sign_in user_with_names
        get :show, format: :json, params: { id: another_users_todo_item.id }
        expect(response.status).to eq(401)
      end
    end
    context 'when not authenticated' do
      it 'returns unauthorized' do
        todo_item = user_with_names.names.first
        get :show, format: :json, params: { id: todo_item.id }
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'create' do
    let!(:user_with_names) { FactoryBot.create(:user_with_names) }
    let!(:another_user_with_names) { FactoryBot.create(:user_with_names) }
    context 'when authenticated' do
      it 'returns a todo_item' do
        sign_in user_with_names
        new_todo = { title: 'a new todo', user: user_with_names }
        post :create, format: :json, params: { todo_item: new_todo }
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)['title']).to eq(new_todo[:title])
      end
      it 'creates a todo_item' do
        sign_in user_with_names
        new_todo = { title: 'a new todo', user: user_with_names }
        expect { post :create, format: :json, params: { todo_item: new_todo } }.to change { Name.count }.by(1)
      end
      it 'returns a message if invalid' do
        sign_in user_with_names
        invalid_new_todo = { title: '', user: user_with_names }
        expect { post :create, format: :json, params: { todo_item: invalid_new_todo } }.to_not change {
                                                                                                 Name.count
                                                                                               }
        expect(response.status).to eq(422)
      end
      it "does not allow a user to create other's names" do
        sign_in user_with_names
        new_todo = { title: 'a new todo create by the wrong accout', user: another_user_with_names }
        post :create, format: :json, params: { todo_item: new_todo }
        expect(JSON.parse(response.body)['user_id']).to eq(user_with_names.id)
        expect(JSON.parse(response.body)['user_id']).to_not eq(another_user_with_names.id)
      end
    end
    context 'when not authenticated' do
      it 'returns unauthorized' do
        new_todo = { title: 'a new todo', user: user_with_names }
        post :create, format: :json, params: { todo_item: new_todo }
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'update' do
    let!(:user_with_names) { FactoryBot.create(:user_with_names) }
    let!(:another_user_with_names) { FactoryBot.create(:user_with_names) }
    context 'when authenticated' do
      it 'returns a todo_item' do
        sign_in user_with_names
        updated_todo = user_with_names.names.first
        updated_todo_title = 'updated'
        put :update, format: :json, params: { todo_item: { title: updated_todo_title }, id: updated_todo.id }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['title']).to eq(updated_todo_title)
      end
      it "does not allow a user to update other's names" do
        sign_in user_with_names
        another_users_updated_todo = another_user_with_names.names.first
        updated_todo_title = 'updated'
        put :update, format: :json,
                     params: { todo_item: { title: updated_todo_title }, id: another_users_updated_todo.id }
        expect(response.status).to eq(401)
      end
      it 'returns a message if invalid' do
        sign_in user_with_names
        updated_todo = user_with_names.names.first
        updated_todo_title = ''
        put :update, format: :json, params: { todo_item: { title: updated_todo_title }, id: updated_todo.id }
        expect(response.status).to eq(422)
      end
    end
    context 'when not authenticated' do
      it 'returns unauthorized' do
        updated_todo = user_with_names.names.first
        updated_todo_title = 'updated'
        put :update, format: :json, params: { todo_item: { title: updated_todo_title }, id: updated_todo.id }
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'destroy' do
    let!(:user_with_names) { FactoryBot.create(:user_with_names) }
    let!(:another_user_with_names) { FactoryBot.create(:user_with_names) }
    context 'when authenticated' do
      it 'returns no content' do
        sign_in user_with_names
        destroyed_todo = user_with_names.names.first
        delete :destroy, format: :json, params: { id: destroyed_todo.id }
        expect(response.status).to eq(204)
      end
      it 'destroys a todo_item' do
        sign_in user_with_names
        destroyed_todo = user_with_names.names.first
        expect { delete :destroy, format: :json, params: { id: destroyed_todo.id } }.to change {
                                                                                          Name.count
                                                                                        }.by(-1)
      end
      it "does not allow a user to destroy other's names" do
        sign_in user_with_names
        another_users_destroyed_todo = another_user_with_names.names.first
        expect do
          delete :destroy, format: :json, params: { id: another_users_destroyed_todo.id }
        end.to_not change {
                     Name.count
                   }
      end
    end
    context 'when not authenticated' do
      it 'returns unauthorized' do
        destroyed_todo = user_with_names.names.first
        delete :destroy, format: :json, params: { id: destroyed_todo.id }
        expect(response.status).to eq(401)
      end
    end
  end
end
