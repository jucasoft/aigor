/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 05/06/14
 * Time: 22.18
 */
package it.juca.aigor.application.utils {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class SelectFile {

    public function SelectFile(resultFunction:Function) {
        _resultFucntion = resultFunction;
    }

    /**
     * la funzione seguente deve accettare come parametro in ingresso un Array.
     */
    private var _resultFucntion:Function;

    public function load():void {
        file = new File();
        file.addEventListener(Event.SELECT, onFileSelected);
        file.addEventListener(Event.CANCEL, onFileCancel);
        file.addEventListener(Event.CLOSE, onFileClose);
        file.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        file.browse();

    }

    protected function onFileCancel(event:Event):void {
        trace("SelectMultipleFile.onFileCancel()");
    }

    protected function onFileClose(event:Event):void {
        trace("SelectMultipleFile.onFileClose()");
    }

    protected function onIOError(event:IOErrorEvent):void {
        trace("SelectMultipleFile.onIOError()");
    }

    protected function onProgress(evt:ProgressEvent):void {
        trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
    }

    private var file:File;

    protected function onFileSelected(event:Event):void {
        file.addEventListener(ProgressEvent.PROGRESS, onProgress);
        file.addEventListener(Event.COMPLETE, onComplete);
        file.load();
    }

    protected function onComplete(evt:Event):void {
        //get the data from the file as a ByteArray
        var data:ByteArray = evt.currentTarget.data;
        var template:String = data.readUTFBytes(data.bytesAvailable);
        _resultFucntion(template);
    }
}

}
