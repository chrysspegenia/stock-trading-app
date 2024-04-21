document.addEventListener("turbo:load", () => {
  document.addEventListener("DOMContentLoaded", () => {
    // Wait for DOM content to load
    const wrapper = document.querySelector(".main-custom-wrapper");

    if (wrapper) {
      // Check if wrapper exists before adding event listener
      wrapper.addEventListener("click", (event) => {
        const container = wrapper.querySelector(".main-custom-container");

        if (event.target.classList.contains("register-link")) {
          container.classList.add("active");
        } else if (event.target.classList.contains("login-link")) {
          container.classList.remove("active");
        }
      });
    }
  });
});
