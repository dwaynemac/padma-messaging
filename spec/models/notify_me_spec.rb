require 'spec_helper'

describe NotifyMe do

  let(:app){FactoryGirl.create(:app, name: 'app-name')}
  let(:notify_me){FactoryGirl.create(:notify_me)}
  let(:message_key){ FactoryGirl.create(:message_key, name: 'this-name')}

  it { should validate_presence_of :app_id }
  it { should validate_presence_of :message_key_id }
  it { should validate_presence_of :url }

  it { should belong_to :app }
  it { should belong_to :message_key }

  describe "JSON version" do
    subject{notify_me.as_json.symbolize_keys!}
    it { should have_key :key_name }
    it { should have_key :app_name }
    it { should_not have_key :message_key_id }
    it { should_not have_key :app_id }
  end

  describe "#key_name" do
    before do
      notify_me.message_key = message_key
    end
    it "returns message key's name" do
      notify_me.key_name.should == message_key.name
    end
  end

  describe "#key_name=" do
    context "when message key with this name exists" do
      before { message_key } # create message key
      it "sets message_key_id" do
        notify_me.key_name = 'this-name'
        notify_me.message_key_id.should == message_key.id
      end
    end
    context "when message key with this name does NOT exist" do
      it "sets message_key_id TO NIL" do
        notify_me.key_name = 'some-other-name'
        notify_me.message_key_id.should be_nil
      end
    end
  end

  describe "#app_name" do
    before do
      notify_me.app = app
    end
    it "returns app's name" do
      notify_me.app_name.should == app.name
    end
  end

  describe "#app_name=" do
    context "when app with this name exists" do
      before { app } # create app
      it "sets app_id" do
        notify_me.app_name = 'app-name'
        notify_me.app_id.should == app.id
      end
    end
    context "when app with this name does NOT exist" do
      it "sets app_id TO NIL" do
        notify_me.app_name = 'name-that-doesnt-exist'
        notify_me.app_id.should be_nil
      end
    end
  end
end
