using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.Time as Time;
using Toybox.Attention as Attention;

class PlaybackView extends Ui.View {

    hidden var mModel;
    hidden var mListId;
    hidden var mCards;
    hidden var mTotalTimes;
    hidden var mCurrentCardId = 0;
    hidden var mCurrentCard = null;
    hidden var mNextCard = null;
    hidden var mCurrentTime = 0;
    hidden var mTotalTime = 0;
    hidden var mRunning = false;

    hidden var mTools;
    hidden var mTimer;

    hidden var mItemHeight = 50;
    hidden var mListWidth = 140;

    hidden var mLayoutDirty = false;

    hidden var DEFAULT_TIME = 5;

    // model - board data
    // listId - list to play back
    function initialize(model, listId) {
        View.initialize();
        mModel = model;
        mListId = listId;
        mCards = mModel.getCards(mListId);
        mTools = new RenderTools("vivoactive_hr");
        mTimer = new Timer.Timer();
        if (mCards.size() > 0) {
            mTotalTimes = new [mCards.size()];
            mTotalTimes[mCards.size() - 1] = 0;
            if (mCards.size() > 1) {
                for (var i = mCards.size() - 2; i >= 0; i--) {
                    mTotalTimes[i] = mCards[i + 1]["t"] ? mCards[i + 1]["t"] : DEFAULT_TIME;
                    mTotalTimes[i] += mTotalTimes[i + 1];
                }
            }
        }
    }

    function start(resetTime) {
        if (mCards.size() > mCurrentCardId) {
            mCurrentCard = mCards[mCurrentCardId];
        } else {
            mCurrentCard = null;
            return;
        }
        if (mCards.size() > mCurrentCardId + 1) {
            mNextCard = mCards[mCurrentCardId + 1];
        } else {
            mNextCard = null;
        }
        if (resetTime) {
            // time in milliseconds
            mCurrentTime = 1000 * (mCurrentCard["t"] ? mCurrentCard["t"]: DEFAULT_TIME);
        }
        mTimer.start(method(:tick), 500, true);
        mRunning = true;
        Attention.vibrate([new Attention.VibeProfile(50, 250)]);
    }

    function pause() {
        mRunning = false;
        mTimer.stop();
        mLayoutDirty = true;
        Ui.requestUpdate();
    }

    function unpause() {
        start(false);
        mLayoutDirty = true;
        Ui.requestUpdate();
    }

    function isRunning() {
        return mRunning;
    }

    function next() {
        if (mCurrentCardId < mCards.size()-1) {
            mCurrentTime = 0;
            tick();
        }
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.PlaybackLayout(dc));
    }

    function onShow() {
        start(true);
    }

    function tick() {
        mCurrentTime -= 500;
        if (mCurrentTime <= 0) {
            mTimer.stop();
            mCurrentCardId += 1;
            if (mCurrentCardId < mCards.size()) {
                start(true);
            } else {
                mCurrentCard = null;
                mNextCard = null;
            }
        }
        Ui.requestUpdate();
    }

    //! Update the view
    // screen resolution:
    // vivoactive hr: 148x205
    function onUpdate(dc) {
        if (mLayoutDirty) {
            mLayoutDirty = false;
            if (!mRunning) {
                setLayout(Rez.Layouts.PlaybackPausedLayout(dc));
            } else {
                setLayout(Rez.Layouts.PlaybackLayout(dc));
            }
        }
        var l = mModel.getList(mListId);
        if (l != null) {
            findDrawableById("list_title").setText(l["name"]);
            if (mCurrentCard) {
                var formatted = mTools.formatText(dc, mCurrentCard["name"], mTools.mListWidth, Gfx.FONT_XTINY);
                findDrawableById("item_title").setText(formatted[0]);
                findDrawableById("item_number").setText("" + (mCurrentCardId + 1) + "/" + mCards.size());
                findDrawableById("time_left").setText(mTools.formatMinSec(mCurrentTime / 1000));
                findDrawableById("time_left_total").setText("total " + mTools.formatMinSec(mTotalTimes[mCurrentCardId] + mCurrentTime / 1000));
            }
            if (mNextCard) {
                findDrawableById("next_item_title").setText(mNextCard["name"]);
            } else {
                findDrawableById("next_item_title").setText("");
            }
        }
        View.onUpdate(dc);
    }

    function onHide() {
        mTimer.stop();
    }
}