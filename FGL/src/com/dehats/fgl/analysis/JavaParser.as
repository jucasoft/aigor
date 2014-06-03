package com.dehats.fgl.analysis {

import com.dehats.fgl.utils.StringTools;

/**
 *
 * @author davidderaedt
 *
 * Java file parser
 *
 */
public class JavaParser implements ICodeParser {

    public function parseCode(javaCode:String):Array {

        // Remove strings
        javaCode = javaCode.replace(/"[^"]*"/g, ""); // double quotes
        javaCode = javaCode.replace(/'[^']*'/g, ""); // simple quote

        // Remove comments
        javaCode = javaCode.replace(/\/\/\s*.*\n/g, ""); // comments
        javaCode = javaCode.replace(/\/\*.*\*\//g, "");
        /* one line */
        javaCode = javaCode.replace(/\/\*.*?\*\//sg, "");
        /* multiline */


        //Get package Name
        var packageName:String = "";
        var packagesDecls:Array = javaCode.match(/package\s+.*;/);

        if (packagesDecls != null && packagesDecls.length > 0) {
            var rawP:String = packagesDecls[0];
            packageName = rawP.substring(8, rawP.length - 1);
        }

        // Get Class name
        var classDefList:Array = javaCode.match(/class\s+\w+/i);

        if (classDefList.length == 0) return [];


        var tab:Array = [];

        for (var i:int = 0; i < classDefList.length; i++) {
            var thisClassName:String = classDefList[i];

            var endOfSearch:int;

            if (i < classDefList.length - 1) {
                var nextClassName:String = classDefList[i + 1];
                endOfSearch = javaCode.indexOf(nextClassName);
            }
            else {
                endOfSearch = javaCode.lastIndexOf("}");
            }

            var classBody:String = javaCode.substring(javaCode.indexOf(thisClassName), endOfSearch);
            tab.push(classBody);
        }


        var classList:Array = [];

        for (var j:int = 0; j < tab.length; j++) {
            var c:PseudoClass = analyzeClass(tab[j], packageName);
            classList.push(c);
        }

        return classList;

    }


    private function analyzeClass(classCode:String, pPackageName:String):PseudoClass {

        var javaClassFile:PseudoClass = new PseudoClass();

        javaClassFile.className = classCode.match(/\w+/g)[1];//classCode.split(" ")[1];
        javaClassFile.packageName = pPackageName;


        // Get class block code

        var classCode:String = classCode.substring(classCode.indexOf("{") + 1, classCode.lastIndexOf("}"));

        // List public methods

        //var rawMethodTable:Array = classCode.match(/public\s+\w+\s+\w+(.+)\)/g);
        var rawMethodTable:Array = classCode.match(/public\s+\w+(.+)\)/g);


        for (var a:int = 0; a < rawMethodTable.length; a++) {
            var s:String = rawMethodTable[a];

            var meth:PseudoClassMethod = new PseudoClassMethod();
            var returnType:String = s.match(/\w+/g)[1];

            meth.returnType = getASEquivType(returnType);

            var methodName:String = s.match(/\w+\s*\(/)[0];
            meth.name = methodName.match(/\w+/)[0];

            var paramsString:String = s.match(/\(.*\)/)[0];
            paramsString = paramsString.replace(/[\$\(\)]/g, "");

            if (paramsString != "") {
                var argsName:Array = paramsString.split(",");
                for (var b:int = 0; b < argsName.length; b++) {
                    var argTab:Array = argsName[b].match(/\w+/g);
                    var argName:String = argTab[1];
                    var argType:String = getASEquivType(argTab[0]);

                    meth.arguments.push(new PseudoVariable(argName, argType));
                }
            }

            if (meth.name != javaClassFile.className) javaClassFile.methods.push(meth);

        }

        // look for properties

        // ...in variables
        var rawVarTable:Array = classCode.match(/public\s+\w+\s+\w+\s*;/g);
        var rawVarTable2:Array = classCode.match(/public\s+\w+\s+\w+\s*=/g);
        rawVarTable = rawVarTable.concat(rawVarTable2);

        for (var j:int = 0; j < rawVarTable.length; j++) {
            var rawVar:String = rawVarTable[j];
            var tb:Array = rawVar.match(/\w+/g);

            var vName:String = tb[2];
            var type:String = getASEquivType(tb[1]);
            var v:PseudoVariable = new PseudoVariable(vName, type)
            javaClassFile.properties.push(v);

        }


        // ... in getter/setters

        var mList:Array = javaClassFile.methods
        for (var i:int = 0; i < mList.length; i++) {
            trace(mList)
            var met:PseudoClassMethod = mList[i];
            var name:String = met.name;
            var propName:String = name.substr(3);
            if (name.indexOf("get") == 0) {
                //if(findSetter(javaClassFile, propName))
                //{
                var _vName:String = StringTools.lowerFirstChar(propName);
                var _type:String = getASEquivType(met.returnType);
                var _v:PseudoVariable = new PseudoVariable(_vName, _type)
                javaClassFile.properties.push(_v);
                //}
            }

        }

        return javaClassFile;//javaClassFile;
    }

    private function findSetter(javaClassFile:PseudoClass, pName:String):Boolean {
        var mList:Array = javaClassFile.methods

        for (var i:int = 0; i < mList.length; i++) {

            var met:PseudoClassMethod = mList[i];
            var name:String = met.name;
            if (met.name == "set" + pName) return true;

        }
        return false;
    }


    private function getASEquivType(pJavaType:String):String {

        if (pJavaType == "byte") return "int";
        if (pJavaType == "short") return "int";
        if (pJavaType == "long") return "int";
        if (pJavaType == "float") return "Number";
        if (pJavaType == "double") return "Number";
        if (pJavaType == "char") return "String";
        if (pJavaType == "Map") return "Object";
        if (pJavaType == "Dictionnary") return "Object";
        if (pJavaType == "Document") return "XML";
        if (pJavaType == "ArrayList") return "Array";
        if (pJavaType == "List") return "Array";

        if (pJavaType == "void") return "Object";

        return pJavaType;
    }

}
}