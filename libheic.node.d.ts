/**
 * Encode image into HEIC format
 *
 * @param {BufferSource} input
 * @param {number} [quality] The quality of the encoded image. A number between 0 and 1. Defaults to 0.8
 * @returns The encoded image data as an ArrayBuffer
 */
export function encode(input: BufferSource, quality?: number): ArrayBuffer;

/**
 * Decode image to PNG format
 * 
 * @param {BufferSource} input Accepts HEIC/WEBP/AVIF image data as an ArrayBuffer
 * @returns The PNG image data as an ArrayBuffer
 */
export function decode(input: BufferSource): ArrayBuffer;