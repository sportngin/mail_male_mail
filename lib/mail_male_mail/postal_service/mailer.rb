module MailMaleMail
  module PostalService
    module Mailer
      def write_postal_service_headers
        if mmm_category == :use_subject_lines
          self.headers['X-PostalService-Category'] = message.subject
        elsif mmm_category
          self.headers['X-PostalService-Category'] = mmm_category
        end
        self.headers['X-PostalService-Data'] = mmm_variables.to_json.gsub(/(["\]}])([,:])(["\[{])/, '\\1\\2 \\3') if mmm_variables
      end
    end
  end
end
