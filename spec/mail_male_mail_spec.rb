require 'spec_helper'

describe MailMaleMail do
  it "should not ignore invalid providers" do
    MMMailer.class_eval {mailman :default}
    MMMailer.mmm_provider.should be_nil
  end
end