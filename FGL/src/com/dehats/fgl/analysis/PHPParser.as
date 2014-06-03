package com.dehats.fgl.analysis {
/**
 *
 * @author davidderaedt
 *
 * PHP file parser
 *
 */

public class PHPParser implements ICodeParser {

    public function parseCode(phpCode:String):Array {

        // Remove strings
        phpCode = phpCode.replace(/"[^"]*"/g, ""); // double quotes
        phpCode = phpCode.replace(/'[^']*'/g, ""); // simple quote

        // Remove comments
        phpCode = phpCode.replace(/\/\/\s*.*\n/g, ""); // comments
        phpCode = phpCode.replace(/\/\*.*\*\//g, "");
        /* one line */
        phpCode = phpCode.replace(/\/\*.*?\*\//sg, "");
        /* multiline */


        // Get Class name
        var classDefList:Array = phpCode.match(/class\s+\w+/gi);
        if (classDefList.length == 0)return [];


        var tab:Array = [];

        for (var i:int = 0; i < classDefList.length; i++) {
            var thisClassName:String = classDefList[i];

            var endOfSearch:int;

            if (i < classDefList.length - 1) {
                var nextClassName:String = classDefList[i + 1];
                endOfSearch = phpCode.indexOf(nextClassName);
            }
            else {
                endOfSearch = phpCode.lastIndexOf("}") + 1;
            }

            var classBody:String = phpCode.substring(phpCode.indexOf(thisClassName), endOfSearch);
            tab.push(classBody);
        }


        var classList:Array = [];

        for (var j:int = 0; j < tab.length; j++) {
            var c:PseudoClass = analyzeClass(tab[j], "");
            classList.push(c);
        }

        return classList;
    }


    private function analyzeClass(classCode:String, pPackageName:String):PseudoClass {

        var phpClassFile:PseudoClass = new PseudoClass();

        phpClassFile.className = classCode.match(/\w+/g)[1];


        // Get class block code

        var classCode:String = classCode.substring(classCode.indexOf("{") + 1, classCode.lastIndexOf("}"));

        // WARNING : The following assumes that vars are always declared before functions !

        var firstFunctionPos:int = classCode.indexOf("function");
        var properties:String;
        if (firstFunctionPos != -1)  properties = classCode.substring(0, firstFunctionPos);
        else properties = classCode;

        // List properties
        var publicTab:Array = properties.match(/public\s+\$\w+\s*;/g);
        var publicTab2:Array = properties.match(/public\s+\$\w+\s*=/g);
        var varTab:Array = properties.match(/var\s+\$\w+\s*;/g);
        var varTab2:Array = properties.match(/var\s+\$\w+\s*=/g);
        var propTab:Array = publicTab.concat(varTab, publicTab2, varTab2);

        for (var i:int = 0; i < propTab.length; i++) {
            var ps:String = propTab[i];
            var p:String = ps.match(/\w+/g)[1];

            // Consider _ as private flag
            if (p.charAt(0) != "_") {
                phpClassFile.properties.push(new PseudoVariable(p));
            }
        }


        // List methods

        var rawMethodTable:Array = classCode.match(/(\w+ )?function(.+)\)/g);

        for (var a:int = 0; a < rawMethodTable.length; a++) {
            var s:String = rawMethodTable[a];

            // ignore private and protected methods
            if (s.indexOf("protected") == 0 || s.indexOf("private") == 0) continue;

            var meth:PseudoClassMethod = new PseudoClassMethod();

            var methodName:String = s.match(/\w+\s?\(/)[0];
            meth.name = methodName.match(/\w+/)[0];

            var paramsString:String = s.match(/\(.*\)/)[0];
            paramsString = paramsString.replace(/[ \$\(\)]/g, "");


            if (paramsString != "") {
                var argsName:Array = paramsString.split(",");
                for (var b:int = 0; b < argsName.length; b++) {
                    meth.arguments.push(new PseudoVariable(argsName[b], "Object"));
                }
            }

            if (meth.name != phpClassFile.className) phpClassFile.methods.push(meth);

        }

        return phpClassFile;
    }

}
}