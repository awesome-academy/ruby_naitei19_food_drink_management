$(document).on("turbo:load", function(){
  const navList = document.querySelectorAll(".navbar>ul>li>a")
  navList.forEach(navItem => {
    if(navItem.pathname === window.location.pathname) {
      $(navItem).addClass("active")
    }
  })
})
