class RegulatorsController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :default_breadcrumbs, except: [:destroy]

  def index
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Regulator'
    puts '------------------------'
    puts response.body
    puts '------------------------'
    @regulators = JSON.parse response.body
  end

  def show
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Regulator'
    @regulators = JSON.parse response.body
    puts '------------------------regulator detail--------'
    puts @regulators
    puts '------------------------'
  end

  def new
    
  end

  def edit
    response = Faraday.get('http://localhost:3000/api/org.coffeechain.Regulator/' + params[:id])
    @regulator = JSON.parse response.body
    puts '------------------------regulator with id: ' + @regulator['regulatorId'] + '----------'
    puts @regulator
    puts '------------------------'
  end

  def create
    
  end

  def create_without_id
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.post do |req|
      req.url ('/api/org.coffeechain.Regulator')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Regulator",
        "regulatorId": params[:regulatorId],
        "firstName": params[:firstName],
        "lastName": params[:lastName],
      }.to_json
    end  
    redirect_to regulators_path
  end  

  def get_grower_list
    regulator_user_id = 'r001'
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Grower'
    growers = JSON.parse response.body
    response = Faraday.get 'http://localhost:3000/api/org.coffeechain.Certificate'
    certificates = JSON.parse response.body
    @growers = growers.map do |grower|
      grower['hasCertificate'] = false 
      grower['certificate'] = certificates.detect do |certificate|       
        (certificate['issuer'].include? regulator_user_id) && (certificate['grower'].include? grower['growerId']) && (certificate['valid'] == true)
      end
      if grower['certificate'] != nil
        grower['hasCertificate'] = true 
      end  
      grower 
    end    
  end
  
  def issue_certificate
    regulator_user_id = 'r001'
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.post do |req|
      req.url ('/api/org.coffeechain.IssueCertificate')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.IssueCertificate",
        "issuer": regulator_user_id,
        "grower": params[:growerId],
        "valid": 'true',
        "certificateId": params[:certificateId],
        "description": params[:description]
      }.to_json
    end 
    redirect_to get_grower_list_regulators_path
  end
  
  def cancel_certificate
    conn = Faraday.new(:url => 'http://localhost:3000')
    puts '----------'
    puts params[:certificateId]
    puts params[:description]
    conn.post do |req|
      req.url ('/api/org.coffeechain.CancelCertificate')
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.CancelCertificate",
        "certificate": params[:certificateId],
        "description": params[:description]
      }.to_json
    end 
    redirect_to get_grower_list_regulators_path
  end  

  def update
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.put do |req|
      req.url ('/api/org.coffeechain.Regulator/' + params[:id])
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "$class": "org.coffeechain.Regulator",
        "firstName": params[:firstName],
        "lastName": params[:lastName],
      }.to_json
    end
    redirect_to regulators_path
  end

  def destroy
    conn = Faraday.new(:url => 'http://localhost:3000')
    conn.delete do |req|
      req.url ('/api/org.coffeechain.Regulator/' + params[:id])
    end
    redirect_to regulators_path
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
