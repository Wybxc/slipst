import { copyFile, glob } from "node:fs/promises";

await Bun.build({
  entrypoints: ["slipst.ts", "slipst.css"],
  outdir: "dist",
  target: "browser",
  minify: true,
  splitting: false,
});

for await (const file of glob(["*.typ", "*.md", "LICENSE", "*.toml"])) {
  await copyFile(file, `dist/${file}`);
}
