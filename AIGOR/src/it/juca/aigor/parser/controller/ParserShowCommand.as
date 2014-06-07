package it.juca.aigor.parser.controller {
import flash.events.IEventDispatcher;

import it.juca.aigor.parser.event.ParserEvent;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ParserShowCommand implements ICommand {

    [Inject]
    public var eventDispatcher:IEventDispatcher;

    public function execute():void {
        eventDispatcher.dispatchEvent(new ParserEvent(ParserEvent.OPEN));
    }

}
}
