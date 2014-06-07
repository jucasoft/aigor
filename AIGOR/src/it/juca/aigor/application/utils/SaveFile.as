package it.juca.aigor.application.utils {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mx.controls.Alert;

public class SaveFile {
    public function SaveFile(path:String, data:String, overwrite:Boolean) {
        var file:File = File.documentsDirectory.resolvePath(path);

        if (!overwrite)
            if (file.exists) return;

        // FileStream for writing the file
        var fileStream:FileStream = new FileStream();
        fileStream.addEventListener(Event.CLOSE, fileClosed);
        fileStream.addEventListener(IOErrorEvent.IO_ERROR, error);
        // Open the file in write mode
        fileStream.open(file, FileMode.WRITE);
        // Write the ArrayCollection object of persons to the file
        fileStream.writeUTFBytes(data);
        // Close FileStream
        fileStream.close();
    }

    protected function error(event:IOErrorEvent):void {
        Alert.show(event.text, "ERROR");
    }

    private function fileClosed(event:Event):void {

    }
}
}