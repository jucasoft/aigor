package com.dehats.fgl.generation {
/**
 *
 * @author davidderaedt
 *
 * Class representing a generated file
 *
 * The application using FGL should be responsible for the actual system file creation
 *
 */

[Bindable]
public class GeneratedFile {

    public var name:String;
    public var code:String;
    public var extension:String;
    public var destination:String;

    public function GeneratedFile(pName:String, pExt:String, pDest:String) {
        name = pName;
        extension = pExt;
        destination = pDest;
    }

    public function get nameWithExt():String {
        return name + "." + extension;
    }
}
}