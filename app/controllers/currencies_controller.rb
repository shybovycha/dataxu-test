class CurrenciesController < ApplicationController
  before_filter :authenticate, :only => [ :collect ]
  
  def index
    @currencies = Currency.all
  end

  def remaining_index
    @currencies = ((Monetization.where :collected => false).collect { |x| x.currency }).uniq
  end

  def show
    @currency = Currency.find(params[:id])
    @visited = (Monetization.where :collected => true, :currency_id => @currency.id).collect { |x| x.country }
  end

  def collect
    m = Monetization.new :country_id => params[:country_id], :currency_id => params[:currency_id]
    m.save

    redirect_to :back
  end
end
