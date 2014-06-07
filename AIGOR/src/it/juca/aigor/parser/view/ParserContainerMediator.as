/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 06/10/13
 * Time: 23.31
 */
package it.juca.aigor.parser.view {
import flash.events.Event;

import it.juca.aigor.parser.event.ParserEvent;
import it.juca.aigor.parser.model.api.IParserContainer;
import it.juca.aigor.parser.view.components.ParserView;

import mx.core.IVisualElement;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 *  questo mediator si occupa di aggiungere l'editor del concorso alla main application.
 */
public class ParserContainerMediator extends Mediator {

    [Inject]
    public var container:IParserContainer;

    private var _view:IVisualElement;

    override public function initialize():void {
        addContextListener(ParserEvent.OPEN, onOpen);
        addContextListener(ParserEvent.CLOSE, onClose);
    }

    private function onOpen(ev:Event):void {
        container.parserContainer.removeAllElements();
        _view = new ParserView();
        container.parserContainer.addElement(_view);
    }

    private function onClose(ev:Event):void {
        container.parserContainer.removeAllElements();
        _view = null;
    }

}
}
