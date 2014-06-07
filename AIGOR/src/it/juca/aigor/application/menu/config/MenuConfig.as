/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 30/09/13
 * Time: 21.49
 */
package it.juca.aigor.application.menu.config {
import it.juca.aigor.application.menu.view.MenuBarMediator;
import it.juca.application.menu.controller.ExecutorCommand;
import it.juca.application.menu.event.SelectMenuEvent;
import it.juca.application.menu.model.api.IMenuBar;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class MenuConfig implements IConfig {

    [Inject]
    public var injector:IInjector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var commandMap:IEventCommandMap;

    public function configure():void {
        mediatorMap.map(IMenuBar).toMediator(MenuBarMediator);
        commandMap.map(SelectMenuEvent.EVENT_SELECTMENUEVENT, SelectMenuEvent).toCommand(ExecutorCommand);


    }

}

}