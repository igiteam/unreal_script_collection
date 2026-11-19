//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGfxAction_BlackAll extends SequenceAction
      native(HDSequence)
      dependsOn(HDGFxBlackAllHud);

var HDGFxBlackAllHud HDGFxBah;

/** Text you want to show on screen,random array*/
var() array<String> ShowText;

var float FontSize;

/** Time to Text display out*/
var() float TextTime;

/** Time to Balck BG display out*/
var() float BackGroundTime;

/** Total Time*/
var() float TotalTime;

/** If true unload self when time up*/
var() Bool autoUnload;
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
event Activated()
{

HDGFxBah = new class'HDGFxBlackAllHud';
HDGFxBah.Start();
HDGFxBah.StringT   = ShowText ;
HDGFxBah.FontSize  = FontSize;
HDGFxBah.ttime     = TextTime;
HDGFxBah.bgtime    = BackGroundTime;
HDGFxBah.totaltime = TotalTime;
HDGFxBah.bAutoUnload= autoUnload;
HDGFxBah.SetS();

    if(InputLinks[0].bHasImpulse)
    {
    HDGFxBah.ShowStartGame();
    }
    else
    {
    HDGFxBah.ShowEndGame();
    }
    OutputLinks[0].bHasImpulse = true;
}

    event CleanUp()
    {
    HDGFxBah.Close();
    }
