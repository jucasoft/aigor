package com.dehats.fgl.generation {
/**
 *
 * @author davidderaedt
 *
 * Base interface for every kind of code generation manager.
 *
 * An IGenManager is the object you use to create GeneratedFile objects (out of templates or from scratch)
 *
 * It may delegate the actual code generation job to another class (eg CairngormGenManager delegates this to CairgormGenerator).
 *
 *
 */

public interface IGenManager {
    function init(pPackageConfig:PackageConfig):void;

    function createBaseFiles():Array;
}
}