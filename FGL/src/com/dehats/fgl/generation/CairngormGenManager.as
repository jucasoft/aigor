package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.PseudoClass;
import com.dehats.fgl.analysis.RemoteService;

import mx.collections.ArrayCollection;

/**
 *
 * @author davidderaedt
 *
 * Code Generation Manager for cairngorm applications
 *
 */

public class CairngormGenManager extends FlexGenManager implements IClientGenManager {

    // for evt/cmd associations (cairngorm only)
    public var commandCollec:ArrayCollection = new ArrayCollection();
    public var eventCmdAssoCollec:ArrayCollection = new ArrayCollection();
    public var CRGmodelGFile:GeneratedFile;
    public var CRGcontrollerGFile:GeneratedFile;
    public var CRGserviceLocatorGFile:GeneratedFile;
    public var CRGdelegateGFile:GeneratedFile;
    private var c_generator:CairngormGenerator;

    override public function init(pConfig:PackageConfig):void {
        generator = c_generator = new CairngormGenerator(pConfig);
    }

    override public function createBaseFiles():Array {

        CRGmodelGFile = c_generator.generateModel(voCollec);
        CRGcontrollerGFile = c_generator.generateController(eventCmdAssoCollec);
        CRGserviceLocatorGFile = c_generator.generateServiceLocator(remoteServicesCollec);
        mainViewGFile = c_generator.generateMainView(viewCollec, remoteServicesCollec);

        return [CRGmodelGFile, CRGcontrollerGFile, CRGserviceLocatorGFile, mainViewGFile];
    }

    override public function addRemoteService(pClassFile:PseudoClass, pEndpoint:String, pDest:String):Array {
        var gFileList:Array = [];

        var remoteService:RemoteService = new RemoteService();
        remoteService.serverFile = pClassFile;
        remoteService.serviceName = pClassFile.className;
        remoteService.endPoint = pEndpoint;
        remoteService.destination = pDest;

        remoteServicesCollec.addItem(remoteService);


        //update Service Locator
        var asFile:GeneratedFile = c_generator.generateServiceLocator(remoteServicesCollec);
        CRGserviceLocatorGFile.code = asFile.code;
        gFileList.push(CRGserviceLocatorGFile);

        // Generate Commands
        var cmdList:Array = generateCRGCmdList(remoteService);
        gFileList = gFileList.concat(cmdList);

        // Generate Delegate
        CRGdelegateGFile = c_generator.generateDelegate(pClassFile);
        gFileList.push(CRGdelegateGFile);

        return gFileList;
    }

    override public function addVO(pClassFile:PseudoClass, pAddEvent:Boolean, pAddListView:Boolean, pAddFormView:Boolean, pTargetName:String = null):Array {
        var gFileList:Array = [];

        var voGFile:GeneratedFile = generator.generateVO(pClassFile, pTargetName);
        voCollec.addItem(voGFile);

        gFileList.push(voGFile);

        if (pAddEvent) {
            var eventGFile:GeneratedFile = generator.generateVOEvent(pClassFile, pTargetName, "com.adobe.cairngorm.control.CairngormEvent");
            eventCollec.addItem(eventGFile);
            gFileList.push(eventGFile);
        }
        if (pAddListView) {
            var listViewFile:GeneratedFile = generator.generateVOListView(voGFile);
            viewCollec.addItem(listViewFile);
            gFileList.push(listViewFile);
        }
        if (pAddFormView) {
            var formViewGFile:GeneratedFile = generator.generateVOFormView(voGFile);
            viewCollec.addItem(formViewGFile);
            gFileList.push(formViewGFile);
        }

        as3_types.push(voGFile.name);

        updateModel();
        gFileList.push(CRGmodelGFile);

        updateMainView();
        gFileList.push(mainViewGFile);

        return gFileList;
    }

    override protected function updateMainView():void {
        var asFile:GeneratedFile = c_generator.generateMainView(viewCollec, remoteServicesCollec);
        mainViewGFile.code = asFile.code;
    }

    private function generateCRGCmdList(pService:RemoteService):Array {
        var list:Array = c_generator.generateCommands(pService.serverFile);

        for (var i:int = 0; i < list.length; i++) {
            commandCollec..addItem(list[i]);
        }
        return list;
    }

    private function updateModel():void {
        var asFile:GeneratedFile = c_generator.generateModel(voCollec);
        CRGmodelGFile.code = asFile.code;
    }

}
}