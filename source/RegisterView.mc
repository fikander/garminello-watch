using Toybox.WatchUi as Ui;
using Toybox.System as Sys;


//  1. check config endpoint
//  2. fail with no internet
//  3. proceed to board selection view
//  4. show new code for watch and after user interacts - go to 1.
class RegisterView extends Ui.View {

    hidden var mOnShowCallback;

    hidden var mErrorMsg = "";
    hidden var mWatchId = "";
    hidden var mErrorsCount = 0;

    hidden var mHideLoading = false;

    function initialize() {
        View.initialize();
        Sys.println("VIEW INIT");
    }

    //! Load your resources here
    function onLayout(dc) {
        Sys.println("ON LAYOUT");
        setLayout(Rez.Layouts.RegisterLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
        Sys.println("ON SHOW");
    }

    //! Update the view
    function onUpdate(dc) {
        Sys.println("ON UPDATE");
        if (mHideLoading) {
            findDrawableById("error_msg").setText(mErrorMsg);
            findDrawableById("watch_id").setText(mWatchId);
            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
         } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.clear();
            dc.drawBitmap(dc.getWidth()/2 - 16, dc.getHeight()/2 - 16, Ui.loadResource(Rez.Drawables.loading));
         }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
        Sys.println("ON HIDE");
    }

    function showNotRegistered(watchId) {
        if (mErrorsCount > 0) {
            mErrorMsg = Ui.loadResource(Rez.Strings.register_watch_try_again);
        }
        mErrorsCount++;
        mWatchId = watchId;
        mHideLoading = true;
        Ui.requestUpdate();
    }
}
