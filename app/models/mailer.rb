class Mailer < ActionMailer::Base
  def invitation(invitation)
    @recipients  = invitation.recipient_email
    @from        = invitation.creator.email
    @subject     = "邀请"
    @body        = {:invitation => invitation, 
                    :signup_url => "http://#{SITE_DOMAIN}/projects/#{invitation.project.id}/add_user?invitation_token=#{invitation.token}"}
  end
end
