class Api::V1::PartnersController < ApiController
  protect_from_forgery with: :null_session
  def create
    partner = Partner.invite!(email: create_params[:email])

    render json: partner.to_json(
      only: [:id, :email]
    )
  rescue ActiveRecord::RecordInvalid => e
    render e.message
  end

  def index
    partners = Partner.all
    render json: partners.to_json(
      only: [:diaper_partner_id, :name]
    )
  end

  def after_invite_path_for(_resource)
    partners_path
  end

  private

  def create_params
    params.permit(
      :diaper_bank_id,
      :diaper_partner_id,
      :email
    )
  end
end
