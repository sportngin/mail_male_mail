require "yaml"
require 'json'
require "action_mailer"
require "mail_male_mail/sendgrid"
require "mail_male_mail/mailgun"
require "mail_male_mail/configuration"

module MailMaleMail
  PROVIDERS = %w(sendgrid mailgun)

  if defined? Rails::Railtie
    class MailMaleMailRailtie < Rails::Railtie
      initializer "mail_male_mail_initializer" do |app|
        unless File.exist? MailMaleMail::Configuration::FILEPATH
          raise LoadError, "#{MailMaleMail::Configuration::FILEPATH} is required for MailMaleMail and does not exist"
        end
        ActionMailer::Base.send(:include, MailMaleMail)
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      Configuration.load
      include(Sendgrid)
      include(Mailgun)
      class << self
        attr_accessor :mmm_provider
      end
      attr_accessor :mmm_category, :mmm_variables

      mailman('default')
    end
  end

  def mail(headers={}, &block)
    super(headers, &block).tap do |m|
      send("write_#{self.class.mmm_provider}_headers") if self.class.mmm_provider
    end
  end

  def set_mail_male_mail_category(category)
    self.mmm_category = category
  end
  alias :set_mmm_cateogry :set_mail_male_mail_category

  def set_mail_male_mail_variables(variables)
    if variables.is_a?(Hash)
      self.mmm_variables = variables
    else
      raise TypeError, "variables must be a Hash"
    end
  end
  alias :set_mmm_variables :set_mail_male_mail_variables

  module ClassMethods
    def mailman(name)
      if config = Configuration.get(name)
        self.delivery_method = config['delivery_method'].to_sym if config.key?('delivery_method')
        if config.key?('smtp_settings') && config['smtp_settings'].is_a?(Hash)
          self.smtp_settings = config['smtp_settings'].symbolize_keys
        end
        self.mmm_provider = config['provider'] if config.key?('provider') && PROVIDERS.include?(config['provider'])
      end
    end
  end
end