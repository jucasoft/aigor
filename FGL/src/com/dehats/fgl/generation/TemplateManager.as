package com.dehats.fgl.generation {

/**
 *
 * @author davidderaedt
 *
 * Singleton used to access template files data
 *
 */

[Bindable]
public class TemplateManager {

    public var CRG_modelLocatorTemplateStr:String;
    public var CRG_frontControllerTemplateStr:String;
    public var CRG_commandTemplateStr:String;
    public var CRG_serviceLocatorTemplateStr:String;
    public var CRG_delegateTemplateStr:String;
    public var CRG_mainViewTemplateStr:String;

    public var PMVC_CommandStr:String;
    public var PMVC_StartUpCommandStr:String;
    public var PMVC_DelegateStr:String;
    public var PMVC_FacadeStr:String;
    public var PMVC_MainViewStr:String;
    public var PMVC_MediatorStr:String;
    public var PMVC_ProxyStr:String;
//		public var PMVC_VOProxyStr:String;

    public var eventTemplateStr:String;
    public var remoteObjectTemplateStr:String;
    public var voTemplateStr:String;
    public var voEventTemplateStr:String;
    public var voListTemplateStr:String;
    public var voFormTemplateStr:String;
    public var mainViewTemplateStr:String;
    public var singletonTemplateStr:String;

    public var phpVOTemplateStr:String;
    public var phpDAOTemplateStr:String;
    public var phpServiceTemplateStr:String;


    private static var instance:TemplateManager;

    public static function getInstance():TemplateManager {
        if (instance == null) instance = new TemplateManager();
        return instance;
    }


    public var getTemplateString:Function;

    public function getTemplates(pDirPath:String):void {

        //checkForTemplatesDir(pDirPath);

        eventTemplateStr = getTemplateString(pDirPath, "Event.txt");
        voTemplateStr = getTemplateString(pDirPath, "VO.txt");
        voEventTemplateStr = getTemplateString(pDirPath, "VOEvent.txt");
        remoteObjectTemplateStr = getTemplateString(pDirPath, "RemoteObject.txt");
        voListTemplateStr = getTemplateString(pDirPath, "VOList.txt");
        voFormTemplateStr = getTemplateString(pDirPath, "VOForm.txt");
        mainViewTemplateStr = getTemplateString(pDirPath, "MainView.txt");
        singletonTemplateStr = getTemplateString(pDirPath, "Singleton.txt");


        CRG_modelLocatorTemplateStr = getTemplateString(pDirPath, "CRG_ModelLocator.txt");
        CRG_frontControllerTemplateStr = getTemplateString(pDirPath, "CRG_FrontController.txt");
        CRG_commandTemplateStr = getTemplateString(pDirPath, "CRG_Command.txt");
        CRG_delegateTemplateStr = getTemplateString(pDirPath, "CRG_Delegate.txt");
        CRG_serviceLocatorTemplateStr = getTemplateString(pDirPath, "CRG_ServiceLocator.txt");
        CRG_mainViewTemplateStr = getTemplateString(pDirPath, "CRG_MainView.txt");

        PMVC_CommandStr = getTemplateString(pDirPath, "PMVC_Command.txt");
        PMVC_StartUpCommandStr = getTemplateString(pDirPath, "PMVC_StartUpCommand.txt");
        PMVC_DelegateStr = getTemplateString(pDirPath, "PMVC_Delegate.txt");
        PMVC_FacadeStr = getTemplateString(pDirPath, "PMVC_Facade.txt");
        PMVC_MainViewStr = getTemplateString(pDirPath, "PMVC_MainView.txt");
        PMVC_MediatorStr = getTemplateString(pDirPath, "PMVC_Mediator.txt");
        PMVC_ProxyStr = getTemplateString(pDirPath, "PMVC_Proxy.txt");


        phpDAOTemplateStr = getTemplateString(pDirPath, "PHPTemplateDAO.php");
        phpVOTemplateStr = getTemplateString(pDirPath, "PHPTemplateVO.php");
        phpServiceTemplateStr = getTemplateString(pDirPath, "PHPTemplateService.php");

    }

}
}