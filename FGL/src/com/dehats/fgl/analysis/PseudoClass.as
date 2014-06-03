package com.dehats.fgl.analysis {
/**
 *
 * @author davidderaedt
 *
 * Represents a class (result of code parsing)
 *
 */

[Bindable]
public class PseudoClass {

    public var packageName:String = "";
    public var className:String;
    public var properties:Array = new Array();
    public var methods:Array = new Array();


    public function get qualifiedClassName():String {
        if (packageName.length == 0) return className;
        else return packageName + "." + className;
    }

}
}