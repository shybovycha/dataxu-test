class Currency < ActiveRecord::Base
  has_many :monetizations
  has_many :countries, :through => :monetizations
end
