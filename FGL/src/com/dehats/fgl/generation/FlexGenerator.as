package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.PseudoClass;
import com.dehats.fgl.analysis.PseudoClassMethod;
import com.dehats.fgl.analysis.PseudoVariable;
import com.dehats.fgl.analysis.RemoteService;
import com.dehats.fgl.utils.StringTools;

import mx.collections.ArrayCollection;

public class FlexGenerator {

    public var useDelegate:Boolean = false;

    public function FlexGenerator(pConfig:PackageConfig) {
        packageConfig = pConfig;
    }

    public var packageConfig:PackageConfig;

    public var templateMgr:TemplateManager = TemplateManager.getInstance();

    protected function replacePackageNames(pOriginal:String):String {
        var str:String = pOriginal;
        str = str.replace(/\*MAINPACKAGE\*/g, packageConfig.mainPackageName);
        str = str.replace(/\*MODELPACKAGE\*/g, packageConfig.modelFullPath);
        str = str.replace(/\*VIEWPACKAGE\*/g, packageConfig.viewFullPath);
        str = str.replace(/\*COMPONENTSPACKAGE\*/g, packageConfig.componentsFullPath);
        str = str.replace(/\*CONTROLPACKAGE\*/g, packageConfig.controlFullPath);
        str = str.replace(/\*COMMANDPACKAGE\*/g, packageConfig.commandFullPath);
        str = str.replace(/\*BUSINESSPACKAGE\*/g, packageConfig.businessFullPath);
        str = str.replace(/\*EVENTSPACKAGE\*/g, packageConfig.eventsFullPath);
        str = str.replace(/\*VOPACKAGE\*/g, packageConfig.voFullPath);

        return str;
    }


    public function generateMainView(pViewCollec:ArrayCollection, pServicesCollec:ArrayCollection):GeneratedFile {
        var pTemplate:String = templateMgr.mainViewTemplateStr;

        var str:String = replacePackageNames(pTemplate);

        var viewsDeclaration:String = "\t<mx:HBox>\n";

        for (var i:int = 0; i < pViewCollec.length; i++) {
            var viewFile:GeneratedFile = pViewCollec.getItemAt(i) as GeneratedFile;
            var viewName:String = viewFile.name;
            var viewName1stCharToLowerCase:String = StringTools.lowerFirstChar(viewName);
            viewsDeclaration += '\t\t<ns1:' + viewName + ' id="' + viewName1stCharToLowerCase + '" />\n\n';
        }

        viewsDeclaration += "\t</mx:HBox>"

        str = str.replace(/\*VIEWS\*/, viewsDeclaration);

        // Remote Objects
        if (!useDelegate) {

            var pROTempl:String = templateMgr.remoteObjectTemplateStr;

            var remoteObjects:String = "";

            for (var j:int = 0; j < pServicesCollec.length; j++) {
                var service:RemoteService = pServicesCollec.getItemAt(j) as RemoteService;
                remoteObjects += generateMXMLRemoteObject(service.serviceName, service.endPoint, service.destination, pROTempl) + "\n\n";
            }


            str = str.replace(/\*SERVICES\*/, remoteObjects);

        }

        else str = str.replace(/\*SERVICES\*/, "");


        var asFile:GeneratedFile = new GeneratedFile("MainView", "mxml", packageConfig.componentsDir);
        asFile.code = str;

        return asFile;

    }


    protected function generateMXMLRemoteObject(pServiceName:String, pEndpoint:String, pDest:String, pTempl:String):String {

        var str:String = pTempl;

        str = str.replace(/\*SERVICENAME\*/g, pServiceName);
        str = str.replace(/\*ENDPOINT\*/, pEndpoint);
        str = str.replace(/\*DESTINATION\*/, pDest);

        return str;

    }

    public function generateEvent(pClassName:String, pQualifiedSuperClass:String, pPublicProperty:String):GeneratedFile {
        var pTemplate:String = templateMgr.eventTemplateStr;

        var str:String = replacePackageNames(pTemplate);
        var lcClassName:String = StringTools.lowerFirstChar(pClassName);
        var superClass:String = pQualifiedSuperClass.substr(pQualifiedSuperClass.lastIndexOf(".") + 1);
        var defaultType:String = "public static const EVENT_" + pClassName.toUpperCase() + ':String = "' + lcClassName + '";'

        str = str.replace(/\*CLASS_NAME\*/g, pClassName);
        str = str.replace(/\*EVENT_SUPERCLASS\*/g, superClass);
        str = str.replace(/\*EVENT_TYPES\*/g, "\t\t" + defaultType);

        var imports:String;
        if (pQualifiedSuperClass == "flash.events.Event") imports = "";
        else imports = "\timport " + pQualifiedSuperClass + ";\n";

        if (pPublicProperty.length > 0) {
            var propertyType:String = pPublicProperty.substr(pPublicProperty.lastIndexOf(".") + 1);
            var propertyIdentifier:String = StringTools.lowerFirstChar(propertyType);
            str = str.replace(/\*PROPERTIES\*/g, "\t\tpublic var " + propertyIdentifier + ":" + propertyType + ";");
            str = str.replace(/\*PROPERTIES_PARAM\*/g, "p" + propertyType + ":" + propertyType + ", ");
            str = str.replace(/\*PROPERTIES_SET\*/g, "\t\t\t" + propertyIdentifier + "=p" + propertyType + ";");
            str = str.replace(/\*PROPERTIES_CLONE\*/g, propertyIdentifier + ", ");
            imports += "\timport " + pPublicProperty + ";\n";

        }
        else {
            str = str.replace(/\*PROPERTIES\*/g, "");
            str = str.replace(/\*PROPERTIES_PARAM\*/g, "");
            str = str.replace(/\*PROPERTIES_SET\*/g, "");
            str = str.replace(/\*PROPERTIES_CLONE\*/g, "");
        }

        str = str.replace(/\*IMPORTS\*/g, imports);


        var asFile:GeneratedFile = new GeneratedFile(pClassName + "Event", "as", packageConfig.eventsDir);
        asFile.code = str;


        return asFile;

    }


    public function generateVO(pOriginalFile:PseudoClass, className:String = null):GeneratedFile {

        var pTemplate:String = templateMgr.voTemplateStr;

        if (className == null) className = pOriginalFile.className;

        var str:String = replacePackageNames(pTemplate);

        //imports
        str = str.replace(/\*IMPORTS\*/, "");

        //metadata
        str = str.replace(/\*QUALIFIED_REMOTE_CLASS\*/, pOriginalFile.qualifiedClassName);

        //class, constructor
        str = str.replace(/\*VO\*/g, className);

        //properties
        var s:String = "";

        var getsets:String = "";
        for (var i:int = 0; i < pOriginalFile.properties.length; i++) {
            var variable:PseudoVariable = pOriginalFile.properties[i] as PseudoVariable;

            if (!variable.isGetSet) {
                s += "\t\t" + "public var " + variable.name + ":" + variable.type + ";\n";
            }

            else {
                s += "\t\t" + "private var _" + variable.name + ":" + variable.type + ";\n";

                getsets += "\t\tpublic function get " + variable.name + "():" + variable.type + "{\n";
                getsets += "\t\t\treturn _" + variable.name + ";\n";
                getsets += "\t\t}\n\n";
                getsets += "\t\tpublic function set " + variable.name + "(pData:" + variable.type + "):void{\n";
                getsets += "\t\t\t_" + variable.name + "=pData;\n";
                getsets += "\t\t}\n\n";
            }

        }
        str = str.replace(/\*PROPERTIES\*/, s);
        str = str.replace(/\*GETTERSETTERS\*/, getsets);

        var asFile:GeneratedFile = new GeneratedFile(className, "as", packageConfig.voDir);
        asFile.code = str;

        return asFile;

    }

    public function generateVOEvent(pPHPFile:PseudoClass, className:String = null, pQualifiedSuperClass:String = "flash.events.Event"):GeneratedFile {

        var pTemplate:String = templateMgr.voEventTemplateStr;

        if (className == null) className = pPHPFile.className;

        var sQualified:String = pQualifiedSuperClass;//"com.adobe.cairngorm.control.CairngormEvent"; // TEMP
        var eventSuperClassName:String = sQualified.substring(sQualified.lastIndexOf(".") + 1);

        var uClassName:String = className.toUpperCase();
        //____

        var str:String = replacePackageNames(pTemplate);


        //imports
        str = str.replace(/\*IMPORTS\*/, "\timport " + sQualified + ";");

        //class
        str = str.replace(/\*EVENT_SUPERCLASS\*/g, eventSuperClassName);
        str = str.replace(/\*LC_VO\*/g, className.toLocaleLowerCase());
        str = str.replace(/\*VO\*/g, className);

        //properties

        var pStr:String = "";

        pStr += "\t\t" + "public static const EVENT_GET_ALL_" + uClassName + "S:String='getAll" + className + "';\n";
        pStr += "\t\t" + "public static const EVENT_GET_" + uClassName + ":String='get" + className + "';\n";
        pStr += "\t\t" + "public static const EVENT_CREATE_" + uClassName + ":String='create" + className + "';\n";
        pStr += "\t\t" + "public static const EVENT_UPDATE_" + uClassName + ":String='update" + className + "';\n";
        pStr += "\t\t" + "public static const EVENT_DELETE_" + uClassName + ":String='delete" + className + "';\n";
        pStr += "\t\t" + "public static const EVENT_SELECT_" + uClassName + ":String='select" + className + "';\n";

        str = str.replace(/\*EVENT_TYPES\*/g, pStr);
        str = str.replace(/\*PROPERTIES\*/, "");

        var asFile:GeneratedFile = new GeneratedFile(className + "Event", "as", packageConfig.eventsDir);
        asFile.code = str;

        return asFile;

    }

    public function generateVOListView(pASVOFile:GeneratedFile):GeneratedFile {
        var pTemplate:String = templateMgr.voListTemplateStr;

        var str:String = replacePackageNames(pTemplate);

        str = str.replace(/\*UP_VO\*/g, pASVOFile.name.toUpperCase());
        str = str.replace(/\*VO\*/g, pASVOFile.name);
        var lcVoName:String = StringTools.lowerFirstChar(pASVOFile.name);
        str = str.replace(/\*LC_VO\*/g, lcVoName);


        var cols:String = "";

        var properties:Array = pASVOFile.code.match(/public var \w+/g);

        for (var i:int = 0; i < properties.length; i++) {
            var pName:String = properties[i].substring(11);
            cols += "\t\t\t<mx:DataGridColumn headerText='" + pName + "' dataField='" + pName + "'/>\n";
        }

        str = str.replace(/\*DGCOLUMNS\*/g, cols);


        var asFile:GeneratedFile = new GeneratedFile(pASVOFile.name + "List", "mxml", packageConfig.componentsDir);
        asFile.code = str;

        return asFile;

    }


    public function generateVOFormView(pASVOFile:GeneratedFile):GeneratedFile {

        var pTemplate:String = templateMgr.voFormTemplateStr;

        var str:String = replacePackageNames(pTemplate);

        str = str.replace(/\*UP_VO\*/g, pASVOFile.name.toUpperCase());
        str = str.replace(/\*VO\*/g, pASVOFile.name);
        var lcVoName:String = StringTools.lowerFirstChar(pASVOFile.name);
        str = str.replace(/\*LC_VO\*/g, lcVoName);

        var props:String = "";
        var formItems:String = "";

        var properties:Array = pASVOFile.code.match(/public var \w+:\w+/g);

        for (var i:int = 0; i < properties.length; i++) {
            var typedName:String = properties[i].substring(11);
            var tab:Array = typedName.split(":");
            var pName:String = tab[0];
            var pType:String = tab[1];

            formItems += "\t\t" + '<mx:FormItem label="' + pName + '">\n';

            if (pType == "String") {
                formItems += "\t\t\t" + '<mx:TextInput id="' + pName + 'Ti" text="{' + pASVOFile.name.toLowerCase() + '.' + pName + '}"/>\n';
                props += '\t\t' + pName + '="{' + pName + 'Ti.text}"\n';
            }
            else if (pType == "int") {
                formItems += "\t\t\t" + '<mx:TextInput restrict="0123456789\-" id="' + pName + 'Ti" text="{' + pASVOFile.name.toLowerCase() + '.' + pName + '}"/>\n';
                props += '\t\t' + pName + '="{int(' + pName + 'Ti.text)}"\n';
            }
            else if (pType == "Number") {
                formItems += "\t\t\t" + '<mx:TextInput restrict=".,0123456789\-" id="' + pName + 'Ti" text="{' + pASVOFile.name.toLowerCase() + '.' + pName + '}"/>\n';
                props += '\t\t' + pName + '="{Number(' + pName + 'Ti.text)}"\n';
            }
            else if (pType == "Date") {
                formItems += "\t\t\t" + '<mx:DateField id="' + pName + 'DF" selectedDate="{DateField.stringToDate(' + pASVOFile.name.toLowerCase() + '.' + pName + ", 'YYYY-MM-DD')" + '}"/>\n';
                props += '\t\t' + pName + '="{DateField.dateToString(' + pName + "DF.selectedDate, 'YYYY-MM-DD')" + '}"\n';
            }
            else if (pType == "Boolean") {
                formItems += "\t\t\t" + '<mx:CheckBox id="' + pName + 'CB" selected="{' + pASVOFile.name.toLowerCase() + '.' + pName + '}"/>\n';
                props += '\t\t' + pName + '="{' + pName + 'CB.selected}"\n';
            }
            else {
                formItems += "\t\t\t" + '<mx:TextInput id="' + pName + 'Ti" text="{' + pASVOFile.name.toLowerCase() + '.' + pName + '}"/>\n';
                props += '\t\t' + pName + '="{' + pName + 'Ti.text}"\n';
            }

            formItems += '\t\t</mx:FormItem>\n\n';
        }

        str = str.replace(/\*PROPERTIES\*/, props);
        str = str.replace(/\*FORMITEMS\*/, formItems);


        var asFile:GeneratedFile = new GeneratedFile(pASVOFile.name + "Form", "mxml", packageConfig.componentsDir);
        asFile.code = str;

        return asFile;

    }

    public function generateSingleton(pName:String):GeneratedFile {
        var pTemplate:String = templateMgr.singletonTemplateStr;

        var str:String = replacePackageNames(pTemplate);
        str = str.replace(/\*CLASSNAME\*/g, pName);

        var asFile:GeneratedFile = new GeneratedFile(pName, "as", "");
        asFile.code = str;

        return asFile;

    }

    public function generateDelegate(pServiceClass:PseudoClass, pRS:RemoteService = null):GeneratedFile {
        var pTemplate:String = templateMgr.PMVC_DelegateStr;

        var str:String = replacePackageNames(pTemplate);

        //ServiceName
        str = str.replace(/\*SERVICENAME\*/g, pServiceClass.className);


        // TODO see if possible to externalize, maybe as mxml (like a ServiceLocator)
        var ro:String = generateRemoteObject(pRS.serviceName, pRS.endPoint, pRS.destination);
        str = str.replace(/\*REMOTEOBJECT\*/g, ro);


        // Service Methods
        var methods:String = "";

        for (var i:int = 0; i < pServiceClass.methods.length; i++) {
            var met:PseudoClassMethod = pServiceClass.methods[i];

            methods += "\t\tpublic function " + met.name + "(" + getMethodArgs(met) + "):void\n";
            methods += "\t\t{\n";
            methods += "\t\t\tvar call:Object = service." + met.name + "(" + getMethodArgs(met, false) + ");\n";
            methods += "\t\t\tcall.addResponder(responder);\n";
            methods += "\t\t}\n\n";

        }

        str = str.replace(/\*DELEGATEMETHODS\*/g, methods);


        var asFile:GeneratedFile = new GeneratedFile(pServiceClass.className + "Delegate", "as", packageConfig.businessDir);
        asFile.code = str;

        return asFile;
    }


    // see generateDelegate()
    protected function generateRemoteObject(pServiceName:String, pEndpoint:String, pDest:String):String {

        var str:String = "\t\t\tservice = new RemoteObject();\n" +
                '\t\t\tservice.endpoint="' + pEndpoint + '";\n' +
                '\t\t\tservice.destination="' + pDest + '";\n' +
                '\t\t\tservice.makeObjectsBindable=true;\n' +
                '\t\t\tservice.showBusyCursor=true;\n' +
                '\t\t\tservice.source="' + pServiceName + '";\n';

        return str;

    }


    protected function getMethodArgs(met:PseudoClassMethod, pTyped:Boolean = true):String {

        var typedArgs:String = "";

        for (var a:int = 0; a < met.arguments.length; a++) {
            var variable:PseudoVariable = met.arguments[a];
            typedArgs += variable.name;
            if (pTyped)typedArgs += ":" + variable.type;
            if (a < met.arguments.length - 1)typedArgs += ", ";
        }

        return typedArgs;
    }

}
}