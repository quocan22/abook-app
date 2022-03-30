export function resizeScaleByWidth(imageUrl, width) {
  // resize image by format of Cloudinary
  return `${imageUrl.slice(0, 47)}c_scale,w_${width}/${imageUrl.slice(47)}`;
}
