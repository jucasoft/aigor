/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 03/06/14
 * Time: 21.30
 */
package it.juca.aigor.source.view {
import it.juca.aigor.application.utils.SelectMultipleFile;
import it.juca.aigor.source.event.SourceEvent;
import it.juca.aigor.source.model.SourceProxy;
import it.juca.aigor.source.model.api.ISourceView;

import mx.collections.ArrayList;

import robotlegs.bender.bundles.mvcs.Mediator;

public class SourceMediator extends Mediator {

    [Inject]
    public var sourceProxy:SourceProxy;

    [Inject]
    public var view:ISourceView;

    override public function initialize():void {
        super.initialize();

        view.dataProvider = sourceProxy.dataProvider;
        addViewListener(SourceEvent.SELECT_SOURCE_FILES, onSelectSourceFiles);
        addViewListener(SourceEvent.REMOVE_SELECTED, onRemoveSelected);
    }

    private function onSelectSourceFiles(event:SourceEvent):void {
        new SelectMultipleFile(onSelect).load();
    }

    private function onRemoveSelected(event:SourceEvent):void {
        sourceProxy.dataProvider.removeItem(event.value);
    }

    private function onSelect(value:Array):void {
        sourceProxy.dataProvider.addAll(new ArrayList(value));
        view.dataProvider = sourceProxy.dataProvider;
    }

    override public function destroy():void {
        super.destroy();
    }
}
}
