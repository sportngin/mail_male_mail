require "yaml"
require 'json'
require "action_mailer"
require "mail_male_mail/sendgrid"
require "mail_male_mail/mailgun"
require "mail_male_mail/configuration"
require "mail_male_mail/postal_service/delivery_method"
require "mail_male_mail/postal_service/mailer"

module MailMaleMail
  PROVIDERS = %w(sendgrid mailgun postal_service)

  if defined? Rails::Railtie
    class MailMaleMailRailtie < Rails::Railtie
      initializer "mail_male_mail_initializer" do |app|
        unless File.exist? MailMaleMail::Configuration.filepath
          raise LoadError, "#{MailMaleMail::Configuration.filepath} is required for MailMaleMail and does not exist"
        end
        ActionMailer::Base.send(:include, MailMaleMail)
        ActionMailer::Base.add_delivery_method :postal_service, MailMaleMail::PostalService::DeliveryMethod, {}
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      Configuration.load
      include(Sendgrid)
      include(Mailgun)
      include(PostalService::Mailer)
      class << self
        attr_accessor :mmm_provider
      end
      attr_accessor :mmm_category, :mmm_variables
      alias_method_chain :mail, :mmm_headers

      mailman('default')
    end
  end

  def mail_with_mmm_headers(headers={}, &block)
    mail_without_mmm_headers(headers, &block).tap do |m|
      send("write_#{self.class.mmm_provider}_headers") if self.class.mmm_provider
    end
  end

  def mail_male_mail_category(category)
    self.mmm_category = category
  end

  def mail_male_mail_variables(variables)
    if variables.is_a?(Hash)
      self.mmm_variables = variables
    else
      raise TypeError, "variables must be a Hash"
    end
  end

  module ClassMethods
    def mailman(name)
      if config = Configuration.get(name)
        self.delivery_method = config['delivery_method'].to_sym if config.key?('delivery_method')
        if config.key?("#{self.delivery_method}_settings") && config["#{self.delivery_method}_settings"].is_a?(Hash)
          self.send("#{self.delivery_method}_settings=", config["#{self.delivery_method}_settings"].symbolize_keys)
        end
        if config.key?('provider') && PROVIDERS.include?(config['provider'])
          self.mmm_provider = config['provider']
        end
      end
    end
  end
end