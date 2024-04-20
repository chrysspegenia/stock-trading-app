document.addEventListener("DOMContentLoaded", () => {
  const wrapper = document.querySelector(".main-custom-wrapper");

  wrapper.addEventListener("click", (event) => {
    const container = wrapper.querySelector(".main-custom-container");

    if (event.target.classList.contains("register-link")) {
      container.classList.add("active");
    } else if (event.target.classList.contains("login-link")) {
      container.classList.remove("active");
    }
  });
});
