require "yaml"

module MailMaleMail
  class Configuration
    class <<self
      def load
        @configurations ||= YAML.load(ERB.new(File.read(Rails.root.join("config/mail_male_mail.yml"))).result)[Rails.env]
      end

      def get(name)
        @configurations and @configurations[name.to_s]
      end
    end
  end
end