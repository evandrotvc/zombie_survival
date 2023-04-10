require 'rails_helper'

RSpec.describe 'Report' do
  let(:json) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET /infected_percentage' do
    it 'returns http success' do
      get reports_infected_percentage_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /non_infected_percentage' do
    it 'returns http success' do
      get reports_non_infected_percentage_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /average_items_per_user' do
    it 'returns http success' do
      get reports_average_items_per_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /lost_points' do
    let!(:user) { create(:user, status: :infected) }
    let!(:inventory) { create(:inventory, user:) }

    let!(:user2) { create(:user, status: :infected) }
    let!(:inventory2) { create(:inventory, user: user2) }

    let!(:water) { create(:item, inventory:) }
    let!(:ammunition) { create(:item, kind: :ammunition, inventory: inventory2) }
    let!(:food) { create(:item, kind: :food, inventory: inventory2) }

    it 'returns http success' do
      get reports_lost_points_path

      expect(response).to have_http_status(:success)
      expect(response.body).to eq("Número de pontos perdidos por usuários infectados: 8")
    end
  end
end
