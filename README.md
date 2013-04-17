MailMaleMail
==============

Manage mail configurations using configuration instead of code. This allows you to cleanly and easily swap mail settings.


## Usage

Create a config in config/mail_male_mail.yml file and specify your settings

```
production: &production
  mailman_1:
    delivery_method: smtp
    smtp_settings:
      address: "smtp.gmail.com"
      port: 587
development:
  <%= "<<: *production" if ENV['SEND_REAL_EMAILS'] == '1' %>
  default:
    delivery_method: letter_opener
test:
  default:
    delivery_method: test
```

In your mailer specify the 'mailman' to deliever the mail:

```
class MainMailer < ActionMailer::Base
  mailman :mailman_1s
end
```


