require 'spec_helper'

describe Message do
  it { should validate_presence_of :app_id }
  it { should validate_presence_of :message_key_id }

  let(:app){FactoryGirl.create(:app, name: 'app-name')}
  let(:message){Message.new()}
  let(:message_key){ FactoryGirl.create(:message_key, name: 'this-name')}

  describe "#notify_subscribed_apps" do

  end

  describe "#finished_delivery?" do
    context "if message has been delivered to all subscribed apps" do
      before do
      end
      it 'returns true'
    end
    context "if message has NOT been delivered to all subscribed apps" do
      before do
      end
      it 'returns false'
    end
  end

  # TODO refactor these to a matcher for SetByName module
  describe "#message_key_name" do
    before do
      message.message_key = message_key
    end
    it "returns message key's name" do
      message.key_name.should == message_key.name
    end
  end

  describe "#message_key_name=" do
    context "when message key with this name exists" do
      before { message_key } # create message key
      it "sets message_key_id" do
        message.key_name = 'this-name'
        message.message_key_id.should == message_key.id
      end
    end
    context "when message key with this name does NOT exist" do
      it "sets message_key_id TO NIL" do
        message.key_name = 'some-other-name'
        message.message_key_id.should be_nil
      end
    end
  end

  describe "#app_name" do
    before do
      message.app = app
    end
    it "returns app's name" do
      message.app_name.should == app.name
    end
  end

  describe "#app_name=" do
    context "when app with this name exists" do
      before { app } # create app
      it "sets app_id" do
        message.app_name = 'app-name'
        message.app_id.should == app.id
      end
    end
    context "when app with this name does NOT exist" do
      it "sets app_id TO NIL" do
        message.app_name = 'name-that-doesnt-exist'
        message.app_id.should be_nil
      end
    end
  end
end
