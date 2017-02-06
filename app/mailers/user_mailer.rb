class UserMailer < Devise::Mailer   
	include Devise::Mailers::Helpers
  	default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  	def confirmation_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
    end
end	