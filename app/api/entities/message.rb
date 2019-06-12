
module Entities
  class Message < Grape::Entity
    expose :code
    expose :message
  end
end
