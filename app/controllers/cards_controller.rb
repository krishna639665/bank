class CardsController < ApplicationController
  before_action :generate_card, only: [:new]
  before_action :set_card, only: [:set_pin, :save_pin]

  def new
    @card = Card.new
  end

  def show
    @account = Account.find(params[:account_id])
    if (@account.card.id != params[:id].to_i) || (Card.find_by(id: params[:id]).nil?) || !(current_user.accounts.include?(@account))
      flash[:notice] = "You are not Autherized to access!"
      render "pages/404"
    else
      @card = Card.find(params[:id])
    end
  end

  def generate_card
    number = ("%016d" % rand(0..9999999999999999)).to_s
    cvv = ("%03d" % rand(0..999)).to_s
    @account = Account.find(params[:account_id])
    @card = @account.create_card(number: number, cvv: cvv)
    CardChargeJob.perform_in(1.minutes, @account.id)
    redirect_to account_card_path(@account.id, @card)
  end

  def set_pin
  end

  def save_pin
    @card.pin = pin_params[:pin]
    @card.errors.add(:pin, "Enter a valid pin 0-9 Only 6 digits") unless pin_params[:pin] =~ /^\d{6}$/
    @card.errors.add(:pin2, "Entered fields are not matching") unless pin_params[:pin] == pin_params[:pin2]
    if @card.errors.empty?
      @card.save
      flash[:notice] = "Card pin saved successfully"
      redirect_to account_card_path(@card.account_id, @card)
    else
      render "set_pin"
    end
  end

  private

  def pin_params
    params.require(:card).permit(:pin, :pin2)
  end

  def set_card
    @card = Card.find(params[:card_id])
  end
end
