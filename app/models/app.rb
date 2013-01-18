class App < ActiveRecord::Base
  attr_accessible :app_key, :name

  validates_uniqueness_of :app_key
  validates_uniqueness_of :name
end
