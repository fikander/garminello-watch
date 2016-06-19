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

    function drawItem(dc, item, offsetY) {
        Sys.println("CardViewTools::drawItem");
        // hidden var COLORS = [Graphics.COLOR_DK_BLUE, Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_RED];
        var style = item["color"] ? item["color"] : 0;
        dc.setColor(COLORS[style % COLORS.size()], Gfx.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(0, offsetY, 144, mItemHeight, 5);

        var formatted = formatText(dc, item["name"], mListWidth, Gfx.FONT_SMALL);
        var offset = offsetY + 0.25 * formatted[1] + 3;
        //Sys.println(formatted.toString() + " " + offset);
        dc.drawText(
            4, offset, Graphics.FONT_XTINY,
            formatted[0], Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}