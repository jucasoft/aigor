package it.juca.aigor.application.utils {
import org.as3commons.lang.StringUtils;

public class MyStringUtils {
    public function MyStringUtils() {
    }

    // converte una stringa nella convenzione per le variabili statiche
    // "nomeVariabile" diventa NOME_VARIABILE
    // "nome variabile" diventa NOME_VARIABILE

    public static function toStaticVarName(value:String):String {
        var index:Array = [];
        value = value.replace("\n", "").replace("\t", "");
        for (var i:int = 0; i < value.length; i++) {
            var source:String = value.charAt(i);
            var uppercase:String = value.charAt(i).toUpperCase();
            //se il carattere è maiuscolo, aggiungo una linea bassa prima del carattere stesso
            // nel caso degli spazzi, vengono visti come maiuscoli
            if (source == uppercase) index.push("_");
            //gli spazzi non vengono aggiunti
            if (source != " " && source != "_") index.push(source);
        }
        if (index[0] == "_") index.shift();
        if (index[index.length - 1] == "_") index.pop();

        return index.join("").toUpperCase();
    }


    /**
     * Elimina la riga vuota all'inizio del file, e toglie lo spazio in < ?php "replace("< ?php","<?php")"
     * in futuro eseguirà una formattazione adeguata del codice.
     *
     * @param value
     * @return
     *
     */
    public static function condenseCode(value:String):String {
        var lines:Array = value.split("\n");
        if (StringUtils.isWhitespace(lines[0]))
            lines.shift();

        return lines.join("\n").replace("< ?php", "<?php");
    }

    public static function toLowerCase(value:String):String {
        return value.toLowerCase();
    }

    public static function upperCase(value:String):String {

        return value.toUpperCase();
    }
}
}