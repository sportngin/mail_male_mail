module MailMaleMail
  module PostalService
    def self.api_request(url, message)
      uri = URI(url)
      req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
      req.body = message.to_json
      req.content_type = 'application/json'
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    end
    class DeliveryMethod
      class InvalidOption < StandardError; end

      attr_accessor :settings
      def initialize(options = {})
        raise InvalidOption, "A url option is required to send email using the Postal Service delivery method" if options[:url].nil?
        self.settings = options
      end
      def deliver!(mail)
        message = {}
        message[:to] = mail.to.join(", ")
        message[:subject] = mail.subject.to_s
        message[:from] = mail.from.to_s
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
        MailMaleMail::PostalService.api_request(self.settings[:url], message)
      end


    end
  end
end