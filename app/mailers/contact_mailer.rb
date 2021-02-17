class ContactMailer < ApplicationMailer
  def contact_mail(contact)
    @contact = contact
    mail to: "mhpdm541@gmail.com", subject: "[My Game DB] お問い合わせ"
  end
end
