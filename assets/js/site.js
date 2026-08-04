(function () {
  "use strict";

  var lensButtons = Array.prototype.slice.call(
    document.querySelectorAll("[data-lens-control]")
  );
  var lensPanels = Array.prototype.slice.call(
    document.querySelectorAll("[data-lens-panel]")
  );
  var lensEvidence = Array.prototype.slice.call(
    document.querySelectorAll("[data-lens-evidence]")
  );

  function setLens(lens) {
    lensButtons.forEach(function (button) {
      var selected = button.getAttribute("data-lens-control") === lens;
      button.setAttribute("aria-pressed", selected ? "true" : "false");
    });

    lensPanels.forEach(function (panel) {
      panel.hidden = panel.getAttribute("data-lens-panel") !== lens;
    });

    lensEvidence.forEach(function (item) {
      var tags = (item.getAttribute("data-lens-evidence") || "").split(" ");
      item.classList.toggle(
        "is-emphasized",
        lens !== "overview" && tags.indexOf(lens) !== -1
      );
      item.classList.toggle(
        "is-deemphasized",
        lens !== "overview" && tags.indexOf(lens) === -1
      );
    });
  }

  lensButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      setLens(button.getAttribute("data-lens-control"));
    });
  });

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

  var sectionLinks = Array.prototype.slice.call(
    document.querySelectorAll("[data-nav-section]")
  );
  var sections = sectionLinks
    .map(function (link) {
      return document.getElementById(link.getAttribute("data-nav-section"));
    })
    .filter(Boolean);

  if ("IntersectionObserver" in window && sections.length) {
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;

          sectionLinks.forEach(function (link) {
            var active =
              link.getAttribute("data-nav-section") === entry.target.id;
            if (active) {
              link.setAttribute("aria-current", "location");
            } else {
              link.removeAttribute("aria-current");
            }
          });
        });
      },
      { rootMargin: "-28% 0px -62% 0px", threshold: 0 }
    );

    sections.forEach(function (section) {
      observer.observe(section);
    });
  }
})();
