#import "../dist/lib.typ": *
#import "template_html.typ": book, corollary, definition, lemma, proof, proposition, remark, small
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.5.2"
#import "@preview/lilaq:0.6.0" as lq

#show: slipst.with(show-fn: book)

#let footer = [This work is supported by the French National Research Agency in the framework of the "France 2030” program: ANR 15 IDEX 02 and ANR-11-LABX-0025-01 for the LabEx PERSYVAL.]

#let citation = [How an actual entity becomes constitutes what that actual entity is; so that the two descriptions of an actual entity are not independent. Its ‘being’ is constituted by its ‘becoming.’ This is the ‘principle of process’.]
#let citation_author = [Alfred North Whitehead]
#let title = [Contextuality as Automata: Open Generators and the Dynamics of Quantum Phenomena]
#let author = [louis TRIOULEYRE-ROBERJOT]

#let date = datetime(
  year: 2026,
  month: 6,
  day: 24,
).display()

#let def-color = rgb("#16a34a")
#let soa-color = rgb("#ea580c")
#let ours-color = rgb("#dc2626")
#let neutral-color = rgb("#64748b")
#let blue-color = rgb("#0075d9")
#let def-fill = def-color.transparentize(95%)
#let soa-fill = soa-color.transparentize(95%)
#let ours-fill = ours-color.transparentize(95%)
#let neutral-fill = neutral-color.transparentize(95%)

#let dcol(it) = text(fill: def-color, it)
#let ncol(it) = text(fill: neutral-color, it)
#let rcol(it) = text(fill: ours-color, it)
#let ocol(it) = text(fill: soa-color, it)
#let bcol(it) = text(fill: blue-color, it)

#let card(fill-color, stroke-color, body) = rect(
  width: 100%,
  inset: 0.7em,
  radius: 0.5em,
  fill: fill-color,
  stroke: 0.7pt + stroke-color,
)[#body]

#let def-card(body) = card(def-fill, def-color)[#body]
#let neutral-card(body) = card(neutral-fill, neutral-color)[#body]
#let orange-card(body) = card(soa-fill, soa-color)[#body]
#let red-card(body) = card(ours-fill, ours-color)[#body]
#let soa-card(body) = card(soa-fill, soa-color)[#body]
#let ours-card(body) = card(ours-fill, ours-color)[#body]

#let formula-card(body) = def-card[
  #set par(justify: false)
  #body
]

#let soa-formula(body) = soa-card[
  #set par(justify: false)
  #body
]

#let ours-formula(body) = ours-card[
  #set par(justify: false)
  #body
]

#let compact(body) = {
  set par(justify: false, spacing: 0.35em)
  set text(size: 0.9em)
  body
}

#let donly = uncover.with(cover: fletcher.hide, raw: true)

#v(3em)

#right()

blabla

#right()
// START here

= From Observation to Theory

== The Laboratory

#def-card[
  A theory is an *explanation* of an experiment.
]

#pause
#diagram(
  $
    edge("-|>", label: "results") & (v_1,v_1,v_2,v_3) edge("-|>", label: "statistics") & p = vec(1/2, 1/4, 1/4)
  $,
)

#pause
#up(offset: -1)

#neutral-card[
  In 1982, Alain Aspect's experiments observed correlations that cannot be explained by any local (classical) theory. @Bell_1964
]<ref:bell>



#pause
Experimental correlations live between two natural bounds:
the classical set $ℒ$ and the non-signaling set $𝒩 𝒮$.
// // https://arxiv.org/abs/1303.2849v3
// #image("bell_corr.png", width: 20%)
#align(center, lq.diagram(
  width: 4cm,
  height: 4cm,
  xlim: (-1.15, 1.15),
  ylim: (-1.15, 1.15),
  xlabel: $S$,
  ylabel: $S'$,
  grid: none,
  legend: (position: bottom),

  // Non-signaling square
  lq.plot(
    (-1, 1, 1, -1, -1),
    (-1, -1, 1, 1, -1),
    label: $𝒩 𝒮$,
    stroke: blue + 1.3pt,
  ),

  // Quantum region, approximated by a circle
  lq.plot(
    (
      1,
      0.966,
      0.866,
      0.707,
      0.5,
      0.259,
      0,
      -0.259,
      -0.5,
      -0.707,
      -0.866,
      -0.966,
      -1,
      -0.966,
      -0.866,
      -0.707,
      -0.5,
      -0.259,
      0,
      0.259,
      0.5,
      0.707,
      0.866,
      0.966,
      1,
    ),
    (
      0,
      0.259,
      0.5,
      0.707,
      0.866,
      0.966,
      1,
      0.966,
      0.866,
      0.707,
      0.5,
      0.259,
      0,
      -0.259,
      -0.5,
      -0.707,
      -0.866,
      -0.966,
      -1,
      -0.966,
      -0.866,
      -0.707,
      -0.5,
      -0.259,
      0,
    ),
    label: $𝒬$,
    stroke: purple + 1.4pt,
    smooth: true,
  ),

  // Local set
  lq.plot(
    (0, 1, 0, -1, 0),
    (1, 0, -1, 0, 1),
    label: $ℒ$,
    stroke: green + 1.5pt,
  ),
  lq.scatter(
    (0.45,),
    (0.65,),
    label: $p$,
    mark: "o",
    // fill: red,
    // stroke: red,
  ),
))
#notes(
  "NS is upper bound theory",
)
#pause
#up(offset: -1)
Let $t$ such that $|N|_1 = 4 t$ for technical reason.
#def-card[
  *Quantum theory*, formulated with Hilbert spaces, are formulated with *$t -> infinity$*.
]

//   Quantum theory, formulated with Hilbert spaces, explains these observed correlations very well.
// But in the usual picture, correlations are described as limiting statistics:
// they appear as points $p$ obtained when the number of experimental runs $t$ becomes large.
#pause
#up(offset: -1)

- For example, with only *4 experimental runs*, it may be impossible to realize a statistic $p ∈ 𝒬$.
- At this finite scale: either $p ∈ ℒ$ or may even fall outside $𝒩 𝒮$.
- Our goal is to develop a *constructive approach*: for each finite value of $t$, we want to describe which empirical models are possible and which are not.

#pause
#up()
#diagram(
  $
    edge("-|>", label: "results") & (v_1,v_1,v_2,v_3) edge("-|>", label: "countings") & N_1 = vec(1, 0, 0) -> N_2 = vec(2, 0, 0) -> N_3 = vec(2, 1, 0) -> N_4 = vec(2, 1, 1)
  $,
)


#pause
#up(offset: -1)
#red-card[
  We want to observe the trajectory by which a correlation $p$ is progressively built.
]
#pause
Why does this *create a lattice*? Since $p = N/t$, for example with $t = 4$, there are only 4 possibles correlations for $p$.
#pause
#up()
#animejs(
  height: 8cm,
  style: "display: grid; place-items: center;",
  html: read("anime.html"),
  css: ```css
    .scene3d {
      width: 100%;
      height: 100%;
      position: relative;
      display: grid;
      place-items: center;
      overflow: hidden;
      border-radius: 1em;
      background:
        radial-gradient(circle at 50% 35%, rgba(219, 234, 254, 0.95), rgba(255, 255, 255, 0.98) 45%, rgba(241, 245, 249, 0.96));
      font-family: ui-sans-serif, system-ui, sans-serif;
    }

    .cone3d {
      width: 100%;
      height: 100%;
      display: block;
    }

    .hud {
      position: absolute;
      left: 1em;
      bottom: 0.8em;
      display: flex;
      flex-direction: column;
      gap: 0.15em;
      padding: 0.55em 0.75em;
      border: 1px solid rgba(148, 163, 184, 0.38);
      border-radius: 0.75em;
      background: rgba(255, 255, 255, 0.78);
      backdrop-filter: blur(6px);
      color: #0f172a;
      font-size: 0.74em;
      box-shadow: 0 0.8em 2em rgba(15, 23, 42, 0.10);
    }

    .hud span {
      color: #64748b;
      font-size: 0.9em;
    }
  ```,
  js: ```js
  const canvas = root.querySelector(".cone3d");
  const ctx = canvas.getContext("2d");

  const colors = {
    axis: "#334155",
    grid: "rgba(148, 163, 184, 0.45)",
    rayLocal: "rgba(37, 99, 235, 0.45)",
    rayPr: "rgba(234, 88, 12, 0.50)",
    t1: "#2563eb",
    t2: "#ea580c",
    t3: "#16a34a",
    t4: "#7c3aed",
    t5: "#64748b",
    t6: "#0891b2",
    t7: "#be123c",
    t8: "#ca8a04",
    path1: "#2563eb",
    path2: "#ea580c",
    target: "#dc2626",
  };

  const sliceColors = [
    colors.t1,
    colors.t2,
    colors.t3,
    colors.t4,
    colors.t5,
    colors.t6,
    colors.t7,
    colors.t8,
  ];

  function resize() {
    const r = canvas.getBoundingClientRect();
    const dpr = Math.max(1, window.devicePixelRatio || 1);
    canvas.width = Math.floor(r.width * dpr);
    canvas.height = Math.floor(r.height * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }

  resize();
  window.addEventListener("resize", resize);

  function nsIntegerPoints(t) {
    const pts = [];
    for (let s = -4 * t; s <= 4 * t; s++) {
      for (let sp = -4 * t; sp <= 4 * t; sp++) {
        const lattice =
          (((s - 2 * t) % 4) + 4) % 4 === 0 &&
          (((sp - 2 * t) % 4) + 4) % 4 === 0;

        if (lattice && Math.abs(s) + Math.abs(sp) <= 4 * t) {
          pts.push({ x: s, y: sp, z: t, t });
        }
      }
    }
    return pts;
  }

  function diamond(t) {
    return [
      { x: 4 * t, y: 0, z: t },
      { x: 0, y: 4 * t, z: t },
      { x: -4 * t, y: 0, z: t },
      { x: 0, y: -4 * t, z: t },
    ];
  }

  const maxT = 8;

  const points = [];
  for (let t = 1; t <= maxT; t++) {
    points.push(...nsIntegerPoints(t));
  }

  const local = [
    { x: 2, y: 2, z: 1 },
    { x: 2, y: -2, z: 1 },
    { x: -2, y: 2, z: 1 },
    { x: -2, y: -2, z: 1 },
  ];

  const pr = [
    { x: 8, y: 0, z: 2 },
    { x: -8, y: 0, z: 2 },
    { x: 0, y: 8, z: 2 },
    { x: 0, y: -8, z: 2 },
  ];

  // Target point at level t = 8.
  // It satisfies |S| + |S′| <= 4t, because 16 + 8 <= 32.
  const A = { x: 16, y: 8, z: 8, label: "A", color: colors.target };

  // Two integer trajectories from the origin to A.
  // Each step goes from level t to level t + 1.
  const trajectory1 = [
    { x: 0, y: 0, z: 0 },
    { x: 2, y: 2, z: 1 },
    { x: 4, y: 4, z: 2 },
    { x: 6, y: 6, z: 3 },
    { x: 8, y: 4, z: 4 },
    { x: 10, y: 6, z: 5 },
    { x: 12, y: 8, z: 6 },
    { x: 14, y: 10, z: 7 },
    A,
  ];

  const trajectory2 = [
    { x: 0, y: 0, z: 0 },
    { x: 2, y: -2, z: 1 },
    { x: 4, y: 0, z: 2 },
    { x: 6, y: 2, z: 3 },
    { x: 8, y: 4, z: 4 },
    { x: 10, y: 2, z: 5 },
    { x: 12, y: 4, z: 6 },
    { x: 14, y: 6, z: 7 },
    A,
  ];

  let wheel = 0;
  let yawOffset = 10;
  let targetZoom = 1;

  function rotate3(p, yaw, pitch) {
    const scaleXY = 0.72;
    const scaleZ = 2.1;

    let x = p.x * scaleXY;
    let y = p.y * scaleXY;
    let z = p.z * scaleZ;

    const cy = Math.cos(yaw);
    const sy = Math.sin(yaw);

    const x1 = x * cy - y * sy;
    const y1 = x * sy + y * cy;

    const cp = Math.cos(pitch);
    const sp = Math.sin(pitch);

    const y2 = y1 * cp - z * sp;
    const z2 = y1 * sp + z * cp;

    return { x: x1, y: y2, z: z2 };
  }

  function cameraProject(p, yaw, pitch, zoom, w, h) {
    const r = rotate3(p, yaw, pitch);
    const distance = 51;
    const perspective = distance / (distance - r.z);
    const focal = 20 * zoom;

    return {
      x: w * 0.5 + r.x * focal * perspective,
      y: h * 0.60 - r.y * focal * perspective,
      depth: r.z,
      scale: perspective,
    };
  }

  function drawLine3(a, b, yaw, pitch, zoom, w, h, color, width = 1, dash = []) {
    const pa = cameraProject(a, yaw, pitch, zoom, w, h);
    const pb = cameraProject(b, yaw, pitch, zoom, w, h);

    ctx.save();
    ctx.strokeStyle = color;
    ctx.lineWidth = width;
    ctx.setLineDash(dash);
    ctx.lineCap = "round";
    ctx.beginPath();
    ctx.moveTo(pa.x, pa.y);
    ctx.lineTo(pb.x, pb.y);
    ctx.stroke();
    ctx.restore();
  }

  function drawPolyline3(path, yaw, pitch, zoom, w, h, color, width = 3) {
    for (let i = 0; i < path.length - 1; i++) {
      drawLine3(path[i], path[i + 1], yaw, pitch, zoom, w, h, color, width);
    }
  }

  function drawText3(p, body, yaw, pitch, zoom, w, h, color = "#0f172a", dx = 0, dy = 0) {
    const q = cameraProject(p, yaw, pitch, zoom, w, h);

    ctx.save();
    ctx.fillStyle = color;
    ctx.font = "600 15px ui-sans-serif, system-ui";
    ctx.fillText(body, q.x + dx, q.y + dy);
    ctx.restore();
  }

  function drawPoint2(q, radius, color, stroke = "white") {
    ctx.save();
    ctx.beginPath();
    ctx.arc(q.x, q.y, radius * q.scale, 0, Math.PI * 2);
    ctx.fillStyle = color;
    ctx.fill();
    ctx.lineWidth = 1.2;
    ctx.strokeStyle = stroke;
    ctx.stroke();
    ctx.restore();
  }

  function frame(time) {
    const rect = canvas.getBoundingClientRect();
    const w = rect.width;
    const h = rect.height;

    ctx.clearRect(0, 0, w, h);

    const autoYaw = Math.sin(time * 0.00025) * 0.25;
    const yaw = Math.PI / 2 + autoYaw + yawOffset;
    const pitch = -1.05;
    const zoom = 1.0 + (targetZoom - 1.0) * Math.min(1, Math.abs(wheel));

    // Axes.
    drawLine3({ x: -34, y: 0, z: 0 }, { x: 34, y: 0, z: 0 }, yaw, pitch, zoom, w, h, colors.axis, 1.5);
    drawLine3({ x: 0, y: -34, z: 0 }, { x: 0, y: 34, z: 0 }, yaw, pitch, zoom, w, h, colors.axis, 1.5);
    drawLine3({ x: 0, y: 0, z: 0 }, { x: 0, y: 0, z: 9 }, yaw, pitch, zoom, w, h, colors.axis, 1.7);

    for (const v of [-32, -24, -16, -8, 0, 8, 16, 24, 32]) {
      drawLine3({ x: v, y: -0.45, z: 0 }, { x: v, y: 0.45, z: 0 }, yaw, pitch, zoom, w, h, colors.grid, 0.8);
      drawLine3({ x: -0.45, y: v, z: 0 }, { x: 0.45, y: v, z: 0 }, yaw, pitch, zoom, w, h, colors.grid, 0.8);
    }

    // Cone slice diamonds.
    for (let t = 1; t <= maxT; t++) {
      const d = diamond(t);
      for (let i = 0; i < d.length; i++) {
        drawLine3(
          d[i],
          d[(i + 1) % d.length],
          yaw,
          pitch,
          zoom,
          w,
          h,
          "rgba(100, 116, 139, 0.32)",
          1.0,
          [5, 5],
        );
      }
    }

    // Generator rays.
    for (const p of local) {
      drawLine3({ x: 0, y: 0, z: 0 }, p, yaw, pitch, zoom, w, h, colors.rayLocal, 1.6);
    }

    for (const p of pr) {
      drawLine3({ x: 0, y: 0, z: 0 }, p, yaw, pitch, zoom, w, h, colors.rayPr, 1.8);
    }

    // Two dynamic trajectories.
    drawPolyline3(trajectory1, yaw, pitch, zoom, w, h, colors.path1, 3.0);
    drawPolyline3(trajectory2, yaw, pitch, zoom, w, h, colors.path2, 3.0);

    const drawable = [];

    for (const p of points) {
      const q = cameraProject(p, yaw, pitch, zoom, w, h);
      drawable.push({
        kind: "point",
        q,
        r: 3.2,
        color: sliceColors[p.t - 1],
        depth: q.depth,
      });
    }

    // Add trajectory vertices.
    for (const p of trajectory1) {
      const q = cameraProject(p, yaw, pitch, zoom, w, h);
      drawable.push({
        kind: "path1",
        q,
        r: 5.2,
        color: colors.path1,
        depth: q.depth + 0.15,
      });
    }

    for (const p of trajectory2) {
      const q = cameraProject(p, yaw, pitch, zoom, w, h);
      drawable.push({
        kind: "path2",
        q,
        r: 5.2,
        color: colors.path2,
        depth: q.depth + 0.15,
      });
    }

    // Add target on top.
    const qA = cameraProject(A, yaw, pitch, zoom, w, h);
    drawable.push({
      kind: "target",
      q: qA,
      r: 9.5,
      color: colors.target,
      depth: qA.depth + 0.4,
    });

    drawable.sort((a, b) => a.depth - b.depth);

    for (const d of drawable) {
      drawPoint2(d.q, d.r, d.color);
    }

    drawText3({ x: 33, y: 0, z: 0 }, "S", yaw, pitch, zoom, w, h, "#334155", 6, 4);
    drawText3({ x: 0, y: 33, z: 0 }, "S′", yaw, pitch, zoom, w, h, "#334155", 6, 4);
    drawText3({ x: 0, y: 0, z: 9.3 }, "t", yaw, pitch, zoom, w, h, "#334155", 6, -4);

    drawText3(A, "A at t = 8", yaw, pitch, zoom, w, h, colors.target, 12, -9);

    ctx.save();
    ctx.fillStyle = "rgba(15, 23, 42, 0.72)";
    ctx.font = "12px ui-sans-serif, system-ui";
    ctx.fillText("Two integer trajectories from (0,0,0) to the same admissible point A at level t = 8.", 18, 24);
    ctx.fillText("Each step moves from one integer point to a nearby integer point at the next level.", 18, 42);
    ctx.restore();

    requestAnimationFrame(frame);
  }

  requestAnimationFrame(frame);

  return {
    onWheel({ deltaY }) {
      yawOffset += deltaY * 0.004;
      wheel = Math.max(0, Math.min(1, wheel + deltaY * 0.0012));
      targetZoom = 1.0 + 0.65 * wheel;
    },
  };
  ```,
)

#notes(
  "Each floor represent the possible correlation with t events compatible with the non-signaling theory, Before we have a surface and a point, now we have a cone and a trajectory.",
)

#pause
#up(offset: -1, dy: 2cm)

#red-card[
  We need to give a *meaning* to all the intermediate experiments,
  whereas the usual quantum formalism gives meaning mainly to the limiting statistics.
]

#right()

= Dynamic Automata

// We do not start from a completed state.

#pause

// We start from a process.

#neutral-card[
  *What happens during the production* of this final counts $N$.
]


#pause

#def-card[
  A *generator family* $cal(G) subset.eq NN^V$ is the elementary explanations of our theory.
]
#pause
Example of $𝒢$:
$
  g_(1 2) = mat(0, 1, 1, 0; 0, 1, 1, 0; 0, 0, 0, 0; 0, 0, 0, 0) ; g_(3 3) = mat(0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 1, 1; 0, 0, 1, 1) ; g_(4 2) = mat(0, 1, 1, 0; 0, 0, 0, 0; 0, 0, 0, 0; 0, 1, 1, 0) ; dots
$

#notes(
  "This is the elementary block of the non-signaling theory ; the (hilbert basis of the cone i show you with the animation)",
)

// DIAGRAM TODO: Cone of compatible countings with local deterministic generators and lifted PR generators as elementary rays.

#pause
#up()

How to build $g$ ? What is the meaning of *being doing $g$*.
#pause
#import "@preview/autograph:0.1.0" as autograph
#import "@preview/fletcher:0.5.8": shapes
#let edge-style = (
  stroke: 0.6pt + black,
  mark: (end: ">", fill: blue, scale: 0.7),
)
#let automaton-edge(from, to, label) = (
  autograph.edge(from, to, ..edge-style),
  // fletcher.edge(from, to, label, stroke: none),
)
#align(center, scale(70%, reflow: true)[
  #autograph.diagram(
    bezier: true,
    node-stroke: black,
    node-fill: white,
    edge-stroke: 0.1pt + blue,
    mark-scale: 10%,

    autograph.node(<g>, $g = mat(1, 1; 1, 1)$, shape: shapes.rect, stroke: red, inset: 0.50em),
    autograph.node(<z>, $0$, shape: shapes.rect, stroke: red, inset: 0.25em),

    autograph.node(<s234>, $mat(0, 1; 1, 1)$),
    autograph.node(<s134>, [], radius: 0.55em),
    autograph.node(<s124>, $mat(1, 1; 0, 1)$),
    autograph.node(<s123>, [], radius: 0.55em),

    autograph.node(<s12>, [], radius: 0.55em),
    autograph.node(<s13>, [], radius: 0.55em),
    autograph.node(<s14>, [], radius: 0.55em),
    autograph.node(<s23>, [], radius: 0.55em),
    autograph.node(<s24>, [], radius: 0.55em),
    autograph.node(<s34>, $mat(0, 0; 1, 1)$),

    autograph.node(<s1>, [], radius: 0.55em),
    autograph.node(<s2>, [], radius: 0.55em),
    autograph.node(<s3>, [], radius: 0.55em),
    autograph.node(<s4>, $mat(0, 0; 0, 1)$),

    automaton-edge(<g>, <s234>, $epsilon_1$),
    automaton-edge(<g>, <s134>, $epsilon_2$),
    automaton-edge(<g>, <s124>, $epsilon_3$),
    automaton-edge(<g>, <s123>, $epsilon_4$),

    automaton-edge(<s234>, <s34>, $epsilon_2$),
    automaton-edge(<s234>, <s24>, $epsilon_3$),
    automaton-edge(<s234>, <s23>, $epsilon_4$),

    automaton-edge(<s134>, <s34>, $epsilon_1$),
    automaton-edge(<s134>, <s14>, $epsilon_3$),
    automaton-edge(<s134>, <s13>, $epsilon_4$),

    automaton-edge(<s124>, <s24>, $epsilon_1$),
    automaton-edge(<s124>, <s14>, $epsilon_2$),
    automaton-edge(<s124>, <s12>, $epsilon_4$),

    automaton-edge(<s123>, <s23>, $epsilon_1$),
    automaton-edge(<s123>, <s13>, $epsilon_2$),
    automaton-edge(<s123>, <s12>, $epsilon_3$),

    automaton-edge(<s12>, <s2>, $epsilon_1$),
    automaton-edge(<s12>, <s1>, $epsilon_2$),

    automaton-edge(<s13>, <s3>, $epsilon_1$),
    automaton-edge(<s13>, <s1>, $epsilon_3$),

    automaton-edge(<s14>, <s4>, $epsilon_1$),
    automaton-edge(<s14>, <s1>, $epsilon_4$),

    automaton-edge(<s23>, <s3>, $epsilon_2$),
    automaton-edge(<s23>, <s2>, $epsilon_3$),

    automaton-edge(<s24>, <s4>, $epsilon_2$),
    automaton-edge(<s24>, <s2>, $epsilon_4$),

    automaton-edge(<s34>, <s4>, $epsilon_3$),
    automaton-edge(<s34>, <s3>, $epsilon_4$),

    automaton-edge(<s1>, <z>, $epsilon_1$),
    automaton-edge(<s2>, <z>, $epsilon_2$),
    automaton-edge(<s3>, <z>, $epsilon_3$),
    automaton-edge(<s4>, <z>, $epsilon_4$),
  )
])
#pause
#def-card[
  A *residual state* of $g$ is an element $R$ such that $0 <= R < g$.
]
#notes(
  "A generator is not produced all at once: it can be produced event by event. Key word: residual state. Say: 'The residual is what remains to be produced.' Top = everything remains, bottom = nothing remains.",
)
#pause
#up(offset: -2, dy: 1.5em)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 0.8em,
  def-card[#compact[#strong[Open]

    residual $R > 0$]],

  def-card[#compact[#strong[Closed]

    residual $R = 0$]],
)
#notes(
  "Vocabulary to fix: open = not finished, emission = one event is produced, closed = finished. Do not add new notation.",
)
#pause
#up(offset: -1)
#import "@preview/pavemat:0.2.0": pavemat
#let pav = pavemat(
  pave: (
    (path: "SDDW", from: (0, 0)),
    (path: "WDDS", from: (4, 0)),
    (path: "SSDDWW", from: (0, 1)),
    (path: "SSDDWW", from: (0, 2)),
  ),
  fills: (
    "0-0": blue.transparentize(70%),
    "3-0": blue.transparentize(70%),
    "1-1": red.transparentize(70%),
    "1-2": color.mix(red.transparentize(70%), green.transparentize(70%)),
    "0-3": green.transparentize(70%),
    "0-1": color.mix(red.transparentize(70%), blue.transparentize(70%)),
  ),
)[$mat(
  1, 2, 2, 1;
  0, 1, 2, 1;
  0, 0, 0, 0;
  1, 1, 0, 0
)$]
We can express observation with a sum of elementary explanation $N = pav = g_(4 1) + g_(1 2) + g_(1 3)$
#notes(
  "Say: 'A visible observation can be decomposed as a sum of complete elementary blocks.' This is the classical/static decomposition.",
)
#pause
#up()
#let pavresi = pavemat(
  pave: (
    (path: "SSDDWW", from: (0, 0)),
    (path: "WWDDSS", from: (4, 0)),
  ),
  // fills: (),
)[$mat(1, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; 1, 1, 0, 0)$]

We can express observation with *residual state* : $N = pavresi = g_(4 1) = (g_(1 1) minus mat(0, 0, 0, 0; 1, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0) ) + (g_(1 3) - mat(0, 0, 0, 0; 0, 0, 0, 0; 1, 1, 0, 0; 0, 0, 0, 0) )$
#notes(
  "Important contrast: same visible count can also be seen as incomplete generators. Say: 'This is a dynamic explanation, because some blocks are still open.'",
)
#pause
#red-card[
  We view an observation as *something we are in the process of producing*.
]
<p4>
#notes(
  "Main conceptual sentence. Pause after it. This is the philosophical core: observation = partial process, not only final table.",
)
// #align(center, fletcher.diagram(
//   node-stroke: black,
//   node((0, 0), $g$, name: <g>, stroke: red),
//   edge((-1, 0), <g>, "-|>"),
//   node((2.2, -0.9), $g - epsilon_v$, name: <gv>),
//   edge(<g>, <gv>, $v$, "-|>"),

//   node((2.2, 0.9), $g - epsilon_w$, name: <gw>),
//   edge(<g>, <gw>, $w$, "-|>"),

//   node((4.1, 0), $dots$, name: <dots>),

//   edge(<gv>, <dots>, $dots$, "-|>"),
//   edge(<gw>, <dots>, $dots$, "-|>"),

//   node((6.2, -0.9), $epsilon_u$, name: <eu>),
//   node((6.2, 0.9), $epsilon_t$, name: <et>),

//   edge(<dots>, <eu>, "-|>"),
//   edge(<dots>, <et>, "-|>"),

//   node((8.4, 0), $0$, name: <zero>, stroke: red, extrude: (0, -3)),
//   edge(<eu>, <zero>, $u$, "-|>"),
//   edge(<et>, <zero>, $t$, "-|>"),
// ))
#pause

=== Dynamic States
#let ins = $mono("in")$
#pause
#align(center, scale(80%, reflow: true)[
  #diagram(
    node-stroke: black,
    node-fill: white,
    edge-stroke: 0.8pt + black,

    node((0, 0), $g_1$, name: <g1>, stroke: red),
    node((1.2, 0), $dots$, name: <d1a>, stroke: none, fill: none, inset: 0pt),
    node((2.4, 0), $(g_1,R_1)$, name: <r1>),
    node((3.6, 0), $dots$, name: <d1b>, stroke: none, fill: none, inset: 0pt),
    node((4.8, 0), $0$, name: <z1>, stroke: red),
    edge(<g1>, <d1a>, "-|>"),
    edge(<d1a>, <r1>, "-|>"),
    edge(<r1>, <d1b>, "-|>"),
    edge(<d1b>, <z1>, "-|>"),

    node((0, 1), $g_1$, name: <g2>, stroke: red),
    node((1.2, 1), $dots$, name: <d2a>, stroke: none, fill: none, inset: 0pt),
    node((2.4, 1), $(g_1,R_2)$, name: <r2>),
    node((3.6, 1), $dots$, name: <d2b>, stroke: none, fill: none, inset: 0pt),
    node((4.8, 1), $0$, name: <z2>, stroke: red),
    edge(<g2>, <d2a>, "-|>"),
    edge(<d2a>, <r2>, "-|>"),
    edge(<r2>, <d2b>, "-|>"),
    edge(<d2b>, <z2>, "-|>"),

    node((0, 2), $g_2$, name: <g3>, stroke: red),
    node((1.2, 2), $dots$, name: <d3a>, stroke: none, fill: none, inset: 0pt),
    node((2.4, 2), $(g_2,R_3)$, name: <r3>),
    node((3.6, 2), $dots$, name: <d3b>, stroke: none, fill: none, inset: 0pt),
    node((4.8, 2), $0$, name: <z3>, stroke: red),
    edge(<g3>, <d3a>, "-|>"),
    edge(<d3a>, <r3>, "-|>"),
    edge(<r3>, <d3b>, "-|>"),
    edge(<d3b>, <z3>, "-|>"),
  )
])
#pause
#up(offset: -1)
#alter(2)

#def-card[
  Let $eta = 𝕆_η := {{(g,R) | g ∈ 𝒢 and 0 <= R <= g}}uncover("2-", = (c_eta, O_eta))$ an multiset of intermediate automaton state, $η$ *explain* $N$ if :
  $
    N = sum_((g,R) ins 𝕆_η) g minus R uncover("2-", = sum_(g ∈ 𝒢) c_η (g) · g + sum_((g,R) ins O_η) g minus R)
  $
]
#pause
#def-card[
  The explanation set of visible count $N$ is $ℋ_𝒢 (N) := {η | N_η = N} = {𝕆 | sum_((g,R) ins 𝕆_η) g minus R = N}$
]
#pause
#up(offset: -2)


#def-card[
  The *completed future* of $η$ is $F_eta = sum_((g,R) ins 𝕆_η) g = N_η + sum_((g,R) ins O_η) R$
]

#def-card[
  The *stabilized past* of $η$ is $P_η = sum_((g,0) ins 𝕆_η) g = sum_(g ∈ 𝒢) c_η (g) · g$
]

#notes(
  "Explain the three views: past = closed part, observation = what we see now, future = what we get if all open generators finish. This prepares the next picture.",
)
// DIAGRAM TODO: Main trajectory picture with P_eta on the left, N_eta in the middle, F_eta on the right.

#pause
#up(offset: -1)

=== The Signature of an Interruption
#pause
#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 0.8em,
  def-card[#compact[#strong[Past]

    $P_eta$: closed explanation]],
  def-card[#compact[#strong[Visible]

    $N_eta$: observed count]],
  def-card[#compact[#strong[Future]

    $F_eta$: completed count]],
)

#pause
#up()
#animejs(
  height: 8cm,
  style: "display: grid; place-items: center;",
  html: ```html
    <div class="scene3d">
      <canvas class="cone3d"></canvas>
      <div class="hud">
        <b>3D non-signaling cone</b>
        <span>Wheel: rotate camera / zoom toward P-N-F</span>
      </div>
    </div>
  ```,
  css: ```css
    .scene3d {
      width: 100%;
      height: 100%;
      position: relative;
      display: grid;
      place-items: center;
      overflow: hidden;
      border-radius: 1em;
      background:
        radial-gradient(circle at 50% 35%, rgba(219, 234, 254, 0.95), rgba(255, 255, 255, 0.98) 45%, rgba(241, 245, 249, 0.96));
      font-family: ui-sans-serif, system-ui, sans-serif;
    }

    .cone3d {
      width: 100%;
      height: 100%;
      display: block;
    }

    .hud {
      position: absolute;
      left: 1em;
      bottom: 0.8em;
      display: flex;
      flex-direction: column;
      gap: 0.15em;
      padding: 0.55em 0.75em;
      border: 1px solid rgba(148, 163, 184, 0.38);
      border-radius: 0.75em;
      background: rgba(255, 255, 255, 0.78);
      backdrop-filter: blur(6px);
      color: #0f172a;
      font-size: 0.74em;
      box-shadow: 0 0.8em 2em rgba(15, 23, 42, 0.10);
    }

    .hud span {
      color: #64748b;
      font-size: 0.9em;
    }
  ```,
  js: ```js
    const canvas = root.querySelector(".cone3d");
    const ctx = canvas.getContext("2d");

    const colors = {
      axis: "#334155",
      grid: "rgba(148, 163, 184, 0.45)",
      rayLocal: "rgba(37, 99, 235, 0.45)",
      rayPr: "rgba(234, 88, 12, 0.50)",
      t1: "#2563eb",
      t2: "#ea580c",
      t3: "#16a34a",
      t4: "#7c3aed",
      t5: "#64748b",
      P: "#2563eb",
      N: "#dc2626",
      F: "#16a34a",
    };

    const sliceColors = [colors.t1, colors.t2, colors.t3, colors.t4, colors.t5];

    function resize() {
      const r = canvas.getBoundingClientRect();
      const dpr = Math.max(1, window.devicePixelRatio || 1);
      canvas.width = Math.floor(r.width * dpr);
      canvas.height = Math.floor(r.height * dpr);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    }

    resize();
    window.addEventListener("resize", resize);

    function nsIntegerPoints(t) {
      const pts = [];
      for (let s = -4 * t; s <= 4 * t; s++) {
        for (let sp = -4 * t; sp <= 4 * t; sp++) {
          const lattice = (((s - 2 * t) % 4) + 4) % 4 === 0
            && (((sp - 2 * t) % 4) + 4) % 4 === 0;
          if (lattice && Math.abs(s) + Math.abs(sp) <= 4 * t) {
            pts.push({ x: s, y: sp, z: t, t });
          }
        }
      }
      return pts;
    }

    function diamond(t) {
      return [
        { x: 4 * t, y: 0, z: t },
        { x: 0, y: 4 * t, z: t },
        { x: -4 * t, y: 0, z: t },
        { x: 0, y: -4 * t, z: t },
      ];
    }

    const points = [];
    for (let t = 1; t <= 5; t++) points.push(...nsIntegerPoints(t));

    const local = [
      { x: 2, y: 2, z: 1 },
      { x: 2, y: -2, z: 1 },
      { x: -2, y: 2, z: 1 },
      { x: -2, y: -2, z: 1 },
    ];

    const pr = [
      { x: 8, y: 0, z: 2 },
      { x: -8, y: 0, z: 2 },
      { x: 0, y: 8, z: 2 },
      { x: 0, y: -8, z: 2 },
    ];

    const P = { x: 2, y: 2, z: 1, label: "P", color: colors.P };
    const N = { x: 14, y: 6, z: 3, label: "N", color: colors.N };
    const F = { x: 14, y: 6, z: 5, label: "F", color: colors.F };

    let wheel = 0;
    let yawOffset = 1.4;
    let targetZoom = 1;

    function rotate3(p, yaw, pitch) {
      const scaleXY = 0.72;
      const scaleZ = 2.55;
      let x = p.x * scaleXY;
      let y = p.y * scaleXY;
      let z = p.z * scaleZ;

      const cy = Math.cos(yaw), sy = Math.sin(yaw);
      const x1 = x * cy - y * sy;
      const y1 = x * sy + y * cy;

      const cp = Math.cos(pitch), sp = Math.sin(pitch);
      const y2 = y1 * cp - z * sp;
      const z2 = y1 * sp + z * cp;

      return { x: x1, y: y2, z: z2 };
    }

    function cameraProject(p, yaw, pitch, zoom, w, h) {
      const r = rotate3(p, yaw, pitch);
      const distance = 34;
      const perspective = distance / (distance - r.z);
      const focal = 24 * zoom;
      return {
        x: w * 0.5 + r.x * focal * perspective,
        y: h * 0.58 - r.y * focal * perspective,
        depth: r.z,
        scale: perspective,
      };
    }

    function drawLine3(a, b, yaw, pitch, zoom, w, h, color, width = 1, dash = []) {
      const pa = cameraProject(a, yaw, pitch, zoom, w, h);
      const pb = cameraProject(b, yaw, pitch, zoom, w, h);
      ctx.save();
      ctx.strokeStyle = color;
      ctx.lineWidth = width;
      ctx.setLineDash(dash);
      ctx.lineCap = "round";
      ctx.beginPath();
      ctx.moveTo(pa.x, pa.y);
      ctx.lineTo(pb.x, pb.y);
      ctx.stroke();
      ctx.restore();
    }

    function drawText3(p, body, yaw, pitch, zoom, w, h, color = "#0f172a", dx = 0, dy = 0) {
      const q = cameraProject(p, yaw, pitch, zoom, w, h);
      ctx.save();
      ctx.fillStyle = color;
      ctx.font = "600 15px ui-sans-serif, system-ui";
      ctx.fillText(body, q.x + dx, q.y + dy);
      ctx.restore();
    }

    function drawPoint2(q, radius, color, stroke = "white") {
      ctx.save();
      ctx.beginPath();
      ctx.arc(q.x, q.y, radius * q.scale, 0, Math.PI * 2);
      ctx.fillStyle = color;
      ctx.fill();
      ctx.lineWidth = 1.2;
      ctx.strokeStyle = stroke;
      ctx.stroke();
      ctx.restore();
    }

    function frame(time) {
      const rect = canvas.getBoundingClientRect();
      const w = rect.width;
      const h = rect.height;

      ctx.clearRect(0, 0, w, h);

      const autoYaw = Math.sin(time * 0.00025) * 0.25;
      const yaw = Math.PI / 2 + autoYaw + yawOffset;
      const pitch = -1.1;
      const zoom = 1.05 + (targetZoom - 1.05) * Math.min(1, Math.abs(wheel));

      // Axes.
      drawLine3({ x: -22, y: 0, z: 0 }, { x: 22, y: 0, z: 0 }, yaw, pitch, zoom, w, h, colors.axis, 1.5);
      drawLine3({ x: 0, y: -22, z: 0 }, { x: 0, y: 22, z: 0 }, yaw, pitch, zoom, w, h, colors.axis, 1.5);
      drawLine3({ x: 0, y: 0, z: 0 }, { x: 0, y: 0, z: 6 }, yaw, pitch, zoom, w, h, colors.axis, 1.7);

      for (const v of [-16, -8, 0, 8, 16]) {
        drawLine3({ x: v, y: -0.45, z: 0 }, { x: v, y: 0.45, z: 0 }, yaw, pitch, zoom, w, h, colors.grid, 0.8);
        drawLine3({ x: -0.45, y: v, z: 0 }, { x: 0.45, y: v, z: 0 }, yaw, pitch, zoom, w, h, colors.grid, 0.8);
      }

      // Cone slice diamonds.
      for (let t = 1; t <= 5; t++) {
        const d = diamond(t);
        for (let i = 0; i < d.length; i++) {
          drawLine3(d[i], d[(i + 1) % d.length], yaw, pitch, zoom, w, h, "rgba(100, 116, 139, 0.35)", 1.0, [5, 5]);
        }
      }

      // Generator rays.
      for (const p of local) drawLine3({ x: 0, y: 0, z: 0 }, p, yaw, pitch, zoom, w, h, colors.rayLocal, 1.6);
      for (const p of pr) drawLine3({ x: 0, y: 0, z: 0 }, p, yaw, pitch, zoom, w, h, colors.rayPr, 1.8);

      // Dynamic trajectory.
      drawLine3(P, N, yaw, pitch, zoom, w, h, "rgba(37, 99, 235, 0.86)", 2.6, [7, 5]);
      drawLine3(N, F, yaw, pitch, zoom, w, h, "rgba(22, 163, 74, 0.90)", 2.6, [7, 5]);

      const drawable = [];
      for (const p of points) {
        const q = cameraProject(p, yaw, pitch, zoom, w, h);
        drawable.push({ kind: "point", q, r: 4.0, color: sliceColors[p.t - 1], depth: q.depth });
      }

      for (const p of [P, N, F]) {
        const q = cameraProject(p, yaw, pitch, zoom, w, h);
        drawable.push({ kind: "special", p, q, r: p.label === "N" ? 9.5 : 8.2, color: p.color, depth: q.depth + 0.2 });
      }

      drawable.sort((a, b) => a.depth - b.depth);
      for (const d of drawable) {
        drawPoint2(d.q, d.r, d.color);
      }

      drawText3({ x: 21, y: 0, z: 0 }, "S", yaw, pitch, zoom, w, h, "#334155", 6, 4);
      drawText3({ x: 0, y: 21, z: 0 }, "S′", yaw, pitch, zoom, w, h, "#334155", 6, 4);
      drawText3({ x: 0, y: 0, z: 6.2 }, "t", yaw, pitch, zoom, w, h, "#334155", 6, -4);
      drawText3(P, "P", yaw, pitch, zoom, w, h, colors.P, -22, -8);
      drawText3(N, "N outside", yaw, pitch, zoom, w, h, colors.N, 12, -9);
      drawText3(F, "F", yaw, pitch, zoom, w, h, colors.F, 12, -9);

      ctx.save();
      ctx.fillStyle = "rgba(15, 23, 42, 0.72)";
      ctx.font = "12px ui-sans-serif, system-ui";
      ctx.fillText("Generated integer points satisfy |S| + |S′| <= 4t on the CHSH projection.", 18, 24);
      ctx.fillText("N violates the slice t=3 but is dynamically related to an admissible completion F at t=5.", 18, 42);
      ctx.restore();

      requestAnimationFrame(frame);
    }

    requestAnimationFrame(frame);

    return {
      onWheel({ deltaY }) {
        yawOffset += deltaY * 0.004;
        wheel = Math.max(0, Math.min(1, wheel + deltaY * 0.0012));
        targetZoom = 1.05 + 0.65 * wheel;
      },
    };
  ```,
)
#notes(
  "N is cannot be express as sum of generator (struture of the theory), BUT we can attach to it an η , with a past and futur consistant with the geometry of the theory !!",
)

#pause
#up()

== What append in the middle?

Imagine, the lab perform the experimentation to get $N_2$, but was interrupt in the middle. Let $N_1$ the intermediate result.
#pause
Example :
$
  mat(
    4, 3;
    8, 0
  ) <= mat(
    9, 3;
    8, 6
  )
$

#pause
We need two explanation, $η_1$ for $N_1$ and $η_2$ for $N_2$ such as the two was indeed the intermediate automaton state of the *same process*.
#pause
#def-card[
  Transition condition $η_1 arrow.squiggly η_2$ is define such that any generator that will open, will either *continue*, or *close*.
]<p6>
#pause
#up(<p6>)
== The Theory $TT = (cal(G), xi)$

The model has two ingredients.

#notes(
  "Announce summary: 'Now the framework becomes a theory. A theory has structure and dynamics.'",
)

#pause

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  red-card[
    #strong[Structure: $cal(G)$]

    Which elementary generators are allowed?
  ],
  red-card[
    #strong[Dynamics: $xi$]

    Which trajectories are admissible?
  ],
)

#pause

The theory explains a sequence of observations when there exists at least one compatible hidden trajectory: <p7>

#red-card[
  $N_(1:k) ∈ 𝕋 <=> cal(H)_(cal(G), xi)(N_(1:k)) := {η_(1:k) | ∀i ∈ [k] space N_η_i = N and η_i arrow.squiggly η_(i+1) and bold(ξ models η_(1:k))} != emptyset$.
]

#pause
#alter(4)

#up(<p7>)
#context {
  let conly = uncover.with(
    cover: it => none,
    alter: get-alter(),
    mode: get-mode(),
  )
  align(center, lq.diagram(
    width: 8cm,
    height: 4cm,
    legend: (position: top + left),
    lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (0.2, 1.1, 0.6, 1.4, 0.9, 1.2, 1.8),
      smooth: if get-alter() <= 3 {
        true
      } else { false },
      step: if get-alter() == 4 {
        center
      },
      mark: none,
      stroke: (paint: rgb("#4361ee").transparentize(20%), thickness: 1.4pt, dash: "dotted"),
      label: [$eta^1$],
    ),

    conly("1 2", lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (1.6, 0.4, 0.6, 1.9, 0.9, 1.2, 0.5),
      smooth: if get-alter() <= 3 {
        true
      } else { false },
      step: if get-alter() == 4 {
        center
      },
      mark: none,
      stroke: (paint: rgb("#f72585").transparentize(20%), thickness: 1.4pt, dash: "dotted"),
      label: [$eta^2$],
    )),

    conly("1 2", lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (1.0, 1.7, 0.6, 0.5, 0.9, 1.2, 0.3),
      smooth: if get-alter() <= 3 {
        true
      } else { false },
      step: if get-alter() == 4 {
        center
      },
      mark: none,
      stroke: (paint: rgb("#2a9d8f").transparentize(20%), thickness: 1.4pt, dash: "dotted"),
      label: [$eta^3$],
    )),

    lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (0.5, 1.5, 0.6, 1.0, 0.9, 1.2, 1.9),
      smooth: if get-alter() <= 3 {
        true
      } else { false },
      step: if get-alter() == 4 {
        center
      },
      mark: none,
      stroke: (paint: rgb("#ff9f1c").transparentize(20%), thickness: 1.4pt, dash: "dotted"),
      label: [$eta^4$],
    ),

    // Observation points shared by all compatible trajectories.
    lq.scatter(
      (2, 4, 5),
      (0.6, 0.9, 1.2),
      mark: "o",
      // mark-size: 7pt,
      color: red,
      label: [$N_i$],
      z-index: 10,
    ),

    lq.vlines(
      2,
      stroke: (paint: red.lighten(40%), thickness: 0.7pt, dash: "dashed"),
      z-index: 1,
    ),

    lq.vlines(
      4,
      stroke: (paint: red.lighten(40%), thickness: 0.7pt, dash: "dashed"),
      z-index: 1,
    ),

    lq.vlines(
      5,
      stroke: (paint: red.lighten(40%), thickness: 0.7pt, dash: "dashed"),
      z-index: 1,
    ),
  ))
}

#align(center)[
  In this example : $ℋ_(𝒢 only("3-", \,bold(ξ)) )(N_(1:3)) = {η_(1:3)^1,only("1 2", η_(1:3)^2\,η_(1:3)^3 \,)η_(1:3)^4}$
]

#uncover("2-", neutral-card[
  Example of stability constraint $ξ$ that controls open generators:
  $
    o_eta (g) <= lambda c_eta (g) + B
  $
])

#notes(
  "Because our explanation are discret process = AUTOMATON , then it is a discrete curve.

  Example, we have one possible trajectory between N2 and N3 and multiple between N1 and N2",
)

#pause
#up()

#neutral-card[
  The constraint behaves like a magnet.

  It does *not choose the path*, but it force the dynamics of the process, it *filter*.
]

#pause
#align(center, cetz.canvas({
  import cetz.draw: *

  // Ellipse: the magnet / attracting region
  circle(
    (0, 0),
    radius: (3.2, 1.8),
    stroke: (paint: black, thickness: 1pt),
    fill: rgb("#f7f7f7"),
  )

  // Center point: the magnet
  circle((0, 0), radius: 0.07, fill: red)
  content((0, -0.25), [magnet], anchor: "north")

  let pi = (-1.05, 0.90)

  // Incoming ray inside the ellipse
  line(
    (0.0, -1.55),
    (-0.45, -0.7),
    pi,
    stroke: (paint: rgb("#1d3557"), thickness: 1.3pt),
  )

  // Split point close to the boundary
  circle(pi, radius: 0.05, fill: rgb("#1d3557"))

  // Valid reflected branch: stays inside the ellipse
  line(
    pi,
    (-0.2, 1.0),
    (0.9, 0.85),
    mark: (end: "stealth"),
    stroke: (paint: rgb("#2a9d8f"), thickness: 1.3pt),
  )

  // Invalid branch: exits the ellipse
  line(
    pi,
    (-2.05, 1.35),
    (-3.15, 2.2),
    mark: (end: "stealth"),
    stroke: (paint: rgb("#d00000"), thickness: 1.3pt),
  )

  // Small cross on the invalid outgoing branch
  line(
    (-2.55, 1.72),
    (-2.35, 1.95),
    stroke: (paint: rgb("#d00000"), thickness: 1.5pt),
  )
  line(
    (-2.35, 1.72),
    (-2.55, 1.95),
    stroke: (paint: rgb("#d00000"), thickness: 1.5pt),
  )

  // Optional labels
  content((-3.25, 2.35), [not compatible], anchor: "south")
  content((0.95, 1.05), [compatible], anchor: "south")
}))

#pause

This is a constructive-theory viewpoint:

#red-card[
  Not predetermined trajectories,
  but constrained possible trajectories.
]

#notes(
  "not deterministic trajectories, but constrained possible trajectories.",
)

#right()

= What this Framework Adds

#notes(
  "Now I show one concrete thing the framework gives: interruption profiles.",
)

#pause
== Interruption Profiles
#pause
Let's take $𝒢$ like before. Example $g_(1 1) = mat(1, 1, 0, 0; 1, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0)$.
#pause
#def-card[If an observation connot be express as the direct sum of close generator, it call *non-contextual*.]

#pause
#align(center)[Example: $mat(1, 1, 0, 0; 1, 0, 0, 0; 0, 0, 1, 0; 0, 0, 0, 0)$]

#pause
#red-card[
  The next idea is to describe the *internal dynamics* of a *trajectory $η$* through its interruption profile.
]

#pause
For a fixed explanation $eta$, compare each coordinate separately:

#let pav1 = pavemat(
  pave: (
    (path: "DDSSASAAAWWDDW", from: (0, 2)),
  ),
  fills: (
    "0-2": green.transparentize(90%),
  ),
)[$mat(
  2, 2, 1, 1;
  3, 3, bcol(1), 1;
  2, 2, rcol(3), 3;
  1, 1, 3, 3
)$]

#let pav2 = pavemat(
  pave: (
    (path: "DDSSASAAAWWDDW", from: (0, 2)),
  ),
  fills: (
    "0-2": green.transparentize(90%),
  ),
)[$mat(
  2, 2, 2, 3;
  4, 5, bcol(2), 2;
  5, 4, rcol(4), 3;
  1, 1, 3, 3
)$]

#let pav3 = pavemat(
  pave: (
    (path: "DDSSASAAAWWDDW", from: (0, 2)),
  ),
  fills: (
    "0-2": green.transparentize(90%),
  ),
)[$mat(
  2, 2, 4, 4;
  6, 7, bcol(5), 4;
  5, 6, rcol(4), 3;
  1, 1, 3, 3
)$]

$
  P_η = pav1 -> N = pav2 -> F_η = pav3
$

#pause
#align(center, diagram($edge("rrrr", "-|>") & node(bcol(2)) & & & node(rcol(4))$))
#pause
#up(offset: -2)
$
  "time"_η =
  k_η / 12 = mat(
    -, -, 4, 8;
    4, 6, 3, 4;
    12, 6, 12, -;
    -, -, -, -
  ) / 12
$

#pause
#up(offset: -1)
#red-card[
  We can measure how synchronized the events are along the evolution of an explanatory trajectory $η$.
]

#grid(
  align: center,
  columns: (2fr, 1fr),
  {
    lq.diagram(
      width: 5cm,
      xaxis: (subticks: none),
      xlabel: $k_eta$,
      ylabel: $"Hist"_eta (k)$,

      lq.bar(
        (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
        (0, 0, 0, 1, 3, 0, 2, 0, 1, 0, 0, 0, 2),
      ),
    )
  },
  align(horizon + left)[$"Hist"_η (k) = \# {v ∈ V | k_η (v) = k}$],
)

#pause
#up(offset: -1)

#red-card[
  Then we can *filter* explanations using $ξ$, depending on the kind of explanation we want: *highly synchronized*, *uniform*, or something else.

  Example: Causal constraint
  $
    k_η (v) <= k_η (v') quad v v' ∈ A
  $
]

#pause
#up(offset: -2, dy: 2em)

#neutral-card[
  This is where the framework becomes genuinely dynamic: *constraints* can act on the *organization of the process*, not only on the final table.
]

#right()


= Conclusion<ref:conclusion>

#pause
*What will you learn?*
- The framework on contextuality through *automata*.
- Why keeping integer counts allows us to express more structure, such as *trajectories* instead of only points.
#pause
*What will we not cover in this presentation?*

- How the internship evolved over time.
- How my dynamic automaton framework connects with the foundational papers on contextuality~#box[@Abramsky_Brandenburger_2011 @Abramsky_Barbosa_Mansfield_2016]<ref:1>, or with the hypergraph approach of~#box[@Cabello_Severini_Winter_2014]<ref:2>.
- How this framework could contribute to the broader study of quantum contextuality.
- Why this approach seems promising for understanding quantum phenomena.
#notes(
  "The goal (of the presentation) was to provider a better intuition of the framework but i also a strong formalied result and connection with literrature.",
)
#pause
*Open questions:*

- Can we find a theory $𝕋 = (𝒢, ξ)$ that separates quantum correlations from classical and non-signaling correlations?
- Can we evaluate such a theory on observations such as $P_v = v P_"PR" + (1 - v) P_"uni"$, or more generally using~#box[@sengupta2025correlationselftestingquantumtheory]<ref:3>?
- Can we test the framework on multipartite games such as $"GHZ"$, which are strongly contextual?
- Can we build a dynamic framework that progressively constructs itself?
#notes(
  "The main next step is to find a concrete $𝕋 = (𝒢, ξ)$ that separates quantum behavior from classical and non-signaling behavior.

  Then thank audience.",
)

#pause
#up(offset: -3, dy: 5pt)

#right()
// --------------------------------------------------------- // ANNEXE
#heading(outlined: false)[Annexe 1]

== The Laboratory

// #grid(
//   columns: (1fr, 1fr, 1fr),
//   column-gutter: 0.75em,
//   def-card[#compact[#strong[Green]

//     Definition or notation]],
//   soa-card[#compact[#strong[Orange]

//     State of the art or inherited content]],
//   ours-card[#compact[#strong[Red]

//     Our result or modelling choice]],
// )


#neutral-card[
  We want to create a theory of theory, and a theory start by an *experience*.
]

#pause

In the Bell $(2,2,2)$ scenario:

#def-card[
  A set of _measure_ $X = {a, a', b, b'}$, a set of _outcome_
  $O = {0,1}$.
]<p1>

Alice can choose $a$ or $a'$. Bob can choose $b$ or $b'$.

#pause
#up(<p1>)
#alter(4)

Example of context : $only("1", C = {a,b}) only("2", C = {a,b'})$
#context align(center, diagram(
  node-stroke: 0.7pt + green,
  node-corner-radius: 5pt,
  node-fill: white,
  edge-stroke: 0.8pt,
  node((1, 0), [Alice], name: <alice>),
  node((5, 0), [Bob], name: <bob>),

  let red-node = (stroke: 0.7pt + red),
  node((0, 1), $a$, name: <a>, ..red-node),
  node((2, 1), $a'$, name: <ap>, ..red-node),
  node((4, 1), $b$, name: <b>, ..red-node),
  node((6, 1), $b'$, name: <bp>, ..red-node),

  edge(<alice>, "dl", "->"),
  donly("2-", edge(<bob>, "dr", "->")),
  donly("1", edge(<bob>, "dl", "->")),

  donly("4", {
    edge(<a>, <ra>, "->")
    edge(<bp>, <rbp>, "->")
    node((0, 1.7), $0$, stroke: none, name: <ra>)
    node((6, 1.7), $1$, stroke: none, name: <rbp>)
  }),
))

#uncover("3-")[
  An experiment first choose one context and get the result $s = (a |-> 0, b' |-> 1)$.
]

#pause

<p3>
#def-card[
  The _measurement context_ is
  $cal(M) = {{a,b}, {a,b'}, {a',b}, {a',b'}} subset cal(P)(X)$.
]

#pause
#up(<p3>)

#def-card[
  A local _section_ $s ∈ ℰ(C)$, example
  $s = (a |-> 0, b' |-> 1)$.
]

#pause

#def-card[
  We define the _visible event_ set by
  $V := {(C,s) | C ∈ ℳ , s ∈ ℰ(C)}$
]

It is what is actually recorded.

#pause
#up()

=== From Local Events to Contextuality

#pause

We also ask whether the result would have been the same in another context?

#neutral-card[
  If Bob had chosen $b$ instead of $b'$, would Alice still have obtained $a |-> 0$?
]

#pause

Classically, the answer should be no: every measurement already has a value.

#def-card[
  A _global section_ is $g ∈ ℰ(X)$, i.e. a map between every measure and outcome :
  $ g = (a |-> 0, a' |-> 1, b |-> 0, b' |-> 0) $
]

#pause

For each context, the local result is only a restriction:

$
  C = {a,b} quad s = g|_C = (a |-> 0, b |-> 0)
$

// #pause
// DIAGRAM TODO: Show a global assignment g as a rectangle/square pattern whose restrictions appear in the four context blocks.

#pause

A global section means: all counterfactual outcomes are already written.

#pause
#up()

== Counts Before Probabilities

One run is not an experiment.
An experiment is a collection of runs.

#pause
#context align(center, diagram(
  node-stroke: 0.8pt + soa-color,
  node-corner-radius: 5pt,
  node-fill: white,
  edge-stroke: 1pt + soa-color,
  node((-3, 0), [$C = {a,b'}$], stroke: 1pt + soa-color),
  edge((-1.85, 0), (-0.55, 0), "-|>", [run the experiment]),
  node((0.55, 0), [$s = (a |-> 0, b' |-> 1)$], stroke: 1pt + soa-color),
  edge((1.95, 0), (3.05, 0), "-|>", [record]),
  node((4.15, 0), [$N(C,s) = N(v) ∈ ℕ^V$], stroke: 1pt + soa-color),
))

#pause

Instead of normalizing immediately, we keep the integer counts:

#def-card[
  An _integer model_ is $N in NN^V$
]

#pause

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  neutral-card[
    #strong[After normalization]

    $N_1 = vec(v_1, v_2) = vec(1, 0)$ and $N_1000 = vec(v_1, v_2) = vec(1000, 0)$ both become probability $vec(1, 0)$.
  ],
  neutral-card[
    #strong[Before normalization]
    They carry different levels of evidence. We are more confidence in $N_1000$ instead of $N_1$.
  ],
)

#pause

#def-card[
  $N ∈ ℕ^V$ is compatible if $∀ C,D ∈ ℳ$ two contexts and $u ∈ ℰ(C ∩ D)$:
  $
    sum_(s ∈ ℰ(C), s_(|C ∩ D) = u) N(C,s) = sum_(s ∈ ℰ(D), s_(|C ∩ D) = u) N(D,s)
  $
]<p2>

#pause
#up(<p2>)

With $C = {bcol(a),bold(b)}$ and $D = {bold(b),rcol(c)}$ we need to have :
$
  "For " u = (bold(b) |-> 0) : N(C, (bcol(a) |-> 0, bold(b) |-> 0)) + N(C, (bcol(a) |-> 1, bold(b) |-> 0)) = N(D, (bold(b) |-> 0, rcol(c) |-> 0)) + N(D, (bold(b) |-> 0, rcol(c) |-> 1)) \
  "For " u = (bold(b) |-> 1) : N(C, (bcol(a) |-> 0, bold(b) |-> 1)) + N(C, (bcol(a) |-> 1, bold(b) |-> 1)) = N(D, (bold(b) |-> 1, rcol(c) |-> 0)) + N(D, (bold(b) |-> 1, rcol(c) |-> 1))
$
The marginal coincide on the common contexts. This call *non-signaling*, no information transit between the context (between Alice and Bob). We write this condition $δ N = 0$

#pause
#up()

Each context can have him own number of event $|N_C|$, by applying the *non-signaling* condition, this force each context to have the same number of element $∀C ∈ ℳ quad |N_C| = t$.

$
  A_cal(M) N & = t bold(1) &              <- "same level" \
     delta N & = 0         & <- "non-signaling constrain"
$

#pause

#neutral-card[This describe a cone $𝒮_"ns" = {(N,t) | A_ℳ N = t 𝟙 and δ N = 0} = t G_"ns" inter ℕ$]

#pause
#up()

=== Noncontextual Countings

A deterministic global section $g$ gives one counting vector $d_g$.

#pause

#def-card[
  An integer counting is _noncontextual_ if it decomposes as a sum of such global sections:
  $
    exists c: 𝒢 -> ℕ,quad N = sum_(g in ℰ(X)) c_g d_g
  $
]

#pause

Contextuality begins when $N$ is compatible but no such decomposition exists.

#def-card[
  $N in cal(S)_"ns"$ but $N in.not cal(S)_"nc"$.
]

// DIAGRAM TODO: Show a compatible table N and several square-like global-section patterns trying to sum to it.

#pause
#up()

== The Quantum Tension

#pause

We have two thing, first quantum lives strictly between non-contextual (global section) and the all set $𝒮_"ns"$ of non-signaling model.

#pause

Second we can try to classify observation with what we call *contextual fraction* (in our case, because we have integer instead of probabilities we have #rcol[minimal distance]).

#notes[Il faut dire que c'est un point important, on a demontrer que c'est deux notions sont équivalentes dans notre report, c'est une contribution !]

#pause

<p5>
#def-card[
  Let define $D^- (hat(N)) = min_(N ∈ 𝒮_"ns") |N - hat(N)|_1$ the minimal distance with the closest explanation of the model $𝒮_"ns"$.
]

#pause
#up(<p5>)

#align(center, cetz.canvas({
  import cetz.draw: *

  // Main scale
  line((0, 0), (10, 0), mark: (end: "stealth"))

  // Graduation from 0 to 1
  for i in range(0, 11) {
    let x = i
    let label = if i == 0 {
      $0$
    } else if i == 10 {
      $1$
    } else {
      none
    }

    line((x, -0.08), (x, 0.08))

    if label != none {
      content((x, -0.35), label, anchor: "north")
    }
  }

  // Labels
  content((0, -0.8), [Classical], anchor: "north")
  content((10, -0.8), [Strong contextual], anchor: "north")
  // content((5, -1.35), [Contextual fraction], anchor: "north")

  // Point N on the scale
  circle((6.3, 0), radius: 0.11, fill: rgb("#d00000"))
  content((6.3, 0.35), [$N$], anchor: "south")

  // Distance from N to the classical boundary
  line(
    (6.1, 0.45),
    (0, 0.45),
    mark: (end: "stealth"),
    stroke: rgb("#d00000"),
  )
  content((3.15, 0.85), [$D^-(N)$], anchor: "south")
}))

The farther $N$ is from the classical side, the more contextual it is.

#pause

#neutral-card[
  But, strong contextual not implies quantum or not, we cannot express quantumness by a distance with the classicality (GHZ)
]



We believe that quantum cannot be found if we think in term of point, or state, we need to analyse the trajectory!

// TODO : In the cone, place a point outside, and draw two possible trajectory that go from P1 -> N -> F1 and P2 -> N -> F2. We want have a criteria on the path and not just with the distance. (Maybe we need to consider another 𝒢)

#pause

How to formalise that?

#right()
#heading(outlined: false)[Annexe 2]

== Static Measure and Dynamic Enrichment

How much of $N$ can be explained by global sections?

#red-card[
  $D^-(N) := min_eta |N - P_eta|_1$ is equivalent to contextual fraction.
]

#pause

But the dynamic model also provide another direction, the completion distance.
#def-card[
  $D^(arrow.loop)(N) := min { |F_eta - N|_1 | d^-_eta = D^-(N) }$.
]<p8>
#pause
#up(<p8>)

#figure(
  cetz.canvas({
    import cetz.draw: *
    let cblue(it) = text(fill: blue, it)
    let cred(it) = text(fill: red, it)

    content((3, 0), $N$, name: "N")
    polygon((0, -3), 9, name: "past", stroke: (blue))

    set-style(polygon: (radius: 2))
    polygon((6, -3), 12, name: "futur", stroke: red)

    circle((6, -3), radius: (1.2, 0.7), name: "subfutur")

    content("past.north", $cblue({P_η}_η)$, anchor: "south")
    content("futur.north", $cred({F_η}_η)$, anchor: "south")

    line("N", "past", name: "line1", mark: (end: ">>"))
    line("past.north-east", "subfutur", name: "line2", mark: (end: ">>"))
    content("line1", angle: "line1.start", anchor: "south", [$D^- (N) = "CF"(e_N)$])

    content("subfutur", $D^(arrow.loop) (N)$)
  }),
)

#pause
<p9>
But we want a *dynamic* theory: one that can revisit its own axioms during the experiment and update them.
#pause
To make this possible, we relax the stabilized past, allowing the theory to explore alternative completions, in a way reminiscent of machine learning.
#pause
#up(<p9>)
#figure(
  cetz.canvas({
    import cetz.draw: *
    let cblue(it) = text(fill: blue, it)
    let cred(it) = text(fill: red, it)

    content((3, 0), $N$, name: "N")
    polygon((0, -3), 9, name: "past", stroke: (blue))

    set-style(polygon: (radius: 2))
    polygon((6, -3), 12, name: "futur", stroke: red)

    {
      rotate(-45deg)
      circle("past.north-east", radius: (0.2, 0.5), anchor: 0, name: "subpast")
      rotate(45deg)
    }

    circle((6, -3), radius: (0.9, 1.6), name: "subfutur")

    content("past.north", $cblue({P_η}_η)$, anchor: "south")
    content("futur.north", $cred({F_η}_η)$, anchor: "south")

    line("N", "past", name: "line1", mark: (end: ">>"))
    line("past.north-east", "subfutur.north", name: "line2")
    line("subpast.south", "subfutur.south", name: "line3")

    content("subfutur", $D_α^(arrow.loop) (N)$)
  }),
  //placement: top,
)<fig:trajectory-relaxed>

#bibliography("refs.bib")
