package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.PseudoClass;
import com.dehats.fgl.analysis.RemoteService;

import mx.collections.ArrayCollection;

/**
 *
 * @author davidderaedt
 *
 * Code Generation Manager for Flex+PureMVC applications
 *
 */

public class PureMVCGenManager extends FlexGenManager implements IClientGenManager {

    public var commandCollec:ArrayCollection = new ArrayCollection();
    public var proxyCollec:ArrayCollection = new ArrayCollection();
    public var mediatorCollec:ArrayCollection = new ArrayCollection();

    public var PMVCStartUpCmdGFile:GeneratedFile;
    public var PMVCFacadeGFile:GeneratedFile;
//		public var PMVCDelegateGFile:GeneratedFile;

    private var p_generator:PureMVCGenerator;


    override public function init(pConfig:PackageConfig):void {
        generator = p_generator = new PureMVCGenerator(pConfig);
    }

    override public function createBaseFiles():Array {

        var list:Array = [];

        // TODO optionally create main Proxy
        var createMainProxy:Boolean = true;

        PMVCFacadeGFile = p_generator.generateFacade(voCollec);
        list.push(PMVCFacadeGFile);

        mainViewGFile = generator.generateMainView(viewCollec, remoteServicesCollec);
        list.push(mainViewGFile);


        if (createMainProxy) {
            var mainProxy:GeneratedFile = p_generator.generateMainProxy();
            proxyCollec.addItem(mainProxy);
            list.push(mainProxy);
        }

        PMVCStartUpCmdGFile = p_generator.generateStartUpCmd(proxyCollec, viewCollec);
        list.push(PMVCStartUpCmdGFile);


        return list;
    }

    override public function addRemoteService(pClassFile:PseudoClass, pEndpoint:String, pDest:String):Array {
        var gFileList:Array = [];

        var remoteService:RemoteService = new RemoteService();
        remoteService.serverFile = pClassFile;
        remoteService.serviceName = pClassFile.className;
        remoteService.endPoint = pEndpoint;
        remoteService.destination = pDest;

        remoteServicesCollec.addItem(remoteService);

        // Generate Commands
        // TODO PMVC Generate Commands : see if necessary to keep as an option
        /*
         var cmdList:Array =generatePMVCCmdList(remoteService);
         gFileList = gFileList.concat(cmdList);
         */

        // Generate Delegate
        var PMVCDelegateGFile:GeneratedFile = p_generator.generateDelegate(pClassFile, remoteService);
        gFileList.push(PMVCDelegateGFile);

        var remoteProxy:GeneratedFile = p_generator.generateRemoteProxy(pClassFile, PMVCDelegateGFile);
        proxyCollec.addItem(remoteProxy);
        gFileList.push(remoteProxy);

        updateStartUpCmd();
        gFileList.push(PMVCStartUpCmdGFile);

        return gFileList;
    }


    private function generatePMVCCmdList(pService:RemoteService):Array {
        var list:Array = p_generator.generateCommands(pService.serverFile);

        for (var i:int = 0; i < list.length; i++) {
            commandCollec.addItem(list[i]);
        }

        return list;

    }

    override public function addVO(pClassFile:PseudoClass, pAddEvent:Boolean, pAddListView:Boolean, pAddFormView:Boolean, pTargetName:String = null):Array {
        var gFileList:Array = [];

        var voGFile:GeneratedFile = generator.generateVO(pClassFile, pTargetName);
        voCollec.addItem(voGFile);
        gFileList.push(voGFile);

        var voProxy:GeneratedFile = p_generator.generateVOProxy(voGFile);
        proxyCollec.addItem(voProxy);
        gFileList.push(voProxy);

        if (pAddEvent) {
            var eventFile:GeneratedFile = generator.generateVOEvent(pClassFile, pTargetName);
            eventCollec.addItem(eventFile);
            gFileList.push(eventFile);
        }
        if (pAddListView) {
            var listViewFile:GeneratedFile = generator.generateVOListView(voGFile);
            viewCollec.addItem(listViewFile);
            gFileList.push(listViewFile);

            var listViewMediator:GeneratedFile = p_generator.generateListMediator(voGFile, listViewFile, voProxy);
            mediatorCollec.addItem(listViewMediator);
            gFileList.push(listViewMediator);
        }
        if (pAddFormView) {
            var formViewFile:GeneratedFile = generator.generateVOFormView(voGFile);
            viewCollec.addItem(formViewFile);
            gFileList.push(formViewFile);

            var formViewMediator:GeneratedFile = p_generator.generateFormMediator(voGFile, formViewFile, voProxy);
            mediatorCollec.addItem(formViewMediator);
            gFileList.push(formViewMediator);
        }


        as3_types.push(voGFile.name);

        updateStartUpCmd();
        gFileList.push(PMVCStartUpCmdGFile);
        updateFacade();
        gFileList.push(PMVCFacadeGFile);
        updateMainView();
        gFileList.push(mainViewGFile);

        return gFileList;
    }

    public function createEmptyProxy(pName:String):GeneratedFile {
        return p_generator.generateEmptyProxy(pName);
    }


    public function createMediator(pViewName:String):GeneratedFile {
        return p_generator.generateEmptyMediator(pViewName);
    }


    private function updateStartUpCmd():void {
        var genFile:GeneratedFile = p_generator.generateStartUpCmd(proxyCollec, viewCollec);
        PMVCStartUpCmdGFile.code = genFile.code;
    }

    private function updateFacade():void {
        var genFile2:GeneratedFile = p_generator.generateFacade(voCollec);
        PMVCFacadeGFile.code = genFile2.code;
    }

    override protected function updateMainView():void {
        var genFile3:GeneratedFile = p_generator.generateMainView(viewCollec, remoteServicesCollec);
        mainViewGFile.code = genFile3.code;
    }

}
}