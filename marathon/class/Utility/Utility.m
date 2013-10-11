//
//  Utility.m
//  LeheB
//
//  Created by zhangluyi on 11-5-4.
//  Copyright 2011年 Lehe. All rights reserved.
//

#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "NSString+stringValue.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSString+MD5.h"
#import "UIDevice+ProcessesAdditions.h"

#define ARC4RANDOM_MAX      0x100000000

#define HANZI_START 19968
#define HANZI_COUNT 20902

#define MAX_STRING_LENGTH 255

static char firstLetterArray[HANZI_COUNT] = 
"ydkqsxnwzssxjbymgcczqpssqbycdscdqldylybssjgyqzjjfgcclzznwdwzjljpfyynnjjtmynzwzhflzppqhgccyynmjqyxxgd"
"nnsnsjnjnsnnmlnrxyfsngnnnnqzggllyjlnyzssecykyyhqwjssggyxyqyjtwktjhychmnxjtlhjyqbyxdldwrrjnwysrldzjpc"
"bzjjbrcfslnczstzfxxchtrqggddlyccssymmrjcyqzpwwjjyfcrwfdfzqpyddwyxkyjawjffxjbcftzyhhycyswccyxsclcxxwz"
"cxnbgnnxbxlzsqsbsjpysazdhmdzbqbscwdzzyytzhbtsyyfzgntnxjywqnknphhlxgybfmjnbjhhgqtjcysxstkzglyckglysmz"
"xyalmeldccxgzyrjxjzlnjzcqkcnnjwhjczccqljststbnhbtyxceqxkkwjyflzqlyhjxspsfxlmpbysxxxytccnylllsjxfhjxp"
"jbtffyabyxbcczbzyclwlczggbtssmdtjcxpthyqtgjjxcjfzkjzjqnlzwlslhdzbwjncjzyzsqnycqynzcjjwybrtwpyftwexcs"
"kdzctbyhyzqyyjxzcfbzzmjyxxsdczottbzljwfckscsxfyrlrygmbdthjxsqjccsbxyytswfbjdztnbcnzlcyzzpsacyzzsqqcs"
"hzqydxlbpjllmqxqydzxsqjtzpxlcglqdcwzfhctdjjsfxjejjtlbgxsxjmyjjqpfzasyjnsydjxkjcdjsznbartcclnjqmwnqnc"
"lllkbdbzzsyhqcltwlccrshllzntylnewyzyxczxxgdkdmtcedejtsyyssdqdfmxdbjlkrwnqlybglxnlgtgxbqjdznyjsjyjcjm"
"rnymgrcjczgjmzmgxmmryxkjnymsgmzzymknfxmbdtgfbhcjhkylpfmdxlxjjsmsqgzsjlqdldgjycalcmzcsdjllnxdjffffjcn"
"fnnffpfkhkgdpqxktacjdhhzdddrrcfqyjkqccwjdxhwjlyllzgcfcqjsmlzpbjjblsbcjggdckkdezsqcckjgcgkdjtjllzycxk"
"lqccgjcltfpcqczgwbjdqyzjjbyjhsjddwgfsjgzkcjctllfspkjgqjhzzljplgjgjjthjjyjzccmlzlyqbgjwmljkxzdznjqsyz"
"mljlljkywxmkjlhskjhbmclyymkxjqlbmllkmdxxkwyxwslmlpsjqqjqxyqfjtjdxmxxllcrqbsyjbgwynnggbcnxpjtgpapfgdj"
"qbhbncfjyzjkjkhxqfgqckfhygkhdkllsdjqxpqyaybnqsxqnszswhbsxwhxwbzzxdmndjbsbkbbzklylxgwxjjwaqzmywsjqlsj"
"xxjqwjeqxnchetlzalyyyszzpnkyzcptlshtzcfycyxyljsdcjqagyslcllyyysslqqqnldxzsccscadycjysfsgbfrsszqsbxjp"
"sjysdrckgjlgtkzjzbdktcsyqpyhstcldjnhmymcgxyzhjdctmhltxzhylamoxyjcltyfbqqjpfbdfehthsqhzywwcncxcdwhowg"
"yjlegmdqcwgfjhcsntmydolbygnqwesqpwnmlrydzszzlyqpzgcwxhnxpyxshmdqjgztdppbfbhzhhjyfdzwkgkzbldnzsxhqeeg"
"zxylzmmzyjzgszxkhkhtxexxgylyapsthxdwhzydpxagkydxbhnhnkdnjnmyhylpmgecslnzhkxxlbzzlbmlsfbhhgsgyyggbhsc"
"yajtxglxtzmcwzydqdqmngdnllszhngjzwfyhqswscelqajynytlsxthaznkzzsdhlaxxtwwcjhqqtddwzbcchyqzflxpslzqgpz"
"sznglydqtbdlxntctajdkywnsyzljhhdzckryyzywmhychhhxhjkzwsxhdnxlyscqydpslyzwmypnkxyjlkchtyhaxqsyshxasmc"
"hkdscrsgjpwqsgzjlwwschsjhsqnhnsngndantbaalczmsstdqjcjktscjnxplggxhhgoxzcxpdmmhldgtybynjmxhmrzplxjzck"
"zxshflqxxcdhxwzpckczcdytcjyxqhlxdhypjqxnlsyydzozjnhhqezysjyayxkypdgxddnsppyzndhthrhxydpcjjhtcnnctlhb"
"ynyhmhzllnnxmylllmdcppxhmxdkycyrdltxjchhznxclcclylnzsxnjzzlnnnnwhyqsnjhxynttdkyjpychhyegkcwtwlgjrlgg"
"tgtygyhpyhylqyqgcwyqkpyyettttlhyylltyttsylnyzwgywgpydqqzzdqnnkcqnmjjzzbxtqfjkdffbtkhzkbxdjjkdjjtlbwf"
"zpptkqtztgpdwntpjyfalqmkgxbcclzfhzcllllanpnxtjklcclgyhdzfgyddgcyyfgydxkssendhykdndknnaxxhbpbyyhxccga"
"pfqyjjdmlxcsjzllpcnbsxgjyndybwjspcwjlzkzddtacsbkzdyzypjzqsjnkktknjdjgyepgtlnyqnacdntcyhblgdzhbbydmjr"
"egkzyheyybjmcdtafzjzhgcjnlghldwxjjkytcyksssmtwcttqzlpbszdtwcxgzagyktywxlnlcpbclloqmmzsslcmbjcsdzkydc"
"zjgqjdsmcytzqqlnzqzxssbpkdfqmddzzsddtdmfhtdycnaqjqkypbdjyyxtljhdrqxlmhkydhrnlklytwhllrllrcxylbnsrnzz"
"symqzzhhkyhxksmzsyzgcxfbnbsqlfzxxnnxkxwymsddyqnggqmmyhcdzttfgyyhgsbttybykjdnkyjbelhdypjqnfxfdnkzhqks"
"byjtzbxhfdsbdaswpawajldyjsfhblcnndnqjtjnchxfjsrfwhzfmdrfjyxwzpdjkzyjympcyznynxfbytfyfwygdbnzzzdnytxz"
"emmqbsqehxfznbmflzzsrsyqjgsxwzjsprytjsjgskjjgljjynzjjxhgjkymlpyyycxycgqzswhwlyrjlpxslcxmnsmwklcdnkny"
"npsjszhdzeptxmwywxyysywlxjqcqxzdclaeelmcpjpclwbxsqhfwrtfnjtnqjhjqdxhwlbyccfjlylkyynldxnhycstyywncjtx"
"ywtrmdrqnwqcmfjdxzmhmayxnwmyzqtxtlmrspwwjhanbxtgzypxyyrrclmpamgkqjszycymyjsnxtplnbappypylxmyzkynldgy"
"jzcchnlmzhhanqnbgwqtzmxxmllhgdzxnhxhrxycjmffxywcfsbssqlhnndycannmtcjcypnxnytycnnymnmsxndlylysljnlxys"
"sqmllyzlzjjjkyzzcsfbzxxmstbjgnxnchlsnmcjscyznfzlxbrnnnylmnrtgzqysatswryhyjzmgdhzgzdwybsscskxsyhytsxg"
"cqgxzzbhyxjscrhmkkbsczjyjymkqhzjfnbhmqhysnjnzybknqmcjgqhwlsnzswxkhljhyybqcbfcdsxdldspfzfskjjzwzxsddx"
"jseeegjscssygclxxnwwyllymwwwgydkzjggggggsycknjwnjpcxbjjtqtjwdsspjxcxnzxnmelptfsxtllxcljxjjljsxctnswx"
"lennlyqrwhsycsqnybyaywjejqfwqcqqcjqgxaldbzzyjgkgxbltqyfxjltpydkyqhpmatlcndnkxmtxynhklefxdllegqtymsaw"
"hzmljtkynxlyjzljeeyybqqffnlyxhdsctgjhxywlkllxqkcctnhjlqmkkzgcyygllljdcgydhzwypysjbzjdzgyzzhywyfqdtyz"
"szyezklymgjjhtsmqwyzljyywzcsrkqyqltdxwcdrjalwsqzwbdcqyncjnnszjlncdcdtlzzzacqqzzddxyblxcbqjylzllljddz"
"jgyqyjzyxnyyyexjxksdaznyrdlzyyynjlslldyxjcykywnqcclddnyyynycgczhjxcclgzqjgnwnncqqjysbzzxyjxjnxjfzbsb"
"dsfnsfpzxhdwztdmpptflzzbzdmyypqjrsdzsqzsqxbdgcpzswdwcsqzgmdhzxmwwfybpngphdmjthzsmmbgzmbzjcfzhfcbbnmq"
"dfmbcmcjxlgpnjbbxgyhyyjgptzgzmqbqdcgybjxlwnkydpdymgcftpfxyztzxdzxtgkptybbclbjaskytssqyymscxfjhhlslls"
"jpqjjqaklyldlycctsxmcwfgngbqxllllnyxtyltyxytdpjhnhgnkbyqnfjyyzbyyessessgdyhfhwtcqbsdzjtfdmxhcnjzymqw"
"srxjdzjqbdqbbsdjgnfbknbxdkqhmkwjjjgdllthzhhyyyyhhsxztyyyccbdbpypzyccztjpzywcbdlfwzcwjdxxhyhlhwczxjtc"
"nlcdpxnqczczlyxjjcjbhfxwpywxzpcdzzbdccjwjhmlxbqxxbylrddgjrrctttgqdczwmxfytmmzcwjwxyywzzkybzcccttqnhx"
"nwxxkhkfhtswoccjybcmpzzykbnnzpbthhjdlszddytyfjpxyngfxbyqxzbhxcpxxtnzdnnycnxsxlhkmzxlthdhkghxxsshqyhh"
"cjyxglhzxcxnhekdtgqxqypkdhentykcnymyyjmkqyyyjxzlthhqtbyqhxbmyhsqckwwyllhcyylnneqxqwmcfbdccmljggxdqkt"
"lxkknqcdgcjwyjjlyhhqyttnwchhxcxwherzjydjccdbqcdgdnyxzdhcqrxcbhztqcbxwgqwyybxhmbymykdyecmqkyaqyngyzsl"
"fnkkqgyssqyshngjctxkzycssbkyxhyylstycxqthysmnscpmmgcccccmnztasmgqzjhklosjylswtmqzyqkdzljqqyplzycztcq"
"qpbbcjzclpkhqcyyxxdtdddsjcxffllchqxmjlwcjcxtspycxndtjshjwhdqqqckxyamylsjhmlalygxcyydmamdqmlmcznnyybz"
"xkyflmcncmlhxrcjjhsylnmtjggzgywjxsrxcwjgjqhqzdqjdcjjskjkgdzcgjjyjylxzxxcdqhhheslmhlfsbdjsyyshfyssczq"
"lpbdrfnztzdkykhsccgkwtqzckmsynbcrxqbjyfaxpzzedzcjykbcjwhyjbqzzywnyszptdkzpfpbaztklqnhbbzptpptyzzybhn"
"ydcpzmmcycqmcjfzzdcmnlfpbplngqjtbttajzpzbbdnjkljqylnbzqhksjznggqstzkcxchpzsnbcgzkddzqanzgjkdrtlzldwj"
"njzlywtxndjzjhxnatncbgtzcsskmljpjytsnwxcfjwjjtkhtzplbhsnjssyjbhbjyzlstlsbjhdnwqpslmmfbjdwajyzccjtbnn"
"nzwxxcdslqgdsdpdzgjtqqpsqlyyjzlgyhsdlctcbjtktyczjtqkbsjlgnnzdncsgpynjzjjyyknhrpwszxmtncszzyshbyhyzax"
"ywkcjtllckjjtjhgcssxyqyczbynnlwqcglzgjgqyqcczssbcrbcskydznxjsqgxssjmecnstjtpbdlthzwxqwqczexnqczgwesg"
"ssbybstscslccgbfsdqnzlccglllzghzcthcnmjgyzazcmsksstzmmzckbjygqljyjppldxrkzyxccsnhshhdznlzhzjjcddcbcj"
"xlbfqbczztpqdnnxljcthqzjgylklszzpcjdscqjhjqkdxgpbajynnsmjtzdxlcjyryynhjbngzjkmjxltbsllrzpylssznxjhll"
"hyllqqzqlsymrcncxsljmlzltzldwdjjllnzggqxppskyggggbfzbdkmwggcxmcgdxjmcjsdycabxjdlnbcddygskydqdxdjjyxh"
"saqazdzfslqxxjnqzylblxxwxqqzbjzlfbblylwdsljhxjyzjwtdjcyfqzqzzdzsxzzqlzcdzfxhwspynpqzmlpplffxjjnzzyls"
"jnyqzfpfzgsywjjjhrdjzzxtxxglghtdxcskyswmmtcwybazbjkshfhgcxmhfqhyxxyzftsjyzbxyxpzlchmzmbxhzzssyfdmncw"
"dabazlxktcshhxkxjjzjsthygxsxyyhhhjwxkzxssbzzwhhhcwtzzzpjxsyxqqjgzyzawllcwxznxgyxyhfmkhydwsqmnjnaycys"
"pmjkgwcqhylajgmzxhmmcnzhbhxclxdjpltxyjkdyylttxfqzhyxxsjbjnayrsmxyplckdnyhlxrlnllstycyyqygzhhsccsmcct"
"zcxhyqfpyyrpbflfqnntszlljmhwtcjqyzwtlnmlmdwmbzzsnzrbpdddlqjjbxtcsnzqqygwcsxfwzlxccrszdzmcyggdyqsgtnn"
"nlsmymmsyhfbjdgyxccpshxczcsbsjyygjmpbwaffyfnxhydxzylremzgzzyndsznlljcsqfnxxkptxzgxjjgbmyyssnbtylbnlh"
"bfzdcyfbmgqrrmzszxysjtznnydzzcdgnjafjbdknzblczszpsgcycjszlmnrznbzzldlnllysxsqzqlcxzlsgkbrxbrbzcycxzj"
"zeeyfgklzlnyhgzcgzlfjhgtgwkraajyzkzqtsshjjxdzyznynnzyrzdqqhgjzxsszbtkjbbfrtjxllfqwjgclqtymblpzdxtzag"
"bdhzzrbgjhwnjtjxlkscfsmwlldcysjtxkzscfwjlbnntzlljzllqblcqmqqcgcdfpbphzczjlpyyghdtgwdxfczqyyyqysrclqz"
"fklzzzgffcqnwglhjycjjczlqzzyjbjzzbpdcsnnjgxdqnknlznnnnpsntsdyfwwdjzjysxyyczcyhzwbbyhxrylybhkjksfxtjj"
"mmchhlltnyymsxxyzpdjjycsycwmdjjkqyrhllngpngtlyycljnnnxjyzfnmlrgjjtyzbsyzmsjyjhgfzqmsyxrszcytlrtqzsst"
"kxgqkgsptgxdnjsgcqcqhmxggztqydjjznlbznxqlhyqgggthqscbyhjhhkyygkggcmjdzllcclxqsftgjslllmlcskctbljszsz"
"mmnytpzsxqhjcnnqnyexzqzcpshkzzyzxxdfgmwqrllqxrfztlystctmjcsjjthjnxtnrztzfqrhcgllgcnnnnjdnlnnytsjtlny"
"xsszxcgjzyqpylfhdjsbbdczgjjjqzjqdybssllcmyttmqnbhjqmnygjyeqyqmzgcjkpdcnmyzgqllslnclmholzgdylfzslncnz"
"lylzcjeshnyllnxnjxlyjyyyxnbcljsswcqqnnyllzldjnllzllbnylnqchxyyqoxccqkyjxxxyklksxeyqhcqkkkkcsnyxxyqxy"
"gwtjohthxpxxhsnlcykychzzcbwqbbwjqcscszsslcylgddsjzmmymcytsdsxxscjpqqsqylyfzychdjynywcbtjsydchcyddjlb"
"djjsodzyqyskkyxdhhgqjyohdyxwgmmmazdybbbppbcmnnpnjzsmtxerxjmhqdntpjdcbsnmssythjtslmltrcplzszmlqdsdmjm"
"qpnqdxcfrnnfsdqqyxhyaykqyddlqyyysszbydslntfgtzqbzmchdhczcwfdxtmqqsphqwwxsrgjcwnntzcqmgwqjrjhtqjbbgwz"
"fxjhnqfxxqywyyhyscdydhhqmrmtmwctbszppzzglmzfollcfwhmmsjzttdhlmyffytzzgzyskjjxqyjzqbhmbzclyghgfmshpcf"
"zsnclpbqsnjyzslxxfpmtyjygbxlldlxpzjyzjyhhzcywhjylsjexfszzywxkzjlnadymlymqjpwxxhxsktqjezrpxxzghmhwqpw"
"qlyjjqjjzszcnhjlchhnxjlqwzjhbmzyxbdhhypylhlhlgfwlcfyytlhjjcwmscpxstkpnhjxsntyxxtestjctlsslstdlllwwyh"
"dnrjzsfgxssyczykwhtdhwjglhtzdqdjzxxqgghltzphcsqfclnjtclzpfstpdynylgmjllycqhynspchylhqyqtmzymbywrfqyk"
"jsyslzdnjmpxyyssrhzjnyqtqdfzbwwdwwrxcwggyhxmkmyyyhmxmzhnksepmlqqmtcwctmxmxjpjjhfxyyzsjzhtybmstsyjznq"
"jnytlhynbyqclcycnzwsmylknjxlggnnpjgtysylymzskttwlgsmzsylmpwlcwxwqcssyzsyxyrhssntsrwpccpwcmhdhhxzdzyf"
"jhgzttsbjhgyglzysmyclllxbtyxhbbzjkssdmalhhycfygmqypjyjqxjllljgclzgqlycjcctotyxmtmshllwlqfxymzmklpszz"
"cxhkjyclctyjcyhxsgyxnnxlzwpyjpxhjwpjpwxqqxlxsdhmrslzzydwdtcxknstzshbsccstplwsscjchjlcgchssphylhfhhxj"
"sxallnylmzdhzxylsxlmzykcldyahlcmddyspjtqjzlngjfsjshctsdszlblmssmnyymjqbjhrzwtyydchjljapzwbgqxbkfnbjd"
"llllyylsjydwhxpsbcmljpscgbhxlqhyrljxyswxhhzlldfhlnnymjljyflyjycdrjlfsyzfsllcqyqfgqyhnszlylmdtdjcnhbz"
"llnwlqxygyyhbmgdhxxnhlzzjzxczzzcyqzfngwpylcpkpykpmclgkdgxzgxwqbdxzzkzfbddlzxjtpjpttbythzzdwslcpnhslt"
"jxxqlhyxxxywzyswttzkhlxzxzpyhgzhknfsyhntjrnxfjcpjztwhplshfcrhnslxxjxxyhzqdxqwnnhyhmjdbflkhcxcwhjfyjc"
"fpqcxqxzyyyjygrpynscsnnnnchkzdyhflxxhjjbyzwttxnncyjjymswyxqrmhxzwfqsylznggbhyxnnbwttcsybhxxwxyhhxyxn"
"knyxmlywrnnqlxbbcljsylfsytjzyhyzawlhorjmnsczjxxxyxchcyqryxqzddsjfslyltsffyxlmtyjmnnyyyxltzcsxqclhzxl"
"wyxzhnnlrxkxjcdyhlbrlmbrdlaxksnlljlyxxlynrylcjtgncmtlzllcyzlpzpzyawnjjfybdyyzsepckzzqdqpbpsjpdyttbdb"
"bbyndycncpjmtmlrmfmmrwyfbsjgygsmdqqqztxmkqwgxllpjgzbqrdjjjfpkjkcxbljmswldtsjxldlppbxcwkcqqbfqbccajzg"
"mykbhyhhzykndqzybpjnspxthlfpnsygyjdbgxnhhjhzjhstrstldxskzysybmxjlxyslbzyslzxjhfybqnbylljqkygzmcyzzym"
"ccslnlhzhwfwyxzmwyxtynxjhbyymcysbmhysmydyshnyzchmjjmzcaahcbjbbhblytylsxsnxgjdhkxxtxxnbhnmlngsltxmrhn"
"lxqqxmzllyswqgdlbjhdcgjyqyymhwfmjybbbyjyjwjmdpwhxqldyapdfxxbcgjspckrssyzjmslbzzjfljjjlgxzgyxyxlszqkx"
"bexyxhgcxbpndyhwectwwcjmbtxchxyqqllxflyxlljlssnwdbzcmyjclwswdczpchqekcqbwlcgydblqppqzqfnqdjhymmcxtxd"
"rmzwrhxcjzylqxdyynhyyhrslnrsywwjjymtltllgtqcjzyabtckzcjyccqlysqxalmzynywlwdnzxqdllqshgpjfjljnjabcqzd"
"jgthhsstnyjfbswzlxjxrhgldlzrlzqzgsllllzlymxxgdzhgbdphzpbrlwnjqbpfdwonnnhlypcnjccndmbcpbzzncyqxldomzb"
"lzwpdwyygdstthcsqsccrsssyslfybnntyjszdfndpdhtqzmbqlxlcmyffgtjjqwftmnpjwdnlbzcmmcngbdzlqlpnfhyymjylsd"
"chdcjwjcctljcldtljjcbddpndsszycndbjlggjzxsxnlycybjjxxcbylzcfzppgkcxqdzfztjjfjdjxzbnzyjqctyjwhdyczhym"
"djxttmpxsplzcdwslshxypzgtfmlcjtacbbmgdewycyzxdszjyhflystygwhkjyylsjcxgywjcbllcsnddbtzbsclyzczzssqdll"
"mjyyhfllqllxfdyhabxggnywyypllsdldllbjcyxjznlhljdxyyqytdlllbngpfdfbbqbzzmdpjhgclgmjjpgaehhbwcqxajhhhz"
"chxyphjaxhlphjpgpzjqcqzgjjzzgzdmqyybzzphyhybwhazyjhykfgdpfqsdlzmljxjpgalxzdaglmdgxmmzqwtxdxxpfdmmssy"
"mpfmdmmkxksyzyshdzkjsysmmzzzmdydyzzczxbmlstmdyemxckjmztyymzmzzmsshhdccjewxxkljsthwlsqlyjzllsjssdppmh"
"nlgjczyhmxxhgncjmdhxtkgrmxfwmckmwkdcksxqmmmszzydkmsclcmpcjmhrpxqpzdsslcxkyxtwlkjyahzjgzjwcjnxyhmmbml"
"gjxmhlmlgmxctkzmjlyscjsyszhsyjzjcdajzhbsdqjzgwtkqxfkdmsdjlfmnhkzqkjfeypzyszcdpynffmzqykttdzzefmzlbnp"
"plplpbpszalltnlkckqzkgenjlwalkxydpxnhsxqnwqnkxqclhyxxmlnccwlymqyckynnlcjnszkpyzkcqzqljbdmdjhlasqlbyd"
"wqlwdgbqcryddztjybkbwszdxdtnpjdtcnqnfxqqmgnseclstbhpwslctxxlpwydzklnqgzcqapllkqcylbqmqczqcnjslqzdjxl"
"ddhpzqdljjxzqdjyzhhzlkcjqdwjppypqakjyrmpzbnmcxkllzllfqpylllmbsglzysslrsysqtmxyxzqzbscnysyztffmzzsmzq"
"hzssccmlyxwtpzgxzjgzgsjzgkddhtqggzllbjdzlsbzhyxyzhzfywxytymsdnzzyjgtcmtnxqyxjscxhslnndlrytzlryylxqht"
"xsrtzcgyxbnqqzfhykmzjbzymkbpnlyzpblmcnqyzzzsjztjctzhhyzzjrdyzhnfxklfzslkgjtctssyllgzrzbbjzzklpkbczys"
"nnyxbjfbnjzzxcdwlzyjxzzdjjgggrsnjkmsmzjlsjywqsnyhqjsxpjztnlsnshrnynjtwchglbnrjlzxwjqxqkysjycztlqzybb"
"ybyzjqdwgyzcytjcjxckcwdkkzxsnkdnywwyyjqyytlytdjlxwkcjnklccpzcqqdzzqlcsfqchqqgssmjzzllbjjzysjhtsjdysj"
"qjpdszcdchjkjzzlpycgmzndjxbsjzzsyzyhgxcpbjydssxdzncglqmbtsfcbfdzdlznfgfjgfsmpnjqlnblgqcyyxbqgdjjqsrf"
"kztjdhczklbsdzcfytplljgjhtxzcsszzxstjygkgckgynqxjplzbbbgcgyjzgczqszlbjlsjfzgkqqjcgycjbzqtldxrjnbsxxp"
"zshszycfwdsjjhxmfczpfzhqhqmqnknlyhtycgfrzgnqxcgpdlbzcsczqlljblhbdcypscppdymzzxgyhckcpzjgslzlnscnsldl"
"xbmsdlddfjmkdqdhslzxlsznpqpgjdlybdskgqlbzlnlkyyhzttmcjnqtzzfszqktlljtyyllnllqyzqlbdzlslyyzxmdfszsnxl"
"xznczqnbbwskrfbcylctnblgjpmczzlstlxshtzcyzlzbnfmqnlxflcjlyljqcbclzjgnsstbrmhxzhjzclxfnbgxgtqncztmsfz"
"kjmssncljkbhszjntnlzdntlmmjxgzjyjczxyhyhwrwwqnztnfjscpyshzjfyrdjsfscjzbjfzqzchzlxfxsbzqlzsgyftzdcszx"
"zjbjpszkjrhxjzcgbjkhcggtxkjqglxbxfgtrtylxqxhdtsjxhjzjjcmzlcqsbtxwqgxtxxhxftsdkfjhzyjfjxnzldlllcqsqqz"
"qwqxswqtwgwbzcgcllqzbclmqjtzgzyzxljfrmyzflxnsnxxjkxrmjdzdmmyxbsqbhgzmwfwygmjlzbyytgzyccdjyzxsngnyjyz"
"nbgpzjcqsyxsxrtfyzgrhztxszzthcbfclsyxzlzqmzlmplmxzjssfsbysmzqhxxnxrxhqzzzsslyflczjrcrxhhzxqndshxsjjh"
"qcjjbcynsysxjbqjpxzqplmlxzkyxlxcnlcycxxzzlxdlllmjyhzxhyjwkjrwyhcpsgnrzlfzwfzznsxgxflzsxzzzbfcsyjdbrj"
"krdhhjxjljjtgxjxxstjtjxlyxqfcsgswmsbctlqzzwlzzkxjmltmjyhsddbxgzhdlbmyjfrzfcgclyjbpmlysmsxlszjqqhjzfx"
"gfqfqbphngyyqxgztnqwyltlgwgwwhnlfmfgzjmgmgbgtjflyzzgzyzaflsspmlbflcwbjztljjmzlpjjlymqtmyyyfbgygqzgly"
"zdxqyxrqqqhsxyyqxygjtyxfsfsllgnqcygycwfhcccfxpylypllzqxxxxxqqhhsshjzcftsczjxspzwhhhhhapylqnlpqafyhxd"
"ylnkmzqgggddesrenzltzgchyppcsqjjhclljtolnjpzljlhymhezdydsqycddhgznndzclzywllznteydgnlhslpjjbdgwxpcnn"
"tycklkclwkllcasstknzdnnjttlyyzssysszzryljqkcgdhhyrxrzydgrgcwcgzqffbppjfzynakrgywyjpqxxfkjtszzxswzddf"
"bbqtbgtzkznpzfpzxzpjszbmqhkyyxyldkljnypkyghgdzjxxeaxpnznctzcmxcxmmjxnkszqnmnlwbwwqjjyhclstmcsxnjcxxt"
"pcnfdtnnpglllzcjlspblpgjcdtnjjlyarscffjfqwdpgzdwmrzzcgodaxnssnyzrestyjwjyjdbcfxnmwttbqlwstszgybljpxg"
"lbnclgpcbjftmxzljylzxcltpnclcgxtfzjshcrxsfysgdkntlbyjcyjllstgqcbxnhzxbxklylhzlqzlnzcqwgzlgzjncjgcmnz"
"zgjdzxtzjxycyycxxjyyxjjxsssjstsstdppghtcsxwzdcsynptfbchfbblzjclzzdbxgcjlhpxnfzflsyltnwbmnjhszbmdnbcy"
"sccldnycndqlyjjhmqllcsgljjsyfpyyccyltjantjjpwycmmgqyysxdxqmzhszxbftwwzqswqrfkjlzjqqyfbrxjhhfwjgzyqac"
"myfrhcyybynwlpexcczsyyrlttdmqlrkmpbgmyyjprkznbbsqyxbhyzdjdnghpmfsgbwfzmfqmmbzmzdcgjlnnnxyqgmlrygqccy"
"xzlwdkcjcggmcjjfyzzjhycfrrcmtznzxhkqgdjxccjeascrjthpljlrzdjrbcqhjdnrhylyqjsymhzydwcdfryhbbydtssccwbx"
"glpzmlzjdqsscfjmmxjcxjytycghycjwynsxlfemwjnmkllswtxhyyyncmmcyjdqdjzglljwjnkhpzggflccsczmcbltbhbqjxqd"
"jpdjztghglfjawbzyzjltstdhjhctcbchflqmpwdshyytqwcnntjtlnnmnndyyyxsqkxwyyflxxnzwcxypmaelyhgjwzzjbrxxaq"
"jfllpfhhhytzzxsgqjmhspgdzqwbwpjhzjdyjcqwxkthxsqlzyymysdzgnqckknjlwpnsyscsyzlnmhqsyljxbcxtlhzqzpcycyk"
"pppnsxfyzjjrcemhszmnxlxglrwgcstlrsxbygbzgnxcnlnjlclynymdxwtzpalcxpqjcjwtcyyjlblxbzlqmyljbghdslssdmxm"
"bdczsxyhamlczcpjmcnhjyjnsykchskqmczqdllkablwjqsfmocdxjrrlyqchjmybyqlrhetfjzfrfksryxfjdwtsxxywsqjysly"
"xwjhsdlxyyxhbhawhwjcxlmyljcsqlkydttxbzslfdxgxsjkhsxxybssxdpwncmrptqzczenygcxqfjxkjbdmljzmqqxnoxslyxx"
"lylljdzptymhbfsttqqwlhsgynlzzalzxclhtwrrqhlstmypyxjjxmnsjnnbryxyjllyqyltwylqyfmlkljdnlltfzwkzhljmlhl"
"jnljnnlqxylmbhhlnlzxqchxcfxxlhyhjjgbyzzkbxscqdjqdsndzsygzhhmgsxcsymxfepcqwwrbpyyjqryqcyjhqqzyhmwffhg"
"zfrjfcdbxntqyzpcyhhjlfrzgpbxzdbbgrqstlgdgylcqmgchhmfywlzyxkjlypjhsywmqqggzmnzjnsqxlqsyjtcbehsxfszfxz"
"wfllbcyyjdytdthwzsfjmqqyjlmqsxlldttkghybfpwdyysqqrnqwlgwdebzwcyygcnlkjxtmxmyjsxhybrwfymwfrxyymxysctz"
"ztfykmldhqdlgyjnlcryjtlpsxxxywlsbrrjwxhqybhtydnhhxmmywytycnnmnssccdalwztcpqpyjllqzyjswjwzzmmglmxclmx"
"nzmxmzsqtzppjqblpgxjzhfljjhycjsrxwcxsncdlxsyjdcqzxslqyclzxlzzxmxqrjmhrhzjbhmfljlmlclqnldxzlllfyprgjy"
"nxcqqdcmqjzzxhnpnxzmemmsxykynlxsxtljxyhwdcwdzhqyybgybcyscfgfsjnzdrzzxqxrzrqjjymcanhrjtldbpyzbstjhxxz"
"ypbdwfgzzrpymnnkxcqbyxnbnfyckrjjcmjegrzgyclnnzdnkknsjkcljspgyyclqqjybzssqlllkjftbgtylcccdblsppfylgyd"
"tzjqjzgkntsfcxbdkdxxhybbfytyhbclnnytgdhryrnjsbtcsnyjqhklllzslydxxwbcjqsbxnpjzjzjdzfbxxbrmladhcsnclbj"
"dstblprznswsbxbcllxxlzdnzsjpynyxxyftnnfbhjjjgbygjpmmmmsszljmtlyzjxswxtyledqpjmpgqzjgdjlqjwjqllsdgjgy"
"gmscljjxdtygjqjjjcjzcjgdzdshqgzjggcjhqxsnjlzzbxhsgzxcxyljxyxyydfqqjhjfxdhctxjyrxysqtjxyefyyssyxjxncy"
"zxfxcsxszxyyschshxzzzgzzzgfjdldylnpzgsjaztyqzpbxcbdztzczyxxyhhscjshcggqhjhgxhsctmzmehyxgebtclzkkwytj"
"zrslekestdbcyhqqsayxcjxwwgsphjszsdncsjkqcxswxfctynydpccczjqtcwjqjzzzqzljzhlsbhpydxpsxshhezdxfptjqyzc"
"xhyaxncfzyyhxgnqmywntzsjbnhhgymxmxqcnssbcqsjyxxtyyhybcqlmmszmjzzllcogxzaajzyhjmchhcxzsxsdznleyjjzjbh"
"zwjzsqtzpsxzzdsqjjjlnyazphhyysrnqzthzhnyjyjhdzxzlswclybzyecwcycrylchzhzydzydyjdfrjjhtrsqtxyxjrjhojyn"
"xelxsfsfjzghpzsxzszdzcqzbyyklsgsjhczshdgqgxyzgxchxzjwyqwgyhksseqzzndzfkwyssdclzstsymcdhjxxyweyxczayd"
"mpxmdsxybsqmjmzjmtjqlpjyqzcgqhyjhhhqxhlhdldjqcfdwbsxfzzyyschtytyjbhecxhjkgqfxbhyzjfxhwhbdzfyzbchpnpg"
"dydmsxhkhhmamlnbyjtmpxejmcthqbzyfcgtyhwphftgzzezsbzegpbmdskftycmhbllhgpzjxzjgzjyxzsbbqsczzlzscstpgxm"
"jsfdcczjzdjxsybzlfcjsazfgszlwbczzzbyztzynswyjgxzbdsynxlgzbzfygczxbzhzftpbgzgejbstgkdmfhyzzjhzllzzgjq"
"zlsfdjsscbzgpdlfzfzszyzyzsygcxsnxxchczxtzzljfzgqsqqxcjqccccdjcdszzyqjccgxztdlgscxzsyjjqtcclqdqztqchq"
"qyzynzzzpbkhdjfcjfztypqyqttynlmbdktjcpqzjdzfpjsbnjlgyjdxjdcqkzgqkxclbzjtcjdqbxdjjjstcxnxbxqmslyjcxnt"
"jqwwcjjnjjlllhjcwqtbzqqczczpzzdzyddcyzdzccjgtjfzdprntctjdcxtqzdtjnplzbcllctdsxkjzqdmzlbznbtjdcxfczdb"
"czjjltqqpldckztbbzjcqdcjwynllzlzccdwllxwzlxrxntqjczxkjlsgdnqtddglnlajjtnnynkqlldzntdnycygjwyxdxfrsqs"
"tcdenqmrrqzhhqhdldazfkapbggpzrebzzykyqspeqjjglkqzzzjlysyhyzwfqznlzzlzhwcgkypqgnpgblplrrjyxcccgyhsfzf"
"wbzywtgzxyljczwhncjzplfflgskhyjdeyxhlpllllcygxdrzelrhgklzzyhzlyqszzjzqljzflnbhgwlczcfjwspyxzlzlxgccp"
"zbllcxbbbbnbbcbbcrnnzccnrbbnnldcgqyyqxygmqzwnzytyjhyfwtehznjywlccntzyjjcdedpwdztstnjhtymbjnyjzlxtsst"
"phndjxxbyxqtzqddtjtdyztgwscszqflshlnzbcjbhdlyzjyckwtydylbnydsdsycctyszyyebgexhqddwnygyclxtdcystqnygz"
"ascsszzdzlcclzrqxyywljsbymxshzdembbllyyllytdqyshymrqnkfkbfxnnsbychxbwjyhtqbpbsbwdzylkgzskyghqzjxhxjx"
"gnljkzlyycdxlfwfghljgjybxblybxqpqgntzplncybxdjyqydymrbeyjyyhkxxstmxrczzjwxyhybmcflyzhqyzfwxdbxbcwzms"
"lpdmyckfmzklzcyqycclhxfzlydqzpzygyjyzmdxtzfnnyttqtzhgsfcdmlccytzxjcytjmkslpzhysnwllytpzctzccktxdhxxt"
"qcyfksmqccyyazhtjplylzlyjbjxtfnyljyynrxcylmmnxjsmybcsysslzylljjgyldzdlqhfzzblfndsqkczfyhhgqmjdsxyctt"
"xnqnjpyybfcjtyyfbnxejdgyqbjrcnfyyqpghyjsyzngrhtknlnndzntsmgklbygbpyszbydjzsstjztsxzbhbscsbzczptqfzlq"
"flypybbjgszmnxdjmtsyskkbjtxhjcegbsmjyjzcstmljyxrczqscxxqpyzhmkyxxxjcljyrmyygadyskqlnadhrskqxzxztcggz"
"dlmlwxybwsyctbhjhcfcwzsxwwtgzlxqshnyczjxemplsrcgltnzntlzjcyjgdtclglbllqpjmzpapxyzlaktkdwczzbncctdqqz"
"qyjgmcdxltgcszlmlhbglkznnwzndxnhlnmkydlgxdtwcfrjerctzhydxykxhwfzcqshknmqqhzhhymjdjskhxzjzbzzxympajnm"
"ctbxlsxlzynwrtsqgscbptbsgzwyhtlkssswhzzlyytnxjgmjrnsnnnnlskztxgxlsammlbwldqhylakqcqctmycfjbslxclzjcl"
"xxknbnnzlhjphqplsxsckslnhpsfqcytxjjzljldtzjjzdlydjntptnndskjfsljhylzqqzlbthydgdjfdbyadxdzhzjnthqbykn"
"xjjqczmlljzkspldsclbblnnlelxjlbjycxjxgcnlcqplzlznjtsljgyzdzpltqcssfdmnycxgbtjdcznbgbqyqjwgkfhtnbyqzq"
"gbkpbbyzmtjdytblsqmbsxtbnpdxklemyycjynzdtldykzzxtdxhqshygmzsjycctayrzlpwltlkxslzcggexclfxlkjrtlqjaqz"
"ncmbqdkkcxglczjzxjhptdjjmzqykqsecqzdshhadmlzfmmzbgntjnnlhbyjbrbtmlbyjdzxlcjlpldlpcqdhlhzlycblcxccjad"
"qlmzmmsshmybhbnkkbhrsxxjmxmdznnpklbbrhgghfchgmnklltsyyycqlcskymyehywxnxqywbawykqldnntndkhqcgdqktgpkx"
"hcpdhtwnmssyhbwcrwxhjmkmzngwtmlkfghkjyldyycxwhyyclqhkqhtdqkhffldxqwytyydesbpkyrzpjfyyzjceqdzzdlattpb"
"fjllcxdlmjsdxegwgsjqxcfbssszpdyzcxznyxppzydlyjccpltxlnxyzyrscyyytylwwndsahjsygyhgywwaxtjzdaxysrltdps"
"syxfnejdxyzhlxlllzhzsjnyqyqyxyjghzgjcyjchzlycdshhsgczyjscllnxzjjyyxnfsmwfpyllyllabmddhwzxjmcxztzpmlq"
"chsfwzynctlndywlslxhymmylmbwwkyxyaddxylldjpybpwnxjmmmllhafdllaflbnhhbqqjqzjcqjjdjtffkmmmpythygdrjrdd"
"wrqjxnbysrmzdbyytbjhpymyjtjxaahggdqtmystqxkbtzbkjlxrbyqqhxmjjbdjntgtbxpgbktlgqxjjjcdhxqdwjlwrfmjgwqh"
"cnrxswgbtgygbwhswdwrfhwytjjxxxjyzyslphyypyyxhydqpxshxyxgskqhywbdddpplcjlhqeewjgsyykdpplfjthkjltcyjhh"
"jttpltzzcdlyhqkcjqysteeyhkyzyxxyysddjkllpymqyhqgxqhzrhbxpllnqydqhxsxxwgdqbshyllpjjjthyjkyphthyyktyez"
"yenmdshlzrpqfbnfxzbsftlgxsjbswyysksflxlpplbbblnsfbfyzbsjssylpbbffffsscjdstjsxtryjcyffsyzyzbjtlctsbsd"
"hrtjjbytcxyyeylycbnebjdsysyhgsjzbxbytfzwgenhhhthjhhxfwgcstbgxklstyymtmbyxjskzscdyjrcythxzfhmymcxlzns"
"djtxtxrycfyjsbsdyerxhljxbbdeynjghxgckgscymblxjmsznskgxfbnbbthfjyafxwxfbxmyfhdttcxzzpxrsywzdlybbktyqw"
"qjbzypzjznjpzjlztfysbttslmptzrtdxqsjehbnylndxljsqmlhtxtjecxalzzspktlzkqqyfsyjywpcpqfhjhytqxzkrsgtksq"
"czlptxcdyyzsslzslxlzmacpcqbzyxhbsxlzdltztjtylzjyytbzypltxjsjxhlbmytxcqrblzssfjzztnjytxmyjhlhpblcyxqj"
"qqkzzscpzkswalqsplczzjsxgwwwygyatjbbctdkhqhkgtgpbkqyslbxbbckbmllndzstbklggqkqlzbkktfxrmdkbftpzfrtppm"
"ferqnxgjpzsstlbztpszqzsjdhljqlzbpmsmmsxlqqnhknblrddnhxdkddjcyyljfqgzlgsygmjqjkhbpmxyxlytqwlwjcpbmjxc"
"yzydrjbhtdjyeqshtmgsfyplwhlzffnynnhxqhpltbqpfbjwjdbygpnxtbfzjgnnntjshxeawtzylltyqbwjpgxghnnkndjtmszs"
"qynzggnwqtfhclssgmnnnnynzqqxncjdqgzdlfnykljcjllzlmzznnnnsshthxjlzjbbhqjwwycrdhlyqqjbeyfsjhthnrnwjhwp"
"slmssgzttygrqqwrnlalhmjtqjsmxqbjjzjqzyzkxbjqxbjxshzssfglxmxnxfghkzszggslcnnarjxhnlllmzxelglxydjytlfb"
"kbpnlyzfbbhptgjkwetzhkjjxzxxglljlstgshjjyqlqzfkcgnndjsszfdbctwwseqfhqjbsaqtgypjlbxbmmywxgslzhglsgnyf"
"ljbyfdjfngsfmbyzhqffwjsyfyjjphzbyyzffwotjnlmftwlbzgyzqxcdjygzyyryzynyzwegazyhjjlzrthlrmgrjxzclnnnljj"
"yhtbwjybxxbxjjtjteekhwslnnlbsfazpqqbdlqjjtyyqlyzkdksqjnejzldqcgjqnnjsncmrfqthtejmfctyhypymhydmjncfgy"
"yxwshctxrljgjzhzcyyyjltkttntmjlzclzzayyoczlrlbszywjytsjyhbyshfjlykjxxtmzyyltxxypslqyjzyzyypnhmymdyyl"
"blhlsyygqllnjjymsoycbzgdlyxylcqyxtszegxhzglhwbljheyxtwqmakbpqcgyshhegqcmwyywljyjhyyzlljjylhzyhmgsljl"
"jxcjjyclycjbcpzjzjmmwlcjlnqljjjlxyjmlszljqlycmmgcfmmfpqqmfxlqmcffqmmmmhnznfhhjgtthxkhslnchhyqzxtmmqd"
"cydyxyqmyqylddcyaytazdcymdydlzfffmmycqcwzzmabtbyctdmndzggdftypcgqyttssffwbdttqssystwnjhjytsxxylbyyhh"
"whxgzxwznnqzjzjjqjccchykxbzszcnjtllcqxynjnckycynccqnxyewyczdcjycchyjlbtzyycqwlpgpyllgktltlgkgqbgychj"
"xy";


@implementation Utility

char indexTitleOfString(unsigned short string) {
	int index = string - HANZI_START;
	if (index >= 0 && index <= HANZI_COUNT) {
		return toupper(firstLetterArray[index]);
	}
	else if ( (string >= 'a' && string <= 'z') || (string >= 'A' && string <= 'Z') ) {
		return toupper(string);
	} else {
		return '#';
	}
}

//add for search
+ (BOOL)isCharacterChinese:(unichar)ch
{
	if (indexTitleOfString(ch) != '#' && ![Utility isCharacter:ch])
		return YES;
	return NO;
}

+ (BOOL)isCharacter:(unichar)ch {
	return (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z');
}


+ (NSString *)codeOfString:(NSString *)string {
	NSMutableString *code = [NSMutableString string];
	for(int i = 0; i < [string length]; i++) {
		NSString *str = [NSString stringWithFormat:@"%c", indexTitleOfString([string characterAtIndex:i])];
		if([str isEqual:@"#"] && ![self isNumberString:str])
			continue;
		[code appendString:str];
	}
	return code;
}

+ (BOOL)isNumberString:(NSString *)str {
	for(int i = 0; i < [str length]; i++) {
		char ch = [str characterAtIndex:i];
		if(ch < '0' || ch > '9')
			return NO;
	}
	return YES;
}

+ (void)changeNavigation:(UINavigationItem *)navItem Title:(NSString *)title {
    if (navItem && title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.shadowColor = [UIColor grayColor];
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        navItem.titleView = titleLabel;
        [titleLabel release];    
    }
}

+ (void)addButtomShadow:(UIView *)view withOffset:(CGFloat)shadowOffset {
    // shadow path
    UIBezierPath *path = [UIBezierPath bezierPath]; 
    
    CGPoint topLeft = CGPointMake(view.frame.origin.x, CGRectGetHeight(view.bounds)) ; 
    CGPoint bottomLeft = CGPointMake(view.frame.origin.x, CGRectGetHeight(view.bounds)+shadowOffset); 
//    CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(view.bounds) / 2, CGRectGetHeight(view.bounds)); 
    CGPoint bottomRight = CGPointMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)+shadowOffset); 
    CGPoint topRight = CGPointMake(CGRectGetWidth(view.bounds), view.frame.origin.y); 
    
    [path moveToPoint:topLeft]; 
    [path addLineToPoint:bottomLeft]; 
//    [path addQuadCurveToPoint:bottomRight controlPoint:bottomMiddle];
    [path addLineToPoint:bottomRight]; 
    [path addLineToPoint:topRight]; 
    [path closePath]; 
    
    view.layer.shadowPath = path.CGPath;     
//    view.layer.shadowColor = [UIColor whiteColor].CGColor;
    view.layer.shadowOpacity = 0.5; 
}

+ (void)addShadow:(UIView *)view {
    
    // shadow path
    UIBezierPath *path = [UIBezierPath bezierPath]; 
    
    CGPoint topLeft = view.bounds.origin; 
    CGPoint bottomLeft = CGPointMake(0.0, CGRectGetHeight(view.bounds) + 0); 
    CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(view.bounds) / 2, CGRectGetHeight(view.bounds)); 
    CGPoint bottomRight = CGPointMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)); 
    CGPoint topRight = CGPointMake(CGRectGetWidth(view.bounds), 0.0); 
    
    [path moveToPoint:topLeft]; 
    [path addLineToPoint:bottomLeft]; 
    [path addQuadCurveToPoint:bottomRight controlPoint:bottomMiddle];
    [path addLineToPoint:topRight]; 
    [path addLineToPoint:topLeft]; 
    [path closePath]; 
    
    view.layer.shadowPath = path.CGPath; 
    
    //setup shadow
    CALayer *layer = [view layer];
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.5; 
    layer.shouldRasterize = YES;
    layer.masksToBounds = NO;
}

+ (void)addShadowByLayer:(UIView *)view {
    //setup shadow
    CALayer *layer = [view layer];
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowOpacity = 0.5; 
    layer.shouldRasterize = YES;
    layer.masksToBounds = YES;
}

+ (void)addRoundCornerToView:(UIView *)view withRadius:(CGFloat)radius {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *roundedPath = 
    [UIBezierPath bezierPathWithRoundedRect:view.bounds
                          byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerBottomLeft | UIRectCornerTopRight
                                cornerRadii:CGSizeMake(radius, radius)];    
    maskLayer.fillColor = [[UIColor orangeColor] CGColor];
    maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    maskLayer.path = [roundedPath CGPath];
    [view layer].mask = maskLayer;
}

+ (NSString *)item:(NSString *)name descriptionWithCount:(NSInteger)count {
    if (!name) {
        return nil;
    }
    
    NSString *string = nil;
    if (count > 9999) {
        string = [NSString stringWithFormat:@"%@9999+", name];
    } else {
        string = [NSString stringWithFormat:@"%@%d", name,count];
    }
    return string;
}

/**
 格式化时间
 timeSeconds 为0时表示当前时间,可以传入你定义的时间戳
 timeFormatStr为空返回当当时间戳,不为空返回你写的时间格式(yyyy-MM-dd HH:ii:ss)
 setTimeZome ([NSTimeZone systemTimeZone]获得当前时区字符串)
 
 Example:
 NSString *a =[self setTimeInt:1317914496 setTimeFormat:@"yy.MM.dd HH:mm:ss" setTimeZome:nil];
 NSString *b =[self setTimeInt:0 setTimeFormat:@"yy.MM.dd HH:mm:ss" setTimeZome:nil];
 NSString *c =[self setTimeInt:0 setTimeFormat:nil setTimeZome:nil];
 NSString *d =[self setTimeInt:0 setTimeFormat:@"yy.MM.dd HH:mm:ss" setTimeZome:@"GMT"];
 */
+(NSString *)setTimeInt:(NSTimeInterval)timeSeconds setTimeFormat:(NSString *)timeFormatStr setTimeZome:(NSString *)timeZoneStr {
    
    NSString *date_string;
    
    NSDate *time_str;
    if( timeSeconds>0){
        time_str = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    }else{
        time_str= [NSDate date];
    }
    
    if( timeFormatStr==nil){
        date_string =[NSString stringWithFormat:@"%ld",(long)[time_str timeIntervalSince1970]];
    }else{
        
        NSDateFormatter *date_format_str =[[[NSDateFormatter alloc] init] autorelease];
        
        [date_format_str setDateFormat:timeFormatStr];
        
        if( timeZoneStr!=nil){
            
            [date_format_str setTimeZone:[NSTimeZone timeZoneWithName:timeZoneStr]];
        }
        date_string =[date_format_str stringFromDate:time_str];
    }
    
    return date_string;
}

+ (NSString *)date:(NSDate *)date descriptorWithFormate:(NSString *)dateFormat {
    NSString *dateString = nil;
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setTimeZone:tzGMT];
    [format setDateFormat:dateFormat];

    dateString = [format stringFromDate:date];
    
    return dateString;
}
// 将某一个时刻到现在的时间间隔转换成更加直观的时间表示
/*
 刚刚
1小时前
2小时前
3小时前
...
23小时前


1天前
2天前
3天前

从4天开始，直接显示日期，不显示具体分钟数

6月23
8月12
9月13
 */
+ (NSString *)desForDateInterval2:(NSString *)dateString {
    if (dateString == nil) {
        return nil;
    }
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setTimeZone:tzGMT];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *parsedDate = [format dateFromString:dateString];
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:parsedDate];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //    NSInteger year = timeInterval / 3600 / 24 / 365;
    //    NSInteger month = timeInterval / 3600 / 24 / 30;
    //    NSInteger week = timeInterval / 3600 / 24 / 7;
    NSInteger day = timeInterval / 3600 / 24;
    NSInteger hour = timeInterval / 3600;
//    NSInteger minute = ((int)timeInterval % 3600) / 60;
    
    if (timeInterval < 0) {
        NSString *finalDate = [format stringFromDate:parsedDate];   
        return finalDate;
    }
    
    if (day >= 4) {
        NSArray *compareTimeArray = [dateString componentsSeparatedByString:@" "];
        if (compareTimeArray == nil || compareTimeArray.count < 1) {
            return nil;
        }
        NSString *dateString = [compareTimeArray objectAtIndex:0];
        NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
        if (dateArray == nil || dateArray.count != 3) {
            return nil;
        }
//        NSString *yearStr = [dateArray objectAtIndex:0];
//        int compareYear = [yearStr intValue];
        NSString *monthStr = [dateArray objectAtIndex:1];
//        int compareMonth = [monthStr intValue];
        NSString *dayStr = [dateArray objectAtIndex:2];
//        int compareDay = [dayStr intValue];
        return [NSString stringWithFormat:@"%@月%@", monthStr,dayStr];
    }
    if (day >= 1 && day < 4) {
        return [NSString stringWithFormat:@"%d天前", day];
    }
    if (hour >= 1 && hour < 24) {
        NSString *finalDate = [NSString stringWithFormat:@"%d小时前", hour];
        
        return finalDate;
    }
    
    if (hour < 1) {
        return @"刚刚";
    }
    
    return nil;
}
+ (NSString *)desForDateInterval:(NSString *)dateString {
    if (dateString == nil) {
        return nil;
    }
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setTimeZone:tzGMT];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *parsedDate = [format dateFromString:dateString];
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:parsedDate];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
//    NSInteger year = timeInterval / 3600 / 24 / 365;
    //    NSInteger month = timeInterval / 3600 / 24 / 30;
    //    NSInteger week = timeInterval / 3600 / 24 / 7;
    NSInteger day = timeInterval / 3600 / 24;
    NSInteger hour = timeInterval / 3600;
    NSInteger minute = ((int)timeInterval % 3600) / 60;
    NSInteger second = ((int)timeInterval % 3600) % 60;
    
    if (timeInterval < 0) {
        NSString *finalDate = [format stringFromDate:parsedDate];   
        return finalDate;
    }
    
//    if (year >= 1) {
//        
//        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
//        [format setTimeZone:tzGMT];
//        [format setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateString = [format stringFromDate:parsedDate];
//        return dateString;
//    }
    
    if (day >= 1) {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        [format setDateFormat:@"HH:mm"];
        [format setTimeZone:tzGMT];
        NSString *dateString = [format stringFromDate:parsedDate];
        return dateString;
    }
    
    if (hour >= 1 && hour <= 24) {
        NSString *finalDate = [NSString stringWithFormat:@"%d小时前", hour];
        
        return finalDate;
    }
    
    if (minute >= 1 && minute <= 60) {
        NSString *finalDate = [NSString stringWithFormat:@"%d分钟前", minute];
        
        return finalDate;
    }
    
    if (second >= 30 && second <= 60) {
        NSString *finalDate = [NSString stringWithFormat:@"%d秒前", second];
        
        return finalDate;
    }
    
    if (second >= 0 && second < 30) {
        return @"刚刚";
    }
    
    return nil;
}

/*
 *  刚刚（30分钟以内）
 *  半小时前
 *  1小时前
 *  具体时间
 */
+ (NSString *)descriptionForDateInterval:(NSString *)dateString {
    if (dateString == nil) {
        return nil;
    }
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];

    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setTimeZone:tzGMT];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *parsedDate = [format dateFromString:dateString];
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:parsedDate];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSInteger year = timeInterval / 3600 / 24 / 365;
//    NSInteger month = timeInterval / 3600 / 24 / 30;
//    NSInteger week = timeInterval / 3600 / 24 / 7;
    NSInteger day = timeInterval / 3600 / 24;
    NSInteger hour = timeInterval / 3600;
    NSInteger minute = ((int)timeInterval % 3600) / 60;
//    NSInteger second = ((int)timeInterval % 3600) % 60;
    
    if (timeInterval < 0) {
        NSString *finalDate = [format stringFromDate:parsedDate];   
        return finalDate;
    }
    
    if (year >= 1 || day >= 1 || hour >= 2) {
        return dateString;
    }
    
    if (hour >= 1 && hour < 2) {
        NSString *finalDate = @"1小时前";

        return finalDate;
    }
    
    if (minute > 30 && minute <= 60) {
        NSString *finalDate = @"半小时前";
        
        return finalDate;
    }
    
    if (minute <= 30) {
        NSString *finalDate = @"刚刚";

        return finalDate;
    }
    
    return nil;
}

+ (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)formatString {
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setTimeZone:tzGMT];
    if (formatString && [formatString length]>0) {
        [format setDateFormat:formatString];
    }else {
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *parsedDate = [format dateFromString:dateString];
    return parsedDate;
}

// Seconds per day (24h * 60m * 60s)
#define kSecondsPerDay 86400.0f
+ (BOOL)isSameDayBetween:(NSDate*)aDate with:(NSDate*)bDate {
    // Split aDate into components
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) 
                                           fromDate:aDate];
    
    // Set to this morning 00:00:00
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate* theMidnightHour = [gregorian dateFromComponents:comps];
    [gregorian release];
    
    // Get time difference (in seconds) between date and then
    NSTimeInterval diff = [bDate timeIntervalSinceDate:theMidnightHour];
    return ( diff>=0.0f && diff<kSecondsPerDay );
}

+ (NSString*)dayDescriptionFromNow:(NSDate*)theDate {
    // Split aDate into components
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) 
                                           fromDate:[NSDate date]];
    
    // Set to this morning 00:00:00
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate* theMidnightHour = [gregorian dateFromComponents:comps];
    [gregorian release];
    
    // Get time difference (in seconds) between date and then
    NSTimeInterval diff = [theDate timeIntervalSinceDate:theMidnightHour];
    
    if (diff>=0.0f && diff<kSecondsPerDay) {
        return @"今天";
    }else if ( diff>=kSecondsPerDay && diff<2*kSecondsPerDay ){
        return @"昨天";
    }else {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:theDate];
        return [NSString stringWithFormat:@"%d月%@日",[[[dateString componentsSeparatedByString:@"-"] objectAtIndex:1] intValue],[[dateString componentsSeparatedByString:@"-"] objectAtIndex:2]];
    }
}

+ (NSString*)weekdayForDate:(NSDate*)theDate {
    NSString* weekDayString; 
    
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:theDate]; 
    int weekday = [weekdayComponents weekday];
    
    switch (weekday) {
        case 1:
            weekDayString = @"星期日";
            break;
            
        case 2:
            weekDayString = @"星期一";
            break;
            
        case 3:
            weekDayString = @"星期二";
            break;
            
        case 4:
            weekDayString = @"星期三";
            break;
            
        case 5:
            weekDayString = @"星期四";
            break;
            
        case 6:
            weekDayString = @"星期五";
            break;
            
        case 7:
            weekDayString = @"星期六";
            break;
            
        default:
            return nil;
            break;
    }
    
    return weekDayString;
}

+ (void)addBorderColor:(UIView *)view  {
    CALayer *layer = [view layer];
    layer.borderColor = [[UIColor orangeColor] CGColor];
    [layer setBorderWidth:3.0f];
}

+ (void)addBorderColor:(UIView *)view withColor:(UIColor *)color width:(CGFloat)width {
	CALayer *layer = [view layer];
    layer.borderColor = [color CGColor];
    [layer setBorderWidth:width];
}

+ (void)clearBorderColor:(UIView *)view {
    CALayer *layer = [view layer];
    layer.borderColor = [[UIColor blackColor] CGColor];
    [layer setBorderWidth:0.0f];
    
}

+ (CGFloat)getFloatRandom {
    return (float)(1+arc4random()% 99)/100;
}

// 从0到(max-1)之间的随机整数
+ (NSInteger)getIntegerRandomWithInMax:(NSInteger)max {
	NSInteger random = 0;
	while (random == 0) {
		random = (arc4random() % (max+1));
	}
    random = random - 1;
    return random;
}

+ (void)doAnimationFromLeft:(BOOL)leftDir
                   delegate:(id)_delegate 
                       view:(UIView *)transView 
                   duration:(CGFloat)duration {
    
    UIView *currentView = transView;
	UIView *theWindow = [currentView superview];
	
	[currentView removeFromSuperview];
	[theWindow addSubview:currentView];
	
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setDuration:0.3];
	[animation setType:kCATransitionPush];
	[animation setSubtype:(leftDir?kCATransitionFromLeft:kCATransitionFromRight)];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[animation setValue:@"sliding" forKey:@"LeheAnimation"];
	[[theWindow layer] addAnimation:animation forKey:nil];
    
//	[self clear];
//    CATransition *transition = [CATransition animation];
//    transition.duration = duration;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    transition.delegate = _delegate;
//    transition.type = kCATransitionPush;
//    transition.subtype = (leftDir ? kCATransitionFromLeft : kCATransitionFromRight);
//    [transView.layer addAnimation:transition forKey:nil];    
}

+ (UIAlertView *)startWebViewMaskWithMessage:(NSString *)_message  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:_message
                                                    delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [alert addSubview:progress];
    [progress release];
    [progress startAnimating];
    [alert show];
    return [alert autorelease]; 
}

+ (void)disMissMaskView:(UIAlertView **)_alertView {
    if (*_alertView != nil) {
        [*_alertView dismissWithClickedButtonIndex:0 animated:YES];
        [*_alertView release];
        *_alertView = nil;
    }
}

+ (NSMutableString *)URLStringMakeWithDict:(NSDictionary *)dict {
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendFormat:@"http://www.lehe.com/lehe/api_call.php?"];
    int i = 0;
    for (NSString *key in dict) {
        if (i == 0) {
            [urlString appendFormat:@"%@=%@", key, [dict objectForKey:key]];
        } else {
            [urlString appendFormat:@"&%@=%@",key, [dict objectForKey:key]];
        }
        i++;
    }
    return urlString;
}


+ (void)setWebView:(UIWebView *)webView withId:(NSInteger)webId {
    NSString *jsString = [NSString stringWithFormat:@"javascript:eval(setContext(%d))",webId];
    [webView stringByEvaluatingJavaScriptFromString:jsString];  
}


+ (void)chageStandardFile:(NSString *)srcPath toAppleFile:(NSString *)desPath {
    
    NSMutableData *appleIlbcHeaderData = [NSMutableData dataWithContentsOfFile:HEADER_FILEPATH];
    
    NSMutableData *appleILBC = [NSMutableData data];
    //添加头
    [appleILBC appendData:appleIlbcHeaderData];
    
    //添加body,用于计算音频数据段长度
    NSData *bodyData = [NSData dataWithContentsOfFile:srcPath];
    
    //添加长度
    int length = 0;
    length = 1 + [bodyData length];
    length = ntohl(length);
    [appleILBC appendBytes:&length length:4];
    
    //添加flag
    int flagBytes = 1;
    flagBytes = ntohl(flagBytes);
    [appleILBC appendBytes:&flagBytes length:4];
    
    //添加body
    [appleILBC appendData:bodyData];
    
    [appleILBC writeToFile:desPath atomically:NO];
}

+ (NSString*)getRecordFilename:(NSString*)urlString {

	if ([urlString hasSuffix:@".ilbc"])
	{
		NSString* filename = [urlString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		NSInteger find = 0;
		while (YES) {
			find = ([filename rangeOfString:@"/"]).location;
			if(find != NSNotFound)
				filename = [filename substringFromIndex:(find+1)];
			else
				break;
		}
		return filename;
	}
	else {
		return @"";
	}

}

+ (BOOL)isValidLatLon:(double)lat Lon:(double)lon {

	if (lat>-90.0f && lat<90.0f && lon>-180.0f && lon<180.0f && lat!=0.0f && lon!=0.0f) {
		return YES;
	}
	
	return NO;
}

+ (NSString*)getPhotoDownloadURL:(NSString*)currentURLString sizeType:(NSString*)sizetype {
    
    if (currentURLString == nil) {
        return nil;
    }
    
	NSRange range;
	int location = 0;
	currentURLString = [currentURLString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
	NSMutableString* resultURL = [[[NSMutableString alloc] initWithString:currentURLString] autorelease];
	
	if ([sizetype caseInsensitiveCompare:@"large"] == NSOrderedSame) {			// To: large
		
		// small -> large 
		range = [resultURL rangeOfString:@"/small/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/large/"];
		
		// normal -> large
		range = [resultURL rangeOfString:@"/normal/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/large/"];
		
	} else if ([sizetype caseInsensitiveCompare:@"normal"] == NSOrderedSame) {	// To: normal
		
		// small -> normal 
		range = [resultURL rangeOfString:@"/small/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/normal/"];
		
		// large -> normal
		range = [resultURL rangeOfString:@"/large/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/normal/"];
		
		
	} else if ([sizetype caseInsensitiveCompare:@"small"] == NSOrderedSame) {	// To: samll
		
		// normal -> small 
		range = [resultURL rangeOfString:@"/normal/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/small/"];
		
		// large -> small
		range = [resultURL rangeOfString:@"/large/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/small/"];
		
	}else if ([sizetype caseInsensitiveCompare:@"orig"] == NSOrderedSame) {	// To: samll
		
        // small -> orig
		range = [resultURL rangeOfString:@"/small/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/orig/"];
        
		// normal -> orig
		range = [resultURL rangeOfString:@"/normal/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/orig/"];
		
		// large -> orig
		range = [resultURL rangeOfString:@"/large/"];
		location = range.location;
		if (location != NSNotFound)
			[resultURL replaceCharactersInRange:range withString:@"/orig/"];
		
	}
    
    
    
    
	
	return resultURL;
}

+ (NSMutableDictionary *)datasourceFromListArray:(NSArray *)array {
    NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in array) {
        NSString *name = [dict objectForKey:@"name"];
        if (name && [name length] > 0) {
            if ([Utility isCharacter:[name characterAtIndex:0]] || [Utility isCharacterChinese:[name characterAtIndex:0]]) {
                NSString *codeOfString = [Utility codeOfString:name];
                NSString *firstLetter = [NSString stringWithFormat:@"%C", [codeOfString characterAtIndex:0]];
                
                NSMutableArray *array = [finalDict objectForKey:firstLetter];
                if (array == nil) {
                    array = [NSMutableArray array];
                    [finalDict setObject:array forKey:firstLetter];
                }
                [array addObject:dict];
            } else {
                NSMutableArray *arrayForUnkown = [finalDict objectForKey:@"#"];
                if (arrayForUnkown == nil) {
                    arrayForUnkown = [NSMutableArray array];
                    [finalDict setObject:arrayForUnkown forKey:@"#"];
                }
                [arrayForUnkown addObject:dict];
            }
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" 
                                                               ascending:YES 
                                                                selector:@selector(localizedCompare:)];
    for (NSString *key in [finalDict allKeys]) {
        NSMutableArray *array = [finalDict objectForKey:key];
        [array sortUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    }    
    [descriptor release];    
    
    return finalDict;
}

+ (void)popModalsToRootFrom:(UIViewController*)aVc {
    if(aVc.parentViewController == nil) {
        return;
    }
    else {
        [Utility popModalsToRootFrom:aVc.parentViewController];  // recursive call to this method
        [aVc.parentViewController dismissModalViewControllerAnimated:NO];
    }
}
 
+ (NSString *)descriptionForDistance:(NSInteger)distance {
	if (distance == 0) {
		return @"身边";
	}
	
    if (distance > 0 && distance < 1000) {
        return [NSString stringWithFormat:@"%d米", distance];
    }
    if (distance >= 1000 && distance < 1000*100) {
        CGFloat newDistance = distance/1000.0;
        return [NSString stringWithFormat:@"%0.1f公里", newDistance];
    }
    if (distance >= 100*1000 && distance < 1000*1000) {
//        NSInteger distance = (NSInteger)(distance/1000.0);
        return [NSString stringWithFormat:@"百里外"];
    }
    if (distance >= 1000*1000) {
        return [NSString stringWithFormat:@"千里外"];
    }
    return nil;
}

+ (double)distanceFromPoint:(GPoint)point1 toPoint:(GPoint)point2 {
    CLLocation *location1 = [[[CLLocation alloc] initWithLatitude:point1.lat longitude:point1.lon] autorelease];  
    CLLocation *location2 = [[[CLLocation alloc] initWithLatitude:point2.lat longitude:point2.lon] autorelease];  
    return [location1 distanceFromLocation:location2];  
}

+ (NSDictionary *)intervalForDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:tzGMT];
    NSInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | 
    NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags 
                                           fromDate:fromDate  
                                             toDate:toDate options:0];
    [gregorian release];

    NSMutableDictionary *dateDict = [NSMutableDictionary dictionary];
    [dateDict setObject:[NSNumber numberWithInt:[comps hour]] forKey:@"hour"];
    [dateDict setObject:[NSNumber numberWithInt:[comps day]] forKey:@"day"];    
    [dateDict setObject:[NSNumber numberWithInt:[comps month]] forKey:@"month"];
    [dateDict setObject:[NSNumber numberWithInt:[comps minute]] forKey:@"minute"];
    [dateDict setObject:[NSNumber numberWithInt:[comps second]] forKey:@"second"];
    [dateDict setObject:[NSNumber numberWithInt:[comps year]] forKey:@"year"];
    
    return dateDict;
}

+ (NSDictionary *)parseByDate:(NSDate *)date {
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | 
    NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:tzGMT];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSMutableDictionary *dateDict = [NSMutableDictionary dictionary];
    [dateDict setObject:[NSNumber numberWithInt:[comps hour]] forKey:@"hour"];
    [dateDict setObject:[NSNumber numberWithInt:[comps day]] forKey:@"day"];    
    [dateDict setObject:[NSNumber numberWithInt:[comps month]] forKey:@"month"];
    [dateDict setObject:[NSNumber numberWithInt:[comps minute]] forKey:@"minute"];
    [dateDict setObject:[NSNumber numberWithInt:[comps second]] forKey:@"second"];
    [dateDict setObject:[NSNumber numberWithInt:[comps year]] forKey:@"year"];
    [calendar release];
    return dateDict;
}

#pragma mark DES & BASE64

//data是需要加密或解密的数据，keyString 是密码（一般是8位），op表示加密/解密(kCCEncrypt/kCCDecrypt)
+ (NSData *)desData:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op
{
    char buffer [1024] ;
    memset(buffer, 0, sizeof(buffer));
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus = CCCrypt(op, 
                                          
                                          kCCAlgorithmDES, 
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          [keyString UTF8String], 
                                          
                                          kCCKeySizeDES,
                                          
                                          NULL, 
                                          
                                          [data bytes], 
                                          
                                          [data length],
                                          
                                          buffer, 
                                          
                                          1024,
                                          
                                          &bufferNumBytes);
    if(cryptStatus == kCCSuccess)
    {
        NSData *returnData =  [NSData dataWithBytes:buffer length:bufferNumBytes];
        return returnData;
		//        NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]autorelease];
    }
    return nil;
    
}

static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)newStringInBase64FromData:(NSData *)data           //追加64编码
{
	
    NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
    unsigned char * working = (unsigned char *)[data bytes];
    int srcLen = [data length];
	
    for (int i=0; i<srcLen; i += 3) {
		
        for (int nib=0; nib<4; nib++) {
			
            int byt = (nib == 0)?0:nib-1;
			
            int ix = (nib+1)*2;
			
            if (i+byt >= srcLen) break;
			
            unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);
			
            if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);
			
            [dest appendFormat:@"%c", base64[curr]];
			
        }
		
    }
	
    return dest;
}


+ (NSString*)base64encode:(NSString*)str
{
	
    if ([str length] == 0)
		
        return @"";
	
    const char *source = [str UTF8String];
	
    int strlength  = strlen(source);
	
    char *characters = malloc(((strlength + 2) / 3) * 4);
	
    if (characters == NULL)
		
        return nil;
	
    NSUInteger length = 0;
	
    NSUInteger i = 0;
	
    while (i < strlength) {
		
        char buffer[3] = {0,0,0};
		
        short bufferLength = 0;
		
        while (bufferLength < 3 && i < strlength)
			
            buffer[bufferLength++] = source[i++];
		
        characters[length++] = base64[(buffer[0] & 0xFC) >> 2];
		
        characters[length++] = base64[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		
        if (bufferLength > 1)
			
            characters[length++] = base64[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		
        else characters[length++] = '=';
		
        if (bufferLength > 2)
			
            characters[length++] = base64[buffer[2] & 0x3F];
		
        else characters[length++] = '=';
		
    }
	
    NSString *g = [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
	
    return g;
	
}

//Example:
//NSData* decodeData = [Utility Base64DecodeString:@"MTE2LjQ2NTI4NjY2ODUx"];
//NSString* decode = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
+(NSData *)Base64DecodeString:(NSString *)string {
	NSData *result = nil;
	NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
	if (data) {
		result = [Utility base64Decode:[data bytes]
						   length:[data length]];
	}
	return result;
}

+(NSData *)base64Decode:(const void *)bytes
               length:(NSUInteger)length {
	// could try to calculate what it will end up as
	NSUInteger maxLength = (length + 3) / 4 * 3;
	// make space
	NSMutableData *result = [NSMutableData data];
	[result setLength:maxLength];
	// do it
    NSUInteger finalLength = base64Decode(bytes,length,[result mutableBytes],[result length],0);
	if (finalLength) {
		if (finalLength != maxLength) {
			// resize down to how big it was
			[result setLength:finalLength];
		}
	} else {
		// either an error in the args, or we ran out of space
		result = nil;
	}
	return result;
}

unsigned long base64Decode(const unsigned char *str, unsigned long length, unsigned char *pdest, unsigned long psize, int strict)
{
    static const char base64_pad = '=';
    static const short base64_reverse_table[256] = {
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -2, -1, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
        -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
        -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
        -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
    };
    const unsigned char *current = str;
    int ch, i = 0, j = 0, k;
    
    unsigned char *result = pdest;
    //result = (unsigned char *)malloc(length + 1);
    
    while ((ch = *current++) != '\0' && length-- > 0) {
        if (ch == base64_pad) {
            if (*current != '=' && (i % 4) == 1) {
                free(result);
                return 0;
            }
            continue;
        }
        
        ch = base64_reverse_table[ch];
        if ((!strict && ch < 0) || ch == -1) {
            continue;
        } else if (ch == -2) {
            free(result);
            return 0;
        }
        
        switch(i % 4) {
            case 0:
                result[j] = ch << 2;
                break;
            case 1:
                result[j++] |= ch >> 4;
                result[j] = (ch & 0x0f) << 4;
                break;
            case 2:
                result[j++] |= ch >>2;
                result[j] = (ch & 0x03) << 6;
                break;
            case 3:
                result[j++] |= ch;
                break;
        }
        i++;
    }
    
    k = j;
    
    if (ch == base64_pad) {
        switch(i % 4) {
            case 1:
                free(result);
                return 0;
            case 2:
                k++;
            case 3:
                result[k++] = 0;
        }
    }
    
    result[j] = '\0';
    
    return j;
}

#pragma mark - URLDecode
+(NSData *)URLDecodeString:(NSString *)string {
	NSData *result = nil;
	NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
	if (data) {
		result = [Utility base64Decode:[data bytes]
                                length:[data length]];
	}
	return result;
}

+(NSData *)urlDecode:(const void *)bytes
                 length:(NSUInteger)length {
	// make space
	NSMutableData *result = [NSMutableData data];
	[result setLength:length];
	// do it
    NSUInteger finalLength = URLDecode((char*)bytes,length);
	if (finalLength) {
		if (finalLength != length) {
			// resize down to how big it was
			[result setLength:finalLength];
		}
	} else {
		// either an error in the args, or we ran out of space
		result = nil;
	}
	return result;
}

/**
 * @param str 需要解码的url字符串
 * @param len 需要解码的url的长度
 * @return int 返回解码后的url长度
 */
int URLDecode(char *str, int len)
{
    char *dest = str;
    char *data = str;
    
    int value;
    int c;
    
    while (len--) {
        if (*data == '+') {
            *dest = ' ';
        }
        else if (*data == '%' && len >= 2 && isxdigit((int) *(data + 1))
                 && isxdigit((int) *(data + 2)))
        {
            
            c = ((unsigned char *)(data+1))[0];
            if (isupper(c))
                c = tolower(c);
            value = (c >= '0' && c <= '9' ? c - '0' : c - 'a' + 10) * 16;
            c = ((unsigned char *)(data+1))[1];
            if (isupper(c))
                c = tolower(c);
            value += c >= '0' && c <= '9' ? c - '0' : c - 'a' + 10;
            
            *dest = (char)value ;
            data += 2;
            len -= 2;
        } else {
            *dest = *data;
        }
        data++;
        dest++;
    }
    *dest = '\0';
    return dest - str;
}


#pragma mark - URLEncode
+ (NSString *)urlEncode:(const void *)bytes length:(NSUInteger)length {
	NSString* result = nil;
    NSInteger finalLength = 0;
    
    char* charEncode = urlencode((char*)bytes,length,&finalLength);
	if (finalLength) {
		if (finalLength != length) {
			// resize down to how big it was
			result = [[NSString alloc] initWithCString:(const char*)charEncode
                                     encoding:NSUTF8StringEncoding];
		}
	} else {
		// either an error in the args, or we ran out of space
		result = nil;
	}
	return result;
}
/**
 * @param s 需要编码的url字符串
 * @param len 需要编码的url的长度
 * @param new_length 编码后的url的长度
 * @return char * 返回编码后的url
 * @note 存储编码后的url存储在一个新审请的内存中，
 * 用完后，调用者应该释放它
 */
char* urlencode(char const *s, int len, int *new_length)
{
    char const *from, *end;
    from = s;
    end = s + len;
    unsigned char *start, *to;
    start = to = (unsigned char *) malloc(3 * len + 1);
    
    unsigned char hexchars[] = "0123456789ABCDEF";
    unsigned char c;
    while (from < end) {
        c = *from++;
        
        if (c == ' ') {
            *to++ = '+';
        } else if ((c < '0' && c != '-' && c != '.')
                   ||(c < 'A' && c > '9')
                   ||(c > 'Z' && c < 'a' && c != '_')
                   ||(c > 'z')) {
            to[0] = '%';
            to[1] = hexchars[c >> 4];
            to[2] = hexchars[c & 15];
            to += 3;
        } else {
            *to++ = c;
        }
    }
    *to = 0;
    if (new_length) {
        *new_length = to - start;
    }
    return (char *) start;
    
}

+ (BOOL)validateEmail:(NSString*)email{
    
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) )
    {
        NSMutableCharacterSet *invalidCharSet = [[[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy]autorelease];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1) {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2) {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else // no ''@'' or ''.'' present
        return NO;
}


// ---- 用户收藏的图片 相关操作 start ---------
+ (BOOL)saveUserCollectedImageToSandbox:(UIImage*)image imageName:(NSString*)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCollectPics"];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:directory] == NO)
    {
        [[NSFileManager defaultManager]createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
	NSString *filePath = [directory stringByAppendingPathComponent:imageName];   // 保存文件的名称
	BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES 
	
	return result;
}
+ (UIImage*)getUserCollectedImageFromSandbox:(NSString*)imageName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCollectPics"];
	NSString *filePath = [directory stringByAppendingPathComponent:imageName];   // 保存文件的名称
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        return nil;
    }else{
        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
        return img;
    }
}
+ (void)deleteUserCollectedImageFromSandbox:(NSString *)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCollectPics"];
	NSString *filePath = [directory stringByAppendingPathComponent:imageName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    }
}
// ---- 用户收藏的图片 相关操作 end ---------

+ (BOOL)saveImageToSandbox:(UIImage*)image imageName:(NSString*)imageName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];   // 保存文件的名称
	BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES 
	
	return result;
}

+ (UIImage*)getImageFromSandbox:(NSString*)imageName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];   // 保存文件的名称
	UIImage *img = [UIImage imageWithContentsOfFile:filePath]; 
	
	return img;
}

+ (void)deleteImageFromSandbox:(NSString*)imageName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];   // 保存文件的名称
	if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    }
}

+ (UIImage *)saveScreen:(UIView*)subView {
    
    CGSize pixelSizeOfImage = subView.frame.size;
    
    //支持retina高分辨率
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(pixelSizeOfImage, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(pixelSizeOfImage);
    }            
    
    //获取图像
    [subView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSMutableArray*)groupByDate:(NSArray*)jsonBlocks timeKey:(NSString*)timeKey {
    NSMutableArray* dataSourceArray = [NSMutableArray array];
    
    if (jsonBlocks && [jsonBlocks count] > 0) {
        
        NSDate* lastProcessedTime = [NSDate date];
        NSMutableDictionary* oneGroupDict = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray* oneGroupArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < [jsonBlocks count]; i++) {
            NSDictionary *oneBlock = [jsonBlocks objectAtIndex:i];
            NSString* timeString = [oneBlock objectForKey:timeKey];
            NSDate* dateForCurrentBlock = [Utility dateFromString:timeString withFormat:nil];
            
            BOOL isSameDay = [Utility isSameDayBetween:dateForCurrentBlock with:lastProcessedTime];
            if (!isSameDay) {//非同一天,增加一天
                
                if (0 == i) {
                    [oneGroupArray addObject:oneBlock];
                    lastProcessedTime = dateForCurrentBlock;
                    continue;
                }
                
                //生成分组字典
                if (oneGroupArray && [oneGroupArray count]>0) {
                    NSString* firstTimeString = [[oneGroupArray objectAtIndex:0] objectForKey:timeKey];
                    NSDate* dateForFirstBlock = [Utility dateFromString:firstTimeString withFormat:nil];
                    NSString* dayName = [Utility dayDescriptionFromNow:dateForFirstBlock];
                    [oneGroupDict setObject:dayName forKey:@"day"];
                    
                    NSString* weekdayName = [Utility weekdayForDate:dateForFirstBlock];
                    [oneGroupDict setObject:weekdayName forKey:@"weekday"];
                    
                    [oneGroupDict setObject:oneGroupArray forKey:@"items"];
                    
                    [dataSourceArray addObject:oneGroupDict];
                }
                
                oneGroupDict = [[[NSMutableDictionary alloc] init] autorelease];
                oneGroupArray = [[[NSMutableArray alloc] init] autorelease];
                
                [oneGroupArray addObject:oneBlock];
                
            } else {        //同一天
                
                [oneGroupArray addObject:oneBlock];
            }
            
            lastProcessedTime = dateForCurrentBlock;
        }
        
        //剩余部分生成分组字典
        if (oneGroupArray && [oneGroupArray count]>0) {
            NSString* firstTimeString = [[oneGroupArray objectAtIndex:0] objectForKey:timeKey];
            NSDate* dateForFirstBlock = [Utility dateFromString:firstTimeString withFormat:nil];
            NSString* dayName = [Utility dayDescriptionFromNow:dateForFirstBlock];
            [oneGroupDict setObject:dayName forKey:@"day"];
            
            NSString* weekdayName = [Utility weekdayForDate:dateForFirstBlock];
            [oneGroupDict setObject:weekdayName forKey:@"weekday"];
            
            [oneGroupDict setObject:oneGroupArray forKey:@"items"];
            
            [dataSourceArray addObject:oneGroupDict];
        }
        
    } else {
        return nil;
    }
    
    
    return dataSourceArray;
}


+ (NSString*)iconFilenameByFirstIndex:(NSInteger)firstIndex SecondIndex:(NSInteger)secondIndex {
    return [NSString stringWithFormat:@"icon_%2d_%2d.png",firstIndex,secondIndex];
}


//////////////////////////////////////////////////////
//设置cookie
+ (void)setCookie:(NSDictionary*)cookieProperties {
    
    NSMutableDictionary *cookiePropertiesDictionary = [NSMutableDictionary dictionaryWithDictionary:cookieProperties];
    
//    // set expiration to one month from now or any NSDate of your choosing
//    // this makes the cookie sessionless and it will persist across web sessions and app launches
//    /// if you want the cookie to be destroyed when your app exits, don't set this
//    [cookiePropertiesDictionary setObject:[[NSDate date] dateByAddingTimeInterval:CGFLOAT_MAX] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieData = [NSHTTPCookie cookieWithProperties:cookiePropertiesDictionary];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieData];
}

//清除cookie
+ (void)deleteCookieForURL:(NSString*)urlstr {
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookieAry = [cookieJar cookiesForURL: [NSURL URLWithString:urlstr]];
    
    for (cookie in cookieAry) {
        
        [cookieJar deleteCookie: cookie];
        
    }
}

// 保存Archiver数据到本地
+ (BOOL)SetLocalData:(NSString *)dataFile dataObject:(NSMutableDictionary *)dataObject {
    // 设置路径,并保存
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *saveFile = [savePath stringByAppendingPathComponent:dataFile]; [NSKeyedArchiver archiveRootObject:dataObject toFile:saveFile];
    return YES;
}
// 读取本地保存的Archiver数据
+ (NSMutableDictionary *)GetLocalData:(NSString *)dataFile {
    // 按文件名来读取数据
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *saveFile = [savePath stringByAppendingPathComponent:dataFile]; return [NSKeyedUnarchiver unarchiveObjectWithFile: saveFile];
}

#pragma mark URL解析
+ (NSMutableDictionary*)urlParser:(NSString*)urlString appScheme:(NSString*)appScheme {
    NSMutableDictionary* urlDict = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([appScheme length]>0 && [urlString hasPrefix:appScheme]) {
        // 对 APPLICATION_SCHEME 进行解析
        
        NSString* operationString = [urlString stringByReplacingOccurrencesOfString:appScheme withString:@""];
        
        NSArray* operationArray = [operationString componentsSeparatedByString:@"?"];
        if (operationArray && [operationArray count]>0) {
            NSString* operationName = [operationArray objectAtIndex:0];
            [urlDict setObject:operationName forKey:@"m"];
            
            if ([operationArray count]>1) {
                NSString* argumentsString = [operationArray objectAtIndex:1];
                if (argumentsString && [argumentsString length]>0) {
                    NSArray* argumentsArray = [argumentsString componentsSeparatedByString:@"&"];
                    for (int n=0; n<[argumentsArray count]; n++) {
                        NSString* argPairString = [argumentsArray objectAtIndex:n];
                        if (argPairString && [argPairString length]>0) {
                            NSString *argmentName,*argmentValue;
                            NSArray* argPairArray = [argPairString componentsSeparatedByString:@"="];
                            if (argPairArray && [argPairArray count]>0) {
                                argmentName = [argPairArray objectAtIndex:0];
                                if ([operationArray count]>1) {
                                    argmentValue = [argPairArray objectAtIndex:1];
                                }else {
                                    argmentValue = @"";
                                }
                                [urlDict setObject:argmentValue forKey:argmentName];
                            }
                        }
                    }
                }
            }
        }else{
            urlDict = nil;
        }
    }else{
        // 其余的得到key：value值
        NSArray* operationArray = [urlString componentsSeparatedByString:@"?"];
        if (operationArray && [operationArray count] > 1) {
            NSString *paramStr = [operationArray objectAtIndex:1];
            NSArray *paramArray = [paramStr componentsSeparatedByString:@"&"];
            for (NSString *item in paramArray) {
                NSArray *itemArray = [item componentsSeparatedByString:@"="];
                NSString *itemKey = [itemArray objectAtIndex:0];
                NSString *itemValue;
                if ([itemArray count] > 1) {
                    itemValue = [itemArray objectAtIndex:1];
                }else{
                    itemValue = @"";
                }
                
                [urlDict setObject:itemValue forKey:itemKey];
            }
        }else{
            urlDict = nil;
        }
    }
    
    return urlDict;
}

//等比压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)largeImage scaledToSize:(CGSize)smallSize {
    UIImage* smallImage = nil;
    
    if (largeImage) {
        float imageWidth = largeImage.size.width;
        float imageHeight = largeImage.size.height;
        
        CGFloat smallHeight = smallSize.height;
        CGFloat smallWidth = smallSize.width;
        
        if ((imageHeight>imageWidth && (imageWidth > smallWidth || imageHeight > smallHeight)) || (imageWidth>imageHeight && (imageHeight > smallWidth || imageWidth > smallHeight))) {
            float factor = 1;
            CGRect sourceRect,destRect;
            if (largeImage.imageOrientation == UIImageOrientationLeft || largeImage.imageOrientation == UIImageOrientationRight) {
                sourceRect = CGRectMake(0, 0, imageHeight, imageWidth);
            }else{
                sourceRect = CGRectMake(0, 0, imageWidth, imageHeight);
            }
            
            //确定压缩比
            if (imageWidth > smallWidth && imageHeight > smallHeight) {
                //高和宽都超出范围，按两者压缩比大者压缩
                CGFloat factorWidth = smallWidth/imageWidth;
                CGFloat factorHeight = smallHeight/imageHeight;
                if (factorWidth<factorHeight) {
                    destRect = CGRectMake(0, 0, smallWidth, imageHeight*factorWidth);
                }else {
                    destRect = CGRectMake(0, 0, imageWidth*factorHeight, smallHeight);
                }
            }else if (imageWidth > smallWidth) {
                //宽度超出范围，按宽度压缩
                factor = smallWidth/imageWidth;
                destRect = CGRectMake(0, 0, smallWidth, imageHeight*factor);
            }else {//(imageHeight > smallHeight)
                //高度超出范围，按高度压缩
                factor = smallHeight/imageHeight;
                destRect = CGRectMake(0, 0, imageWidth*factor, smallHeight);
            }
            
            //压缩
            UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 1.0); // 0.0 for scale means "correct scale for device's main screen".
            CGImageRef sourceImg = CGImageCreateWithImageInRect([largeImage CGImage], sourceRect); // cropping happens here.
            smallImage = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:largeImage.imageOrientation]; // create cropped UIImage.
            [smallImage drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
            CGImageRelease(sourceImg);
            smallImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }else{
            smallImage = largeImage;
        }
    }
    
    return smallImage;
}

#pragma mark - 从url中截取图片SN
+ (NSString*)getImageSNFromUrl:(NSString*)urlString {
    
    NSString *imageSN = nil;
    
    urlString = [urlString removeSpaceAndNewLine];
	if ([urlString length]>0) {
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSArray* splitArray = [urlString componentsSeparatedByString:@"."];
        if ([splitArray count]>1) {
            urlString = [splitArray objectAtIndex:0];
        }
        
        imageSN = urlString;
		NSInteger find = 0;
		while (YES) {
			find = ([imageSN rangeOfString:@"/"]).location;
			if(find != NSNotFound)
				imageSN = [imageSN substringFromIndex:(find+1)];
			else
				break;
		}
	}
    
    return imageSN;
    
}

+ (NSString*)generateRequestSign:(NSString*)requestString partnerKey:(NSString*)partnerKey {
    NSString* sign = @"";
    NSString* sortedString = @"";
    
    requestString = [requestString stringByReplacingOccurrencesOfString:apiHost withString:@""];
//    requestString = [requestString stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    NSArray* paramsArray = [requestString componentsSeparatedByString:@"&"];
    if (paramsArray && [paramsArray count]>0) {
        //排序参数数组
        NSArray *sortedArray = [paramsArray sortedArrayUsingComparator:^(id obj1, id obj2) {
            
//            NSComparisonResult result = [obj1_Date compare:obj2];
//            return result == NSOrderedDescending;  // 升序
            
            return [obj1 compare:obj2];
        }];
        
        NSLog(@"sortedArray:%@",sortedArray);
        
        for (int n=0; n<[sortedArray count]; n++) {
            sortedString = [NSString stringWithFormat:@"%@%@",sortedString,[sortedArray objectAtIndex:n]];
        }
        
        sortedString = [NSString stringWithFormat:@"%@%@",sortedString,partnerKey];
        
        sign = [sortedString md5];
    }
    
    return sign;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    CGFloat alpha = 1.0f;
    if ([cString length] == 8) {
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *alphaString = [cString substringWithRange:range];
        cString = [cString substringFromIndex:2];
        
        unsigned int alphaInt;
        [[NSScanner scannerWithString:alphaString] scanHexInt:&alphaInt];
        alpha = (float)alphaInt / 255.0f;
    }
    
    
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (NSString *)replaceUnicodeToiOSText:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF16StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    //DMLog(@"Output = %@", returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

//判断某个点是否在某个区域里
+ (BOOL)isPointInRect:(CGPoint)p rect:(CGRect)rect
{
    CGFloat rectX = rect.origin.x;
    CGFloat rectY = rect.origin.y;
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    
    CGFloat pX = p.x;
    CGFloat pY = p.y;
    
    if(pX < rectX
       ||(pX > rectX + rectWidth)
       || pY < rectY
       || pY > rectY + rectHeight)
    {
        return FALSE;
    }
    
    return TRUE;
}

//截取部分图像
+ (UIImage*)getSubImage:(UIImage*)originalImage forRect:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, rect);
	CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
	
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
	
    return smallImage;
}

@end
