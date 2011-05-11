class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :auth?, :only => [:log_in]

  def update_country_data
    client = Savon::Client.new "http://www.webservicex.net/country.asmx?WSDL"

    resp = (client.request :get_countries)[:get_countries_response][:get_countries_result]
    doc = Hpricot resp
    
    doc.search("table name").each do |c|
      country = Country.new :name => c.inner_html

      resp = client.request :get_currency_by_country do
        #soap.body = {  }
      end

      #currency = Currency.new

      #country.save
      #currency.save
      
      #monetization = Monetization.new :country_id => country.id, :currency_id => currency.id
      #monetization.save
    end
  end
  
  def log_out
    session[:uid] = nil
    redirect_to root_path
  end

  def log_in
    if authenticate(params[:username], params[:password])
      flash[:notice] = "Error logging in"
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      moo(username, password)
    end
  end

  def authenticate(u, p)
    moo(u, p)
  end

  def moo(username, password)
    r = (username == "moo" && password == "foo")
    session[:uid] = r
    return r
  end

  def encode(phrase)
    Digest::SHA2.hexdigest(Digest::MD5.hexdigest(phrase))
  end
end