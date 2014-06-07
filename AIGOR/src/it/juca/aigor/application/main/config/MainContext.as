/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 21.03
 */
package it.juca.aigor.application.main.config {
import flash.display.DisplayObjectContainer;

import it.juca.aigor.application.config.config.ConfigFileConfig;
import it.juca.aigor.application.menu.config.MenuConfig;
import it.juca.aigor.parser.config.ParserConfig;
import it.juca.aigor.project.config.ProjectConfig;
import it.juca.aigor.source.config.SourceConfig;
import it.juca.aigor.template.config.TemplateConfig;

import robotlegs.bender.bundles.mvcs.MVCSBundle;
import robotlegs.bender.extensions.contextView.ContextView;
import robotlegs.bender.framework.impl.Context;

public class MainContext extends Context {

    public function MainContext(view:DisplayObjectContainer) {
        super();
        install(MVCSBundle)
                .configure(MainConfig)
                .configure(ParserConfig)
                .configure(SourceConfig)
                .configure(TemplateConfig)
                .configure(ConfigFileConfig)
                .configure(MenuConfig)
                .configure(ProjectConfig)
                .configure(new ContextView(view));
    }

}
}
