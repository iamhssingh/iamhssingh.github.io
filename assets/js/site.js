(function () {
  "use strict";

  var detailToggles = Array.prototype.slice.call(
    document.querySelectorAll("[data-details-toggle]")
  );

  detailToggles.forEach(function (button) {
    var target = document.querySelector(button.getAttribute("data-details-toggle"));
    if (!target) return;

    button.addEventListener("click", function () {
      var details = Array.prototype.slice.call(target.querySelectorAll("details"));
      var shouldOpen = details.some(function (item) {
        return !item.open;
      });

      details.forEach(function (item) {
        item.open = shouldOpen;
      });

      button.setAttribute("aria-pressed", shouldOpen ? "true" : "false");
      button.textContent = shouldOpen ? "Collapse all" : "Expand all";
    });
  });
})();
