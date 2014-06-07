/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 05/06/14
 * Time: 21.18
 */
package it.juca.aigor.application.utils {
import flash.events.Event;
import flash.events.FileListEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;

public class SelectMultipleFile {

    public function SelectMultipleFile(resultFunction:Function) {
        _resultFucntion = resultFunction;
    }

    /**
     * la funzione seguente deve accettare come parametro in ingresso un Array.
     */
    private var _resultFucntion:Function;

    public function load():void {
        var file:File = new File();
        file.addEventListener(FileListEvent.SELECT_MULTIPLE, file_selectMultiple);
        file.addEventListener(Event.CANCEL, onFileCancel);
        file.addEventListener(Event.CLOSE, onFileClose);
        file.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

        file.browseForOpenMultiple("Please select a file or three...");

    }

    protected function onFileCancel(event:Event):void {
        trace("SelectMultipleFile.onFileCancel()");
    }

    protected function onFileClose(event:Event):void {
        trace("SelectMultipleFile.onFileClose()");
    }

    protected function file_selectMultiple(event:FileListEvent):void {
        _resultFucntion(event.files);
    }

    protected function onIOError(event:IOErrorEvent):void {
        trace("SelectMultipleFile.onIOError()");
    }

    protected function onProgress(evt:ProgressEvent):void {
        trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
    }
}

}
