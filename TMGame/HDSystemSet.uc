//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSystemSet extends Object
native(HDGame);

enum EGraphicsLevel
{
  GL_UNKNOWN,
  GL_LOW,
  GL_MID,
  GL_HIGH
};

var int             ResX;
var int             ResY;
var bool            bFullScreen;
var float           Gamma; //Brightness, 1.0~3.0(2.2 is default)
var EGraphicsLevel  GraphLevel;

final native function CommitGraphicsSet();
final native function GetCurGraphicsSet();

final native function GetPossibleScreenResolutions(out array<string> OutResults);


