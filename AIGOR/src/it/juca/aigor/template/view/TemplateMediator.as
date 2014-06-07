/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 21.30
 */
package it.juca.aigor.template.view {
import it.juca.aigor.application.utils.SelectFile;
import it.juca.aigor.template.event.TemplateEvent;
import it.juca.aigor.template.model.TemplateProxy;
import it.juca.aigor.template.model.api.ITemplateView;

import robotlegs.bender.bundles.mvcs.Mediator;

public class TemplateMediator extends Mediator {

    [Inject]
    public var proxy:TemplateProxy;
    [Inject]
    public var view:ITemplateView;

    override public function initialize():void {
        super.initialize();
        view.value = proxy.template;
        addViewListener(TemplateEvent.SELECT_SOURCE_FILES, onSelectSourceFiles);
        addViewListener(TemplateEvent.CHANGED, onchanged);
    }

    override public function destroy():void {
        super.destroy();
    }

    private function onSelect(value:String):void {
        proxy.template = value;
        view.value = proxy.template;
    }

    private function onchanged(event:TemplateEvent):void {
        proxy.template = event.value as String;
    }

    private function onSelectSourceFiles(event:TemplateEvent):void {
        new SelectFile(onSelect).load();
    }
}
}
