package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.PseudoClass;
import com.dehats.fgl.analysis.RemoteService;

import mx.collections.ArrayCollection;

/**
 *
 * @author davidderaedt
 *
 * Code Generation Manager for Flex applications
 *
 */

public class FlexGenManager implements IClientGenManager {

    public var remoteServicesCollec:ArrayCollection = new ArrayCollection();

    public var viewCollec:ArrayCollection = new ArrayCollection();

    public var eventCollec:ArrayCollection = new ArrayCollection();

    public var voCollec:ArrayCollection = new ArrayCollection();

    public var mainViewGFile:GeneratedFile;


    protected var generator:FlexGenerator;

    [Bindable]
    public var as3_types:Array = ["Object", "Array", "Number", "int", "uint", "Boolean", "String", "XML", "Date"];


    public function init(pConfig:PackageConfig):void {
        generator = new FlexGenerator(pConfig);
    }


    public function createBaseFiles():Array {
        var list:Array = [];

        mainViewGFile = generator.generateMainView(viewCollec, remoteServicesCollec);
        list.push(mainViewGFile);

        return list;

    }


    public function addVO(pClassFile:PseudoClass, pAddEvent:Boolean, pAddListView:Boolean, pAddFormView:Boolean, pTargetName:String = null):Array {
        var gFileList:Array = [];

        var voGFile:GeneratedFile = generator.generateVO(pClassFile, pTargetName);
        voCollec.addItem(voGFile);
        gFileList.push(voGFile);


        if (pAddEvent) {
            var eventFile:GeneratedFile = generator.generateVOEvent(pClassFile, pTargetName);
            eventCollec.addItem(eventFile);
            gFileList.push(eventFile);
        }
        if (pAddListView) {
            var listViewFile:GeneratedFile = generator.generateVOListView(voGFile);
            viewCollec.addItem(listViewFile);
            gFileList.push(listViewFile);

        }
        if (pAddFormView) {
            var formViewFile:GeneratedFile = generator.generateVOFormView(voGFile);
            viewCollec.addItem(formViewFile);
            gFileList.push(formViewFile);

        }


        updateMainView();
        gFileList.push(mainViewGFile);

        as3_types.push(voGFile.name);

        return gFileList;
    }


    protected function updateMainView():void {
        var genFile3:GeneratedFile = generator.generateMainView(viewCollec, remoteServicesCollec);
        mainViewGFile.code = genFile3.code;
    }

    public function addRemoteService(pClassFile:PseudoClass, pEndPointURL:String, pDestinationURL:String):Array {
        var gFileList:Array = [];

        var remoteService:RemoteService = new RemoteService();
        remoteService.serverFile = pClassFile;
        remoteService.serviceName = pClassFile.className;
        remoteService.endPoint = pEndPointURL;
        remoteService.destination = pDestinationURL;

        remoteServicesCollec.addItem(remoteService);

        // Generate Delegate
        if (generator.useDelegate) {
            var delegateGFile:GeneratedFile = generator.generateDelegate(pClassFile, remoteService);
            gFileList.push(delegateGFile);
        }

        updateMainView();
        gFileList.push(mainViewGFile);

        return gFileList;
    }

    public function createEvent(pName:String, pSuperClass:String, pProp:String):GeneratedFile {
        var evtFile:GeneratedFile = generator.generateEvent(pName, pSuperClass, pProp);
        eventCollec.addItem(evtFile);

        return evtFile;
    }

    public function createSingleton(pName:String):GeneratedFile {
        return  generator.generateSingleton(pName);
    }

}
}