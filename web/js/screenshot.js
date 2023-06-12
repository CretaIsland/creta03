async function jsScreenshot(x, y, width, height) {
    // Get The canvas
    var canvas = await html2canvas(document.body, {
        x: x,
        y: y,
        width: width,
        height: height
    });      
     
    return canvas.toDataURL("image/png");

    // a.download = "Example.png";
    // document.querySelector("body").append(a);
    // a.click();
    // a.remove();
    
}
