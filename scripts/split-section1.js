const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const mPath = path.join(root, "Data", "Section1.m");
const srcRoot = path.join(root, "src");

const folderMap = {
  CleanseColumns: "CleanseColumns",
  CleanseRows: "CleanseRows",
  CleanseTables: "CleanseTables",
  InfoFunctions: "Info",
  DataPreProcessing: "DataPreProcessing",
  DateFunctions: "Dates",
  ControlCharts: "ControlCharts",
  Sampling: "Sampling",
  AddColumn: "AddColumn",
  MLEncoder: "MLEncoder",
};

const text = fs.readFileSync(mPath, "utf8");
const re = /shared\s+#"([^"]+)"\s*=\s*/g;
const matches = [];
let m;
while ((m = re.exec(text)) !== null) {
  matches.push({ name: m[1], start: m.index, bodyStart: re.lastIndex });
}

const catalog = [];

for (let i = 0; i < matches.length; i++) {
  const cur = matches[i];
  const end = i + 1 < matches.length ? matches[i + 1].start : text.length;
  let body = text.slice(cur.bodyStart, end).trim();
  if (body.endsWith(";")) body = body.slice(0, -1).trimEnd();

  const parts = cur.name.split("/");
  const categoryKey = parts[1] || "Misc";
  const rawFn = parts[parts.length - 1];
  const fnName = rawFn.replace(/\s+/g, "");
  const folder = folderMap[categoryKey] || categoryKey;

  const dir = path.join(srcRoot, folder);
  fs.mkdirSync(dir, { recursive: true });

  let description = "";
  let author = "";
  let date = "";
  const headerMatch = body.match(/^\/\*([\s\S]*?)\*\//);
  if (headerMatch) {
    const h = headerMatch[1];
    const d = h.match(/Description:\s*(.+)/i);
    const a = h.match(/Author:\s*(.+)/i);
    const dt = h.match(/Date:\s*(.+)/i);
    if (d) description = d[1].trim();
    if (a) author = a[1].trim();
    if (dt) date = dt[1].trim();
  }

  const lines = [
    "////////////////////////////////////////////////////////////////////////////////",
    `// ${fnName}`,
    `// Category : ${folder}`,
  ];
  if (description) lines.push(`// Description : ${description}`);
  if (author) lines.push(`// Author      : ${author}`);
  if (date) lines.push(`// Date        : ${date}`);
  lines.push(`// Source path : ${cur.name}`);
  lines.push("////////////////////////////////////////////////////////////////////////////////", "", body, "");

  const filePath = path.join(dir, `${fnName}.pq`);
  fs.writeFileSync(filePath, lines.join("\n"), "utf8");
  catalog.push({
    name: fnName,
    category: folder,
    workbookPath: cur.name,
    file: `src/${folder}/${fnName}.pq`,
    description,
    author,
    date,
  });
  console.log("Wrote", path.relative(root, filePath));
}

fs.writeFileSync(
  path.join(root, "catalog.json"),
  JSON.stringify(catalog, null, 2),
  "utf8"
);
console.log("Total:", catalog.length);
