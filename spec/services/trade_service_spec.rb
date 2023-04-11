# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TradeService, type: :service do
  subject(:described_instance) { described_class.new(user, user2) }

  let!(:user) { create(:user) }
  let!(:inventory) { create(:inventory, user:) }

  let!(:user2) { create(:user) }
  let!(:inventory2) { create(:inventory, user: user2) }

  let(:items_from) { [{ kind: 'water', quantity: 2 }] }
  let(:items_to) { [{ kind: 'food', quantity: 1 }, { kind: 'ammunition', quantity: 1 }] }

  describe '#methods' do
    describe '#exists_items_inventory?' do
      let(:items_array) { %w[food ammunition] }

      context 'when exists all items' do
        let!(:water) { create(:item, inventory:, quantity: 2) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
        let!(:food) { create(:item, kind: :food, inventory: inventory2) }

        it 'must return true' do
          expect(described_instance.exists_items_inventory?(items_from,
            items_to)).to be(true)
        end
      end

      context 'when just missing a item' do
        let!(:water) { create(:item, inventory:, quantity: 2) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

        it 'must raise Exception TradeError' do
          expect do
            described_instance.exists_items_inventory?(items_from,
              items_to)
          end.to raise_error(TradeError)
        end
      end

      context 'when quantity item insuficient' do
        let!(:water) { create(:item, inventory:, quantity: 2) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
        let!(:food) { create(:item, kind: :food, inventory: inventory2) }
        let(:items_from) { [{ kind: 'water', quantity: 200 }] }

        it 'must raise Exception TradeError' do
          expect do
            described_instance.exists_items_inventory?(items_from,
              items_to)
          end.to raise_error(TradeError)
        end
      end
    end

    describe '#check_points_trade' do
      context 'when the points item are equals' do
        let!(:water) { create(:item, inventory:, quantity: 2) }
        let!(:ammunition) do
          create(:item, kind: :ammunition, inventory: inventory2, quantity: 2)
        end
        let!(:food) { create(:item, kind: :food, inventory: inventory2, quantity: 2) }

        let(:items_from) { [{ kind: 'water', quantity: 2 }] }
        let(:items_to) do
          [{ kind: 'food', quantity: 2 }, { kind: 'ammunition', quantity: 2 }]
        end

        it 'must to allow the trade' do
          expect(described_instance.check_points_trade(items_from, items_to)).to be(true)
        end
      end

      context 'when the points items not are equals' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

        let(:items_from) { [{ kind: 'water', quantity: 2 }] }
        let(:items_to) do
          [{ kind: 'food', quantity: 1 }, { kind: 'ammunition', quantity: 1 }]
        end

        it 'must raise Exception TradeError' do
          expect do
            described_instance.check_points_trade(items_from, items_to)
          end.to raise_error(TradeError)
        end
      end
    end

    describe '#execute' do
      let!(:water) { create(:item, inventory:, quantity: 2) }
      let!(:ammunition) do
        create(:item, kind: :ammunition, inventory: inventory2, quantity: 2)
      end
      let!(:food) { create(:item, kind: :food, inventory: inventory2, quantity: 2) }

      let(:items_from) { [{ kind: 'water', quantity: 2 }] }
      let(:items_to) do
        [{ kind: 'food', quantity: 2 }, { kind: 'ammunition', quantity: 2 }]
      end

      context 'when validate status user' do
        before { user.update(status: :infected) }

        it 'must raise exception' do
          expect do
            described_instance.execute(items_from, items_to)
          end.to raise_error(TradeError)
        end
      end

      it 'must to happen trade with success' do
        described_instance.execute(items_from, items_to)

        expect(inventory.items.reload.count).to eq(2)
        expect(inventory.items.pluck(:kind)).to include('food', 'ammunition')
        expect(inventory2.items.reload.count).to eq(1)
        expect(inventory2.items.pluck(:kind)).to include('water')
      end
    end
  end
end
