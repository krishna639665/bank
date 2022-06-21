class CardsController < ApplicationController

    before_action :generat_card, only:[:new]

    def new
        @card = Card.new
        binding
    end

    def show
        @card = Card.find(params[:id])
    end

    def generat_card
        number = ("%016d" % rand(0..9999999999999999)).to_s
        cvv = ("%03d" % rand(0..999)).to_s
        account = Account.find(params[:account_id])
        @card = account.create_card(number: number, cvv: cvv)
        redirect_to account_card_path(account.id,@card)
    end

    private

    def card_params
        params.require(:cards).permit(:account_id,)
    end
end
