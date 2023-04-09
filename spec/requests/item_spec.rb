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
    let!(:item) { create(:item, inventory:) }

    let(:request) { delete remove_user_items_path(user.id), params: { item: params } }

    it 'destroys the requested person' do
      expect { request }.to change(Item, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /trade' do
    let!(:user) { create(:user) }
    let!(:inventory) { create(:inventory, user:) }
    let!(:userB) { create(:user) }
    let!(:inventory2) { create(:inventory, user: userB) }
    let(:request) { post trade_user_items_path(user.id), params: }

    let(:params) do
      {
        user: {
          items: ['water']
        },
        user_to: {
          name: userB.name,
          items: %w[food ammunition]
        }
      }
    end

    context 'user dont have some items in inventory' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

      it 'must to raise exception' do
        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq('User doesnt have some item!')
      end
    end

    context 'items points are insuficients for the trade' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

      let(:params) do
        {
          user: {
            items: ['water']
          },
          user_to: {
            name: userB.name,
            items: ['ammunition']
          }
        }
      end

      it 'must to raise exception' do
        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq('Items points are insuficients for the trade!')
      end
    end

    context 'user infected' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

      before { user.update(status: :infected) }

      it 'must to raise exception' do
        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq('Users infecteds cannot to trade items!')
      end
    end

    context 'trade with success' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
      let!(:food) { create(:item, kind: :food, inventory: inventory2) }

      it 'must to happen trade with sucess' do
        request

        expect do
          water.reload
        end.to change(water, :inventory_id).from(inventory.id).to(inventory2.id)
        expect do
          ammunition.reload
        end.to change(ammunition, :inventory_id).from(inventory2.id).to(inventory.id)
        expect do
          food.reload
        end.to change(food, :inventory_id).from(inventory2.id).to(inventory.id)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
