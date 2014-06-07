package it.juca.aigor.application.utils {

/**
 *  Utility class per generare valori random da utilizzare da riempitivo per bean non ancora valorizzati/valorizzabili
 * @author Davide de Paolis Apr.2010
 *
 */
public class RandomizerUtil {
    public static const COGNOMI:Array = ["Abbott", "Acevedo", "Acosta", "Adams", "Crane", "Crawford", "Crosby", "Cross", "Deleon", "Delgado", "Dennis", "Diaz", "Dickerson", "Dickson", "Dillard", "Dillon", "Dixon", "Dodson", "Dominguez", "Donaldson", "Donovan", "Dorsey", "Dotson", "Douglas", "Downs", "Doyle", "Drake", "Dudley", "Duffy", "Duke", "Duncan", "Dunlap", "Faulkner", "Ferguson", "Fernandez", "Ferrell", "Fields", "Figueroa", "Finch", "Finley", "Fischer", "Fisher", "Fitzgerald", "Fitzpatrick", "Fleming", "Fletcher", "Flores", "Flowers", "Floyd", "Flynn", "Foley", "Forbes", "Ford", "Foreman", "Foster", "Fowler", "Fox", "Francis", "Franco", "Frank", "Franklin", "Franks", "Frazier", "Frederick", "Freeman", "French", "Frost", "Fry", "Frye", "Fuentes", "Fuller", "Fulton", "Gaines", "Gallagher", "Gallegos", "Galloway", "Gamble", "Garcia", "Gardner", "Garner", "Garrett", "Garrison", "Garza", "Gates", "Gay", "Gentry", "George", "Gibbs", "Gibson", "Gilbert", "Giles", "Gill", "Gillespie", "Gilliam", "Gilmore", "Glass", "Glenn", "Glover", "Goff", "Golden", "Gomez", "Gonzales", "Gonzalez", "Good", "Goodman", "Goodwin", "Gordon", "Gould", "Graham", "Grant", "Graves", "Gray", "Green", "Greene", "Greer", "Gregory", "Griffin", "Griffith", "Grimes", "Gross", "Guerra", "Guerrero", "Guthrie", "Gutierrez", "Guy", "Guzman", "Hahn", "Hale", "Haley", "Hall", "Hamilton", "Hammond", "Hampton", "Hancock", "Haney", "Hansen", "Hanson", "Hardin", "Harding", "Hardy", "Harmon", "Harper", "Harrell", "Harrington", "Harris", "Harrison", "Hart", "Hartman", "Harvey", "Hatfield", "Hawkins", "Hayden", "Hayes", "Haynes", "Hays", "Head", "Heath", "Hebert", "Henderson", "Hendricks", "Hendrix", "Henry", "Hensley", "Henson", "Herman", "HernandezRandall", "Randolph", "Rasmussen", "Ratliff", "Ray", "Raymond", "Reed", "Reese", "Reeves", "Reid", "Reilly", "Reyes", "Reynolds", "Rhodes", "Rice", "Rich", "Richard", "Richards", "Richardson", "Richmond", "Riddle", "Riggs", "Riley", "Rios", "Rivas", "Rivera", "Rivers", "Roach", "Robbins", "Roberson", "Roberts", "Robertson", "Robinson", "Robles", "Rocha", "Rodgers", "Taylor", "Terrell", "Terry", "Thomas", "Thompson", "Thornton", "Tillman", "Todd", "Torres", "Townsend", "Tran", "Travis", "Trevino", "Trujillo", "Tucker", "Turner", "Tyler", "Vinson", "Wade", "Wagner", "Walker", "Wells", "West", "Wheeler", "Whitaker", "White", "Whitehead", "Whitfield", "Whitley", "Whitney", "Wiggins", "Wilcox", "Wilder", "Wiley", "Wilkerson", "Wilkins", "Wilkinson", "William", "Williams", "Williamson", "Willis", "Wilson", "Winters", "Wise", "Witt", "Wolf", "Wolfe", "Wong", "Wood", "Woodard", "Woods", "Woodward", "Wooten", "Workman", "Wright", "Wyatt", "Wynn", "Yang", "Yates", "York", "Young", "Zamora", "Zimmerman"];

    public static const GIORNI:Array = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica"];

    public static const NOMI:Array = ["Luca", "Roberto", "Davide", "Francesco", "Luigi", "Alberto", "Fulvio", "Giovanni", "Paolo", "Pietro", "Donatello", "Lorenzo", "Filippo", "Vittorio"];
    private static const ALFABETO:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
    private static const LOREM:Array = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Sed eu orci sit amet sapien venenatis laoreet.", "Nulla at arcu mi, ut ornare dolor.", "In sed eros lorem, vel adipiscing massa.", "Nullam adipiscing varius dui, a vulputate velit lobortis porta.", "In ac erat sit amet nisi pharetra fringilla venenatis in nisi.", "Cras euismod est egestas massa fermentum vehicula.", "Nulla cursus gravida magna, sed malesuada elit ullamcorper convallis.", "Sed et nisi cursus dolor tincidunt feugiat.", "Donec non justo eu libero dignissim tempor quis eu mauris.", "Fusce quis nunc augue, quis semper velit.", "Nunc malesuada convallis nibh, sit amet accumsan nisi fringilla vitae.", "Proin eget felis vel eros dictum rhoncus non tincidunt erat.", "Integer in lacus sit amet massa fermentum mattis in id quam.", "Quisque vel massa sed diam sagittis aliquam.", "Mauris ornare urna id dolor ultrices at varius enim pretium.", "Vivamus id tellus at dolor interdum placerat eu porttitor nisi.", "Nullam varius elit quis nulla consequat ut pulvinar ipsum pharetra.", "Ut interdum placerat neque, non tincidunt justo accumsan nec.", "Nullam rutrum lectus in urna facilisis sed elementum justo lacinia.", "Sed adipiscing ligula in ipsum tincidunt ac dictum nisl posuere.", "Nulla nec dui vel eros scelerisque sagittis.", "Vestibulum lacinia tempor tortor, non consequat nunc commodo rutrum.", "Nullam et ligula a est ullamcorper tincidunt in et lorem.", "Nulla vitae mauris sed libero varius consequat porta ac ligula.", "Mauris auctor enim ac dui cursus pretium.", "Phasellus eget mauris metus, sit amet ultrices arcu.", "Sed posuere imperdiet velit, sit amet sodales libero sodales non.", "Donec vitae metus urna, non dictum lacus.", "Duis tincidunt lobortis ante, nec tristique mauris dictum non.", "Integer sit amet nulla est, eu rutrum odio.", "Praesent porta vestibulum lorem, a ornare quam cursus adipiscing.", "Sed placerat dignissim turpis, eget placerat est tempus eget.", "Donec quis urna ac nibh auctor facilisis.", "Maecenas a massa ac dolor tincidunt fermentum at vel sem.", "Nunc porttitor placerat quam, ut dignissim metus mattis non.", "Nunc placerat facilisis sem, quis hendrerit lectus vehicula non.", "Nunc cursus felis non libero tristique non auctor odio tincidunt."];
    private static const NUMERI:String = "0123456789";
    public static const PRODOTTI:Array = ["ABBA 12BUST 875MG+125MG", "ABBA 12CPR RIV 875MG+125MG", "ABELCET EV 10FL 20ML+10AGHI", "ABIDEC OS GTT 10ML", "ABILIFY 28CPR 10MG", "ABILIFY 28CPR 15MG", "ABILIFY 28CPR 5MG", "ABILIFY 28CPR ORODISP 10MG", "ABILIFY 28CPR ORODISP 15MG", "ABILIFY IM FL 1,3ML 7,5MG/ML", "ABILIFY OS FL 150ML 1MG/ML", "ABIMONO 1 OV VAG 600MG", "ABIOSTIL POM RIN 10G", "ABIS 14CPR 10MG", "ABIS 28CPR 5MG", "ABSEAMED 6SIR 10000UI 1ML", "ABSEAMED 6SIR 1000UI 0,5ML", "ABSEAMED 6SIR 2000UI 1ML", "ABSEAMED 6SIR 3000UI 0,3ML", "ABSEAMED 6SIR 4000UI 0,4ML", "ABSEAMED 6SIR 5000UI 0,5ML", "ABSEAMED 6SIR 6000UI 0,6ML", "ABSEAMED 6SIR 8000UI 0,8ML", "AC.VAL.SOD.VAL.EG 30CPR 300MG", "AC.VAL.SOD.VAL.EG 30CPR 500MG", "AC.VAL.SOD.VAL.RAT. 30CPR300MG", "AC.VAL.SOD.VAL.RAT. 30CPR500MG", "ACADIMOX 12CPR RIV 875MG+125MG", "ACCOLEIT 28CPR RIV 20MG", "ACCUPRIN 14CPR RIV 20MG", "ACCUPRIN 28CPR RIV 5MG", "ACCURETIC 14CPR RIV 20+12,5MG", "ACCUSOL C/K 35 2SA 5000ML2MMOL", "ACCUSOL C/K 35 2SA 5000ML4MMOL", "ACEDIUR 12CPR 50MG+15MG", "ACEDIUR 12CPR 50MG+25MG", "ACEF IM 1FL 1G+F 4ML", "ACEPLUS 12CPR 50MG+25MG", "ACEQUIDE 14CPR RIV 20MG+12,5MG", "ACEQUIN 14CPR RIV 20MG", "ACEQUIN 28CPR RIV 5MG", "ACESISTEM 14CPR 20MG+12,5MG", "ACETAMOL 16CPR EFF DIV 1000MG", "ACETAMOL AD 10SUPP 1G", "ACETAMOL AD 20CPR 500MG", "ACETAMOL BB 10SUPP 250MG", "ACETAMOL BB 10SUPP 500MG", "ACETAMOL GRAT EFF 10BUST 300MG", "ACETAMOL PRIMA INF 100ML 25MG/", "ACETAMOL PRIMA INF10SUPP 125MG", "ACETILCISTEINA ANG. 20CPR EFF", "ACETILCISTEINA ANG. 30BS 200MG", "ACETILCISTEINA ANG. EV NEB 5F", "ACETILCISTEINA MG 30CPR EFF600", "ACETILCISTEINA 20CPR EFF 600MG", "ACETILCISTEINA 20CPR EFF 600MG", "ACETILCISTEINA 30BUST 200MG", "ACETILCISTEINA 30CPR EFF 600MG", "ACETILCISTEINA EV NEB 5F 300MG", "GABAPENTIN FIDIA 30CPS 400MG", "GABAPENTIN FIDIA 50CPS 100MG", "GABAPENTIN FIDIA 50CPS 300MG", "GABAPENTIN HEX. 30CPS 400MG BL", "GABAPENTIN HEX. 50CPS 100MG BL", "GABAPENTIN HEX. 50CPS 300MG BL", "GABAPENTIN M.G. 30CPS 400MG", "GABAPENTIN M.G. 50CPS 100MG", "GABAPENTIN M.G. 50CPS 300MG", "GABAPENTIN PLIVA 30CPS 400MG", "GABAPENTIN PLIVA 50CPS 300MG", "GABAPENTIN RAN FL 30CPS 400MG", "GABAPENTIN RAN FL 50CPS 100MG", "GABAPENTIN RAN FL 50CPS 300MG", "GABAPENTIN RATIO. 30CPS 400MG", "GABAPENTIN RATIO. 50CPS 100MG", "GABAPENTIN RATIO. 50CPS 300MG"];
    private static const PROVINCE:Array = ["MI", "BO", "CO", "LE", "CL", "MB", "TO", "GE", "CA", "CT", "AG", "RI", "MO", "VI"];
    private static const TEL:Array = ["039202023", "022020202", "03920202020", "0493030300", "01129292929", "01124773829"];


    /**
     * Genera data casuale
     * @param startYear
     * data minima indietro nel tempo da cui generare nuova data
     * @return
     *
     */
    public static function getRandomDate(startYear:Number = 1935):Date {
        var mm:Number = Math.floor(0 + (Math.random() * 11));
        var gg:Number = Math.floor(1 + (Math.random() * 31));
        var yy:Number = Math.floor(startYear + (Math.random() * (new Date().getFullYear() - startYear)));
        return new Date(yy, mm, gg);

    }

    /**

     * @return
     *
     */
    public static function getRandomLoremIpsum():String {
        return LOREM[randomNumber(LOREM.length - 1, 0)]


    }


    /**
     * Genera un valore booleano casuale
     * @return
     *
     */
    public static function randomBoolean():Boolean {
        return Math.random() >= 0.5;
    }

    /**
     * Genera un numero casuale di tante cifre quante sono quelle specificate nel param
     * @param cifre
     * @return
     *
     */
    public static function getRandomNum(cifre:Number = 4):Number {
        var arr:Array = NUMERI.split();
        var num:String = "";

        for (var i:Number = 0; i < cifre; i++) {
            num += Math.floor((Math.random() * 10));
        }
        return Number(num);

    }

    /**
     * Genera un numero casuale di valore contenuto fra il min e il max specificati
     * @param valRandom
     * @param valMin
     * @return
     *
     */
    public static function randomNumber(valRandom:int = 1, valMin:int = 0):Number {
        return Math.round(Math.random() * valRandom) + valMin;
    }


    /**
     *  Estrae un elemento a caso dall'array di partenza
     * @param arr
     * @return
     *
     */
    public static function randomValue(arr:Array):String {
        return arr[Math.round(Math.random() * (arr.length - 1))];
    }


    public static function randomCod(userAlphabet:String = "pippo-pluto-paperino"):String {
        var alphabet:Array = userAlphabet.split("-");
        var alphabetLength:int = alphabet.length;
        var randomLetters:String = "";

        randomLetters = alphabet[int(Math.floor(Math.random() * alphabetLength))];

        return randomLetters;
    }

    /**
     *  Genera una stringa casuale  della lunghezza specificata
     * @param newLength
     * @param userAlphabet
     * @return
     *
     */
    public static function randomString(newLength:uint = 1, userAlphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String {
        var alphabet:Array = userAlphabet.split("");
        var alphabetLength:int = alphabet.length;
        var randomLetters:String = "";
        for (var i:uint = 0; i < newLength; i++) {
            randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];
        }
        return randomLetters;
    }
}
}