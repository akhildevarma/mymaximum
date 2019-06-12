
# To fix this error - 
# JsonApi::PaginationLinks requires a ActiveModelSerializers::SerializationContext.\n 
# Please pass a ':serialization_context' option or\n override CollectionSerializer#paginated? to return 'false'.\n
module ActiveModel
  class Serializer
    class CollectionSerializer
      def paginated?
        false
      end
    end
  end
end
