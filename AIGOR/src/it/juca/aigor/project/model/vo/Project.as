/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 04/06/14
 * Time: 23.46
 */
package it.juca.aigor.project.model.vo {
import mx.collections.ArrayCollection;

[RemoteClass]
public class Project {

    /**
     * Elenco dei file selezionati per la generazione
     */
    public var sourceFiles:ArrayCollection = new ArrayCollection();

    /**
     * template che è stato selezionato e successivamente può aver subito delle modifiche
     */
    public var template:String = "";


}
}
