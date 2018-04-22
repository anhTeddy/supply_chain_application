class BuyersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :default_breadcrumbs, except: [:destroy]

  def index
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Buyer'
    puts '------------------------'
    puts response.body
    puts '------------------------'
    @buyers = JSON.parse response.body
  end

  def show
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Buyer'
    @buyers = JSON.parse response.body
    puts '------------------------buyer detail--------'
    puts @buyers
    puts '------------------------'
  end

  def new
    
  end

  def edit
    response = Faraday.get('http://localhost:3000/api/org.coffeechain.Buyer/' + params[:id])
    @buyer = JSON.parse response.body
    puts '------------------------buyer with id: ' + @buyer['buyerId'] + '----------'
    puts @buyer
    puts '------------------------'
    # breadcrumbs << {path: edit_dashboard_customer_path(@customer), title: 'Edit'}
  end

  def create
    
  end

  def create_without_id
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.post do |req|
      req.url ('/api/org.coffeechain.Buyer')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Buyer",
        "buyerId": params[:buyerId],
        "firstName": params[:firstName],
        "lastName": params[:lastName],
      }.to_json
    end  
    redirect_to buyers_path
  end  

  def update
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.put do |req|
      req.url ('/api/org.coffeechain.Buyer/' + params[:id])
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Buyer",
        "firstName": params[:firstName],
        "lastName": params[:lastName],
      }.to_json
    end
    redirect_to buyers_path
  end

  def destroy
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.delete do |req|
      req.url ('/api/org.coffeechain.Buyer/' + params[:id])
    end
    redirect_to buyers_path
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
