require 'barby'
require 'rqrcode'
require 'barby/barcode/qr_code'
require 'barby/outputter/html_outputter'

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

  def get_offer_for_owning_request
    buyer_user_id = "b001"
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Request'
    all_requests = JSON.parse response.body
    owning_requests = all_requests.select do |request|
      request['buyer'].include? buyer_user_id
    end
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Offer'
    all_offers = JSON.parse response.body
    @requests = all_requests.map do |request| 
      request['offers'] = all_offers.select do |offer|
        offer['request'].include? request['requestId']
      end
      request  
    end    
  end

  def get_success_transaction
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.AcceptOffer'
    transactions = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Grower'
    growers = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Buyer'
    buyers = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Certificate'
    certificates = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Regulator'
    regulators = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Offer'
    offers = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Request'
    requests = JSON.parse response.body  

    @transactions = transactions.map do |trans|
      offer = offers.detect do |offer|
        trans['offer'].include? offer['offerId']
      end 
      request = requests.detect do |request|
        offer['request'].include? request['requestId']
      end  
      buyer = buyers.detect do |buyer|
        request['buyer'].include? buyer['buyerId']
      end   
      grower = growers.detect do |grower|
        offer['grower'].include? grower['growerId']
      end
      trans['requestQuantityInKg'] = request['quantityInKg']
      trans['requestCoffeeType'] = request['coffeeType']
      trans['buyerId'] = buyer['buyerId']
      trans['buyerName'] = buyer['firstName'] + ' ' + buyer['lastName']
      trans['growerId'] = grower['growerId']
      trans['growerName'] = grower['firstName'] + ' ' + grower['lastName']
      trans['growerFarmName'] = grower['FarmName']
      trans['growerFarmAltitude'] = grower['farmAltitude']
      trans['growerFarmRegion'] = grower['farmRegion']
      trans['growerCertificate'] = []   
      certificates.each do |certificate|
        if (certificate['grower'].include? grower['growerId']) && (certificate['valid'] == true)
          regulator = regulators.detect do |regulator|
            certificate['issuer'].include? regulator['regulatorId']
          end
          trans['growerCertificate'].push certificate['certificateId'] + ' issued by ' + regulator['regulatorOrgName']
        end  
      end  
      trans
    end 
    
    if params[:buyerId] != nil
      @transactions = @transactions.select do |trans|
        trans['buyerId'] == params[:buyerId]
      end  
    end  
  end  

  def get_barcode
    if params[:buyerId] != nil
      barcode = Barby::QrCode.new ('http://localhost:3001/buyers/get_success_transaction/' + params[:buyerId])
    else  
      barcode = Barby::QrCode.new 'http://localhost:3001/buyers/get_success_transaction'
    end
    @barcode = Barby::HtmlOutputter.new(barcode).to_html.html_safe
  end  
  
  def accept_offer
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.post do |req|
      req.url ('/api/org.coffeechain.AcceptOffer')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.AcceptOffer",
        "offer": params[:offerId]
      }.to_json
    end 
    redirect_to get_offer_for_owning_request_buyers_path
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
