require 'spec_helper'

class MMMMailgunMailer < MMMailer
  mailman :mailgun
  def test_mail
    set_mmm_cateogry("MailgunCategory1")
    set_mmm_variables(:color => "green", :sound => "bark")
    mail(:subject => "Mailgun Testing", :from => "test@example.com", :to => "test2@example.com")
  end
end

module MailMaleMail
  describe Sendgrid do
    it "should set the X-SMTPAPI header with category unique_args" do
      mail = MMMMailgunMailer.test_mail
      mail.header['X-Mailgun-Tag'].to_s.should == "MailgunCategory1"
      mail.header['X-Mailgun-Variables'].to_s.should == "{\"color\": \"green\", \"sound\": \"bark\"}"
    end
  end
end

