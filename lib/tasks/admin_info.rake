namespace :admin_info do

  desc "Print list of users by number of inquires submitted"
  task :top_users => :environment do

    puts "Inquiry Count | Name | Phone Number | Email" unless Rails.env.test?
    Inquiry.all.pluck(:submitter_id).each_with_object(Hash.new(0)) { |ids,counts|
      counts[ids] += 1
    }.sort { |x, y|
      x[1] <=> y[1]
    }.each { |i|
      u = User.find(i[0]);
      p = u.profile;
      puts "#{i[1]} => #{p.first_name} #{p.last_name} #{p.phone_number} #{u.email}";
    }


  end

end
