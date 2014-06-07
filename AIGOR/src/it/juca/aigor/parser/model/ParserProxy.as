/**
 * Created with IntelliJ IDEA.
 * User: Luca
 * Date: 05/06/14
 * Time: 22.41
 */
package it.juca.aigor.parser.model {
import com.dehats.fgl.analysis.JavaParser;
import com.dehats.fgl.analysis.PHPParser;

import mx.collections.ArrayCollection;

public class ParserProxy {

    public var parsers:ArrayCollection = new ArrayCollection(
            [
                {label: "JavaParser", codeParser: JavaParser},
                {label: "PHPParser", codeParser: PHPParser}
            ]
    );

}

}
