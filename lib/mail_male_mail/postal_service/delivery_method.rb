module MailMaleMail
  module PostalService
    def self.api_request(settings, message)
      if settings[:method].to_s == "iron_mq"
        queue = IronMQ::Client.new(token: settings[:token], project_id: settings[:project_id]).queue(settings[:queue])
        queue.post(message.to_json)
      else
        uri = URI(url)
        req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
        req.body = message.to_json
        req.content_type = 'application/json'
        http = Net::HTTP.new(uri.host, uri.port)
        response = http.request(req)
      end
    end
    class DeliveryMethod
      class InvalidOption < StandardError; end

      attr_accessor :settings
      def initialize(options = {})
        unless options[:url].present? || options[:method].present?
          raise InvalidOption, "A url or method option is required to send email using the Postal Service delivery method"
        end
        self.settings = options
      end
      def deliver!(mail)
        message = {}
        message[:to] = mail.to.join(", ")
        message[:subject] = mail.subject.to_s
        message[:from] = mail.from.first.to_s
        message[:extra_provider_data] = ActiveSupport::JSON.decode(mail.header['X-PostalService-Data'].to_s) if mail.header['X-PostalService-Data']
        if mail.header['X-PostalService-Provider']
          message[:provider] = mail.header['X-PostalService-Provider'].to_s
        elsif self.settings[:provider]
          message[:provider] = self.settings[:provider]
        end

        message[:category] = mail.header['X-PostalService-Category'].to_s if mail.header['X-PostalService-Category']

        message[:text] = mail.text_part.body.to_s if mail.text_part
        message[:html] = mail.html_part.body.to_s if mail.html_part
        unless mail.text_part || mail.html_part
          part = mail.content_type =~ /html/ ? :html : :text
          message[part] = mail.body.to_s
        end
        MailMaleMail::PostalService.api_request(self.settings, message)
      end


    end
  end
end