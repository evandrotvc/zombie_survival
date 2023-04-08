# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Item' do
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
      kind: 'water'
    }
  end

  describe 'POST /add' do
    let!(:user) { create(:user) }
    let!(:inventory) { create(:inventory, user:) }
    describe '#validations' do
      context 'when send params' do
        it 'creates a new Person' do
          expect do
            post add_user_items_path(user), params: { item: params }
          end.to change(Item, :count).by(1)
        end
      end
    end
  end

  describe 'DELETE /remove' do
    let!(:user) { create(:user) }
    let!(:inventory) { create(:inventory, user:) }
    let!(:item) { create(:item, inventory: inventory) }

    let(:request) { delete remove_user_items_path(user.id), params: { item: params } }

    it 'destroys the requested person' do
      expect{ request }.to change(Item, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
