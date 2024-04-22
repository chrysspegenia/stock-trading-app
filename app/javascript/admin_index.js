document.addEventListener("turbo:load", function () {
  // Function to toggle list visibility and update local storage
  function toggleListVisibility(
    wrapperSelector,
    toggleId,
    listSelector,
    storageKey
  ) {
    let wrapper = document.querySelector(wrapperSelector);
    if (wrapper) {
      let list = wrapper.querySelector(listSelector);
      if (list) {
        let isHidden = localStorage.getItem(storageKey) === "true";
        if (isHidden) {
          list.classList.add("hidden");
        }

        let toggle = wrapper.querySelector(`#${toggleId}`);
        if (toggle) {
          toggle.addEventListener("click", function () {
            list.classList.toggle("hidden");
            localStorage.setItem(storageKey, list.classList.contains("hidden"));
          });
        }
      }
    }
  }

  // Toggle pending traders list
  toggleListVisibility(
    ".pending-traders-wrapper",
    "pending-toggle-list",
    ".pending-traders-list",
    "pendingListHidden"
  );

  // Toggle approved traders list
  toggleListVisibility(
    ".approved-traders-wrapper",
    "approved-toggle-list",
    ".approved-traders-list",
    "approvedListHidden"
  );
});
