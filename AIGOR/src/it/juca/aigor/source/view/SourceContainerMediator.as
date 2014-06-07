/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 06/10/13
 * Time: 11.31
 */
package it.juca.aigor.source.view {
import flash.events.Event;

import it.juca.aigor.source.event.SourceEvent;
import it.juca.aigor.source.model.api.ISourceContainer;
import it.juca.aigor.source.view.components.SourceView;

import mx.core.IVisualElement;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 *  Mediator utilizzato in quei casi si debba aggiungere un elemento ad una view
 */
public class SourceContainerMediator extends Mediator {

    [Inject]
    public var container:ISourceContainer;
    private var _view:IVisualElement;

    override public function initialize():void {
        addContextListener(SourceEvent.OPEN, onOpen);
        addContextListener(SourceEvent.CLOSE, onClose);
    }

    protected function getNewView():IVisualElement {
        throw new Error();
    }

    private function onOpen(ev:Event):void {
        container.sourceContainer.removeAllElements();
        _view = new SourceView();
        container.sourceContainer.addElement(_view);
    }

    private function onClose(ev:Event):void {
        container.sourceContainer.removeAllElements();
        _view = null;
    }

}
}
