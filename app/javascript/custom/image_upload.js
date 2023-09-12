document.addEventListener("turbo:load", function() {
  let image_upload = document.querySelector("#avatar-input")
  let image_preview = document.querySelector("#preview-img")
  image_upload.addEventListener("change", function(){
    readURL(image_upload, image_preview)
  })
})

function readURL(input, image) {
  let allowedExtensions = ["image/jpeg", "image/gif", "image/png"]
  if (input.files && input.files[0]) {
    var reader = new FileReader()
    reader.onload = function(e) {

      if (allowedExtensions.includes(input.files[0].type)) {
        image.setAttribute("src", e.target.result)
      } else {
        input.value = ""
        alert("Please select valid image!")
      }
    }
    reader.readAsDataURL(input.files[0])
  }
}
