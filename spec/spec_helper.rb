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

class MMMailer < ActionMailer::Base
  include MailMaleMail
end

RSpec.configure do |config|
  config.after :each do
    MMMailer.class_eval do
      mailman :default
      self.mmm_provider = nil
    end
  end
end