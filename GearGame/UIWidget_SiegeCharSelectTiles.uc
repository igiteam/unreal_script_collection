/**
 * The main menu object linked to the main menu movie
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIWidget_SiegeCharSelectTiles extends GFxObject
	Config(UI);

//The lists
var GFxObject PrimaryList;

//Reference to the game
var class<GearGameSiege_Base> SiegeGameClass;

//Reference to the movieplayer
var UIScene_SiegeCharSelect SiegeCharSelectScene;

//The dataprovider we are using to run the list
var GFxObject DataProvider;

//The first guy to focus on.
var int FirstFocus;

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("UIWidget_SiegeCharSelectTiles WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
	default:
		return false;
	}
	return true;
}

function SubPostWidgetInit()
{
	UpdateCharList();
}

/** @return whether the passed in character in the UI should be locked and unselectable */
final function bool IsCharacterLocked(int CharIndex, int WaveNum, GearPRI_Siege PRI)
{
	local int Tier;

	Tier = CharIndex % `LOCUSTLIST_COLUMNS;
	// check if it's not allowed to be picked in this wave
	if (!SiegeGameClass.static.IsValidPawnChoice(SiegeGameClass.default.LocustList, CharIndex, WaveNum))
	{
		return true;
	}
	// check if it has already been unlocked
	else if (PRI.UnlockedCharacters[Tier] == CharIndex || PRI.UnlockedCharacters[Tier] == `OPEN_LOCUSTLIST_TIER)
	{
		return false;
	}
	// check if the player already chose a creature type for this tier and this one isn't it
	else if (PRI.UnlockedCharacters[Tier] != `LOCKED_LOCUSTLIST_TIER)
	{
		return true;
	}
	// check if the tier is eligible for unlocking
	else if (Tier == 0 || PRI.UnlockedCharacters[Tier - 1] != `LOCKED_LOCUSTLIST_TIER)
	{
		// still show locked if player has insufficient tokens
		return PRI.WavePointsRemaining < SiegeGameClass.default.TierUnlockCost[Tier];
	}
	else
	{
		return true;
	}
}

/** @return cost string for this character in the UI */
final function string GetCharacterCost(int CharIndex, GearPRI_Siege PRI)
{
	local int Tier;

	Tier = CharIndex % `LOCUSTLIST_COLUMNS;
	if (PRI.UnlockedCharacters[Tier] == `LOCKED_LOCUSTLIST_TIER)
	{
		if (Tier == 0 || PRI.UnlockedCharacters[Tier - 1] != `LOCKED_LOCUSTLIST_TIER)
		{
			return string(SiegeGameClass.default.TierUnlockCost[Tier]);
		}
		else
		{
			return "";
		}
	}
	else if (PRI.UnlockedCharacters[Tier] == `OPEN_LOCUSTLIST_TIER || PRI.UnlockedCharacters[Tier] == CharIndex)
	{
		return string(SiegeGameClass.static.GetCharacterCost(CharIndex, PRI));
	}
	else
	{
		return "";
	}
}

//Initialize the entire character list
function UpdateCharList()
{
	local int i, WaveNum;
	local GFxObject Obj;
	local class<GearPawn> GPClass;
	local string GPClassName;
	local Texture2D CharPortrait;
	local GearGRI_Horde GRI;
	local GearPC_Siege PC;
	local GearPRI_Siege PRI;

	PC = GearPC_Siege(GetPC());
	//If you don't have a PC, just abort.
	if (PC == None)
	{
		return;
	}
	PRI = GearPRI_Siege(PC.PlayerReplicationInfo);

	GRI = GearGRI_Horde(PC.WorldInfo.GRI);
	WaveNum = 1;
	if (GRI != None)
	{
		WaveNum = GRI.InvasionCurrentWaveIndex;
	}

	FirstFocus = -1;

	DataProvider = CreateArray();
	for (i = 0; i < SiegeGameClass.default.LocustList.Length; i++)
	{
		Obj = CreateObject("Object");
		if (SiegeGameClass.default.LocustList[i].EnemyType != AIType_MAX)
		{
			//If this is who we selected last time OR if we don't have a focus item yet, then this will be the thing focused.
			if (i == PC.LastCharSelected || FirstFocus == -1)
			{
				FirstFocus = i;
			}
			Obj.SetString("Cost", GetCharacterCost(i, PRI));
			GPClassName = string(class'SeqAct_AIFactory'.default.SpawnInfo[SiegeGameClass.default.LocustList[i].EnemyType].PawnClassName);
			GPClass = class<GearPawn>(FindObject("GearGameContent." $ GPClassName, class'Class'));
			if (GPClass == None)
			{
				GPClass = class<GearPawn>(FindObject("GearGame."$GPClassName, class'Class'));
			}
			if (GPClass != None)
			{
				Obj.SetString("Name", GPClass.default.CharacterName);
			}
			else
			{
				// bit of a hack but reaver is the only class this currently applies to
				Obj.SetString("Name", class<Vehicle_Reaver_Base>(FindObject("GearGameContent." $ GPClassName, class'Class')).default.CharacterName);
			}

			CharPortrait = SiegeCharSelectScene.CharacterPortraits[SiegeGameClass.default.LocustList[i].EnemyType];
			Obj.SetString("PicPath","img://"$CharPortrait.PathName(CharPortrait));

			Obj.SetBool("bIsLocked", IsCharacterLocked(i, WaveNum, PRI));

			DataProvider.SetElementObject(i,Obj);
		}
	}

	OtherPlayersStatusChanged(false);

	SetObject("dataProvider", DataProvider);
	SetFloat("selectedIndex",FirstFocus);
	SiegeCharSelectScene.UpdateNumPoints();
}

function UpdateLockedStatus()
{
	local int i;
	local GFxObject Obj;
	local GearGRI_Horde GRI;
	local int WaveNum;
	local array<ASValue> args;
	local PlayerController PC;
	local GearPRI_Siege PRI;

	PC = GetPC();
	if (PC != None)
	{
		GRI = GearGRI_Horde(PC.WorldInfo.GRI);
		WaveNum = 1;
		if (GRI != none)
		{
			WaveNum = GRI.InvasionCurrentWaveIndex;
		}

		PRI = GearPRI_Siege(PC.PlayerReplicationInfo);
		for (i = 0; i < SiegeGameClass.default.LocustList.Length; i++)
		{
			if (SiegeGameClass.default.LocustList[i].EnemyType != AIType_MAX)
			{
				Obj = DataProvider.GetElementObject(i);
				Obj.SetString("Cost", GetCharacterCost(i, PRI));
				Obj.SetBool("bIsLocked", IsCharacterLocked(i, WaveNum, PRI));
			}
		}
		args.Length = 0;
		Invoke("invalidateData",args);
	}
}

//Something has happened with the other players, update their status indicators
function OtherPlayersStatusChanged(optional bool bUpdateDataProvider)
{
	local GearPRI_Siege PRI;
	local GFxObject Obj;
	local int i;
	local GearGRI GRI;
	local array<ASValue> args;
	local PlayerController PC;

	for (i = 0; i < SiegeGameClass.default.LocustList.Length; i++)
	{
		if (SiegeGameClass.default.LocustList[i].EnemyType != AIType_MAX)
		{
			Obj = DataProvider.GetElementObject(i);
			Obj.SetFloat("NumPlayers",0);
		}
	}

	PC = GetPC();
	GRI = GearGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	if (GRI != none && PC != None)
	{
		for (i = 0; i < GRI.PRIArray.Length; i++)
		{
			PRI = GearPRI_Siege(GRI.PRIArray[i]);
			if (PRI != none)
			{
				if (PRI != PC.PlayerReplicationInfo)
				{
					if (PRI != none && !PRI.bBot && !PRI.bIsDead && PRI.SiegeCharIndex >= 0 && PRI.SiegeCharIndex < SiegeGameClass.default.LocustList.Length)
					{
						Obj = DataProvider.GetElementObject(PRI.SiegeCharIndex);
						Obj.SetFloat("NumPlayers",Obj.GetFloat("NumPlayers")+1);
					}
				}
			}
		}
	}

	if (bUpdateDataProvider)
	{
		args.Length = 0;
		Invoke("invalidateData",args);
	}
}

defaultproperties
{
	FirstFocus=-1;
}
