class TPCheatManager extends CheatManager;

exec function bool GetPlayersOnly()
{
	return WorldInfo.bPlayersOnly;
}

exec function UnlockAllChapters()
{
	local TPPlayerController PC;

	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.UnlockAllChapters();
		PC.WriteProfile(true);
		ClientMessage("Unlocking all chapters!");
	}
}

exec function LockAllChapters()
{
	local TPPlayerController PC;

	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.LockAllChapters();
		PC.WriteProfile(true);
		ClientMessage("Locking all chapters!");
	}
}

exec function UnlockChapter(int newMaxChapter)
{
	local TPPlayerController PC;

	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.SetMaxChapter(newMaxChapter);
		PC.WriteProfile(true);
		ClientMessage("Unlocking chapter"@newMaxChapter@"and below.");
	}
}

exec function LoadChapter(int newChapterPoint)
{
	local TPPlayerController PC;
	local String TravelString;

	// Check for a valid number - this will be easier once we actually know how many we have
	if (newChapterPoint < 0)
	{
		ClientMessage("Can't load that - need a valid chapter point!");
		return;
	}
	
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		if (PC.TPCM != NONE)
		{
			if (PC.TPCM.ChapterPointExists(newChapterPoint))
			{
				TravelString = "TurningPoint_P?LoadChapter="$newChapterPoint;
				ClientTravel(TravelString, TRAVEL_ABSOLUTE);
				ClientMessage("Loading chapter point "$newChapterPoint$"!");
			}
			else
			{
				ClientMessage("Couldn't find file for chapter point "$newChapterPoint$"!");
			}
		}
		else
			ClientMessage("Couldn't find a checkpoint manager!");
	}
}

exec function AllWeapons()
{
	local TPPlayerController PC;
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.CheatMenuInt.GiveWeapons();
	}
}


