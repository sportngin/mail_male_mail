module MailMaleMail
  module Sendgrid
    def write_sendgrid_headers
      self.headers['X-SMTPAPI'] = build_sendgrid_json
    end

    private

    def build_sendgrid_json
      header_opts = {}

      if mmm_category == :use_subject_lines
        header_opts[:category] = message.subject
      elsif mmm_category
        header_opts[:category] = mmm_category
      end
      header_opts[:unique_args] = mmm_variables if mmm_variables

      header_opts.to_json.gsub(/(["\]}])([,:])(["\[{])/, '\\1\\2 \\3')
    end
  end
end