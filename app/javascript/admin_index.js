document.addEventListener("turbo:load", function () {
  // Toggle pending traders list
  var pendingHeader = document.getElementById("pending-toggle-list");
  var pendingList = document.querySelector(".pending-traders-list");
  var isPendingHidden = localStorage.getItem("pendingListHidden") === "true";

  if (isPendingHidden) {
    pendingList.classList.add("hidden");
  }

  pendingHeader.addEventListener("click", function () {
    pendingList.classList.toggle("hidden");
    localStorage.setItem(
      "pendingListHidden",
      pendingList.classList.contains("hidden")
    );
  });

  // Toggle approved traders list
  var approvedHeader = document.getElementById("approved-toggle-list");
  var approvedList = document.querySelector(".approved-traders-list");
  var isApprovedHidden = localStorage.getItem("approvedListHidden") === "true";

  if (isApprovedHidden) {
    approvedList.classList.add("hidden");
  }

  approvedHeader.addEventListener("click", function () {
    approvedList.classList.toggle("hidden");
    localStorage.setItem(
      "approvedListHidden",
      approvedList.classList.contains("hidden")
    );
  });
});
