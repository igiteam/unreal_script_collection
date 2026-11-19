//-----------------------------------------------------------
// HDGFxMilitary.uc
//-----------------------------------------------------------
class HDGFxMilitary extends GFxMoviePlayer;

var GFxObject MilitaryMC;

var int rank;
var int nextLevel;
var int militaryLevel;
var string mapName;

var PlayerController PC;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0);

	PC =  GetPC();
	MilitaryMC = GetVariableObject("_root.Military");

	PC.PlayerInput.ResetInput();
	MilitaryMC.GotoAndPlayI(2);
	// PC.SetPause(TRUE);
	return TRUE;
}

function GetRankAndLevel (int _rank, int _militaryLevel)
{
	rank = _rank;
	militaryLevel = _militaryLevel;
}

function SetMapName (String _mapName)
{
	mapName = _mapName;
}

function SetNextLevel (int _nextLevel)
{
	nextLevel = _nextLevel;
}

function SetRankAndLevel ()
{
	MilitaryMC.SetFloat("rank", rank);
	MilitaryMC.SetFloat("level", militaryLevel);
}

function CloseSelf ()
{
	// PC.SetPause(FALSE);

	switch (nextLevel)
	 {
	  case(1):
			  break;
	  case(2):
			  ConsoleCommand("open TMSP-BEACH03?game=TMGame.TGGameSP_Base?NumPlay=0");
			  break;
	  case(3):
			  ConsoleCommand("open TMSP-HILL?game=TMGame.TGGameSP_Base?NumPlay=0");
			  break;
	  case(4):
			  ConsoleCommand("open TMSP-CLIFF01?game=TMGame.TGGameSP_Base?NumPlay=0");
			  break;
	  case(5):
			  ConsoleCommand("open TMSP-SEIGE?game=TMGame.TGGameSP_Base?NumPlay=0");
			  break;
	  case(6):
			  ConsoleCommand("open TMSP-FACTORY?game=TMGame.TGGameSP_Base?NumPlay=0");
			  break;
	  case(7):
			  ConsoleCommand("open TMSP-VILLAGE?game=TMGame.TGGameSP_Sniper?NumPlay=0");
			  break;
	  case(8):
			  ConsoleCommand("open TMSP-City?game=TMGame.TGGameSP_Base?NumPlay=0");
			  break;
	  case(9):
			  ConsoleCommand("open TMSP-End?game=TMGame.TGGameSP_Base?NumPlay=0");
			  break;
	  default:
			  ConsoleCommand("open TMFrontEnd");
			  break;
		 }

	self.Close(TRUE);
}

