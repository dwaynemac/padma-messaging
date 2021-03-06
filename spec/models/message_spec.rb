require 'spec_helper'

describe Message do
  it { should validate_presence_of :app_id }
  it { should validate_presence_of :message_key_id }

  let(:app){create(:app, name: 'app-name')}
  let(:message){create(:message)}
  let(:message_key){ create(:message_key, name: 'this-name')}

  describe ".clear_all_finished" do
    let(:other_message){create(:message)}
    before do
      nm = create(:notify_me, message_key: other_message.message_key)
      create(:app_message_delivery, message: other_message, app: nm.app, delivered: false)

      3.times{create(:notify_me, message_key: message.message_key)}

      message.registered_apps.each do |app|
        message.mark_delivered_to(app)
      end
    end

    it 'destroys all fully delivered messages' do
      Message.clear_all_finished
      Message.all.should == [other_message]
    end

    it 'destroys messages with no apps subscribed' do
      tm = create(:message)
      Message.clear_all_finished
      Message.all.should_not include tm
    end
  end
  
  describe "#notify_subscribed_apps" do
    describe "if message finishes delivering" do
      before do
        Message.any_instance.stub(:finished_delivery?).and_return true
      end
      it "is destroyed" do
        message.notify_subscribed_apps
        Message.clear_all_finished
        expect(Message.where(id: message.id).count).to eq 0
      end
    end
  end

  describe "#queue_notification_requests" do
    let(:hydra){Typhoeus::Hydra.new}
    before do
      create(:notify_me, message_key: message_key)
      create(:notify_me, message_key: message_key)
      message.message_key = message_key
    end
    it "enqueues a request for each undelivered notify me" do
      message.save
      create(:app_message_delivery, message: message, delivered: false, app: NotifyMe.last.app)
      message.queue_notification_requests(hydra)
      hydra.queued_requests.count.should == 2
    end
    it 'doesnt enqueue if notifyme has been delivered' do
      message.save
      create(:app_message_delivery, message: message, delivered: true, app: NotifyMe.last.app)
      message.queue_notification_requests(hydra)
      hydra.queued_requests.count.should == 1
    end

  end

  describe "#mark_delivered_to" do
    it "creates new AppMessageDelivery with delivered=true" do
      expect{message.mark_delivered_to(app)}.to change{AppMessageDelivery.count}.by 1
      amd = AppMessageDelivery.last
      amd.app.should == app
      amd.message == message
      amd.should be_delivered
    end
    specify "#delivered_to?(same_app) returns true" do
      message.delivered_to?(app).should be_false
      message.mark_delivered_to(app)
      message.reload
      message.delivered_to?(app).should be_true
    end
  end

  describe "#finished_delivery?" do
    context "if message has been delivered to all subscribed apps" do
      before do
        3.times{create(:notify_me, message_key: message.message_key)}
        message.message_key.registered_apps.each do |app|
          create(:app_message_delivery, message: message, app: app, delivered: true)
        end
      end
      it 'returns true' do
        message.finished_delivery?.should be_true
      end
    end
    context "if message has NOT been delivered to all subscribed apps" do
      before do
        create(:notify_me, message_key: message.message_key)
        3.times{create(:app_message_delivery, message: message, delivered: true)}
      end
      it 'returns false' do
        message.finished_delivery?.should be_false
      end
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
