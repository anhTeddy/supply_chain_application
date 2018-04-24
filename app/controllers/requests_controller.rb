class RequestsController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :default_breadcrumbs, except: [:destroy]

  def index
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Request'
    puts '------------------------'
    puts response.body
    puts '------------------------'
    @requests = JSON.parse response.body
  end

  def show
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Request'
    @requests = JSON.parse response.body
    puts '------------------------request detail--------'
    puts @requests
    puts '------------------------'
  end

  def new
    
  end

  def edit
    response = Faraday.get('http://localhost:3000/api/org.coffeechain.Request/' + params[:id])
    @request = JSON.parse response.body
    puts '------------------------request with id: ' + @request['requestId'] + '----------'
    puts @request
    puts '------------------------'
    # breadcrumbs << {path: edit_dashboard_customer_path(@customer), title: 'Edit'}
  end

  def create
    
  end

  def create_without_id
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.post do |req|
      req.url ('/api/org.coffeechain.Request')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Request",
        "requestId": params[:requestId],
        "coffeeType": params[:coffeeType],
        "quantityInKg": params[:quantityInKg],
        "maxPrice": params[:maxPrice],
        "region": params[:region],
        "dateToReceive": params[:dateToReceive],
        "buyer": params[:buyer] 
      }.to_json
    end  
    redirect_to requests_path
  end  

  def update
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.put do |req|
      req.url ('/api/org.coffeechain.Request/' + params[:id])
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Request",
        "firstName": params[:firstName],
        "lastName": params[:lastName],
      }.to_json
    end
    redirect_to requests_path
  end

  def destroy
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.delete do |req|
      req.url ('/api/org.coffeechain.Request/' + params[:id])
    end
    redirect_to requests_path
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
