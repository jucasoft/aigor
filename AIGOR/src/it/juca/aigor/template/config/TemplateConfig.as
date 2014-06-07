/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 21.03
 */
package it.juca.aigor.template.config {

import it.juca.aigor.template.model.TemplateProxy;
import it.juca.aigor.template.model.api.ITemplateContainer;
import it.juca.aigor.template.model.api.ITemplateView;
import it.juca.aigor.template.view.TemplateContainerMediator;
import it.juca.aigor.template.view.TemplateMediator;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class TemplateConfig implements IConfig {

    [Inject]
    public var injector:IInjector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var commandMap:IEventCommandMap;

    public function configure():void {
        mediatorMap.map(ITemplateView).toMediator(TemplateMediator);
        mediatorMap.map(ITemplateContainer).toMediator(TemplateContainerMediator);
        injector.map(TemplateProxy).asSingleton();
    }
}
}
