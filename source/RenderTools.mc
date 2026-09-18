using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

// Original layout was hand-tuned for the VivoActive HR's 148x205 rectangular
// display. All coordinates below are still expressed relative to that
// reference size and rescaled to the actual device via scaleX/scaleY, so the
// app renders proportionally on any screen size or shape instead of being
// hardcoded to one device.
class RenderTools {

    const REFERENCE_WIDTH = 148.0;
    const REFERENCE_HEIGHT = 205.0;

    var mItemHeight;
    var mListWidth;

    hidden var COLORS = [Graphics.COLOR_DK_BLUE, Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_RED];

    function initialize(dc) {
        mItemHeight = RenderTools.scaleY(dc, 50);
        mListWidth = RenderTools.scaleX(dc, 140);
    }

    static function scaleX(dc, x) {
        return scaleToWidth(dc.getWidth(), x);
    }

    static function scaleY(dc, y) {
        return scaleToHeight(dc.getHeight(), y);
    }

    //! Same as scaleX(), but for callers (eg. tap hit-testing in delegates)
    //! that only have the device's screen width, not a dc.
    static function scaleToWidth(screenWidth, x) {
        return (x * screenWidth / REFERENCE_WIDTH).toNumber();
    }

    //! Same as scaleY(), but for callers that only have the screen height.
    static function scaleToHeight(screenHeight, y) {
        return (y * screenHeight / REFERENCE_HEIGHT).toNumber();
    }

    //! font: Graphics.FONT_...
    function formatText(dc, text, width, font) {
        //var chars = "EeeTtaAooiNshRdlcum   ";
        var chars = "AbCdEfGhIj";
        var oneCharWidth = dc.getTextWidthInPixels(chars, font) / chars.length();
        //Sys.println("ListView::formatText: char width: " + oneCharWidth);
        var charPerLine = mListWidth / oneCharWidth;
        if (text.length() > charPerLine) {
            var result = text.substring(0, charPerLine);
            result += "\n";
            result += text.substring(charPerLine, text.length());
            return [result, 0];
        } else {
            return [text, 1];
        }
    }

    function formatMinSec(seconds) {
        var result = "";
        var min = seconds / 60;
        var sec = seconds % 60;
        if (min < 10) { result += "0"; }
        result += min + ":";
        if (sec < 10) { result += "0"; }
        result += sec;
        return result;
    }
}