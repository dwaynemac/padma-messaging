require 'spec_helper'

describe V0::MessagesController do
  before do
    App.delete_all
    create(:message_key, name: 'enrollment')
  end
  let(:app){ create(:app) }
  describe "POST create" do
    describe "with existing app_key" do
      before do
        post :create,
             app_key: app.app_key,
             message: {
               key_name: 'enrollment',
               data: {id: 1234}.to_json
            }
      end
      it { should respond_with 201 }
      it "creates message" do
        Message.count.should == 1
      end
    end
    describe "with unexistant app_key" do
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
