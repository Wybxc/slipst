import { signal, effect } from "@preact/signals-core";
import { debounce, isNotNil } from "es-toolkit";
import AnyTouch from "any-touch";

const DEFAULT_TRANSITION_DURATION = "0.4s";

// Avoid initial fade/scroll animation when the page first loads or reloads.
document.documentElement.style.setProperty("--transition-duration", "0s");
requestAnimationFrame(() => {
  requestAnimationFrame(() => {
    document.documentElement.style.setProperty(
      "--transition-duration",
      DEFAULT_TRANSITION_DURATION,
    );
  });
});

document.querySelectorAll(".slip > svg").forEach((svg) => {
  if (svg instanceof SVGElement) {
    svg.style.width = "100%";
    svg.style.height = "auto";
  }
});

/**
 * Parse the hash in the URL to get the current slip index and alter index.
 * The hash should be in the format "#slip-alter".
 */
function parseHash() {
  const hashGroups = /^(?<slip>\d+)(?:-(?<alter>\d+))?/.exec(
    location.hash.slice(1),
  )?.groups;

  let slip = parseInt(hashGroups?.slip ?? "1", 10);
  if (isNaN(slip) || slip < 1) {
    slip = 1;
  }

  let alter = parseInt(hashGroups?.alter ?? "1", 10);
  if (isNaN(alter) || alter < 1) {
    alter = 1;
  }

  return { slip, alter };
}

const { slip: initialSlip, alter: initialAlter } = parseHash();
const currentSlip = signal(initialSlip);
const currentSlipAlter = signal(initialAlter);
effect(() => {
  let hash = `#${currentSlip.value}`;
  if (currentSlipAlter.value > 1) {
    hash += `-${currentSlipAlter.value}`;
  }
  if (location.hash !== hash) {
    history.replaceState(null, "", hash);
  }
});
window.addEventListener("hashchange", () => {
  const { slip, alter } = parseHash();
  if (slip !== currentSlip.value) {
    currentSlip.value = slip;
  }
  if (alter !== currentSlipAlter.value) {
    currentSlipAlter.value = alter;
  }
});

const maxSlip = Array.from(document.querySelectorAll(".slip"))
  .map((slip) => {
    const attr = slip.getAttribute("data-slip");
    return attr !== null ? parseInt(attr, 10) : 0;
  })
  .reduce((a, b) => Math.max(a, b), 0);

/**
 * Map from slip index to number of alters.
 */
const slipAlters = new Map(
  Array.from(document.querySelectorAll(".slip")).map((slip) => {
    const attrSlip = slip.getAttribute("data-slip");
    const attrAlter = slip.getAttribute("data-slip-alter-num");
    const slipIndex = attrSlip !== null ? parseInt(attrSlip, 10) : 0;
    const alterNum = attrAlter !== null ? parseInt(attrAlter, 10) : 1;
    return [slipIndex, alterNum] as const;
  }),
);

/**
 * Go to the next slip or alter.
 */
function nextSlip() {
  const alterNum = slipAlters.get(currentSlip.value) ?? 1;
  if (currentSlipAlter.value < alterNum) {
    currentSlipAlter.value += 1;
  } else if (currentSlip.value < maxSlip) {
    currentSlip.value += 1;
    currentSlipAlter.value = 1;
  }
}

/**
 * Go to the previous slip or alter.
 */
function previousSlip() {
  if (currentSlipAlter.value > 1) {
    currentSlipAlter.value -= 1;
  } else if (currentSlip.value > 1) {
    currentSlip.value -= 1;
    const alterNum = slipAlters.get(currentSlip.value) ?? 1;
    currentSlipAlter.value = alterNum;
  }
}

const main = document.querySelector("main");
if (main) {
  main.addEventListener("click", nextSlip);
  main.addEventListener(
    "wheel",
    debounce((event) => (event.deltaY > 0 ? nextSlip() : previousSlip()), 50, {
      edges: ["leading"],
    }),
  );
  const anyTouch = new AnyTouch(main);
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
    const attrSlip = slip.getAttribute("data-slip");
    const slipIndex = attrSlip !== null ? parseInt(attrSlip, 10) : 0;

    const attrAlter = slip.getAttribute("data-slip-alter-idx");
    const alterIdx = attrAlter !== null ? parseInt(attrAlter, 10) : 1;

    if (slip instanceof HTMLElement) {
      if (slipIndex < currentSlip.value) {
        // Previous slips, only show the last alter.
        if (alterIdx !== (slipAlters.get(slipIndex) ?? 1)) {
          slip.style.opacity = "0";
        } else {
          slip.style.opacity = "1";
        }
      } else if (slipIndex === currentSlip.value) {
        // Current slip, show the current alter.
        if (alterIdx === currentSlipAlter.value) {
          slip.style.opacity = "1";
        } else {
          slip.style.opacity = "0";
        }
      } else {
        // Future slips, hide all alters.
        slip.style.opacity = "0";
      }
    }
  });
});

const layoutEffect = () => {
  // Find the nearest slip with a "data-slip-up" attribute, starting from the current slip and going upwards.
  let up = document
    .querySelector(`[data-slip="${currentSlip.value}"]`)
    ?.getAttribute("data-slip-up");
  let dy = document
    .querySelector(`[data-slip="${currentSlip.value}"]`)
    ?.getAttribute("data-slip-dy");

  for (let i = currentSlip.value - 1; i > 0; i--) {
    if (isNotNil(up)) break;
    up = document
      .querySelector(`[data-slip="${i}"]`)
      ?.getAttribute("data-slip-up");
    dy = document
      .querySelector(`[data-slip="${i}"]`)
      ?.getAttribute("data-slip-dy");
  }

  if (isNotNil(up)) {
    const anchors = document.querySelectorAll(`[data-slip="${up}"]`);
    const anchor = Array.from(anchors)
      .filter((anchor) => anchor instanceof HTMLElement)
      .filter(
        (anchor) => window.getComputedStyle(anchor).display !== "none",
      )[0];
    const container = document.getElementById("container");
    if (anchor instanceof HTMLElement && container instanceof HTMLElement) {
      if (isNotNil(dy)) {
        const dyValue = parseFloat(dy);
        container.style.top = `calc(${-anchor.offsetTop}px - ${dyValue} * var(--slip-1cm))`;
      } else {
        container.style.top = `${-anchor.offsetTop}px`;
      }
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
        DEFAULT_TRANSITION_DURATION,
      );
    }, 1);
  });
}
