desc "Update the Plans table with the latest data from Stripe"
task :sync_plans_with_stripe => :environment do
  if Rails.env == 'test'
    WebMock.allow_net_connect!
  end
  
  Stripe::Plan.all.each do |remote_plan|
    local_plan = Plan.find_by_name(remote_plan.id)
    if local_plan.present?
      local_plan.update_attributes!(price_in_cents: remote_plan.amount, interval: remote_plan.interval, description: remote_plan.name)
    else
      Plan.create!(name: remote_plan.id, price_in_cents: remote_plan.amount, interval: remote_plan.interval, description: remote_plan.name)
    end

  end

  if Rails.env == 'test'
    WebMock.disable_net_connect!
  end
end
