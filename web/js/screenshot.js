async function jsScreenshot(x, y, width, height) {

  try {
      var fullCanvas = await htmlToImage.toCanvas(document.body);
      var cropCanvas = document.createElement("canvas");
      var context = cropCanvas.getContext("2d");

      var cropX = x * window.devicePixelRatio;
      var cropY =  y * window.devicePixelRatio;
      var cropWidth =  width * window.devicePixelRatio;
      var cropHeight =  height * window.devicePixelRatio;

      cropCanvas.width = cropWidth;
      cropCanvas.height = cropHeight;
      context.drawImage(fullCanvas, cropX, cropY, cropWidth, cropHeight, 0, 0, cropWidth, cropHeight);

      return cropCanvas.toDataURL();
  } catch (error) {
      console.log(error);
      return '';
  }

}
