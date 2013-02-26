require 'spec_helper'

describe AppMessageDelivery do
  it { should belong_to :app }
  it { should belong_to :message }
  it { should validate_presence_of(:app) }
  it { should validate_presence_of :message }
end
