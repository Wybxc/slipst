import { signal, effect } from "@preact/signals-core";
import { debounce, isNotNil } from "es-toolkit";
import AnyTouch from "any-touch";

document.querySelectorAll(".slip > svg").forEach((svg) => {
  if (svg instanceof SVGElement) {
    svg.style.width = "100%";
    svg.style.height = "auto";
  }
});

const currentSlip = signal(parseInt(location.hash.slice(1), 10) || 1);
effect(() => {
  history.replaceState(null, "", `#${currentSlip.value}`);
});
window.addEventListener("hashchange", () => {
  const hashSlip = parseInt(location.hash.slice(1), 10);
  if (!isNaN(hashSlip) && hashSlip !== currentSlip.value) {
    currentSlip.value = hashSlip;
  }
});

const maxSlip = Array.from(document.querySelectorAll(".slip"))
  .map((slip) => {
    const attr = slip.getAttribute("data-slip");
    return attr !== null ? parseInt(attr, 10) : 0;
  })
  .reduce((a, b) => Math.max(a, b), 0);

function nextSlip() {
  if (currentSlip.value < maxSlip) {
    currentSlip.value += 1;
  }
}

function previousSlip() {
  if (currentSlip.value > 1) {
    currentSlip.value -= 1;
  }
}

const container = document.getElementById("container");
if (container) {
  container.addEventListener("click", nextSlip);
  container.addEventListener(
    "wheel",
    debounce((event) => (event.deltaY > 0 ? nextSlip() : previousSlip()), 50, {
      edges: ["leading"],
    }),
  );
  const anyTouch = new AnyTouch(container);
  anyTouch.on("swipeup", nextSlip);
  anyTouch.on("swipeleft", nextSlip);
  anyTouch.on("swiperight", previousSlip);
  anyTouch.on("swipedown", previousSlip);
}
document.addEventListener("keydown", (event) => {
  if (
    ["ArrowRight", "ArrowDown", "PageDown", " ", "Enter"].includes(event.key)
  ) {
    nextSlip();
  } else if (
    ["ArrowLeft", "ArrowUp", "PageUp", "Backspace"].includes(event.key)
  ) {
    previousSlip();
  }
});

effect(() => {
  document.querySelectorAll(".slip").forEach((slip) => {
    const attr = slip.getAttribute("data-slip");
    const slipIndex = attr !== null ? parseInt(attr, 10) : 0;
    if (slip instanceof HTMLElement) {
      if (slipIndex <= currentSlip.value) {
        slip.style.opacity = "1";
      } else {
        slip.style.opacity = "0";
      }
    }
  });
});

const layoutEffect = () => {
  let up = document
    .querySelector(`[data-slip="${currentSlip.value}"]`)
    ?.getAttribute("data-slip-up");
  for (let i = currentSlip.value - 1; i > 0; i--) {
    if (isNotNil(up)) break;
    up = document
      .querySelector(`[data-slip="${i}"]`)
      ?.getAttribute("data-slip-up");
  }
  if (isNotNil(up)) {
    const anchor = document.querySelector(`[data-slip="${up}"]`);
    const container = document.getElementById("container");
    if (anchor instanceof HTMLElement && container instanceof HTMLElement) {
      container.style.top = `${-anchor.offsetTop}px`;
    }
  } else {
    const container = document.getElementById("container");
    if (container instanceof HTMLElement) {
      container.style.top = "0";
    }
  }
};
effect(layoutEffect);
if (document.defaultView) {
  document.defaultView.addEventListener("resize", () => {
    document.documentElement.style.setProperty("--transition-duration", "0s");
    layoutEffect();
    setTimeout(() => {
      document.documentElement.style.setProperty(
        "--transition-duration",
        "0.5s",
      );
    }, 1);
  });
}
