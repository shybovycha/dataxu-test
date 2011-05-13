class InitiariesController < ApplicationController
  # GET /initiaries
  # GET /initiaries.xml
  def index
    @initiaries = Initiary.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @initiaries }
    end
  end

  # GET /initiaries/1
  # GET /initiaries/1.xml
  def show
    @initiary = Initiary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @initiary }
    end
  end

  # GET /initiaries/new
  # GET /initiaries/new.xml
  def new
    @initiary = Initiary.new
    @countries = Country.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @initiary }
    end
  end

  # GET /initiaries/1/edit
  def edit
    @initiary = Initiary.find(params[:id])
  end

  # POST /initiaries
  # POST /initiaries.xml
  def create
    #raise "breakpoint"
    
    @initiary = Initiary.new(params[:initiary])
    @initiary.save

    params[:country].each do |c|
      country = Country.find c
      
      r = Initiarization.new :country_id => country.id, :initiary_id => @initiary.id
      r.save

      monetizations = Monetization.where :country_id => country.id

      monetizations.each do |m|
        m.update_attribute :collected, true
      end
    end

    respond_to do |format|
      if @initiary.save
        format.html { redirect_to(@initiary, :notice => 'Initiary was successfully created.') }
        format.xml  { render :xml => @initiary, :status => :created, :location => @initiary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @initiary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /initiaries/1
  # PUT /initiaries/1.xml
  def update
    @initiary = Initiary.find(params[:id])

    respond_to do |format|
      if @initiary.update_attributes(params[:initiary])
        format.html { redirect_to(@initiary, :notice => 'Initiary was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @initiary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /initiaries/1
  # DELETE /initiaries/1.xml
  def destroy
    @initiary = Initiary.find(params[:id])
    @initiary.destroy

    respond_to do |format|
      format.html { redirect_to(initiaries_url) }
      format.xml  { head :ok }
    end
  end
end
