require 'spec_helper'

describe App do
  it { should validate_uniqueness_of :app_key }
  it { should validate_uniqueness_of :name }

  it { should have_many :allowed_message_keys }
  it { should have_many :messages }
end
