MailMaleMail
==============

Manage mail configurations using configuration instead of code. This allows you to cleanly and easily swap mail settings.


## Usage

### Config File

Create a config in config/mail_male_mail.yml file and specify your settings

```
#config/mail_male_mail.yml
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

### Mailman

In your mailer specify the 'mailman' to deliever the mail:

```
class MainMailer < ActionMailer::Base
  mailman :mailman_1
end
```

### Categories/Variables

MailMaleMale supports Sendgrid Categories/UniqArgs and Mailgun Tags/Varibales

<table>
<tr><th>MailMaleMail</th><th>Sendgrid</th><th>Mailgun</th></tr>
<tr><td>category</td><td>category</td><td>tag</td></tr>
<tr><td>variables</td><td>unique args</td><td>variables</td></tr>
</table>

```
class MainMailer < ActionMailer::Base
  def test_email
    set_mail_male_mail_category("CategoryName")
    set_mail_male_mail_variables(:key1 => "value1", :key2 => "value2")
    mail(...)
  end
end
```

To add this functionality, add sendgrid/mailgun to the provider in your config

```
#config/mail_male_mail.yml
production:
  sendgrid_mailman:
    provider: sendgrid
  mailgun_mailman:
    provider: mailgun
```

