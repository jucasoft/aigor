package com.dehats.fgl.analysis {
import mx.collections.ArrayCollection;

/**
 *
 * @author davidderaedt
 *
 * Represents an SQL DB table
 *
 */
[Bindable]
public class SQLTable {

    public var name:String;

    public var fields:ArrayCollection;

    public var foreignKeys:ArrayCollection = new ArrayCollection();


    // returns first primary key
    public function getPrimaryKey():SQLTableField {
        for (var i:int = 0; i < fields.length; i++) {
            var field:SQLTableField = fields.getItemAt(i) as SQLTableField;
            if (field.is_primary_key) return field;
        }

        return null;
    }

}
}