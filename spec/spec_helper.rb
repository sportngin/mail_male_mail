require 'rspec'
require 'debugger'

class Rails
  def self.root
    Pathname.new(__FILE__).dirname
  end

  def self.env
    "production"
  end
end

require "mail_male_mail"
ActionMailer::Base.send(:include, MailMaleMail)
ActionMailer::Base.add_delivery_method :postal_service, MailMaleMail::PostalService::DeliveryMethod, {:url => "http://example.com"}
class MMMailer < ActionMailer::Base
end

RSpec.configure do |config|
  config.after :each do
    MMMailer.class_eval do
      mailman :default
      self.mmm_provider = nil
    end
  end
end