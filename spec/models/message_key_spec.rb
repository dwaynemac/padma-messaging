require 'spec_helper'

describe MessageKey do
  it { should validate_uniqueness_of :name }

  it { should have_many :allowed_apps }
  it { should have_many :registered_apps }
end
