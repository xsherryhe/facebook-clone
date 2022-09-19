class UserMailer < ApplicationMailer
  def welcome_email
    @profile = params[:user].profile
    mail(to: email_address_with_name(params[:user].email, @profile.full_name),
         subject: 'Welcome to Clonebook!')
  end
end
