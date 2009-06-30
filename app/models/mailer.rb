class Mailer < ActionMailer::Base
  def invitation(invitation)
    @recipients  = invitation.recipient_email
    @from        = invitation.creator.email
    @subject     = "邀请"
    @body        = {:invitation => invitation, 
                    :signup_url => "http://#{SITE_DOMAIN}/projects/#{invitation.project.id}/add_user?invitation_token=#{invitation.token}"}
  end
  
  def notify(notify)
    @recipients  = notify.user.email
    @from        = SITE_MAIL
    @subject     = "内网－－#{notify.user.project.name}"
    @body        = {:notify => notify}
  end
end
