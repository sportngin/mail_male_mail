require "yaml"
require "action_mailer"

module MailMaleMail
  autoload :Configuration, "mail_male_mail/configuration"


  if defined? Rails::Railtie
    class MailMaleMailRailtie < Rails::Railtie
      initializer "mail_male_mail_initializer" do |app|
        ActionMailer::Base.send(:include, MailMaleMail)
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      Configuration.load
      mailman('default')
    end
  end

  module ClassMethods
    def mailman(name)
      config = Configuration.get(name)
      if config
        self.delivery_method = config['delivery_method'].to_sym if config.key?('delivery_method')
        self.smtp_settings = config['smtp_settings'].symbolize_keys if config.key?('smtp_settings') && config['smtp_settings'].is_a?(Hash)
      end
    end
  end
end