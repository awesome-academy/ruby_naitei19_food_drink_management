import consumer from "channels/consumer"

$(document).on("turbo:load",function() {
  $("#notif-icon").on("click", function(){
    $("#notif-modal").toggleClass("show")
  })
  $(document).on("click", function(event){
    if(event.target != $("#notif-icon")[0]){
      let modal = $("#notif-modal")
      if(modal.hasClass("show") && !modal[0].contains(event.target)){
        modal.removeClass("show")
      }
    }
  })
  $.ajax({
    url: "/notifications",
    type: "GET",
    data: {locale: window.location.pathname.split("/")[1] || "en"},
    success: function(data){
      $("#notif-modal").append(data)
    }
  })
  consumer.connection.open()
})
