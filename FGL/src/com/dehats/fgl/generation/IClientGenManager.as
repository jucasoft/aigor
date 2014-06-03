package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.PseudoClass;

/**
 *
 * @author davidderaedt
 *
 * Base interface for classes that manage Flex/AIR applications code generation
 *
 * In the future, this could define classes that manage any kind of client side applications (not just flex)
 *
 *
 */

public interface IClientGenManager extends IGenManager {

    function addRemoteService(pClassFile:PseudoClass, pEndPointURL:String, pDestinationURL:String):Array;

    function addVO(pClassFile:PseudoClass, pAddEvent:Boolean, pAddListView:Boolean, pAddFormView:Boolean, pTargetName:String = null):Array;

    function createEvent(pName:String, pSuperClass:String, pProp:String):GeneratedFile;

    function createSingleton(pName:String):GeneratedFile;

}
}