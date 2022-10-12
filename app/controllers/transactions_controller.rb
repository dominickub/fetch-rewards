class TransactionsController < ApplicationController
    def index
        @transactions = Transaction.all
        render json: @transactions
    end

    def create
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            render json: @transaction
        else
            render json: @transaction.errors, status: :unprocessable_entity
        end
    end
    
    def show 
        @user = Transaction.find(params[:user_id])
        render json: @user
    end

    private

    def transaction_params
        params.permit(:payer_name, :points, :user_id)
    end
end
