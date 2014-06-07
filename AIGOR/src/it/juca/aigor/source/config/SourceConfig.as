/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 21.03
 */
package it.juca.aigor.source.config {
import it.juca.aigor.source.model.SourceProxy;
import it.juca.aigor.source.model.api.ISourceContainer;
import it.juca.aigor.source.model.api.ISourceView;
import it.juca.aigor.source.view.SourceContainerMediator;
import it.juca.aigor.source.view.SourceMediator;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class SourceConfig implements IConfig {

    [Inject]
    public var injector:IInjector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var commandMap:IEventCommandMap;

    public function configure():void {
        mediatorMap.map(ISourceView).toMediator(SourceMediator);
        mediatorMap.map(ISourceContainer).toMediator(SourceContainerMediator);
        injector.map(SourceProxy).asSingleton();
        /*        mediatorMap.map(IMainView).toMediator(MainMediator);
         injector.map(String, "settings").toValue('settings.jdb');
         commandMap.map(ExtractionEvent.EXTRACT, ExtractionEvent).toCommand(ExtractCommand);*/

    }
}
}
