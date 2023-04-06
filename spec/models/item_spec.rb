# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item do
  subject(:item) { build(:item) }

  # describe 'associations' do
  #   it { is_expected.to have_many(:inventories) }
  #   # it { should have_many(:inventories) }

  # end

  describe 'item create' do
    context 'when item is persisted' do
      before { item.save }

      it { is_expected.to be_persisted }
    end

    # context 'when a person report as infected the same person one more time' do
    #   let(:mark_survivor2) do
    #     described_class.new(person_marked: mark_survivor.person_marked,
    #       person_report: mark_survivor.person_report)
    #   end

    #   before { mark_survivor.save }

    #   it 'will raise exception', :aggregate_failures do
    #     expect { mark_survivor2.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    #   end
    # end
  end
end
