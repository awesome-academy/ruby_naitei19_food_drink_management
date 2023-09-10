document.addEventListener("turbo:load", function(){
  let selected_element = document.querySelector("#account")
  selected_element.addEventListener("click", function(event){
    event.preventDefault()
    let menu = document.querySelector("#dropdown-menu")
    menu.classList.toggle("show")
  })
})
