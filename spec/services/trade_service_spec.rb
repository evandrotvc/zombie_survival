# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TradeService, type: :service do
  subject(:described_instance) { described_class.new(user, userB) }

  let!(:user) { create(:user) }
  let!(:inventory) { create(:inventory, user:) }

  let!(:userB) { create(:user) }
  let!(:inventory2) { create(:inventory, user: userB) }

  let(:itemsFrom) { ['water'] }
  let(:itemsTo) { %w[food ammunition] }

  describe '#methods' do
    describe '#exists_items_inventory?' do
      let(:items_array) { %w[food ammunition] }

      context 'exists all items' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
        let!(:food) { create(:item, kind: :food, inventory: inventory2) }

        it 'must return true' do
          expect(described_instance.exists_items_inventory?(itemsFrom,
            itemsTo)).to be(true)
        end
      end

      context 'just missing a item' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

        it 'must raise Exception TradeError' do
          expect do
            described_instance.exists_items_inventory?(itemsFrom,
              itemsTo)
          end.to raise_error(TradeError)
        end
      end
    end

    describe '#check_points_trade' do
      context 'when the points item are equals' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
        let!(:food) { create(:item, kind: :food, inventory: inventory2) }

        it 'must to allow the trade' do
          expect(described_instance.check_points_trade).to be(true)
        end
      end

      context 'when the points items not are equals' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

        it 'must raise Exception TradeError' do
          expect { described_instance.check_points_trade }.to raise_error(TradeError)
        end
      end
    end

    describe '#execute' do
      let!(:water) { create(:item, inventory:) }
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
      let!(:food) { create(:item, kind: :food, inventory: inventory2) }

      before { described_instance.execute(itemsFrom, itemsTo) }

      it 'must to happen trade with sucess' do
        expect do
          water.reload
        end.to change(water, :inventory_id).from(inventory.id).to(inventory2.id)
        expect do
          ammunition.reload
        end.to change(ammunition, :inventory_id).from(inventory2.id).to(inventory.id)
        expect do
          food.reload
        end.to change(food, :inventory_id).from(inventory2.id).to(inventory.id)
      end
    end
  end
end
