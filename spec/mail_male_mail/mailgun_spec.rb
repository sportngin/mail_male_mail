require 'spec_helper'

class MMMMailgunMailer < MMMailer
  mailman :mailgun
  def test_mail
    mail_male_mail_category("MailgunCategory1")
    mail_male_mail_variables(:color => "green", :sound => "bark")
    mail(:subject => "Mailgun Testing", :from => "test@example.com", :to => "test2@example.com")
  end
end

module MailMaleMail
  describe Mailgun do
    it "should set the mailgun headers with tag and variables" do
      mail = MMMMailgunMailer.test_mail
      mail.header['X-Mailgun-Tag'].to_s.should == "MailgunCategory1"
      mail.header['X-Mailgun-Variables'].to_s.should == "{\"color\": \"green\", \"sound\": \"bark\"}"
    end
  end
end

