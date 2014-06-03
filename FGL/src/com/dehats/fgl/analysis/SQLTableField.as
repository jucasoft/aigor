package com.dehats.fgl.analysis {

/**
 *
 * @author davidderaedt
 *
 * Represents a field - or column - of an SQL Table
 */

public class SQLTableField {

    public var name:String;

    public var type:String;

    public var is_primary_key:Boolean = false;

    public var is_foreign_key:Boolean = false;


}
}