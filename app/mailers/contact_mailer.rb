class ContactMailer < ApplicationMailer
  def contact_mail(contact)
    @contact = contact
    mail to: ENV["MAIL_TO"], subject: "[My Game DB] お問い合わせ"
  end
end
