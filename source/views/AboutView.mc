using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class AboutViewDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(evt) {
        closeAbout();
        return true;
    }
    function onTap(evt) {
        closeAbout();
        return true;
    }

    function closeAbout() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}

class AboutView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.AboutLayout(dc));
        var centerX = dc.getWidth() / 2;
        findDrawableById("about_title").setLocation(centerX, RenderTools.scaleY(dc, 10));
        findDrawableById("about_subtitle").setLocation(centerX, RenderTools.scaleY(dc, 50));
        findDrawableById("about_url").setLocation(centerX, RenderTools.scaleY(dc, 100));
        findDrawableById("version").setLocation(centerX, RenderTools.scaleY(dc, 160));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
     }

    //! Update the view
    function onUpdate(dc) {
        (findDrawableById("version") as Ui.Text).setText(VERSION);
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }
}
