document.addEventListener("turbo:load", function() {
  document.addEventListener("click", function(event) {
    if (event.target.classList.contains("add-to-cart-button")) {
      event.preventDefault();

      var cuisineId = event.target.dataset.cuisineId;

      var popupDiv = document.createElement("div");
      popupDiv.className = "popup";

      var optionContainer = document.createElement("div");
      optionContainer.className = "option-container";

      fetch("/options/new?cuisine_id=" + cuisineId)
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
