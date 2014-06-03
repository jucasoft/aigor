package com.dehats.fgl.utils {

/**
 *
 * @author davidderaedt
 *
 * Utility for various string jobs
 *
 */

public class StringTools {


    public function StringTools() {
    };


    public static var alphabet:Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];

    public static function getRandomLetter():String {
        var r:Number = Math.round(Math.random() * 25);
        return StringTools.alphabet[r];
    }


    public static function getUniqueString(length:Number):String {

        var string:String = "";
        var salt:String = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvXxYyZz0123456789";
        var i:Number = 1;

        while (i <= length) {
            var num:int = Math.round(Math.random() * salt.length);
            string += salt.substr(num, 1);
            i++;
        }

        return string;
    }

    static public function getRandomFileName(pOriginalFileName:String):String {

        var extIndex:int = pOriginalFileName.lastIndexOf(".");
        var extension:String = pOriginalFileName.slice(extIndex + 1);

        return StringTools.getUniqueString(10) + "." + extension;

    }


    public static function lowerFirstChar(pString:String):String {
        var c:String = pString.charAt(0);

        return c.toLowerCase() + pString.substr(1);
    }

    public static function upperFirstChar(pString:String):String {
        var c:String = pString.charAt(0);

        return c.toUpperCase() + pString.substr(1);
    }


}
}