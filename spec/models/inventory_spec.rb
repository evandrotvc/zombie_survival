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
end
