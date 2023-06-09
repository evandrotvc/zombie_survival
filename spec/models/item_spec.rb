# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item do
  subject(:item) { build(:item) }

  describe 'associations' do
    it { is_expected.to belong_to(:inventory) }
  end

  describe 'item create' do
    context 'when item is persisted' do
      before { item.save }

      it { is_expected.to be_persisted }
    end
  end
end
