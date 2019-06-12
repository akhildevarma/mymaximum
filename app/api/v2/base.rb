module V2
  class Base < Grape::API
  	mount V2::Login
  	mount V2::Teams
    mount V2::Inquiries
    mount V2::UsersDetails
    mount V2::Comments
    mount V2::Uploaders
    mount V2::ProviderSignups
    mount V2::DrugShortage
    mount V2::MMECalculator
  end
end
