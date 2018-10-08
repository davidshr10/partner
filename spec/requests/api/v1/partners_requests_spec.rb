require "rails_helper"

describe "Partners Api Requests" do
  describe 'GET "/api/v1/partners' do
    it "returns all partners" do
      partner = FactoryBot.create(:partner)

      get api_v1_partners_path

      expect(response).to have_http_status(:ok)

      results = JSON.parse(response.body)
      expect(results.size).to eq 1
      expect(results[0]["diaper_partner_id"]).to eq(partner.id)
    end
  end

  describe 'POST "/api/v1/partners' do
    it "creates a partner" do
      attrs = {
        diaper_bank_id: 1,
        diaper_partner_id: 1,
        email: "partner@email.com"
      }

      post api_v1_partners_path, params: attrs

      expect(response).to have_http_status(:ok)
      expect(Partner.count).to eq 1
      expect(Partner.last.email).to eq("partner@email.com")

      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to include "partner@email.com"
      expect(last_email.html_part.body.to_s).to include "Accept invitation"
    end
  end
end