require 'spec_helper'

class MMMSendGridMailer < MMMailer
  mailman :sendgrid
  def test_mail
    mail_male_mail_category("SendgridCategory1")
    mail_male_mail_variables(:color => "blue", sound: "meow")
    mail(:subject => "Sengrid Testing", :from => "test@example.com", :to => "test2@example.com")
  end
end

module MailMaleMail
  describe Sendgrid do
    it "should set the X-SMTPAPI header with category unique_args" do
      mail = MMMSendGridMailer.test_mail
      mail.header['X-SMTPAPI'].to_s.should == "{\"category\": \"SendgridCategory1\", \"unique_args\": {\"color\": \"blue\", \"sound\": \"meow\"}}"
    end
  end
end

