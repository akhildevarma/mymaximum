require 'rails_helper'

describe 'Inquiry Tags API' do
    let!(:me) { login_as_student }
    let!(:inquiry) { create :inquiry }
    let!(:tag_count) { inquiry.tag_list.size }

    let(:response_json) { JSON.parse(response.body) }
    let(:db_inquiry) { Inquiry.find(inquiry.id) }
    let(:valid_request_params) do
      {
        inquiry_id: inquiry.id,
        tag_name: 'testtag'
      }
    end


    describe 'POST /api/legacy/inquiry_tags' do
      it 'creates a new tag for the inquiry' do
        expect do
          post legacy_api('inquiry_tags'), valid_request_params, @env
        end.to change { Inquiry.find(inquiry.id).tag_list.size }.from( tag_count ).to( tag_count+1 )
      end

    end

    describe 'DELETE /api/legacy/inquiry_tags' do
      it 'creates a new tag for the inquiry' do
        expect do
          delete legacy_api('inquiry_tags'), {
            inquiry_id: inquiry.id,
            tag_name: inquiry.tag_list.first
          } , @env
        end.to change { Inquiry.find(inquiry.id).tag_list.size }.from( tag_count ).to( tag_count-1 )
      end

    end

    def legacy_api(path)
      "/api/legacy/#{path.gsub('/','')}"
    end

end
