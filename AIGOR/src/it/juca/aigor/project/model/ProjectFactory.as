/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 04/06/14
 * Time: 21.14
 */
package it.juca.aigor.project.model {
import it.juca.aigor.project.model.vo.Project;
import it.juca.application.configfile.model.api.IConfigFileFactory;

public class ProjectFactory implements IConfigFileFactory {
    public function newInstance():* {
        return new Project();
    }
}
}
