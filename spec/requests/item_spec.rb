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
      kind: 'water',
      quantity: 1
    }
  end

  describe 'POST /add' do
    let!(:user) { create(:user) }
    let!(:inventory) { create(:inventory, user:) }

    describe '#validations' do
      context 'when send params' do
        it 'creates a new Item' do
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
    let!(:user2) { create(:user) }
    let!(:inventory2) { create(:inventory, user: user2) }
    let(:request) { post trade_user_items_path(user.id), params: }

    let(:params) do
      {
        user: {
          items: [{ kind: 'water', quantity: 1 }]
        },
        user_to: {
          name: user2.name,
          items: [{ kind: 'food', quantity: 1 }, { kind: 'ammunition', quantity: 1 }]
        }
      }
    end

    context 'when user dont have some items in inventory' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

      let(:comment) do
        "#{inventory2.user.name} dont have food or quantity insuficient!"
      end

      it 'must to raise exception' do
        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq(comment)
      end
    end

    context 'when user dont have quantity items suficients for the trade' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
      let!(:food) { create(:item, kind: :food, inventory: inventory2) }

      let(:params) do
        {
          user: {
            items: [{ kind: 'water', quantity: 1 }]
          },
          user_to: {
            name: user2.name,
            items: [{ kind: 'food', quantity: 1 },
                    { kind: 'ammunition', quantity: 500 }]
          }
        }
      end

      let(:comment) do
        "#{inventory2.user.name} dont have ammunition or quantity insuficient!"
      end

      it 'must to raise exception' do
        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq(comment)
      end
    end

    context 'when items points are insuficients for the trade' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

      let(:params) do
        {
          user: {
            items: [{ kind: 'water', quantity: 1 }]
          },
          user_to: {
            name: user2.name,
            items: [{ kind: 'ammunition', quantity: 1 }]
          }
        }
      end

      it 'must to raise exception' do
        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq('Items points are insuficients for the trade!')
      end
    end

    context 'when user infected' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

      before { user.update(status: :infected) }

      it 'must to raise exception' do
        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq('Users infecteds cannot to trade items!')
      end
    end

    context 'when trade with success' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
      let!(:food) { create(:item, kind: :food, inventory: inventory2) }

      it 'must to happen trade with sucess' do
        request

        expect(response).to have_http_status(:ok)
        expect(inventory.items.reload.count).to eq(2)
        expect(inventory.items.pluck(:kind)).to include('food', 'ammunition')
        expect(inventory2.items.reload.count).to eq(1)
        expect(inventory2.items.pluck(:kind)).to include('water')
      end
    end
  end
end
