module MailMaleMail
  module Mailgun
    def write_mailgun_headers
      if mmm_category == :use_subject_lines
        self.headers['X-Mailgun-Tag'] = message.subject
      elsif mmm_category
        self.headers['X-Mailgun-Tag'] = mmm_category
      end
      self.headers['X-Mailgun-Variables'] = mmm_variables.to_json.gsub(/(["\]}])([,:])(["\[{])/, '\\1\\2 \\3') if mmm_variables
    end
  end
end