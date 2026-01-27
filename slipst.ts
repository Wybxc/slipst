import { signal, effect } from "@preact/signals-core";
import { debounce, isNotNil } from "es-toolkit";

document.querySelectorAll(".slip > svg").forEach((svg) => {
  if (svg instanceof SVGElement) {
    svg.style.width = "100%";
    svg.style.height = "auto";
  }
});

const currentSlip = signal(0);

const savedSlip = sessionStorage.getItem("slipst-current-slip");
if (savedSlip != null) {
  currentSlip.value = parseInt(savedSlip, 10);
}
document.documentElement.style.setProperty("--transition-time", "0s");
setTimeout(() => {
  document.documentElement.style.setProperty("--transition-time", "0.5s");
}, 1);
effect(() => {
  if (currentSlip.value > 0) {
    sessionStorage.setItem("slipst-current-slip", currentSlip.value.toString());
  }
});

const container = document.getElementById("container");
if (container) {
  container.addEventListener("click", () => (currentSlip.value += 1));
  container.addEventListener(
    "wheel",
    debounce(
      (event) => {
        if (event.deltaY > 0) {
          currentSlip.value += 1;
        } else if (event.deltaY < 0) {
          currentSlip.value -= 1;
        }
      },
      50,
      { edges: ["leading"] },
    ),
  );
}
document.addEventListener("keydown", (event) => {
  if (
    ["ArrowRight", "ArrowDown", "PageDown", " ", "Enter"].includes(event.key)
  ) {
    currentSlip.value += 1;
  } else if (
    ["ArrowLeft", "ArrowUp", "PageUp", "Backspace"].includes(event.key)
  ) {
    currentSlip.value -= 1;
  }
});

const maxSlip = Array.from(document.querySelectorAll(".slip"))
  .map((slip) => {
    const attr = slip.getAttribute("data-slip");
    return attr !== null ? parseInt(attr, 10) : 0;
  })
  .reduce((a, b) => Math.max(a, b), 0);

effect(() => {
  if (currentSlip.value <= 0) {
    currentSlip.value = 1;
  } else if (currentSlip.value > maxSlip) {
    currentSlip.value = maxSlip;
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
    document.documentElement.style.setProperty("--transition-time", "0s");
    layoutEffect();
    setTimeout(() => {
      document.documentElement.style.setProperty("--transition-time", "0.5s");
    }, 1);
  });
}
