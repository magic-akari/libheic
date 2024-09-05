const { parseArgs } = require("node:util");
const fs = require("node:fs");
const path = require("node:path");
const heic = require("./libheic.node");

const { values, positionals } = parseArgs({
    args: process.argv.slice(2),
    allowPositionals: true,
    options: {
        help: { type: "boolean", short: "h" },
        decode: { type: "boolean", short: "d" },
        quality: { type: "string" },
    },
});

if (values.help || positionals.length === 0) {
    console.log("Usage: heic [options] <input>...");
    console.log("Options:");
    console.log("  -h, --help     Print this help message");
    console.log("  --decode       Decode the HEIF/AVIF/WEBP file image to PNG");
    console.log("  --quality      Quality of the output HEIF image (0-1)");
    process.exit(0);
}

const fn = values.decode ? heic.decode : heic.encode;
const ext = values.decode ? ".png" : ".heic";

for (const input_path of positionals) {
    const output_path = path.format({
        ...path.parse(input_path),
        base: undefined,
        ext,
    });

    const input = fs.readFileSync(input_path);
    try {
        const quality = values.quality ? parseFloat(values.quality) : undefined;

        const data = fn(input, quality);
        fs.writeFileSync(output_path, Buffer.from(data));
        console.log(output_path);
    } catch (error) {
        console.error(error);
    }
}

process.stderr.write("Done\n");
