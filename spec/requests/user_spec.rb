# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  let(:headers) { { 'Content-Type': 'application/json' } }
  let(:json) { JSON.parse(response.body, symbolize_names: true) }
  let(:invalid_attributes) do
    {
      status: 'bridge',
      latitude: Faker::Address.latitude
    }
  end

  let(:params) do
    {
      name: 'Sam',
      gender: 'male',
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      age: 15
    }
  end

  describe 'POST /create' do
    describe '#validations' do
      context 'when send params' do
        it 'creates a new Person' do
          expect do
            post users_path, params: { user: params }
          end.to change(User, :count).by(1)
        end

        it 'return person created' do
          post users_path, params: { user: params }
          expect(response).to have_http_status(:created)
        end
      end
    end
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      User.create! params
      get users_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /infected' do
    let!(:survivor) { create(:user) }
    let!(:last_user) { create(:user) }

    context 'when a person report another is infected' do
      before do
        create_list(:user, 5)
      end

      it 'must create a marksurvivor', :aggregate_failures do
        expect { post(infected_user_survivor_path(survivor, User.second)) }
          .to change(MarkSurvivor, :count).by(1)
      end
    end

    context 'when the person is marked 3 times' do
      let(:mark_survivor) { create(:mark_survivor, user_marked: survivor) }
      let(:mark_survivor2) { create(:mark_survivor, user_marked: survivor) }

      before do
        mark_survivor
        mark_survivor2
        post(infected_user_survivor_path(last_user, survivor))
      end

      it 'must update status to infected', :aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect { survivor.reload }
          .to change(survivor, :status).from('survivor').to('infected')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'fulano'
        }
      end

      it 'updates the requested person' do
        user = User.create! params
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.reload.name).to eq('fulano')
      end

      it 'redirects to the person' do
        user = User.create! params
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user) { create(:user) }
    let(:request) { delete user_path(user.id) }

    it 'destroys the requested person' do
      expect{ request }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:ok)

    end
  end
end