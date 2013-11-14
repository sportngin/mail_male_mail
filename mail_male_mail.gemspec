require File.expand_path('../lib/mail_male_mail/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carl Allen"]
  gem.email         = ["github@allenofmn.com"]
  gem.description   = %q{extend actionmailer to work with multiple mail providers}
  gem.summary       = %q{extend actionmailer to work with multiple mail providers}
  gem.homepage      = "http://github.com/carlallen/mail_male_mail"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "mail_male_mail"
  gem.require_paths = ["lib"]
  gem.license       = "MIT"
  gem.version       = MailMaleMail::VERSION

  gem.add_dependency "actionmailer", ">= 3.0.0"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "debugger"
end
