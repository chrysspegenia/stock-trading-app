document.addEventListener("turbo:load", () => {
  const wrapper = document.querySelector(".main-custom-wrapper");

  if (wrapper) {
    // Check if wrapper exists
    const handleWrapperClick = (event) => {
      const container = wrapper.querySelector(".main-custom-container");

      if (event.target.classList.contains("register-link")) {
        container.classList.add("active");
      } else if (event.target.classList.contains("login-link")) {
        container.classList.remove("active");
      }
    };

    wrapper.addEventListener("click", handleWrapperClick);

    // Remove event listener when leaving page
    document.addEventListener("turbo:before-cache", () => {
      wrapper.removeEventListener("click", handleWrapperClick);
    });
  }
});
