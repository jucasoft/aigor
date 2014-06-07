/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 06/10/13
 * Time: 20.34
 */
package it.juca.aigor.parser.event {
import flash.events.Event;

public class ParserEvent extends Event {

    private static var ENTITY:String = "ParserEvent";

    public static const OPEN:String = ENTITY + "Open";
    public static const CLOSE:String = ENTITY + "Close";
    public static const PARSE:String = ENTITY + "parse";
    public static const GENERATE:String = ENTITY + "generate";

    public function ParserEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }

    override public function clone():Event {
        return new ParserEvent(super.type, super.bubbles, super.cancelable);
    }
}
}
