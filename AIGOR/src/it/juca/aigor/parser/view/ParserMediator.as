/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 23.30
 */
package it.juca.aigor.parser.view {
import com.dehats.fgl.analysis.ICodeParser;
import com.dehats.fgl.analysis.PseudoClass;

import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import it.juca.aigor.parser.event.ParserEvent;
import it.juca.aigor.parser.model.ParserProxy;
import it.juca.aigor.parser.model.api.IParserView;
import it.juca.aigor.project.model.ProjectProxy;
import it.juca.application.menu.controller.ShowStorageDirectory;
import it.juca.application.menu.event.SelectMenuEvent;
import it.juca.mustache.Mustache;

import mx.collections.ArrayCollection;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ParserMediator extends Mediator {

    [Inject]
    public var projectProxy:ProjectProxy;
    [Inject]
    public var view:IParserView;
    [Inject]
    public var parserProxy:ParserProxy;
    private var files:ArrayCollection = new ArrayCollection();

    override public function initialize():void {
        trace("ParserMediator.initialize()");
        super.initialize();
        addViewListener(ParserEvent.PARSE, onParse);
        addViewListener(ParserEvent.GENERATE, onGenerate);
        view.parsers = parserProxy.parsers;
        view.files = files;
    }

    override public function destroy():void {
        trace("ParserMediator.destroy()");
        super.destroy();
    }

    private function parse(source:String, name:String, parser:ICodeParser):Object {
        var parsed:PseudoClass = parser.parseCode(source)[0];
        var jsonS:String = JSON.stringify(parsed);
        var jsonO:Object = JSON.parse(jsonS);
        var code:String = new Mustache().to_html(projectProxy.projext.template, jsonO);
        name = name.split(".")[0] + view.selectedExtension;
        var result:Object = {name: name, data: code};
        return result;
    }

    private function onGenerate(event:ParserEvent):void {
        for each (var object:Object in files) {

            var fileToCreate:File = File.applicationStorageDirectory;
            fileToCreate = fileToCreate.resolvePath(object.name);

            var fileStream:FileStream = new FileStream();
            fileStream.open(fileToCreate, FileMode.WRITE);
            fileStream.writeUTF(object.data);
            fileStream.close();

        }
        dispatch(new SelectMenuEvent(SelectMenuEvent.EVENT_SELECTMENUEVENT, ShowStorageDirectory));
    }

    private function onParse(event:ParserEvent):void {
        files.removeAll();
        view.value = "";
        for each (var file:File in projectProxy.projext.sourceFiles) {
            file.addEventListener(Event.COMPLETE, onComplete);
            file.load();
        }

    }

    private function onComplete(evt:Event):void {
        trace("ParserMediator.onComplete()");
        //get the data from the file as a ByteArray
        var file:File = File(evt.currentTarget);
        file.removeEventListener(Event.COMPLETE, onComplete);
        var data:ByteArray = file.data;
        var source:String = data.readUTFBytes(data.bytesAvailable);
        trace(source);
        files.addItem(parse(source, file.name, view.selectedParser));
    }

}
}
