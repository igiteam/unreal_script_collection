class PersistantData extends Object;
	//DLLBind(TestDLL);

//dllimport final function getChar(int s);
var SaveGameData gameData;// = new (none) class'SaveGameData'

private final function readCurrentStats()
{
	gameData = new (none) class'SaveGameData';
	class'Engine'.static.BasicLoadObject(gameData, "SaveGame.bin", true, 1);
}

private final function saveCurrentStats()
{
	class'Engine'.static.BasicSaveObject(gameData, "SaveGame.bin", true, 1);
}

private final function resetTotalStatsAcrossLevels()
{
	gameData = new (none) class'SaveGameData';
	saveCurrentStats();
}

public final function incrementDeathCount()
{
	readCurrentStats();
	gameData.totalDeathsAcrossAllLevels++;
	saveCurrentStats();
}

public final function int getTotalDeathsAcrossAllLevels()
{
	readCurrentStats();
	return gameData.totalDeathsAcrossAllLevels;
}

public final function setTotalDeathsAcrossAllLevels(int value)
{
	readCurrentStats();
	gameData.totalDeathsAcrossAllLevels = value;
	saveCurrentStats();
}

public final function int getTotalSecondsAliveAcrossAllLevels()
{
	readCurrentStats();
	return gameData.totalSecondsAliveAcrossAllLevels;
}

public final function setTotalSecondsAliveAcrossAllLevels(int value)
{
	readCurrentStats();
	gameData.totalSecondsAliveAcrossAllLevels = value;
	saveCurrentStats();
}

public final function addTotalSecondsAliveAcrossAllLevels(int value)
{
	readCurrentStats();
	gameData.totalSecondsAliveAcrossAllLevels += value;
	saveCurrentStats();
}

public final function saveRoundOverStats(int totalSecondsThisRound)
{
	readCurrentStats();
	gameData.totalDeathsAcrossAllLevels++;
	gameData.totalSecondsAliveAcrossAllLevels += totalSecondsThisRound;
	saveCurrentStats();
}


