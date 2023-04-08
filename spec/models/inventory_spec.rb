# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory do
  subject(:inventory) { build(:inventory) }

  describe 'associations' do
    it { is_expected.to have_many(:items) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'inventory create' do
    context 'when inventory is persisted' do
      before { inventory.save }

      it { is_expected.to be_persisted }
    end
  end

  describe '#methods' do
    let!(:user) { create(:user) }
    let!(:inventory) { create(:inventory, user: user) }
    let(:items_array) { ['food', 'ammunition'] }

    context 'exists all items' do
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory) }
      let!(:food) { create(:item, kind: :food, inventory: inventory) }

      it 'must return true' do
        expect(inventory.all_items_in_inventory?(items_array)).to eq(true)
      end
    end

    context 'just missing a item' do
      let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory) }

      it 'must return false' do
        expect(inventory.all_items_in_inventory?(items_array)).to eq(false)
      end
    end
  end
end
