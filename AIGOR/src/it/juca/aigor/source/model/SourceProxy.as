/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 04/06/14
 * Time: 21.58
 */
package it.juca.aigor.source.model {

import it.juca.aigor.project.model.ProjectProxy;

import mx.collections.ArrayCollection;

public class SourceProxy {

    [Inject]
    public var projectProxy:ProjectProxy;
    public function get dataProvider():ArrayCollection {
        return projectProxy.projext.sourceFiles;
    }

    public function set dataProvider(value:ArrayCollection):void {
        projectProxy.projext.sourceFiles = value;
    }

}
}
