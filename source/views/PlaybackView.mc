using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PlaybackView extends Ui.View {

    hidden var mModel;
    hidden var mListId;
    hidden var mCurrentCard;

    // model - board data
    // listId - list to play back
    function initialize(model, listId) {
        View.initialize();
        mModel = model;
        mListId = listId;
        mCurrentCard = 0;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.PlaybackLayout(dc));
    }

    //! Update the view
    function onUpdate(dc) {
        var l = mModel.getList(mListId);
        if (l != null) {
            findDrawableById("list_title").setText(l["name"]);
            var cards = mModel.getCards(mListId);
            if (cards.size() > mCurrentCard) {
                findDrawableById("item_title").setText(cards[mCurrentCard]["name"]);
                findDrawableById("item_number").setText("" + (mCurrentCard + 1) + "/" + cards.size());
            }
            findDrawableById("time").setText("00:00");
            if (cards.size() > mCurrentCard + 1) {
                findDrawableById("next_item_title").setText(cards[mCurrentCard + 1]["name"]);
            }
        }
        View.onUpdate(dc);
    }
}