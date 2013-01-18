require 'spec_helper'

describe AppAllowedKey do
  it { should validate_uniqueness_of(:message_key_id).scoped_to(:app_id)}
  it { should belong_to :app }
  it { should belong_to :message_key }
end
