class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  before_action :set_logo_attachment

  private

  def set_logo_attachment
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
  end
end
