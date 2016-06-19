using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class PlaybackView extends Ui.View {

    hidden var mModel;
    hidden var mListId;
    hidden var mCurrentCard;

    hidden var mTools;

    hidden var mItemHeight = 50;
    hidden var mListWidth = 140;

    // model - board data
    // listId - list to play back
    function initialize(model, listId) {
        View.initialize();
        mModel = model;
        mListId = listId;
        mCurrentCard = 0;
        mTools = new RenderTools("vivoactive_hr");
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.PlaybackLayout(dc));
    }

    //! Update the view
    // screen resolution:
    // vivoactive hr: 148x205
    function onUpdate(dc) {
        var l = mModel.getList(mListId);
        if (l != null) {
            findDrawableById("list_title").setText(l["name"]);
            var cards = mModel.getCards(mListId);
            var current;
            if (cards.size() > mCurrentCard) {
                current = cards[mCurrentCard];
                Sys.println("PlaybackView::onUpdate::before format");
                var formatted = mTools.formatText(dc, current["name"], mTools.mListWidth, Gfx.FONT_SMALL);
                Sys.println("PlaybackView::onUpdate::after format: " + formatted);
                findDrawableById("item_title").setText(formatted[0]);
                findDrawableById("item_number").setText("" + (mCurrentCard + 1) + "/" + cards.size());
            }
            findDrawableById("time_left").setText("00:00");
            findDrawableById("time_left_total").setText("total 00:00");
            if (cards.size() > mCurrentCard + 1) {
                findDrawableById("next_item_title").setText(cards[mCurrentCard + 1]["name"]);
            }
        }
        View.onUpdate(dc);
    }
}