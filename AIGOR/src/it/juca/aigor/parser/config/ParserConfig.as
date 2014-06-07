/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 20.03
 */
package it.juca.aigor.parser.config {
import it.juca.aigor.parser.model.ParserProxy;
import it.juca.aigor.parser.model.api.IParserContainer;
import it.juca.aigor.parser.model.api.IParserView;
import it.juca.aigor.parser.view.ParserContainerMediator;
import it.juca.aigor.parser.view.ParserMediator;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class ParserConfig implements IConfig {

    [Inject]
    public var injector:IInjector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var commandMap:IEventCommandMap;

    public function configure():void {
        mediatorMap.map(IParserView).toMediator(ParserMediator);
        mediatorMap.map(IParserContainer).toMediator(ParserContainerMediator);
        injector.map(ParserProxy).asSingleton();
    }
}
}
