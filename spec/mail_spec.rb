require File.expand_path('helper', File.dirname(__FILE__))

describe "Mail gem integration" do
  before(:each) do
    Mail.defaults do
      delivery_method Mail::MarshaledDelivery, {:location => './tmp/mails', :filename => 'serialized'}
    end
  end

  after(:each) do
    Mail::MarshaledDelivery.drop_storage
    # fallback to default settings
    Mail.defaults do
      delivery_method Mail::MarshaledDelivery, { :location => File.expand_path(File.join('.', 'tmp', 'mails')),
                                                 :filename => 'marshaled_deliveries' }
    end
  end

  it "stores correct settings" do
    Mail.delivery_method.class.must_equal Mail::MarshaledDelivery
    Mail.delivery_method.settings[:location].must_equal './tmp/mails'
    Mail.delivery_method.settings[:filename].must_equal 'serialized'
  end

  it "delivers" do
    mail1 = Mail.deliver do
      from    'junkie1@tanga.com'
      to      'bellechic@tanga.com'
      subject 'a gas mask? a handmade robot!'
    end
    mail2 = Mail.deliver do
      from    'junkie2@tanga.com'
      to      'lolshirts@tanga.com'
      subject 'will work for bandwidth'
    end
    d = Mail::MarshaledDelivery.deliveries
    d.must_be_instance_of Array
    d.size.must_equal 2

    d[0].to.must_equal       mail1.to
    d[0].subject.must_equal  mail1.subject
    d[0].from.must_equal     mail1.from
    d[1].to.must_equal       mail2.to
    d[1].subject.must_equal  mail2.subject
    d[1].from.must_equal     mail2.from
  end
end