/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 06/10/13
 * Time: 11.34
 */
package it.juca.aigor.source.event {
import flash.events.Event;

public class SourceEvent extends Event {

    public static const OPEN:String = ENTITY + "Open";
    public static const CLOSE:String = ENTITY + "Close";
    public static const SELECT_SOURCE_FILES:String = ENTITY + "selectSourceFiles";
    public static const REMOVE_SELECTED:String = ENTITY + "removeSelected";
    private static var ENTITY:String = "SourceEvent";

    public var value:Object;

    public function SourceEvent(type:String, value:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        this.value = value;
        super(type, bubbles, cancelable);
    }

    override public function clone():Event {
        return new SourceEvent(super.type, value ,super.bubbles, super.cancelable);
    }
}
}
