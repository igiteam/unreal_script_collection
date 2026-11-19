//=============================================================================
// SASFrontend.uc
//
// Placeable object that signifys (and controls) the frontend. Place in a level 
// to make the level "the frontend"
//=============================================================================


class SASFrontend extends Actor
	placeable;


var bool bDone;

struct sLevelDesc
{
	var() string mLevelName;
	var() string mLevelURL;
	var() string mLevelDescription;
	var() string mLevelCommand; // If you click on the level, it will just call this console command
};

var(Levels) array<sLevelDesc> mLevels;

function int GetNumLevels()
{
	return mLevels.Length;
}

function string GetLevelName(int index)
{
	return mLevels[index].mLevelName;
}

function string GetLevelCommand(int index)
{
	return mLevels[index].mLevelCommand;
}

function string GetLevelURL(int index)
{
	return mLevels[index].mLevelURL;
}

function string GetLevelDescription(int index)
{
	return mLevels[index].mLevelDescription;
}

//exec function TestFrontend()
//{
//	Level.GetLocalPlayerController().ClientOpenMenu ( "SASGUI.SASLevelMenu");
//}

event Tick(float aDelta)
{
	if (Level != None)
	{
		if (Level.GetLocalPlayerController() != None)
		{
			if (!bDone)
			{
				Level.GetLocalPlayerController().SetPause(true);

//				Level.GetLocalPlayerController().ClientOpenMenu ( "SASGUI.SASLevelMenu");
				StartUpFrontEnd(0);

				bDone = true;
			}
		}
	}
}

