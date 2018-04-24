class GrowersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :default_breadcrumbs, except: [:destroy]

  def index
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Grower'
    puts '------------------------'
    puts response.body
    puts '------------------------'
    @growers = JSON.parse response.body
  end

  def show
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Grower'
    @growers = JSON.parse response.body
    puts '------------------------grower detail--------'
    puts @growers
    puts '------------------------'
  end

  def new
    
  end

  def edit
    response = Faraday.get('http://localhost:3000/api/org.coffeechain.Grower/' + params[:id])
    @grower = JSON.parse response.body
    puts '------------------------grower with id: ' + @grower['growerId'] + '----------'
    puts @grower
    puts '------------------------'
    # breadcrumbs << {path: edit_dashboard_customer_path(@customer), title: 'Edit'}
  end

  def create
    
  end

  def offer_to_buyer
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.post do |req|
      req.url ('/api/org.coffeechain.Offer')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Offer",
        "offerId": params[:offerId],
        "price": params[:price],
        "accepted": 'false',
        "request": params[:requestId],
        "grower": params[:grower]
      }.to_json
    end 
    conn.post do |req|
      req.url ('/api/org.coffeechain.SendOffer')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.SendOffer",
        "request": params[:requestId],
        "grower": params[:grower],
        "offerId": params[:offerId],
        "price": 0,
        "transactionId": params[:transactionId],
        "timestamp": Time.now.strftime("yyyy-mm-dd")
      }.to_json
    end 
    redirect_to requests_path
  end  

  def update
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.put do |req|
      req.url ('/api/org.coffeechain.Grower/' + params[:id])
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Grower",
        "firstName": params[:firstName],
        "lastName": params[:lastName],
      }.to_json
    end
    redirect_to growers_path
  end

  def destroy
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.delete do |req|
      req.url ('/api/org.coffeechain.Grower/' + params[:id])
    end
    redirect_to growers_path
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
