require 'spec_helper'

describe V0::NotifyMeController do

  let(:app){FactoryGirl.create(:app, app_key: 'secret')}
  let(:message_key){FactoryGirl.create(:message_key)}

  before do
    app # create app
  end

  describe "#index" do
    before do
      FactoryGirl.create(:notify_me, app: app, message_key: message_key)
      get :index, app_key: 'secret'
    end
    let(:body){JSON.parse(response.body)}
    it { should respond_with 200 }
    it "includes list of message keys" do
      body['collection'].last.should == message_key.as_json
    end
    it "shows total" do
      body['total'].should == 1
    end
  end

  describe "#create" do
    before do
      post :create,
           app_key: 'secret',
           notify_me: {
               key_name: message_key.name,
               url: 'asd'
           }
    end
    it { should respond_with 201 }
    it 'creates a NotifyMe' do
      app.notify_mes.count.should == 1
    end
  end

  describe "#destroy" do
    let(:other_app){FactoryGirl.create(:app)}
    before do
      FactoryGirl.create(:notify_me, app: app, message_key: message_key)
    end
    context "with a valid key_name" do
      before do
        FactoryGirl.create(:notify_me, app: other_app, message_key: message_key)
        delete :destroy, app_key: 'secret', key_name: message_key.name
      end
      it { should respond_with 200 }
      it 'removes a NotifyMe' do
        app.notify_mes.count.should == 0
      end
      it 'doesnt unsubscribe other apps' do
        other_app.notify_mes.count.should == 1
      end
    end
    context "with a key name without app subscriptions" do
      before do
        FactoryGirl.create(:notify_me, app: other_app, message_key: message_key)
        delete :destroy, app_key: 'secret'
      end
      it { should respond_with 404 }
      it 'wont remove a NotifyMe' do
        app.notify_mes.count.should == 1
      end
      it 'doesnt unsubscribe other apps' do
        other_app.notify_mes.count.should == 1
      end
    end
  end

end
