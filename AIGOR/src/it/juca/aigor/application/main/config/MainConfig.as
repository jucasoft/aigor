/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 23.03
 */
package it.juca.aigor.application.main.config {
import it.juca.aigor.application.main.model.api.IMainView;
import it.juca.aigor.application.main.view.MainMediator;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class MainConfig implements IConfig {

    [Inject]
    public var injector:IInjector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var commandMap:IEventCommandMap;

    public function configure():void {
        mediatorMap.map(IMainView).toMediator(MainMediator);
        /*        mediatorMap.map(IMainView).toMediator(MainMediator);
         injector.map(String, "settings").toValue('settings.jdb');
         commandMap.map(ExtractionEvent.EXTRACT, ExtractionEvent).toCommand(ExtractCommand);*/

    }
}
}
