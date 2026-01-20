import { signal, effect } from "https://esm.sh/@preact/signals-core@1.12.1";
import { debounce } from "https://esm.sh/es-toolkit@1.44.0?standalone&exports=debounce";

const currentSlip = signal(0);

document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".slip > svg").forEach((svg) => {
        svg.style.width = "100%";
        svg.style.height = "auto";
    });

    document.getElementById("container").addEventListener("click", () => currentSlip.value += 1);
    document.getElementById("container").addEventListener("wheel", debounce((event) => {
        if (event.deltaY > 0) {
            currentSlip.value += 1;
        } else if (event.deltaY < 0) {
            currentSlip.value -= 1;
        }
    }, 50));
    document.addEventListener("keydown", (event) => {
        if (["ArrowRight", "ArrowDown", "PageDown", " ", "Enter"].includes(event.key)) {
            currentSlip.value += 1;
        } else if (["ArrowLeft", "ArrowUp", "PageUp", "Backspace"].includes(event.key)) {
            currentSlip.value -= 1;
        }
    });
});

effect(() => {
    document.querySelectorAll(".slip").forEach((slip) => {
        const slipIndex = parseInt(slip.getAttribute("data-slip"), 10);
        if (slipIndex <= currentSlip.value) {
            slip.style.opacity = 1;
        } else {
            slip.style.opacity = 0;
        }
    });
});

const layoutEffect = () => {
    let up = document.querySelector(`[data-slip="${currentSlip.value}"]`)?.getAttribute("data-slip-up");
    for (let i = currentSlip.value - 1; i > 0; i--) {
        if (up != null) break;
        up = document.querySelector(`[data-slip="${i}"]`)?.getAttribute("data-slip-up");
    }
    if (up == null) {
        document.getElementById("container").style.top = 0;
    } else {
        const anchor = document.querySelector(`[data-slip="${up}"]`);
        document.getElementById("container").style.top = `${-anchor.offsetTop}px`;
    }
};
effect(layoutEffect);
document.defaultView.addEventListener("resize", () => {
    document.documentElement.style.setProperty("--transition-time", "0s");
    layoutEffect();
    setTimeout(() => {
        document.documentElement.style.setProperty("--transition-time", "0.5s");
    }, 0);
});