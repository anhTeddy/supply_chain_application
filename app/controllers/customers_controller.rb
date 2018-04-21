class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :default_breadcrumbs, except: [:destroy]

  def index

  end

  def show
  end

  def new
    # breadcrumbs << {path: new_dashboard_customer_path, title: 'New'}
    @customer = Customer.new
  end

  def edit
    # breadcrumbs << {path: edit_dashboard_customer_path(@customer), title: 'Edit'}
  end

  def create
    # @customer = customer.new(customer_params)
    # breadcrumbs << {path: new_dashboard_customer_path, title: 'New'}
    render :new
  end

  def update
    # @customer.attributes = customer_params
    # breadcrumbs << {path: edit_dashboard_customer_path(@customer), title: 'Edit'}
    render :edit
  end

  def destroy
    # redirect_to dashboard_countries_path, notice: 'customer was successfully destroyed.'
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
