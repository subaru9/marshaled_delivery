require 'fileutils'

module Mail
  # This class can be registered as custom Mail/ActionMailer delivery method
  # See test/*_spec.rb for examples.
  class MarshaledDelivery

    attr_reader :settings
    @@settings = { :location => File.expand_path(File.join('.', 'tmp', 'mails')),
                   :filename => 'marshaled_deliveries' }

    def initialize values={}
      @settings = @@settings.merge!(values)
      create_storage
    end

    def deliver! mail
      deliveries = MarshaledDelivery.deliveries
      deliveries << mail

      File.open(MarshaledDelivery.storage, 'w') do |f|
        Marshal.dump(deliveries, f)
      end
    end

    def MarshaledDelivery.deliveries
      raise "Storage file not found" unless File.exist?(MarshaledDelivery.storage)
      deliveries = File.open(MarshaledDelivery.storage, 'r') do |f|
        Marshal.load(f) unless f.size == 0
      end
      deliveries || []
    end

    def MarshaledDelivery.storage
      File.join @@settings[:location], @@settings[:filename]
    end

    def MarshaledDelivery.drop_storage
      File.delete(MarshaledDelivery.storage) if File.exist?(MarshaledDelivery.storage)
    end

    private
    def create_storage
      return if File.exist?(MarshaledDelivery.storage)
      ::FileUtils.mkdir_p settings[:location]
      ::FileUtils.touch MarshaledDelivery.storage
    end

  end
end