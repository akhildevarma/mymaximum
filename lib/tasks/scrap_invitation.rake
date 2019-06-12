desc "Scrap database for invitations of uniq emails and save into a CSV"
task :scrap_invitation => :environment do
  CSV.open("./invites.csv", "wb") do |csv|
    csv << ['email', 'token', 'invitation_type'] #Invitation.attribute_names

    Invitation.select("distinct email").each do |invite|
      i = Invitation.find_by_email(invite.email, select: 'email, token, invitation_type')
      u = User.where(email: i.email)
      unless u.count > 0
        csv << i.attributes.values
      end
    end
  end
end