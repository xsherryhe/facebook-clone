class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('no-reply@sleepy-springs-52383.herokuapp.com', 'Clonebook')
  layout "mailer"

  before_action :set_logo_attachment

  private

  def set_logo_attachment
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
  end
end
