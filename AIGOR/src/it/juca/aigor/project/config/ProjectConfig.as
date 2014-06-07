/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 22.03
 */
package it.juca.aigor.project.config {
import it.juca.aigor.project.model.ProjectProxy;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class ProjectConfig implements IConfig {

    [Inject]
    public var injector:IInjector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var commandMap:IEventCommandMap;

    public function configure():void {
        injector.map(ProjectProxy).asSingleton();

    }
}
}
