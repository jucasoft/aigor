package com.dehats.fgl.analysis {

/**
 *
 * @author davidderaedt
 *
 * Represents a variable ( as a member of a class)
 *
 */

public class PseudoVariable {

    public var name:String;
    public var type:String;
    public var isGetSet:Boolean;

    public function PseudoVariable(pName:String, pType:String = "String", pGetSet:Boolean = false) {
        name = pName;
        type = pType;
        isGetSet = pGetSet;
    }

}
}