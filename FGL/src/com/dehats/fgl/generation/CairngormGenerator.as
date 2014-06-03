package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.PseudoClass;
import com.dehats.fgl.analysis.PseudoClassMethod;
import com.dehats.fgl.analysis.RemoteService;
import com.dehats.fgl.utils.StringTools;

import mx.collections.ArrayCollection;

/**
 *
 * @author davidderaedt
 *
 * Class responsible for generating cairngorm specific files
 *
 */

public class CairngormGenerator extends FlexGenerator {

    public function CairngormGenerator(pConfig:PackageConfig) {
        super(pConfig);
    }

    public function generateModel(pVOCollec:ArrayCollection):GeneratedFile {

        var pTemplate:String = templateMgr.CRG_modelLocatorTemplateStr;

        var str:String = replacePackageNames(pTemplate);

        var properties:String = "";
        var imports:String = "";

        for (var i:int = 0; i < pVOCollec.length; i++) {
            var gFile:GeneratedFile = pVOCollec.getItemAt(i) as GeneratedFile;
            var fileName:String = gFile.name;//gFile.name.substr(gFile.name.lastIndexOf(".")+1);
            var fileNameLow1stChar:String = StringTools.lowerFirstChar(fileName);
            properties += "\t\tpublic var " + fileNameLow1stChar + "Collection:ArrayCollection;\n";

            properties += "\t\tpublic var current" + gFile.name + ":" + fileName + ";\n";
            imports += "\timport " + packageConfig.voFullPath + "." + fileName + ";\n";
        }

        str = str.replace(/\*IMPORTS\*/g, imports);
        str = str.replace(/\*PROPERTIES\*/g, properties);

        var asFile:GeneratedFile = new GeneratedFile("ModelLocator", "as", packageConfig.modelDir);
        asFile.code = str;

        return asFile;

    }


    public function generateController(pAssoList:ArrayCollection):GeneratedFile {
        var pTemplate:String = templateMgr.CRG_frontControllerTemplateStr;

        var str:String = replacePackageNames(pTemplate);

        var cmdAssoStr:String = "";
        /*
         for ( var a:int = 0 ; a < pAssoList.length ; a++)
         {

         var asso:EventCmdAsso = pAssoList.getItemAt(a) as EventCmdAsso;
         cmdAssoStr+="\t\t\taddCommand("+asso.eventClassName+"."+asso.eventTypeConst+", "+asso.commandClassName+");\n";

         }
         */
        str = str.replace(/\*CMDASSO\*/, cmdAssoStr);


        var asFile:GeneratedFile = new GeneratedFile("FController", "as", packageConfig.controlDir);
        asFile.code = str;

        return asFile;

    }


    public function generateCommands(pPseudoClass:PseudoClass):Array {

        var pModel:String = templateMgr.CRG_commandTemplateStr;

        var commandList:Array = new Array();

        var methodList:Array = pPseudoClass.methods;

        for (var i:int = 0; i < methodList.length; i++) {

            var cmd:GeneratedFile = generateCommand(pPseudoClass.className, methodList[i], pModel);
            commandList.push(cmd);
        }


        return commandList;

    }


    private function generateCommand(pService:String, pMethod:PseudoClassMethod, pTemplate:String):GeneratedFile {
        var str:String = replacePackageNames(pTemplate);

        //imports TODO
        str = str.replace(/\*IMPORTS\*/, "");

        //Command
        var cmdClassPrefix:String = pMethod.name.charAt(0).toUpperCase() + pMethod.name.substring(1);
        str = str.replace(/\*CMDNAME\*/, cmdClassPrefix);

        //Super class : TODO
        str = str.replace(/\*EXTSUPERCLASS\*/, "");

        //Service Name
        str = str.replace(/\*SERVICENAME\*/g, pService);

        //Service Method
        str = str.replace(/\*METHODNAME\*/, pMethod.name);

        //Method args
        str = str.replace(/\*METHODARGS\*/, getMethodArgs(pMethod, false));

        // return type
        str = str.replace(/\*RETURNTYPE\*/g, pMethod.returnType);

        var asFile:GeneratedFile = new GeneratedFile(cmdClassPrefix + "Command", "as", packageConfig.commandDir);
        asFile.code = str;

        return asFile;
    }


    public function generateServiceLocator(pServices:ArrayCollection):GeneratedFile {
        var pServiceLocTempl:String = TemplateManager.getInstance().CRG_serviceLocatorTemplateStr;
        var pROTempl:String = TemplateManager.getInstance().remoteObjectTemplateStr;

        var str:String = pServiceLocTempl;

        var ros:String = "";

        for (var a:int = 0; a < pServices.length; a++) {
            var service:RemoteService = pServices.getItemAt(a) as RemoteService;
            ros += generateMXMLRemoteObject(service.serviceName, service.endPoint, service.destination, pROTempl) + "\n\n";
        }

        str = str.replace(/\*REMOTEOBJECTS\*/, ros);

        var asFile:GeneratedFile = new GeneratedFile("Services", "mxml", packageConfig.businessDir);
        asFile.code = str;

        return asFile;

    }

    override public function generateDelegate(pPseudoClass:PseudoClass, pRS:RemoteService = null):GeneratedFile {
        var pTemplate:String = TemplateManager.getInstance().CRG_delegateTemplateStr;

        var str:String = replacePackageNames(pTemplate);

        //ServiceName
        str = str.replace(/\*SERVICENAME\*/g, pPseudoClass.className);


        // Service Methods
        var methods:String = "";

        for (var i:int = 0; i < pPseudoClass.methods.length; i++) {
            var met:PseudoClassMethod = pPseudoClass.methods[i];

            methods += "\t\tpublic function " + met.name + "(" + getMethodArgs(met) + "):void\n";
            methods += "\t\t{\n";
            methods += "\t\t\tvar call:Object = service." + met.name + "(" + getMethodArgs(met, false) + ");\n";
            methods += "\t\t\tcall.addResponder(responder);\n";
            methods += "\t\t}\n\n";

        }

        str = str.replace(/\*DELEGATEMETHODS\*/g, methods);


        var asFile:GeneratedFile = new GeneratedFile(pPseudoClass.className + "Delegate", "as", packageConfig.businessDir);
        asFile.code = str;

        return asFile;
    }

    /*
     private function getMethodArgs(met:PseudoClassMethod, pTyped:Boolean=true):String
     {

     var typedArgs:String="";

     for (var a:int=0 ; a<met.arguments.length ; a++) {
     var variable:PseudoVariable = met.arguments[a];
     typedArgs+=variable.name;
     if(pTyped)typedArgs+=":"+variable.type;
     if(a<met.arguments.length-1)typedArgs+=", ";
     }

     return typedArgs ;
     }
     */

    override public function generateMainView(pViewCollec:ArrayCollection, pServicesCollec:ArrayCollection):GeneratedFile {
        var pTemplate:String = templateMgr.CRG_mainViewTemplateStr;

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

        var asFile:GeneratedFile = new GeneratedFile("MainView", "mxml", packageConfig.componentsDir);
        asFile.code = str;

        return asFile;

    }

}
}