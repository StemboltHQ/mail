# encoding: utf-8
require 'spec_helper'

describe "Mail::TestMailer" do
  before(:each) do
    # Reset all defaults back to original state
    Mail.defaults do
      delivery_method :smtp, { :address              => "localhost",
                               :port                 => 25,
                               :domain               => 'localhost.localdomain',
                               :user_name            => nil,
                               :password             => nil,
                               :authentication       => nil,
                               :enable_starttls_auto => true  }
      Mail::TestMailer.deliveries.clear
    end
  end

  it "should have no deliveries when first initiated" do
    Mail.defaults do
      delivery_method :test
    end
    Mail::TestMailer.deliveries.should be_empty
  end

  it "should deliver an email to the Mail::TestMailer.deliveries array" do
    Mail.defaults do
      delivery_method :test
    end
    mail = Mail.new do
      to 'mikel@me.com'
      from 'you@you.com'
      subject 'testing'
      body 'hello'
    end
    mail.deliver
    Mail::TestMailer.deliveries.length.should eq 1
    Mail::TestMailer.deliveries.first.should eq mail
  end

  it "should clear the deliveries when told to" do
    Mail.defaults do
      delivery_method :test
    end
    mail = Mail.new do
      to 'mikel@me.com'
      from 'you@you.com'
      subject 'testing'
      body 'hello'
    end
    mail.deliver
    Mail::TestMailer.deliveries.length.should eq 1
    Mail::TestMailer.deliveries.clear
    Mail::TestMailer.deliveries.should be_empty
  end

  it "should raise an error if no sender is defined" do
    Mail.defaults do
      delivery_method :test
    end
    lambda do
      Mail.deliver do
        to "to@somemail.com"
        subject "Email with no sender"
        body "body"
      end
    end.should raise_error('An SMTP From address is required to send a message. Set the message smtp_envelope_from, return_path, sender, or from address.')
  end

  it "should raise an error if no recipient if defined" do
    Mail.defaults do
      delivery_method :test
    end
    lambda do
      Mail.deliver do
        from "from@somemail.com"
        subject "Email with no recipient"
        body "body"
      end
    end.should raise_error('An SMTP To address is required to send a message. Set the message smtp_envelope_to, to, cc, or bcc address.')
  end

  it "should save settings passed to initialize" do
    Mail::TestMailer.new(:setting => true).settings.should include(:setting => true)
  end
end
