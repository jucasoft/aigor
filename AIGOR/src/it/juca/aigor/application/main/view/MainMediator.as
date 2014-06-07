/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 22.23
 */
package it.juca.aigor.application.main.view {
import it.juca.aigor.parser.event.ParserEvent;
import it.juca.aigor.project.model.ProjectProxy;
import it.juca.aigor.project.model.vo.Project;
import it.juca.aigor.source.event.SourceEvent;
import it.juca.aigor.template.event.TemplateEvent;
import it.juca.application.configfile.event.ConfigEvent;

import robotlegs.bender.bundles.mvcs.Mediator;

public class MainMediator extends Mediator {

    [Inject]
    public var projectProxy:ProjectProxy;

    override public function initialize():void {
        addContextListener(ConfigEvent.NEW_CONFIGURATION_SUCCESS, newPrizeDrawView);
        addContextListener(ConfigEvent.OPEN_CONFIGURATION_SUCCESS, openPrizeDrawView);
    }

    private function newPrizeDrawView(event:ConfigEvent):void {
        openPrizeDrawView(event);
    }

    private function openPrizeDrawView(event:ConfigEvent):void {
        projectProxy.projext = Project(event.data);
        eventDispatcher.dispatchEvent(new SourceEvent(SourceEvent.OPEN));
        eventDispatcher.dispatchEvent(new TemplateEvent(TemplateEvent.OPEN));
        eventDispatcher.dispatchEvent(new ParserEvent(ParserEvent.OPEN));
    }
}
}
