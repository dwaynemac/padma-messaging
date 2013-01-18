require 'spec_helper'

describe V0::MessagesController do
  before do
    FactoryGirl.create(:message_key, name: 'enrollment')
  end
  describe "POST create" do
    context "with existing app_key" do
      before do
        FactoryGirl.create(:app, name: 'an-app', app_key: 'secret-key')
        post :create,
             app_key: 'secret-key',
             message: {
               key_name: 'enrollment',
               data: {id: 1234}.to_json
            }
      end
      it { should respond_with 201 }
      it "cretas message" do
        Message.count.should == 1
      end
    end
    context "with unexistant app_key" do
      before do
        post :create, app_key: 'not-existing-key', message: {
            key_name: 'enrollment',
            data: {id: 1234}.to_json
        }
      end
      it { should respond_with 403 }
      it "wont create message" do
        Message.count.should == 0
      end
    end
  end
end
