#import "../dist/lib.typ": *

#show link: underline          // <-- has no effect on slip content
#set text(size: 5pt) // <-- has no effect on slip content

#show: slipst

= My Presentation
#pause
Content with a #link("https://example.com")[link] and text.
#right()
= Second part
#pause
Yesss !
#right()
#boxjs(
  height: 4cm,
  style: "display: grid; place-items: center; background: #f8fafc;",
  html: ```html
    <button class="btn">Click me</button>
  ```,
  css: ```css
    .btn {
      padding: 0.7em 1em;
      border: 0;
      border-radius: 999px;
      background: #2563eb;
      color: white;
      cursor: pointer;
    }
  ```,
  js: ```js
    const btn = root.querySelector(".btn");
    btn.addEventListener("click", () => {
      btn.textContent = `Clicked ${box.id}`;
    });
  ```,
)
#right()
#alter(3)
$
  sum_(x ∈ 𝒮) & = uncover("2 3", 1 + x + (x^2)/2 + (x^3)/(3!) + dots) \
              & = uncover("3", x+x+x+x+x)
$
#pause
#alter(2)
$
  sum_(x ∈ ℝ) uncover("1", x^2) uncover("2", x^x^2)
$
