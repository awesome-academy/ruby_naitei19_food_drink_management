document.addEventListener("turbo:load", function() {
  document.addEventListener("click", function(event) {
    if (event.target.classList.contains("edit-order-item-button")) {
      event.preventDefault();

      var index = event.target.dataset.index;

      var popupDiv = document.createElement("div");
      popupDiv.className = "popup";

      var optionContainer = document.createElement("div");
      optionContainer.className = "option-container";

      fetch("/order_items/new?index=" + index)
        .then(response => response.text())
        .then(data => {
          optionContainer.innerHTML = data;
          popupDiv.appendChild(optionContainer);

          document.body.appendChild(popupDiv);
        });
    }
  });

  // Event for close
  document.addEventListener("click", function(event) {
    if (event.target.classList.contains("close-popup-button")) {
      let selected_element = document.querySelector(".popup")
      selected_element.remove()
    }
  });
});

function handleCloseModal(){
  let selected_element = document.querySelector(".popup")
  selected_element.className = "popupnon"
}

window.handleCloseModal = handleCloseModal
