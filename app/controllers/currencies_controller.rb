class CurrenciesController < ApplicationController
  before_filter :authenticate, :only => [ :collect ]
  
  def index
    @currencies = Currency.all
  end

  def show
    @currency = Currency.find(params[:id])
  end

  def collect
    m = Monetization.new :country_id => params[:country_id], :currency_id => params[:currency_id]
    m.save

    redirect_to :back
  end

=begin
  # GET /currencies/new
  # GET /currencies/new.xml
  def new
    @currency = Currency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  # GET /currencies/1/edit
  def edit
    @currency = Currency.find(params[:id])
  end

  # POST /currencies
  # POST /currencies.xml
  def create
    @currency = Currency.new(params[:currency])

    respond_to do |format|
      if @currency.save
        format.html { redirect_to(@currency, :notice => 'Currency was successfully created.') }
        format.xml  { render :xml => @currency, :status => :created, :location => @currency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @currency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /currencies/1
  # PUT /currencies/1.xml
  def update
    @currency = Currency.find(params[:id])

    respond_to do |format|
      if @currency.update_attributes(params[:currency])
        format.html { redirect_to(@currency, :notice => 'Currency was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @currency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.xml
  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy

    respond_to do |format|
      format.html { redirect_to(currencies_url) }
      format.xml  { head :ok }
    end
  end
=end
end
