/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 05/06/14
 * Time: 13.53
 */
package it.juca.aigor.template.model {
import it.juca.aigor.project.model.ProjectProxy;

public class TemplateProxy {
    [Inject]
    public var projectProxy:ProjectProxy;

    public function get template():String {
        return projectProxy.projext.template;
    }

    public function set template(value:String):void {
        projectProxy.projext.template = value;
    }

}

}
