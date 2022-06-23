class CardsController < ApplicationController

    before_action :generate_card, only:[:new]
    

    def new
        @card = Card.new
    end

    def show
        @card = Card.find(params[:id])
    end

    def generate_card
        number = ("%016d" % rand(0..9999999999999999)).to_s
        cvv = ("%03d" % rand(0..999)).to_s
        @account = Account.find(params[:account_id])
        @card = @account.create_card(number: number, cvv: cvv)
        redirect_to account_card_path(@account.id,@card)
    end

    def set_pin
        @card = Card.find(params[:card_id])
    end

    def save_pin
        card= Card.find(params[:card_id])
        raise "Invalid pin, Try again" if pin_params[:pin] == nil || pin_params[:pin] == ""
        raise "Enter a valid pin 0-9 Only 6 digits" unless pin_params[:pin] =~ /[0-9]{6,6}/
        raise "Entered fields are not matching" unless pin_params[:pin] == pin_params[:pin2]
        card.pin = pin_params[:pin]
        card.save
        if card.errors.empty?
            flash[:notice] = "Card pin saved successfully"
            redirect_to account_card_path(card.account_id,card)
        end
        rescue => exception
            flash[:alert] = exception.message
            redirect_to account_card_path(card.account_id,card)
    end
    private
    def pin_params
        params.require(:card).permit(:pin,:pin2)
    end
end
