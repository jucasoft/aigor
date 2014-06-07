/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 06/10/13
 * Time: 20.27
 */
package it.juca.aigor.parser.controller {
import flash.events.IEventDispatcher;

import it.juca.aigor.parser.event.ParserEvent;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ParserHideCommand implements ICommand {

    [Inject]
    public var eventDispatcher:IEventDispatcher;

    public function execute():void {
        eventDispatcher.dispatchEvent(new ParserEvent(ParserEvent.CLOSE));
    }

}
}
