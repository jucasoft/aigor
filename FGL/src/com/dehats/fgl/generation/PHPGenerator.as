package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.*;
import com.dehats.fgl.utils.StringTools;

/**
 *
 * @author davidderaedt
 *
 * Class responsible for generating PHP files from templates, or from scratch
 *
 */

public class PHPGenerator {

    public function generateVO(pTemplate:String, pSQLTable:SQLTable):GeneratedFile {
        var str:String = pTemplate;

        var className:String = pSQLTable.name;
        className = StringTools.upperFirstChar(className);

        var properties:String = "";
        var mapping:String = "";

        for (var i:int = 0; i < pSQLTable.fields.length; i++) {
            var field:SQLTableField = pSQLTable.fields.getItemAt(i) as SQLTableField;
            properties += "\tpublic $" + field.name + ";\n";
            mapping += "\t\t$this->" + field.name + ' = $data["' + field.name + '"];\n';
        }


        str = str.replace(/\*CLASS\*/g, className);
        str = str.replace(/\*PROPERTIES\*/, properties);
        str = str.replace(/\*MAPPING\*/, mapping);

        var phpFile:GeneratedFile = new GeneratedFile(className + "VO", "php", "vo");
        phpFile.code = str;

        return phpFile;
    }

    public function generateService(pTemplate:String, pSQLTableList:Array, pServiceName:String):GeneratedFile {
        var str:String = pTemplate;

        str = str.replace(/\*SERVICENAME\*/g, pServiceName);


        var imports:String = "";
        var methods:String = "";
        var propertyDeclarations:String = "";
        var propertyInits:String = "";


        for (var i:int = 0; i < pSQLTableList.length; i++) {
            var table:SQLTable = pSQLTableList[i];

            // IMPORTS
            var className:String = StringTools.upperFirstChar(table.name);
            var daoPropName:String = table.name + "DAO";

            imports += 'require_once "vo/' + className + 'VO.php";\n';
            imports += 'require_once "dao/' + className + 'DAO.php";\n';

            propertyDeclarations += "\t private $" + daoPropName + ";\n";
            propertyInits += "\t\t$this->" + daoPropName + " = new " + className + "DAO;\n";

            // METHODS
            methods += '\t// ' + className + '\n\n';

            methods += '\tpublic function getAll' + className + '()\n\t{\n';
            methods += '\t\treturn $this->' + daoPropName + '->getAll();\n\t}\n\n\n';

            // Foreign key methods
            for (var j:int = 0; j < table.foreignKeys.length; j++) {
                var fk:SQLTableField = table.foreignKeys.getItemAt(j) as SQLTableField;
                methods += '\tpublic function getAll' + className + 'By_' + fk.name + '($pValue)\n\t{\n';
                methods += '\t\treturn $this->' + daoPropName + '->getBy_' + fk.name + '($pValue);\n\t}\n\n\n';

            }


            methods += '\tpublic function getOne' + className + '($p' + className + 'ID)\n\t{\n';
            methods += '\t\treturn $this->' + daoPropName + '->getOne($p' + className + 'ID);\n\t}\n\n\n';

            methods += '\tpublic function create' + className + '($p' + className + ')\n\t{\n';
            methods += '\t\treturn $this->' + daoPropName + '->create($p' + className + ');\n\t}\n\n\n';

            methods += '\tpublic function update' + className + '($p' + className + ')\n\t{\n';
            methods += '\t\treturn $this->' + daoPropName + '->update($p' + className + ');\n\t}\n\n\n';

            methods += '\tpublic function delete' + className + '($p' + className + 'ID)\n\t{\n';
            methods += '\t\treturn $this->' + daoPropName + '->delete($p' + className + 'ID);\n\t}\n\n\n';

        }

        str = str.replace(/\*IMPORTS\*/, imports);
        str = str.replace(/\*METHODS\*/, methods);
        str = str.replace(/\*PROPDECLAR\*/, propertyDeclarations);
        str = str.replace(/\*PROPINIT\*/, propertyInits);


        var phpFile:GeneratedFile = new GeneratedFile(pServiceName, "php", "");
        phpFile.code = str;

        return phpFile;
    }


    public function generateDAO(pTemplate:String, pSQLTable:SQLTable, accessAsObject:Boolean):GeneratedFile {

        var str:String = pTemplate;

        var className:String = pSQLTable.name;
        className = StringTools.upperFirstChar(className);

        var primaryKey:String = pSQLTable.getPrimaryKey().name;

        var fieldsInsert:String = "";
        var valuesInsert:String = "";
        var fieldsUpdate:String = "";
        var accessPrimaryKey:String = "";

        for (var i:int = 0; i < pSQLTable.fields.length; i++) {
            var field:SQLTableField = pSQLTable.fields.getItemAt(i) as SQLTableField;

            if (field.is_primary_key) continue;

            fieldsInsert += "\t\t" + field.name;

            var objVal:String;

            if (accessAsObject) {
                accessPrimaryKey = "$obj->" + primaryKey;
                objVal = '"' + ".mysql_real_escape_string($obj->" + field.name + ')."' + "'";
            }
            else {
                accessPrimaryKey = '$obj["' + primaryKey + '"]';
                objVal = '"' + ".mysql_real_escape_string($obj[" + '"' + field.name + '"' + "])." + '"' + "'";
            }

            valuesInsert += "\t\t'" + objVal;
            fieldsUpdate += "\t\t" + field.name + " = '" + objVal;


            if (i != pSQLTable.fields.length - 1) {
                fieldsInsert += ",\n";
                valuesInsert += ",\n";
                fieldsUpdate += ",\n";
            }
            else {
                fieldsInsert += "\n";
                valuesInsert += "\n";
                fieldsUpdate += "\n";
            }
        }


        str = str.replace(/\*CLASS\*/g, className);
        str = str.replace(/\*SQLTABLE\*/g, pSQLTable.name);
        str = str.replace(/\*PRIMARYKEYFIELD\*/g, primaryKey);
        str = str.replace(/\*ACCESSPRIMARYKEYFIELD\*/g, accessPrimaryKey);
        str = str.replace(/\*FIELDSINSERT\*/g, fieldsInsert);
        str = str.replace(/\*VALUESINSERT\*/g, valuesInsert);
        str = str.replace(/\*FIELDSUPDATES\*/g, fieldsUpdate);


        var foreignKeyMethods:String = "";

        for (var j:int = 0; j < pSQLTable.foreignKeys.length; j++) {
            var fk:SQLTableField = pSQLTable.foreignKeys.getItemAt(j) as SQLTableField;
            foreignKeyMethods += "\tpublic function getBy_" + fk.name + "($pValue)\n\t{\n";
            foreignKeyMethods += "\t\t$rs = mysql_query('SELECT * FROM " + pSQLTable.name + " WHERE " + fk.name + " = '.$pValue);\n";
            foreignKeyMethods += "\t\treturn $this->mapRecordSet($rs);\n";
            foreignKeyMethods += "\t}\n\n";
        }


        str = str.replace(/\*ADD_METHODS\*/g, foreignKeyMethods);


        var phpFile:GeneratedFile = new GeneratedFile(className + "DAO", "php", "dao");
        phpFile.code = str;

        return phpFile;

    }


}
}