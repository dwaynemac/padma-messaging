require 'spec_helper'

describe MessageKey do
  it { should validate_uniqueness_of :name }
end
