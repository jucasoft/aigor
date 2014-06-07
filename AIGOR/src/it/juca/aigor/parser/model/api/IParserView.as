/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 23.31
 */
package it.juca.aigor.parser.model.api {
import com.dehats.fgl.analysis.ICodeParser;

import mx.collections.ArrayCollection;

public interface IParserView {
    function set value(value:String):void;

    function set parsers(value:ArrayCollection):void;

    function set files(value:ArrayCollection):void;

    function get selectedParser():ICodeParser;

    function get selectedExtension():String;



}
}
