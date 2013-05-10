require 'spec_helper'

class MMMPostalServiceMailer < MMMailer
  mailman :postal_service
  def test_mail
    mail_male_mail_category("PostalServiceCategory1")
    mail_male_mail_variables(:color => "yellow", :sound => "moo")
    mail(:subject => "PostalService Testing", :from => "test@example.com", :to => "test2@example.com")
  end
end

module MailMaleMail
  module PostalService
    describe Mailer do
      it "should set the postal service headers for category and data" do
        mail = MMMPostalServiceMailer.test_mail
        mail.header['X-PostalService-Category'].to_s.should == "PostalServiceCategory1"
        mail.header['X-PostalService-Data'].to_s.should == "{\"color\": \"yellow\", \"sound\": \"moo\"}"
      end
    end
  end
end

