class UsersController < ApplicationController
    def create  
        @user = User.new(user_params)
        if @user.save
            render json: @user
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(params[:id])
        render json: @user, include: :transactions
    end
    def balance
        @user = User.find(params[:id])
        @user.balance = @user.transactions.sum(:points)
        render json: @user, include: :transactions
    end
    def spend 
        # Find the user
        # find the transactions that have the timestamp that is the oldest
        # take the points from the transaction and subtract it from the user's balance
        # if the total amount is greater than the balance, return 0 else subtract it from the balance
        # if the balance is 0, delete the transaction
        @user = User.find(params[:id])
        @user.balance = @user.transactions.sum(:points)
        @user.transactions.each do |transaction|
            if @user.balance > 0
                if @user.balance > transaction.points
                    @user.balance -= transaction.points
                    transaction.points = 0
                    transaction.save
                else
                    transaction.points -= @user.balance
                    @user.balance = 0
                    transaction.save
                end
            end
        end
        render json: @user, include: :transactions
    end

    # order the transactions by timestamp
    # if the user's balance is greater than the transaction's points, subtract the transaction's points from the user's balance
    def order_transactions
        @user = User.find(params[:id])
        @user.transactions.order(:timestamp)
        @user.transactions.each do |transaction|
            if @user.balance > 0
                if @user.balance > transaction.points
                    @user.balance -= transaction.points
                    transaction.points = 0
                    transaction.save
                else
                    # if the user's balance is less than the transaction's points, return "Not enough points"
                    render json: "Not enough points"
                end
            end
        end
        render json: @user, include: :transactions
    end

    private
    def user_params
        params.permit(:id, :balance)
    end
end
