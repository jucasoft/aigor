package com.dehats.fgl.analysis {
import mx.collections.ArrayCollection;

/**
 *
 * @author davidderaedt
 *
 * Parser for any SQL DB structure file (basically, a list of CREATE TABLE statements)
 *
 */

public class SQLStructureParser {

    public function analyzeCode(pSQL:String):SQLDBData {

        pSQL = pSQL.replace(/\-\-s*.*\n/g, ""); // remove -- comments
        pSQL = pSQL.replace(/SETs*.*\n/g, ""); // remove SET directives

        var sqlDbData:SQLDBData = new SQLDBData();

        var col:ArrayCollection = new ArrayCollection();


        var tab:Array = pSQL.split("CREATE TABLE ");

        tab.shift(); // get rid of the first element, which is blank

        for (var i:int = 0; i < tab.length; i++) {
            var tableString:String = tab[i];

            var table:SQLTable = getTableFromString(tableString);

            col.addItem(table);
        }


        sqlDbData.tables = col;

        return sqlDbData;

    }

    private function getTableFromString(pString:String):SQLTable {

        var table:SQLTable = new SQLTable;

        var tableName:String = pString.match(/\w+/g)[0];


        table.name = tableName;
        table.fields = new ArrayCollection();

        var i1:int = pString.indexOf("(");
        var i2:int = pString.lastIndexOf(")");

        var fieldsString:String = pString.substring(i1 + 1, i2);

        var fieldsTab:Array = split(fieldsString);


        for (var i:int = 0; i < fieldsTab.length; i++) {
            var fieldString:String = fieldsTab[i];

            // get rid of the first blanks
            fieldString = fieldString.replace(/\s*/, "");
            //trace("->"+fieldString)

            var field:SQLTableField = new SQLTableField();


            // PRIMARY KEY as an argument for an existing field (MySQL)
            if (fieldString.indexOf("PRIMARY KEY") == 0) {
                var name:String = fieldString.match(/\w+/g)[2];
                var f:SQLTableField = getFieldByName(name, table.fields);

                if (f == null) {
                    trace("Unable to find this field");
                    continue;
                }

                f.is_primary_key = true;
            }
            else if (fieldString.indexOf("INDEX") == 0) {
                // TODO deal with indices
            }
            else if (fieldString.indexOf("KEY") == 0) {
                //MySQL - MyIsam does not support FK, so we
                // consider Keys as FK

                var KeyWords:Array = fieldString.match(/\w+/g);
                field.name = KeyWords[2];
                field.is_foreign_key = true;
                table.foreignKeys.addItem(field);

            }

            else if (fieldString.indexOf("FOREIGN KEY") == 0) {
                // foreign keys (MySQL - innoDB only)
                var FKWords:Array = fieldString.match(/\w+/g);

                field.name = FKWords[2];
                field.is_foreign_key = true;
                table.foreignKeys.addItem(field);

            }

            // New field definition
            else {
                var t:Array = fieldString.match(/\w+/g);
                field.name = t[0];
                field.type = t[1];

                // PRIMARY KEY as an option for the created field (Oracle, SQLServer)
                if (fieldString.indexOf("PRIMARY KEY") != -1) field.is_primary_key = true;

                // foreign keys (Oracle, SQLServer)
                if (fieldString.indexOf("references") > 0) {
                    field.is_foreign_key = true;
                    table.foreignKeys.addItem(field);
                }

                table.fields.addItem(field);

            }

        }

        return table;

    }

    private function getFieldByName(pFieldName:String, pFieldList:ArrayCollection):SQLTableField {
        for (var i:int = 0; i < pFieldList.length; i++) {
            var f:SQLTableField = pFieldList.getItemAt(i) as SQLTableField;
            if (f.name == pFieldName) return f;
        }

        return null;
    }


    private function getTableByName(pTableName:String, pTableList:ArrayCollection):SQLTable {
        for (var i:int = 0; i < pTableList.length; i++) {
            var t:SQLTable = pTableList.getItemAt(i) as SQLTable;
            if (t.name == pTableName) return t;
        }

        return null;
    }


    // Orginal code from
    //http://www.schelterstudios.com/blog/?p=39

    public function split(args:String):Array {

        var arr:Array = [];
        var i:int = 0;
        var d:int = 0;
        var posOP:int = args.indexOf("(");
        var posCP:int = args.indexOf(")");
        var posCM:int = args.indexOf(",");

        while (posOP >= 0 || posCP >= 0 || posCM >= 0) {

            // check to see if there's an open parenthesis without a close parenthesis
            if (posOP >= 0 && posCP < 0) throw new Error("syntax error: missing )");

            // if comma exists and is closest, check the depth
            if (posCM >= 0 && (posOP < 0 || posCM < posOP) && (posCP < 0 || posCM < posCP)) {

                // if depth is 0, then split string
                if (d == 0) {
                    arr.push(args.substring(i, posCM));
                    i = posCM + 1;
                }
                posCM = args.indexOf(",", posCM + 1);

            }
            // if open parenthesis exists and is closest, increment depth
            else if (posOP >= 0 && posOP < posCP) {
                d++;
                posOP = args.indexOf("(", posOP + 1);

            }
            // else decrement depth
            else {
                d--;
                if (d < 0) throw new Error("syntax error: found ) before (");
                posCP = args.indexOf(")", posCP + 1);
            }
        }

        arr.push(args.substring(i));
        return arr;
    }


}
}