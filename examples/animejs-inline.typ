#import "../dist/lib.typ": *

#show: slipst

= Figure Anime.js inline

Voici une figure interactive autonome dans une slip.

#animejs(
  height: 7cm,
  style: ```display: grid; place-items: center;```,
  html: ```html
    <div class="stage">
      <div class="ball"></div>
      <div class="shadow"></div>
    </div>
  ```,
  css: ```css
    .stage {
      position: relative;
      width: 24em;
      height: 12em;
    }

    .ball {
      position: absolute;
      left: 4em;
      bottom: 3em;
      width: 3.6em;
      height: 3.6em;
      border-radius: 999px;
      background: radial-gradient(circle at 35% 28%, #fff7ed 0 10%, #fb923c 35%, #c2410c 100%);
      box-shadow: 0 1em 2em rgba(124, 45, 18, 0.35);
      transform-origin: 50% 100%;
    }

    .shadow {
      position: absolute;
      left: 4.4em;
      bottom: 2.5em;
      width: 2.8em;
      height: 0.45em;
      border-radius: 999px;
      background: rgba(15, 23, 42, 0.24);
      filter: blur(0.12em);
    }
  ```,
  js: ```js
    const ball = root.querySelector(".ball");
    const shadow = root.querySelector(".shadow");

    const jump = anime.createTimeline({ autoplay: true, loop: true });
    jump.add(ball, {
      translateX: ["0em", "16em"],
      translateY: ["0em", "-7em", "0em"],
      scaleX: [1.12, 0.92, 1.12],
      scaleY: [0.88, 1.12, 0.88],
      duration: 1100,
      ease: "inOutQuad",
    });
    jump.add(shadow, {
      translateX: ["0em", "16em"],
      scaleX: [1, 0.45, 1],
      opacity: [0.35, 0.12, 0.35],
      duration: 1100,
      ease: "inOutQuad",
    }, 0);

    return {
      onWheel({ deltaY }) {
        jump.pause();
        jump.seek(jump.currentTime + deltaY * 2);
      },
    };
  ```,
)

#pause

= Slip normale

Cette deuxieme slip contient une autre figure Anime.js. En mode static, la
molette controle uniquement cette figure, pas celle de la slip precedente.

#animejs(
  height: 5cm,
  html: ```html
    <div class="stage second">
      <div class="square"></div>
    </div>
  ```,
  css: ```css
    .stage {
      position: relative;
      width: 100%;
      height: 100%;
      overflow: hidden;
      border-radius: 1.2em;
      background: linear-gradient(135deg, #ecfeff, #cffafe);
      box-shadow: inset 0 0 0 0.08em rgba(8, 145, 178, 0.25);
    }

    .square {
      position: absolute;
      left: 3em;
      top: 3em;
      width: 4em;
      height: 4em;
      border-radius: 0.8em;
      background: #0891b2;
      box-shadow: 0 1em 2em rgba(8, 145, 178, 0.25);
    }
  ```,
  js: ```js
    const square = root.querySelector(".square");
    const timeline = anime.createTimeline({ autoplay: false });

    timeline.add(square, {
      translateX: ["0em", "20em"],
      rotate: ["0turn", "1turn"],
      duration: 1200,
      ease: "inOutSine",
    });

    return {
      onWheel({ deltaY }) {
        timeline.seek(timeline.currentTime + deltaY * 2);
      },
    };
  ```,
)

Le clic molette n'affiche rien : il change seulement le mode de controle.
