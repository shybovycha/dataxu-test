require 'savon'
require 'hpricot'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate, :only => [:log_in]

  def update_country_data
    Thread.new {
      begin
        # setup Savon client for SOAP requests
        client = Savon::Client.new "http://www.webservicex.net/country.asmx?WSDL"

        # test if "webservicex.net" server is up and running
        actions = client.wsdl.soap_actions

        raise "SOAP server is down" if actions.nil? or actions.length <= 0

        resp = client.request :get_currencies

        raise "No response for currencies" if resp.nil?

        doc = Hpricot resp.to_hash[:get_currencies_response][:get_currencies_result]

        a = doc.search "table"

        a.each do |e|
          country = Country.new :name => (e.at "name").inner_html
          country.save

          currency = Currency.new :name => (e.at "currency").inner_html
          currency.save

          monetization = Monetization.new :country_id => country.id, :currency_id => currency.id
          monetization.save
        end
      end
    }
    
    flash[:notice] = "Updating process started..."
    
    redirect_to root_path
  end
  
  def log_out
    session[:uid] = nil
    redirect_to root_path
  end

  def log_in
    if authenticate
      flash[:error] = "Error logging in"
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      r = (username == "moo" && password == "foo")
      session[:uid] = r
      return r
    end
  end

  def encode(phrase)
    Digest::SHA2.hexdigest(Digest::MD5.hexdigest(phrase))
  end
end