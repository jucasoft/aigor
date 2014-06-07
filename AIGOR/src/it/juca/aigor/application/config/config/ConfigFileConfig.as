/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 05/10/13
 * Time: 20.44
 */
package it.juca.aigor.application.config.config {
import flash.net.FileFilter;

import it.juca.aigor.project.model.ProjectFactory;
import it.juca.application.configfile.model.ConfigProxy;
import it.juca.application.configfile.model.api.IConfigFileFactory;
import it.juca.application.configfile.model.vo.IConfigProxy;

import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class ConfigFileConfig implements IConfig {

    [Inject]
    public var injector:IInjector;

    /**
     * configurazione sisitema per l'apertura del file di configurazion/di progetto.
     */
    public function configure():void {
        injector.map(IConfigProxy).toSingleton(ConfigProxy);
        injector.map(FileFilter, "fileProject").toValue(new FileFilter("Project file", "*.aigor"));
        injector.map(String, "defaultExtension").toValue("aigor");
        injector.map(IConfigFileFactory).toType(ProjectFactory);
    }

}

}
