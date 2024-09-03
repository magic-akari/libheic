# libheic

NAPI bindings for a HEIC image format decoder and encoder, integrating with ImageIO on macOS.

> [!NOTE]
> The library is still in development and not ready for production.
> The API may change. Currently, only the encoder is available.

## Installation

```sh
npm install libheic
```

## API Usage

```JavaScript
const heic = require("libheic");

const input = fs.readFileSync("image.png");
const output = heic.decode(input.buffer);
fs.writeFileSync("image.heic", Buffer.from(output));
```

## CLI Usage

```sh
npx libheic image.png
```
