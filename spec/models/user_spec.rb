# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:age) }
  end

  # describe 'associations' do
  #   # it { is_expected.to have_many(:group_documents) }
  #   it { is_expected.to have_many(:inventories) }
  # end

  describe 'User create' do
    before { user.save }

    it { is_expected.to be_persisted }
  end
end
