class OffersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :default_breadcrumbs, except: [:destroy]

  def index
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Offer'
    puts '------------------------'
    puts response.body
    puts '------------------------'
    @offers = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Offer'
    puts '------------------------'
    puts response.body
    puts '------------------------'
    @offers = JSON.parse response.body
  end

  def show
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Offer'
    @offers = JSON.parse response.body
    puts '------------------------offer detail--------'
    puts @offers
    puts '------------------------'
  end

  def new
    
  end

  def edit
    response = Faraday.get('http://localhost:3000/api/org.coffeechain.Offer/' + params[:id])
    @offer = JSON.parse response.body
    puts '------------------------offer with id: ' + @offer['offerId'] + '----------'
    puts @offer
    puts '------------------------'
    # breadcrumbs << {path: edit_dashboard_customer_path(@customer), title: 'Edit'}
  end

  def create
    
  end

  def create_without_id
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.post do |req|
      req.url ('/api/org.coffeechain.Offer')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Offer",
        "offerId": params[:offerId],
        "coffeeType": params[:coffeeType],
        "quantityInKg": params[:quantityInKg],
        "maxPrice": params[:maxPrice],
        "region": params[:region],
        "dateToReceive": params[:dateToReceive],
        "buyer": params[:buyer] 
      }.to_json
    end  
    redirect_to offers_path
  end 

  def update
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.put do |req|
      req.url ('/api/org.coffeechain.Offer/' + params[:id])
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Offer",
        "firstName": params[:firstName],
        "lastName": params[:lastName],
      }.to_json
    end
    redirect_to offers_path
  end

  def destroy
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.delete do |req|
      req.url ('/api/org.coffeechain.Offer/' + params[:id])
    end
    redirect_to offers_path
  end

  private

  def set_customer
  end

  def customer_params
    params.fetch(:customer, {}).permit(:id, :name, :code)
  end

  def default_breadcrumbs
    
  end
end
