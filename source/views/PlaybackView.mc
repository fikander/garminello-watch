using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;

class PlaybackView extends Ui.View {

    hidden var mModel;
    hidden var mListId;
    hidden var mCurrentCard;

    hidden var mTools;
    hidden var mTimer;

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
        mTimer = new Timer.Timer();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.PlaybackLayout(dc));
    }

    function onShow() {
        mTimer.start(method(:tick), 500, true);
    }

    function tick() {
        Sys.println("tick");
        Ui.requestUpdate();
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
                var formatted = mTools.formatText(dc, current["name"], mTools.mListWidth, Gfx.FONT_SMALL);
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

    function onHide() {
        mTimer.stop();
    }
}