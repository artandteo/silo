class ApplicationMailer < ActionMailer::Base
  default from: 'contact@artandteo.com'
  layout 'mailer'
  content_type "text/html"
end
