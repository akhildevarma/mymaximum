require('cropperjs/dist/cropper.css')
import Cropper from 'cropperjs'

var TeamAdminLogoCropper = {
  start: function() {
    var image = document.getElementById('logo-cropper');
    var cropper = new Cropper(image, {
      viewMode: 2,
      background: true,
      autoCrop: true,
      autoCropArea: 1,
      zoomable: false,
      crop: function(e) {
        var croppingAttributes = JSON.parse(document.getElementById('cropping-attributes').dataset.store);
        var that = this;
        croppingAttributes.forEach(function(value, index, array){
          document.getElementById(value).value = e.detail[value.replace('crop_','')]
        }, that)
      }
    });
  }
}

module.exports = TeamAdminLogoCropper
