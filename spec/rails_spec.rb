require File.expand_path('helper', File.dirname(__FILE__))
require 'action_mailer'

class WarmKittyMailer < ActionMailer::Base
  DEFAULT_HEADERS = {
    :to => 'barsik@warm.kitty.net',
    :from => 'kukusya@warm.kitty.net',
    :subject => 'vegetarian diet for cats'
  }

  def welcome(hash={})
    mail(DEFAULT_HEADERS.merge(hash))
  end
end

describe "ActionMailer integration" do
  before(:each) do
    ActionMailer::Base.add_delivery_method :marshaled, Mail::MarshaledDelivery
  end

  it "adds as custom delivery method" do
    ActionMailer::Base.delivery_methods.must_include :marshaled
  end

  it "uses custom delivery method after assignment" do
    ActionMailer::Base.delivery_method = :marshaled
    ActionMailer::Base.delivery_method.must_equal :marshaled
  end

  describe "sending" do
    before(:each) do
      WarmKittyMailer.delivery_method = :marshaled
      WarmKittyMailer.perform_deliveries = true
      WarmKittyMailer.raise_delivery_errors = true
    end

    after(:each) do
      Mail::MarshaledDelivery.drop_storage
    end

    it "works" do
      WarmKittyMailer.welcome.deliver
      Mail::MarshaledDelivery.deliveries.size.must_equal 1
      d = Mail::MarshaledDelivery.deliveries.first
      d.to.must_equal [WarmKittyMailer::DEFAULT_HEADERS[:to]]
      d.from.must_equal [WarmKittyMailer::DEFAULT_HEADERS[:from]]
      d.subject.must_equal WarmKittyMailer::DEFAULT_HEADERS[:subject]
    end
  end

end