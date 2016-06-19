using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class RenderTools {

    var mItemHeight = 150;
    var mListWidth = 140;

    hidden var COLORS = [Graphics.COLOR_DK_BLUE, Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_RED];

    function initialize(type) {
        if (type == "vivoactive_hr") {
            mItemHeight = 50;
            mListWidth = 140;
        }
        // TODO: constants for other watch types
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