/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 12/11/13
 * Time: 23.43
 */
package it.juca.aigor.application.menu.view {
import it.juca.application.configfile.event.ConfigEvent;
import it.juca.application.menu.event.SelectMenuEvent;
import it.juca.application.menu.model.api.IMenuBar;
import it.juca.application.menu.view.IconMenuMediator;

import mx.core.UIComponent;

public class MenuBarMediator extends IconMenuMediator {


    [Inject]
    public var menuBar:IMenuBar;

    private var map:Array = [
        "saveButton",
        "saveAsButton",
        "garbageCollectionButton"
    ];

    override public function initialize():void {
        super.initialize();
        profile(false);
        addContextListener(ConfigEvent.NEW_CONFIGURATION_SUCCESS, onProfile);
        addContextListener(ConfigEvent.OPEN_CONFIGURATION_SUCCESS, onProfile);
    }

    private function profile(value:Boolean):void {
        for each (var proprety:String in map) {
            var uiComponent:UIComponent = menuBar[proprety];
            uiComponent.enabled = value;
        }
    }

    override protected function onSelect(event:SelectMenuEvent):void {
        super.onSelect(event);
    }

    private function onProfile(event:ConfigEvent):void {
        profile(true);
    }

}
}
