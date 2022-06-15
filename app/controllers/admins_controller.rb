class AdminsController < ApplicationController

    def index
        @users = User.all
    end
    def users
        @users = User.all
    end
    def accounts
      @accounts = Account.all  
    end

end
