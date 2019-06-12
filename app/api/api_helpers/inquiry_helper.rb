module ApiHelpers
  module InquiryHelper
    def validate_completed_inquiry
      if @resource.present? && (!@resource.closed? || !@resource.asap_inquiry?)
        validation_error(
          source: "/data/attributes/inquiry",
          title: "Inquiry does not qualify for reopen",
          detail: "Inquiry with id #{@resource.id} is incomplete/ non ASAP type and doesn't qualify for reopen.",
          code: :inquiry_does_not_qualify,
          status: :bad_request,
          meta: {
             error_type: 'validation_error',
             validation_error_code: :inquiry_does_not_qualify,
             validation_error_message: "Inquiry with id #{@resource.id} is incomplete/ non ASAP type and doesn't qualify for reopen."
          }
        )
      end
    end

  end
end
