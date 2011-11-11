require File.expand_path('helper', File.dirname(__FILE__))

describe Mail::MarshaledDelivery do

  describe "standalone tests" do
    before(:each) do
      @delivery = Mail::MarshaledDelivery.new
    end

    after(:each) do
      Mail::MarshaledDelivery.drop_storage
    end

    it "got initialized with the default settings" do
      Mail::MarshaledDelivery.storage.must_equal File.expand_path('./tmp/mails/marshaled_deliveries')
    end

    it "delivers to a file" do
      @delivery.deliver! "blah"
      File.must_be :exist?, Mail::MarshaledDelivery.storage
    end

    it "delivers correctly" do
      @delivery.deliver! "blah"
      Mail::MarshaledDelivery.deliveries.must_equal ["blah"]
    end

    it "returns [] if no deliverise" do
      File.size(Mail::MarshaledDelivery.storage).must_equal 0
      Mail::MarshaledDelivery.deliveries.must_equal []
    end
  end

  describe "Deliveries storage file" do
    before(:each) do
      @delivery = Mail::MarshaledDelivery.new
    end

    after(:each) do
      Mail::MarshaledDelivery.drop_storage
    end

    it "is created on initialization" do
      File.zero?(Mail::MarshaledDelivery.storage).must_equal true
      File.exist?(Mail::MarshaledDelivery.storage).must_equal true
    end

    it "is removed when #drop_storage" do
      @delivery.deliver! "blah"
      File.zero?(Mail::MarshaledDelivery.storage).must_equal false
      Mail::MarshaledDelivery.drop_storage
      File.exist?(Mail::MarshaledDelivery.storage).must_equal false
    end
  end

end
