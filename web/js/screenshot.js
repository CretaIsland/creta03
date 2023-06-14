async function jsScreenshot(x, y, width, height) {

    try {
         // Get The canvas
        var canvas = await html2canvas(document.body, {
            x: x,
            y: y,
            width: width,
            height: height,
            allowTaint: true,
            useCORS: true,
            proxy: "https://devcreta.com:444/"
        });      

        return canvas.toDataURL("image/png");
    } catch (e) {
        console.log(e.toString());
    }

}
