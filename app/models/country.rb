class Country < ActiveRecord::Base
  has_many :currencies
  has_many :currencies, :through => :monetizations

  has_many :initiaries
  has_many :initiaries, :through => :initiarizations
end
