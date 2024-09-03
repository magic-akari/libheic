const { parseArgs } = require("node:util");
const fs = require("node:fs");
const path = require("node:path");
const heic = require("./libheic.node");

const { values, positionals } = parseArgs({
    args: process.argv.slice(2),
    allowPositionals: true,
    options: {
        help: { type: "boolean", short: "h" },
        quality: { type: "string" },
        overwrite: { type: "boolean", default: false },
    },
});

if (values.help || positionals.length === 0) {
    console.log("Usage: heic [options] <input>...");
    console.log("Options:");
    console.log("  -h, --help     Print this help message");
    console.log("  --quality      Quality of the output HEIC image (0-1)");
    console.log("  --overwrite    Overwrite the output file if it exists");
    process.exit(0);
}

for (const input_path of positionals) {
    const output_path = path.format({
        ...path.parse(input_path),
        base: undefined,
        ext: ".heic",
    });

    const input = fs.readFileSync(input_path);
    try {
        const quality = values.quality ? parseFloat(values.quality) : undefined;

        const data = heic.encode(input.buffer, quality);
        fs.writeFileSync(output_path, Buffer.from(data));
        console.log(output_path);
    } catch (error) {
        console.error(error);
    }
}

process.stderr.write("Done\n");
