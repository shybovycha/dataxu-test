require 'savon'
require 'hpricot'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :auth?, :only => [:log_in]

  def update_country_data
    Thread.new { update_db }
    
    flash[:notice] = "Updating process started..."
    
    redirect_to root_path
  end
  
  def log_out
    session[:uid] = nil
    redirect_to root_path
  end

  def log_in
    if authenticate(params[:username], params[:password])
      flash[:error] = "Error logging in"
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

  def update_db
    begin
      # setup Savon client for SOAP requests
      client = Savon::Client.new "http://www.webservicex.net/country.asmx?WSDL"

      # test if "webservicex.net" server is up and running
      actions = client.wsdl.soap_actions

      raise "SOAP server is down" if actions.nil? or actions.length <= 0

      # get country list
      resp = client.request :get_countries

      raise "No response for countries" if resp.nil?

      resp = resp[:get_countries_response][:get_countries_result]

      # create XML SOAP response representation
      doc = Hpricot resp

      # get countries array
      countries = doc.search("table name").uniq

      # assign currencies to each country
      countries.each do |c|
        # first, we should create a country model instance, of course
        country = Country.new :name => c.inner_html
        country.save

        # somehow, Savon could not get any valid response using its simple interactions
        # this should fix problem
        resp = client.request :get_currency_by_country do
          soap.xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">  <soap:Body>    <GetCurrencyByCountry xmlns=\"http://www.webserviceX.NET\">      <CountryName> #{ country.name } </CountryName>    </GetCurrencyByCountry>  </soap:Body></soap:Envelope>"
        end

        raise "No response for currencies in <#{ country.name }>" if resp.nil?

        # create XML representation
        doc2 = Hpricot resp.to_hash[:get_currency_by_country_response][:get_currency_by_country_result]

        # get currency names array
        currencies = (doc2.search("table currency").collect { |x| x.inner_html }).uniq

        # attach each currency to current country
        currencies.each do |e|
          currency = Currency.new :name => e.name
          currency.save

          monetization = Monetization.new :country_id => country.id, :currency_id => currency.id
          monetization.save
        end
      end

      flash[:info] = "Well, done!"
    rescue Exception => e
      logger.error e.message

      e.backtrace.each do |i|
        logger.debug i
      end

      flash[:errors] = [] if flash[:errors].nil?
      flash[:errors] << "Oh, i'm sorry! Seems that some error annoyed me while trying to get country data. Please, try again in a few minutes..."
    end
  end
end