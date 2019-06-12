module Paperclip
  class ManualCrop < Thumbnail
    def transformation_command
      if crop_command
        super.delete_if {|i| i.match(/-crop \S+/)}.prepend crop_command
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        " -crop '#{target.crop_width.to_i}x#{target.crop_height.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}'"
      end
    end
  end
end
