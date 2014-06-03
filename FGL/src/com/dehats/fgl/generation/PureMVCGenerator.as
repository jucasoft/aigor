package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.PseudoClass;
import com.dehats.fgl.analysis.PseudoClassMethod;
import com.dehats.fgl.utils.StringTools;

import mx.collections.ArrayCollection;

/**
 *
 * @author davidderaedt
 *
 *  Class responsible for generating PureMVC specific files
 *
 */

public class PureMVCGenerator extends FlexGenerator {

    public function PureMVCGenerator(pConfig:PackageConfig) {
        super(pConfig);
    }

    // MODEL

    public function generateMainProxy():GeneratedFile {
        return generateProxy("Main", "", "", "");
    }

    // Not Used for now : TODO Check the possibility to create generic Proxy
    public function generateEmptyProxy(pName:String):GeneratedFile {
        return generateProxy(pName, "", "", "");
    }

    private function generateProxy(pName:String, pImports:String, pProperties:String, pMethods:String):GeneratedFile {

        var pTemplate:String = templateMgr.PMVC_ProxyStr;

        var str:String = replacePackageNames(pTemplate);

        str = str.replace(/\*NAME\*/g, pName);
        str = str.replace(/\*IMPORTS\*/, pImports);
        str = str.replace(/\*PROPERTIES\*/, pProperties);
        str = str.replace(/\*METHODS\*/, pMethods);

        var lcName:String = StringTools.lowerFirstChar(pName);
        str = str.replace(/\*LC_NAME\*/, lcName);


        var asFile:GeneratedFile = new GeneratedFile(pName + "Proxy", "as", packageConfig.modelDir);
        asFile.code = str;

        return asFile;

    }

    public function generateVOProxy(pVO:GeneratedFile):GeneratedFile {

        var imports:String = "\timport " + packageConfig.voFullPath + "." + pVO.name + ";";

        var lcVO:String = StringTools.lowerFirstChar(pVO.name);

        var properties:String = "";
        properties += "\t\t public var " + lcVO + "Collection:ArrayCollection = new ArrayCollection();\n";
        properties += "\t\t public var current" + pVO.name + ":" + pVO.name + ";\n";

        return generateProxy(pVO.name, imports, properties, "");

    }

    public function generateRemoteProxy(pService:PseudoClass, pDelegate:GeneratedFile):GeneratedFile {

        var imports:String = "";
        imports += "\timport " + packageConfig.businessFullPath + "." + pDelegate.name + ";\n";
        imports += "\timport mx.rpc.Responder;\n";
        imports += "\timport mx.rpc.events.FaultEvent;\n";
        imports += "\timport mx.rpc.events.ResultEvent;\n";
        imports += "\timport mx.controls.Alert;\n";

        var properties:String = "";
        var methods:String = "";


        var methodList:Array = pService.methods;

        for (var i:int = 0; i < methodList.length; i++) {

            var met:PseudoClassMethod = methodList[i];

            var ucMethName:String = StringTools.upperFirstChar(met.name);

            methods += "\t\tpublic function " + met.name + "(" + getMethodArgs(met) + "):void\n";
            methods += "\t\t{\n";
            methods += "\t\t\tvar delegate:" + pDelegate.name + " = new " + pDelegate.name + "(new Responder(on" + ucMethName + "Result, onFault));\n"
            methods += "\t\t\tdelegate." + met.name + "(" + getMethodArgs(met, false) + ");\n";
            methods += "\t\t}\n\n";
            methods += "\t\tprivate function on" + ucMethName + "Result(pResultEvt:ResultEvent):void\n";
            methods += "\t\t{\n";
            methods += "\t\t\tvar result:" + met.returnType + "=pResultEvt.result as " + met.returnType + " ;\n";
            methods += "\t\t\t//sendNotification();\n";
            methods += "\t\t}\n\n";
        }

        methods += "\t\tprivate function onFault(pFaultEvt:FaultEvent):void\n";
        methods += "\t\t{\n";
        methods += "\t\t\tAlert.show(pFaultEvt.fault.faultString, 'Error');\n"
        methods += "\t\t}\n\n";

        return generateProxy(pService.className + "Remote", imports, properties, methods);
    }


    // CONTROLLER


    public function generateFacade(pVOList:ArrayCollection):GeneratedFile {
        var pTemplate:String = templateMgr.PMVC_FacadeStr;

        var str:String = replacePackageNames(pTemplate);

        var cmdAssoStr:String = "";
        var notifConsts:String = "";

        for (var i:int = 0; i < pVOList.length; i++) {
            var voGFile:GeneratedFile = pVOList.getItemAt(i) as GeneratedFile;
            var voName:String = voGFile.name;//voFile.name.substr(voFile.name.lastIndexOf("."));
            var upperCaseVoName:String = voName.toUpperCase();
            notifConsts += "\t\t\public static const CREATE_" + upperCaseVoName + ':String = "create' + voName + '";\n';
            notifConsts += "\t\t\public static const GET_" + upperCaseVoName + 'S:String = "get' + voName + 's";\n';
            notifConsts += "\t\t\public static const UPDATE_" + upperCaseVoName + ':String = "update' + voName + '";\n';
            notifConsts += "\t\t\public static const DELETE_" + upperCaseVoName + ':String = "delete' + voName + '";\n';
            notifConsts += "\t\t\public static const SELECT_" + upperCaseVoName + ':String = "set' + voName + '";\n';

            cmdAssoStr += "\t\t\t// Uncomment and replace with the appropriate Commands\n";
            cmdAssoStr += "\t\t\t//registerCommand(CREATE_" + upperCaseVoName + ", Create" + voName + "Command);\n";
            cmdAssoStr += "\t\t\t//registerCommand(GET_" + upperCaseVoName + "S, Get" + voName + "sCommand);\n";
            cmdAssoStr += "\t\t\t//registerCommand(UPDATE_" + upperCaseVoName + ", Update" + voName + "Command);\n";
            cmdAssoStr += "\t\t\t//registerCommand(DELETE_" + upperCaseVoName + ", Delete" + voName + "Command);\n";

        }

        str = str.replace(/\*NOTIFCONSTS\*/, notifConsts);
        str = str.replace(/\*REGISTERCMDS\*/, cmdAssoStr);
        str = str.replace(/\*MAINVIEW\*/, "MainView");

        var asFile:GeneratedFile = new GeneratedFile("ApplicationFacade", "as", "");
        asFile.code = str;

        return asFile;

    }


    private function generateMediatorBase(pViewName:String, pProxyName:String = null):String {
        var template:String = templateMgr.PMVC_MediatorStr;

        var str:String = replacePackageNames(template);

        str = str.replace(/\*VIEWNAME\*/g, pViewName);
        var viewName1stCharToLowerCase:String = StringTools.lowerFirstChar(pViewName);
        str = str.replace(/\*LC_VIEWNAME\*/g, viewName1stCharToLowerCase);

        if (pProxyName) {
            var proxyName1stCharToLowerCase:String = StringTools.lowerFirstChar(pProxyName);

            str = str.replace(/\*PROXYIMPORT\*/, "\timport " + packageConfig.modelFullPath + "." + pProxyName + ";");
            str = str.replace(/\*PROXYPROP\*/g, "\t\tprivate var " + proxyName1stCharToLowerCase + ":" + pProxyName + ";\n");
        }
        else {
            str = str.replace(/\*PROXYIMPORT\*/, "");
            str = str.replace(/\*PROXYPROP\*/, "");
        }


        return str;

    }


    public function generateEmptyMediator(pViewName:String):GeneratedFile {
        var str:String = generateMediatorBase(pViewName);

        // should be left blank if generated without a VOEvent
        str = str.replace(/\*EVENTIMPORT\*/g, "");
        str = str.replace(/\*VO\*/g, "*");
        str = str.replace(/\*ADDLISTENERS\*/g, "");
        str = str.replace(/\*LISTENERS\*/g, "");
        str = str.replace(/\*NOTIF_HANDLING\*/g, "\t\tdefault : break;");
        str = str.replace(/\*NOTIF_INTERESTS\*/g, "");

        var asFile:GeneratedFile = new GeneratedFile(pViewName + "Mediator", "as", packageConfig.viewDir);
        asFile.code = str;

        return asFile;

    }

    public function generateListMediator(pVO:GeneratedFile, pView:GeneratedFile, pProxy:GeneratedFile):GeneratedFile {
        var viewName1stCharToLowerCase:String = StringTools.lowerFirstChar(pView.name);
        var voName1stCharToLowerCase:String = StringTools.lowerFirstChar(pVO.name);

        var str:String = generateMediatorBase(pView.name, pProxy.name);

        var addListeners:String = "";
        var listeners:String = "";

        // Listen for CRUD Events of the VOEvent dispatched by the view
        addListeners += "\t\t\t" + viewName1stCharToLowerCase + ".addEventListener( " +
                pVO.name + "Event.EVENT_CREATE_" + pVO.name.toUpperCase() + ", onCreate );\n";

        addListeners += "\t\t\t" + viewName1stCharToLowerCase + ".addEventListener( " +
                pVO.name + "Event.EVENT_DELETE_" + pVO.name.toUpperCase() + ", onDelete );\n";

        addListeners += "\t\t\t" + viewName1stCharToLowerCase + ".addEventListener( " +
                pVO.name + "Event.EVENT_SELECT_" + pVO.name.toUpperCase() + ", onSelect );\n";

        addListeners += "\n\n";

        addListeners += "\t\t\t" + voName1stCharToLowerCase + "Proxy = facade.retrieveProxy(" + pVO.name + "Proxy.NAME) as " + pVO.name + "Proxy ;\n";

        addListeners += "\t\t\t" + viewName1stCharToLowerCase + ".collection = " + voName1stCharToLowerCase + "Proxy." + voName1stCharToLowerCase + "Collection;\n";


        listeners += "\t\tprivate function onCreate(pEvt:" + pVO.name + "Event):void\n" +
                "\t\t{\n" +
                "\t\t\tsendNotification(ApplicationFacade.CREATE_" + pVO.name.toUpperCase() + ", pEvt." + pVO.name.toLowerCase() + ");\n" +
                "\t\t}\n\n";

        listeners += "\t\tprivate function onDelete(pEvt:" + pVO.name + "Event):void\n" +
                "\t\t{\n" +
                "\t\t\tsendNotification(ApplicationFacade.DELETE_" + pVO.name.toUpperCase() + ", pEvt." + pVO.name.toLowerCase() + ");\n" +
                "\t\t}\n\n";

        listeners += "\t\tprivate function onSelect(pEvt:" + pVO.name + "Event):void\n" +
                "\t\t{\n" +
                "\t\t\tsendNotification(ApplicationFacade.SELECT_" + pVO.name.toUpperCase() + ", pEvt." + pVO.name.toLowerCase() + ");\n" +
                "\t\t}\n\n";


        // should be left blank if generated without a VOEvent
        str = str.replace(/\*EVENTIMPORT\*/g, "\timport " + packageConfig.eventsFullPath + "." + pVO.name + "Event;");

        str = str.replace(/\*ADDLISTENERS\*/g, addListeners);
        str = str.replace(/\*LISTENERS\*/g, listeners);
        str = str.replace(/\*VO\*/g, pVO.name);
        var lcVO:String = StringTools.lowerFirstChar(pVO.name);
        str = str.replace(/\*LC_VO\*/g, lcVO);


        str = str.replace(/\*NOTIF_HANDLING\*/g, "\t\t\t\tdefault : break;");
        str = str.replace(/\*NOTIF_INTERESTS\*/g, "");


        var asFile:GeneratedFile = new GeneratedFile(pView.name + "Mediator", "as", packageConfig.viewDir);
        asFile.code = str;

        return asFile;

    }

    public function generateFormMediator(pVO:GeneratedFile, pView:GeneratedFile, pProxy:GeneratedFile):GeneratedFile {
        var viewName1stCharToLowerCase:String = StringTools.lowerFirstChar(pView.name);
        var voName1stCharToLowerCase:String = StringTools.lowerFirstChar(pVO.name);

        var str:String = generateMediatorBase(pView.name, pProxy.name);


        var addListeners:String = "";
        var listeners:String = "";

        addListeners += "\t\t\t" + viewName1stCharToLowerCase + ".addEventListener( " + pVO.name + "Event.EVENT_UPDATE_" + pVO.name.toUpperCase() + ", onUpdate );\n";

        listeners += "\t\tprivate function onUpdate(pEvt:" + pVO.name + "Event):void\n" +
                "\t\t{\n" +
                "\t\t\tsendNotification(ApplicationFacade.UPDATE_" + pVO.name.toUpperCase() + ", pEvt." + pVO.name.toLowerCase() + ");\n" +
                "\t\t}\n\n";

        // should be left blank if generated without a VOEvent
        str = str.replace(/\*EVENTIMPORT\*/g, "\timport " + packageConfig.eventsFullPath + "." + pVO.name + "Event;");

        str = str.replace(/\*ADDLISTENERS\*/g, addListeners);
        str = str.replace(/\*LISTENERS\*/g, listeners);
        str = str.replace(/\*VO\*/g, pVO.name);
        var lcVO:String = StringTools.lowerFirstChar(pVO.name);
        str = str.replace(/\*LC_VO\*/g, lcVO);

        var notificationInterests:String = "\t\t\t\tApplicationFacade.SELECT_" + pVO.name.toUpperCase() + "\n";

        var notificationHandling:String = "" +
                "\t\t\t\tcase ApplicationFacade.SELECT_" + pVO.name.toUpperCase() + ":\n" +
                "\t\t\t\t\tvar " + voName1stCharToLowerCase + ":" + pVO.name + " = notification.getBody() as " + pVO.name + ";\n" +
                "\t\t\t\t\t" + viewName1stCharToLowerCase + "." + voName1stCharToLowerCase + " = " + voName1stCharToLowerCase + " ;\n" +
                "\t\t\t\t\tbreak;\n";

        str = str.replace(/\*NOTIF_HANDLING\*/g, notificationHandling);
        str = str.replace(/\*NOTIF_INTERESTS\*/g, notificationInterests);


        var asFile:GeneratedFile = new GeneratedFile(pView.name + "Mediator", "as", packageConfig.viewDir);
        asFile.code = str;

        return asFile;

    }


    public function generateCommands(pPHPFile:PseudoClass):Array {

        var template:String = templateMgr.PMVC_CommandStr;

        var commandList:Array = new Array();

        var methodList:Array = pPHPFile.methods;

        for (var i:int = 0; i < methodList.length; i++) {

            var cmd:GeneratedFile = generateCommand(pPHPFile.className, methodList[i], template);
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

        //Super class : TODO add option to create a Command SuperClass
        str = str.replace(/\*EXTSUPERCLASS\*/, "extends SimpleCommand");

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

    public function generateStartUpCmd(pProxyCollec:ArrayCollection, pViewCollec:ArrayCollection):GeneratedFile {
        var str:String = templateMgr.PMVC_StartUpCommandStr;

        str = replacePackageNames(str);

        var proxyRegistrations:String = "";
        var mediatorRegistrations:String = "";//// Uncomment and replace with the appropriate components ids\n

        for (var i:int = 0; i < pProxyCollec.length; i++) {
            var generatedFile:GeneratedFile = pProxyCollec.getItemAt(i) as GeneratedFile;
            var lcProxy:String = StringTools.lowerFirstChar(generatedFile.name);
            proxyRegistrations += "\t\t\tvar " + lcProxy + ":" + generatedFile.name + " = new " + generatedFile.name + "() ;\n"
            proxyRegistrations += "\t\t\tfacade.registerProxy( " + lcProxy + " );\n"

        }

        for (var j:int = 0; j < pViewCollec.length; j++) {
            var generatedViewFile:GeneratedFile = pViewCollec.getItemAt(j) as GeneratedFile;
            var viewName1stCharToLowerCase:String = StringTools.lowerFirstChar(generatedViewFile.name);
            mediatorRegistrations += "\t\t\tfacade.registerMediator( new " + generatedViewFile.name + "Mediator( app." + viewName1stCharToLowerCase + " ) );\n";
        }

        str = str.replace(/\*REGISTERPROXIES\*/, proxyRegistrations);
        str = str.replace(/\*MAINVIEW\*/g, "MainView");
        str = str.replace(/\*REGISTERMEDIATORS\*/, mediatorRegistrations);


        var asFile:GeneratedFile = new GeneratedFile("StartUpCommand", "as", packageConfig.commandDir);
        asFile.code = str;

        return asFile;
    }


    override public function generateMainView(pViewCollec:ArrayCollection, pServicesCollec:ArrayCollection):GeneratedFile {
        var pTemplate:String = templateMgr.PMVC_MainViewStr;

        var str:String = replacePackageNames(pTemplate);

        var viewsDeclaration:String = "\t<mx:HBox>\n";

        for (var i:int = 0; i < pViewCollec.length; i++) {
            var view:GeneratedFile = pViewCollec.getItemAt(i) as GeneratedFile;
            var viewName1stCharToLowerCase:String = StringTools.lowerFirstChar(view.name);
            viewsDeclaration += '\t\t<ns1:' + view.name + ' id="' + viewName1stCharToLowerCase + '" />\n\n';
        }

        viewsDeclaration += "\t</mx:HBox>"

        str = str.replace(/\*VIEWS\*/, viewsDeclaration);

        var asFile:GeneratedFile = new GeneratedFile("MainView", "mxml", packageConfig.componentsDir);
        asFile.code = str;

        return asFile;

    }

    // TODO see if necessary to create with Notification subclass
    public function generateNotification(pClassName:String, pQualifiedSuperClass:String):GeneratedFile {
        var str:String;

        var asFile:GeneratedFile = new GeneratedFile(pClassName + "Notification", "as", packageConfig.eventsDir);
        asFile.code = str;

        return asFile;

    }

}
}