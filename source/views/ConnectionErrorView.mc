using Toybox.WatchUi as Ui;

class ConnectionErrorDelegate extends Ui.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
}

class ConnectionErrorView extends Ui.View {
    hidden var mMessage;
    function initialize(message) {
        View.initialize();
        mMessage = message;
    }
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.ConnectionErrorLayout(dc));
        var centerX = dc.getWidth() / 2;
        findDrawableById("connection_error_title").setLocation(centerX, RenderTools.scaleY(dc, 10));
        findDrawableById("error_msg").setLocation(centerX, RenderTools.scaleY(dc, 100));
    }

    function onUpdate(dc) {
        findDrawableById("error_msg").setText(mMessage.toString());
        View.onUpdate(dc);
    }
}