document.addEventListener("turbo:load", function () {
  var header = document.getElementById("toggle-list");
  var list = document.querySelector(".pending-traders-list");

  // Retrieve the state from local storage
  var isHidden = localStorage.getItem("pendingListHidden") === "true";

  // Set initial visibility based on the stored state
  if (isHidden) {
    list.classList.add("hidden");
  }

  // Toggle the 'hidden' class and update local storage when clicking the header
  header.addEventListener("click", function () {
    list.classList.toggle("hidden");
    // Update local storage with the current state
    localStorage.setItem(
      "pendingListHidden",
      list.classList.contains("hidden")
    );
  });
});
