/**
 * Encode image into HEIC format
 *
 * @param {BufferSource} input The input image data as an ArrayBuffer, TypedArray, or DataView
 * @param {number} [quality] The quality of the encoded image. A number between 0 and 1. Defaults to 0.8
 * @returns The encoded image data as an ArrayBuffer
 */
export function encode(input: BufferSource, quality?: number): ArrayBuffer;
