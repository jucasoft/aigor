/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 04/06/14
 * Time: 22.39
 */
package it.juca.aigor.project.model {
import flash.filesystem.File;
import flash.net.registerClassAlias;

import it.juca.aigor.project.model.vo.Project;
import it.juca.application.robotlegs.model.Proxy;

public class ProjectProxy extends Proxy {
    public function ProjectProxy() {
        registerClassAlias("flash.filesystem.File", File);
    }

    private var _projext:Project;
    public function get projext():Project {
        return _projext;
    }

    public function set projext(value:Project):void {
        _projext = value;
    }
}
}
