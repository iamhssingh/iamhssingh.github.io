(function () {
  "use strict";

  var quickSummary = document.querySelector("[data-quick-summary]");
  if (quickSummary) {
    var copyButton = quickSummary.querySelector("[data-copy-prompt]");
    var prompt = quickSummary.querySelector("textarea");
    var status = quickSummary.querySelector("[role='status']");

    copyButton.addEventListener("click", async function () {
      try {
        await navigator.clipboard.writeText(prompt.value);
        prompt.hidden = true;
        status.textContent = "Prompt copied.";
      } catch {
        status.textContent = "Copy the selected prompt.";
        prompt.hidden = false;
        prompt.focus();
        prompt.select();
      }
    });

    copyButton.hidden = false;
  }

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
