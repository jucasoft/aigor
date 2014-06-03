package com.dehats.fgl.generation {
import com.dehats.fgl.analysis.SQLDBData;
import com.dehats.fgl.analysis.SQLTable;

/**
 *
 * @author davidderaedt
 *
 * Code Generation Manager for PHP applications
 *
 */

public class PHPGenManager implements IServerGenManager {

    public var generator:PHPGenerator;

    public var objectStyleAccess:Boolean;

    public function PHPGenManager() {
        generator = new PHPGenerator();
    }

    public function init(pParam:PackageConfig):void {
        // do nothing
    }

    public function createBaseFiles():Array {
        return null;
    }

    public function addSQLDBData(dbData:SQLDBData):Array {

        var fileList:Array = [];

        for (var i:int = 0; i < dbData.tables.length; i++) {
            var table:SQLTable = dbData.tables.getItemAt(i) as SQLTable;

            var phpVOfile:GeneratedFile = generator.generateVO(TemplateManager.getInstance().phpVOTemplateStr, table);
            var phpDAOfile:GeneratedFile = generator.generateDAO(TemplateManager.getInstance().phpDAOTemplateStr, table, objectStyleAccess);

            fileList.push(phpVOfile);
            fileList.push(phpDAOfile);

        }

        var serviceFile:GeneratedFile = generator.generateService(
                TemplateManager.getInstance().phpServiceTemplateStr,
                dbData.tables.toArray(),
                "ApplicationService");

        fileList.push(serviceFile);


        return fileList;

    }

}
}