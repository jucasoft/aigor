/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 06/10/13
 * Time: 22.31
 */
package it.juca.aigor.template.view {
import flash.events.Event;

import it.juca.aigor.template.event.TemplateEvent;

import it.juca.aigor.template.model.api.ITemplateContainer;
import it.juca.aigor.template.view.components.TemplateView;

import mx.core.IVisualElement;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 *  Mediator utilizzato in quei casi si debba aggiungere un elemento ad una view
 */
public class TemplateContainerMediator extends Mediator {

    [Inject]
    public var container:ITemplateContainer;
    private var _view:IVisualElement;

    override public function initialize():void {
        addContextListener(TemplateEvent.OPEN, onOpen);
        addContextListener(TemplateEvent.CLOSE, onClose);
    }

    protected function getNewView():IVisualElement {
        throw new Error();
    }

    private function onOpen(ev:Event):void {
        container.templateContainer.removeAllElements();
        _view = new TemplateView();
        container.templateContainer.addElement(_view);
    }

    private function onClose(ev:Event):void {
        container.templateContainer.removeAllElements();
        _view = null;
    }

}
}
