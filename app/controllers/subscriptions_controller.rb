class SubscriptionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def checkOut
        productTag = ""
        productHelper = [0, 0, 0, 0]
        if params[:product] == '3'
            productHelper[1] = 1
            productTag = 'price_1Nc1cmSJqMEWYUvSYWsfKSrH'
        elsif params[:product] == '5'
            productHelper[2] = 1
            productTag = 'price_1Nc1djSJqMEWYUvSDlkqDafW'
        elsif params[:product] == '10'
            productHelper[3] = 1
            productTag = 'price_1Nc1eESJqMEWYUvSGHEUK6IZ'
        end

        Stripe.api_key = ENV['STRIPE_API_KEY']
        stripe = Stripe::Checkout::Session.create({
            line_items: [{
            price: productTag,
            quantity: 1,
            }],
            mode: 'payment',
            success_url: "http://127.0.0.1:3000/subscriptions/?user_id=#{params[:user_id]}&tierfree=#{productHelper[0]}&tier3d=#{productHelper[1]}&tier5d=#{productHelper[2]}&tier10d=#{productHelper[3]}",
            cancel_url: 'http://127.0.0.1:3000/',
        })
        redirect_to stripe.url.to_s, allow_other_host: true
    end 

    def subscriptions 
        @subscription = Subscription.where(user_id: params[:user_id])[0]
        @subscription.tierfree = params[:tierfree]
        @subscription.tier3d   = params[:tier3d]
        @subscription.tier5d   = params[:tier5d]
        @subscription.tier10d  = params[:tier10d]

        if @subscription.tierfree
            @subscription.allowedViews = 1
        elsif @subscription.tier3d
            @subscription.allowedViews = 3
        elsif @subscription.tier5d
            @subscription.allowedViews = 5
        elsif @subscription.tier10d
            @subscription.allowedViews = 10
        end
        @subscription.save
        render json: @subscription, notice: 'Subscription added...'
    end
end