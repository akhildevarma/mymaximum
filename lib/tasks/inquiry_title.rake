namespace :inquiry_title do
  desc "Add Guid Table entry for published Inquiries"
  task :add => :environment do
    Inquiry.where("(title is NULL or title = '') and researchable_question is not null").each do |inquiry|
      inquiry.title = inquiry.researchable_question
      if inquiry.save
        puts "Successfully updated title for this inquiry with id : #{inquiry.id}"
      else
        puts "Failed to update title for this inquiry with id : #{inquiry.id} #{inquiry.errors.full_messages}"
      end
    end
  end
  task :recreate => :environment do
    Inquiry.where("title is not null and slug is not null").each do |inquiry|
      inquiry.send :assign_slug
      if inquiry.save
        puts "Successfully updated title for this inquiry with id : #{inquiry.id}"
      else
        puts "Failed to update title for this inquiry with id : #{inquiry.id} #{inquiry.errors.full_messages}"
      end
    end
  end
end
