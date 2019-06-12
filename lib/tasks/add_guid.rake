namespace :add_guid do
  desc "Add Guid Table entry for published Inquiries"
  task :guid => :environment do
    Inquiry.published.each do |inquiry|
      if inquiry.guid.blank?
        Guid.create(referenceable: inquiry)
        puts "Added Guid entry for this inquiry with id: #{inquiry.id}"
      else
        puts "This inquiry has a guid entry with id: #{inquiry.id}"
      end
    end
  end
end
