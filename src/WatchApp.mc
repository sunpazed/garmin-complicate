using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.Complications as Complications;

public class WatchApp extends App.AppBase {


    function initialize() {
      App.AppBase.initialize();
    }

    function onSettingsChanged() {
      Ui.requestUpdate();
    }

    // register all the complication callbacks
    function onStart(state) {
      Complications.registerComplicationChangeCallback(self.method(:onComplicationUpdated));
      Complications.subscribeToUpdates(new Complications.Id(Complications.COMPLICATION_TYPE_HEART_RATE));
      Complications.subscribeToUpdates(new Complications.Id(Complications.COMPLICATION_TYPE_STEPS));
      Complications.subscribeToUpdates(new Complications.Id(Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE));
      Complications.subscribeToUpdates(new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY));
    }

    // fetches the complication when it changes, and passes to the Watchface
    function onComplicationUpdated(complicationId) {
        if (WatchView != null) {
            try {
                WatchView.updateComplication(complicationId);
            } catch (e) {
                Sys.println("error passing complicaiton to watchface");
            }
        }
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new WatchView(), new WatchDelegate()  ];
    }

}
