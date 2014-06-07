/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 06/10/13
 * Time: 11.34
 */
package it.juca.aigor.template.event {
import flash.events.Event;

public class TemplateEvent extends Event {

    public static const OPEN:String = ENTITY + "Open";
    public static const CLOSE:String = ENTITY + "Close";
    public static const SELECT_SOURCE_FILES:String = ENTITY + "selectSourceFiles";
    public static const CHANGED:String = ENTITY + "changed";
    private static var ENTITY:String = "TemplateEvent";

    public function TemplateEvent(type:String, value:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        this.value = value;
        super(type, bubbles, cancelable);
    }

    public var value:Object;

    override public function clone():Event {
        return new TemplateEvent(super.type, value, super.bubbles, super.cancelable);
    }
}
}
