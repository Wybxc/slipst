import { signal, effect } from "https://esm.sh/@preact/signals-core@1.12.1";

const currentSlip = signal(0);

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".slip > svg").forEach(function (svg) {
        svg.style.width = "100%";
        svg.style.height = "auto";
    });

    document.getElementById("container").addEventListener("click", () => currentSlip.value += 1);
    document.addEventListener("keydown", function (event) {
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