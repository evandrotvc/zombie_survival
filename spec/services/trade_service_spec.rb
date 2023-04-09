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
            itemsTo)).to eq(true)
        end
      end

      context 'just missing a item' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

        it 'must return false' do
          expect(described_instance.exists_items_inventory?(itemsFrom,
            itemsTo)).to eq(false)
        end
      end
    end

    describe '#check_points_trade' do
      context 'when the points item are equals' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
        let!(:food) { create(:item, kind: :food, inventory: inventory2) }

        it 'must to allow the trade' do
          expect(described_instance.check_points_trade).to eq(true)
        end
      end

      context 'when the points items not are equals' do
        let!(:water) { create(:item, inventory:) }
        let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }

        it 'trade must fail' do
          expect(described_instance.check_points_trade).to eq(false)
        end
      end
    end
  end
end
