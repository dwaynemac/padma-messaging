require 'spec_helper'

describe AppMessageDelivery do
  it { should belong_to :app }
  it { should belong_to :message }
  it { should validate_presence_of(:app) }
  it { should validate_presence_of :message }
  
  describe "finished?" do
    let(:delivery){create(:app_message_delivery)}
    subject { delivery.finished? }
    describe "if delivered" do
      before do
        delivery.update_attribute(:delivered, true)
      end
      it { should be_true }
    end
    describe "if not delivered" do
      before do
        delivery.update_attribute(:delivered, false)
      end
      describe "and attempted > tolerance times" do
        before do
          delivery.update_attribute :attempts, AppMessageDelivery::ATTEMPTS_TOLERANCE + 1
        end
        it { should be_true }
      end
      describe "and attempted < tolerance times" do
        before do
          delivery.update_attribute :attempts, AppMessageDelivery::ATTEMPTS_TOLERANCE - 1
        end
        it { should be_false }
      end
    end
  end
  
end
