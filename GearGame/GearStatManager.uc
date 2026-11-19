/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearStatManager extends Object
	config(Game);
/** Class that manages the Stat system */

`include(GearPlayerPersistentDataConstants.uci)

/** Array of stats tracked */
var transient array<GearStat> Stats;

// Prefix prepended to all stat names when constructing stat objects
var string StatPrefix;

/** Initialization structure used to read stats from the ini file */
struct StatInit
{
	//Name of the stat
	var name StatName;
	//Persistent Data name if the stat is persisted
	var name PersistentDataName;
};

/** Data from the ini file used to initialize the stats */
var array<StatInit> StatInits;

/** Reference to the PC that controls this AwardManager */
var transient GearPC PC;

/** Array of all of the awards earned since the last time it was wiped. Should be wiped every game */
var transient array<GearAward> EarnedAwards;

/** Ladder relevant to the gametype being played */
var GearCarrotLadder_Base CarrotLadder;


/** EXP-LEVEL DATA */
/** The amount of experience earned before the last exp update. Used in the personal progression screen so we can show progress*/
var int PrevXP;
/** Starting amount of experience needed to level up */
var config int SecondLevelXP;
/** Starting amount to scale this level by to reach the next level */
var config float StartingXPScale;
/** The amount of levels to progress before reducing the level scaling */
var config int DecrementXPScaleEvery;
/** The amount to decress the scale by when decreasing */
var config float DecrementXPScaleBy;

/** Use StatInit to populate Stats with the non-Award stats */
function private ConstructStats()
{
	local int ConfigIndex;
	local GearStat Stat;
	local StatInit ConfigStat;

	for (ConfigIndex = 0; ConfigIndex < StatInits.Length; ConfigIndex++)
	{
		ConfigStat = StatInits[ConfigIndex];
		Stat = new(self, StatPrefix $ ConfigStat.StatName) class'GearStat';
		Stat.StatName = ConfigStat.StatName;
		Stat.PersistentDataID = class'GearPlayerPersistentData'.static.FindDefaultProfileMappingIndexByName(ConfigStat.PersistentDataName);

		Stat.StatDataByPeriod.Length = GEARPERIOD_MAX;

		Stats.AddItem(Stat);
	}
}

/*
 *   @return high score for a give leaderboard (arcade/siege/horde only)
 */
simulated function int GetHighScore()
{
	if (CarrotLadder != None)
	{
	   return CarrotLadder.GetHighScore();
	}

	return -1;
}

/*
 *   @return high score for a give leaderboard (siege/horde only)
 */
simulated function int GetMaxWaveCompleted()
{
	if (CarrotLadder != None)
	{
	   return CarrotLadder.GetMaxWaveCompleted();
	}

	return -1;
}


/**
 * Read the LIVE leaderboards and setup stats in order to
 * properly alert player where they stand relative to friends
 * @param CarrotLadderClassName - LadderClass to instantiate
 */
simulated function SetupCarrotLadder(string CarrotLadderClassName)
{
	local LocalPlayer LP;
	local class<GearCarrotLadder_Base> CarrotLadderClass;

	CarrotLadderClass = class<GearCarrotLadder_Base>(FindObject(CarrotLadderClassName, class'Class'));
	if (CarrotLadderClass != None)
	{
		CarrotLadder = new(self) CarrotLadderClass;
		if (CarrotLadder != None)
		{
			LP = LocalPlayer(PC.Player);
			if (LP != None)
			{
				CarrotLadder.ReadLadderData(LP.ControllerId);
			}
		}
	}
}

/** Initialize the manager from the config variables
 *  @param GPC The PC that uses this stat manager
 */
function InitializeManager(GearPC GPC)
{
	PC = GPC;
	//1. Wipe any existing data
	Stats.Length = 0;
	EarnedAwards.Length = 0;
	//2. Use StatInit to populate Stats with the non-Award stats
	ConstructStats();
}

/** Update the stats from the persistent data */
function ReadFromPersistentData()
{
	local int StatIndex;

	if (PC.PersistentData != None)
	{
		for (StatIndex = 0; StatIndex < Stats.Length; StatIndex++)
		{
			if (Stats[StatIndex].PersistentDataID != `Invalid)
			{
				Stats[StatIndex].StatDataByPeriod[GEARPERIOD_Persistent] = PC.PersistentData.GetValue(Stats[StatIndex].PersistentDataID);
			}
		}
	}
	//Update the cache
	PC.AwardManager.CacheAwardDataByGroup();
	//Update progress
	PC.AwardManager.UpdateAwardProgress();
}

/** Update the persistent data from the stats */
function WriteToPersistentData()
{
	local int StatIndex;

	if (PC.PersistentData != None)
	{
		for (StatIndex = 0; StatIndex < Stats.Length; StatIndex++)
		{
			if (Stats[StatIndex].PersistentDataID != `Invalid)
			{
				PC.PersistentData.SetValue(Stats[StatIndex].PersistentDataID, Stats[StatIndex].StatDataByPeriod[GEARPERIOD_Persistent]);
			}
		}
	}
}

/** Clears all tracked stats back to 0
 *	@param bWipePersistent Whether or not to wipe the persistent period data
 */
function ClearManager(optional bool bWipePersistent=False)
{
	local int StatIndex;
	local int PeriodIndex;

	for(StatIndex = 0; StatIndex < Stats.Length; StatIndex++)
	{
		for(PeriodIndex = 0; PeriodIndex < Stats[StatIndex].StatDataByPeriod.Length; PeriodIndex++)
		{
			if (PeriodIndex != GEARPERIOD_Persistent || bWipePersistent)
			{
				Stats[StatIndex].StatDataByPeriod[PeriodIndex] = 0;
			}
		}
	}
	EarnedAwards.Length = 0;
}

/** Clears all tracked stats for this period
 *	@param Period The period that has just started
 */
function PeriodStarted(ERecordingPeriodType Period)
{
	local int StatIndex;

	for(StatIndex = 0; StatIndex < Stats.Length; StatIndex++)
	{
		if (Stats[StatIndex].StatDataByPeriod.Length >= Period)
		{
			Stats[StatIndex].StatDataByPeriod[Period] = 0;
		}
	}
	//Wipe the earned awards list if the game is over
	if (Period == GEARPERIOD_Game)
	{
		EarnedAwards.Length = 0;
	}
}

/** Records a stat and determines if this will earn an award
 *  @param Stat The type of stat being recorded
 *	@param Amount The amount it has changed
 *	@param ModType The type of modification to be made on the stat
 *
 *  @return Returns true if the stat was successfully found
 */
function bool ModifyStat(name StatName, int Amount, EStatModificationType ModType)
{
	local GearStat Stat;

	Stat = GetStatByName(StatName);
	if (Stat != None)
	{
		Stat.ModifyStat(Amount, ModType);
		return true;
	}
	else
	{
		`Log("Attempt to modify stat '" $ StatName $ "' failed as it cannot be found!",, 'Stats');
		return false;
	}
}

/** Records an earned award in the earned awards list
 *  @param Award - The award to record
 */
function RecordAwardEarned(GearAward Award)
{
	if (Award != None)
	{
		Award.AssociatedStat.ModifyStat(1, GEARSTATMODTYPE_Delta);
		EarnedAwards.AddItem(Award);
	}
}

final function GearStat GetStatByName(name StatName)
{
	return GearStat(FindObject(PathName(self) $"."$StatPrefix$string(StatName), class'GearStat'));
}

final function int GetStatValueByName(name StatName, optional ERecordingPeriodType Period=GEARPERIOD_Persistent)
{
	local GearStat Stat;

	Stat = GetStatByName(StatName);

	if (Stat != None)
	{
		return Stat.StatDataByPeriod[Period];
	}
	return 0;
}

/** Check for achievements based on the level */
function CheckLevelAchievements()
{
	local int CurrentLevel;

	if (PC != None)
	{
		CurrentLevel = GetStatValueByName('Level');

		if (CurrentLevel >= 5)
		{
			// @ACHIEVEMENT - LEVEL 5
			PC.ClientUnlockAchievement(eGA_LEVEL5);
		}
		if (CurrentLevel >= 10)
		{
			// @ACHIEVEMENT - LEVEL 10
			PC.ClientUnlockAchievement(eGA_LEVEL10);
		}
		if (CurrentLevel >= 15)
		{
			// @ACHIEVEMENT - LEVEL 15
			PC.ClientUnlockAchievement(eGA_LEVEL15);
		}
		if (CurrentLevel >= 25)
		{
			// @ACHIEVEMENT - LEVEL 25
			PC.ClientUnlockAchievement(eGA_LEVEL25);
			// @BETA
			PC.NotifyEarnedAward('Level25Beta');
		}
		if (CurrentLevel >= 50)
		{
			// @BETA
			PC.NotifyEarnedAward('Level50Beta');
		}
	}
}

/** See if we should perform a progression update */
function CheckLevelProgression(int PreUpdateLevel, int PostUpdateLevel)
{
	local GearAlertManager GAM;

	// Make sure the PC and alert manager are valid and that the level actually changed
	if (PC != None && PreUpdateLevel < PostUpdateLevel)
	{
	   GAM = PC.GetAlertManager();
	   if (GAM != None)
	   {
		   // Level 5 progression
		   if (PostUpdateLevel < 5)
		   {
			   GAM.MadeProgress(ePROG_Achievement, eGA_LEVEL5);
		   }
		   // Level 10 progression
		   else if (PostUpdateLevel > 5 &&
			   PostUpdateLevel < 10)
		   {
			   GAM.MadeProgress(ePROG_Achievement, eGA_LEVEL10);
		   }
		   // Level 15 progression
		   else if (PostUpdateLevel > 10 &&
			   PostUpdateLevel < 15)
		   {
			   GAM.MadeProgress(ePROG_Achievement, eGA_LEVEL15);
		   }
		   // Level 25 progression
		   else if (PostUpdateLevel > 15 &&
			   PostUpdateLevel < 25)
		   {
			   GAM.MadeProgress(ePROG_Achievement, eGA_LEVEL25);
		   }
	   }
	}
}

/**
 * Determines the player's level information for display
 */
function UpdateLevelFromXP(bool bDoProgression=true)
{
	local int CurrentLevel;
	local int XPNeededForCurrentLevel, XPNeededForNextLevel, NewLevel;

	CurrentLevel = GetStatValueByName('Level');
	NewLevel = DetermineLevel(GetStatValueByName('XP'),XPNeededForCurrentLevel,XPNeededForNextLevel);

	if (CurrentLevel != NewLevel)
	{
		ModifyStat('Level', NewLevel, GEARSTATMODTYPE_Set);

		// Check for achievements based on the level
		CheckLevelAchievements();

	    // See if we should perform a progression update
	    if (bDoProgression)
	    {
		    CheckLevelProgression(CurrentLevel, NewLevel);
	    }
	}
}

/** Determines the player's level from their Xp
 *  @param CurrentXp - The amount of exp the player has
 *  @param XPNeededForCurrentLevel - the amount of exp needed to attain the current level
 *  @param XPNeededForNextLevel - the amount of exp needed to attain the next level
 *  @return Returns the level equated to this amount of exp
 */
function int DetermineLevel(int CurrentXp, out int XPNeededForCurrentLevel, out int XPNeededForNextLevel)
{
	local int XpGrowth;
	local int NextLevel;
	local float ScaleBy;

	XPNeededForCurrentLevel = 0;
	// Set up start conditions for the level calculation
	ScaleBy = StartingXPScale;
	NextLevel = 1;
	XpGrowth = SecondLevelXP;
	// Run the level calculation until we find their current & next level
	for (XPNeededForNextLevel = XpGrowth; XPNeededForNextLevel <= CurrentXp && NextLevel < 100; NextLevel++)
	{
		// Increase the step size for the next level
		XpGrowth = XpGrowth * ScaleBy;
		// Keep track of the start of their current level so that we can do percentages
		if (XPNeededForNextLevel <= CurrentXp)
		{
			XPNeededForCurrentLevel = XPNeededForNextLevel;
		}
		// See if we need to step down our XP scaling curve
		if (NextLevel % DecrementXPScaleEvery == 0)
		{
			ScaleBy -= DecrementXPScaleBy;
		}
		// Add the next level step size to our current XP
		XPNeededForNextLevel += XpGrowth;
	}

	return NextLevel;
}

defaultproperties
{
	PrevXP=-1

	StatPrefix="GEARSTAT_"

	StatInits={(
	(StatName=XP, PersistentDataName=XP),
	(StatName=Level, PersistentDataName=Level),
	(StatName=HighScoreHorde, PersistentDataName=HighScoreHorde),
	(StatName=KillsHorde, PersistentDataName=KillsHorde),
	(StatName=RevivesHorde, PersistentDataName=RevivesHorde),
	(StatName=DownsHorde, PersistentDataName=DownsHorde),
	(StatName=DeathsHorde, PersistentDataName=DeathsHorde),
	(StatName=HighScoreSiege, PersistentDataName=HighScoreSiege),
	(StatName=KillsSiege, PersistentDataName=KillsSiege),
	(StatName=DownsSiege, PersistentDataName=DownsSiege),
	(StatName=DeathsSiege, PersistentDataName=DeathsSiege),
	(StatName=RevivesSiege, PersistentDataName=RevivesSiege),
	(StatName=HighScoreArcade, PersistentDataName=HighScoreArcade),
	(StatName=HighestMultiplierArcade, PersistentDataName=HighestMultiplierArcade),
	(StatName=HighestOneKillScoreArcade, PersistentDataName=HighestOneKillScoreArcade),
	(StatName=KillsArcade, PersistentDataName=KillsArcade),
	(StatName=DeathsArcade, PersistentDataName=DeathsArcade),
	(StatName=RevivesArcade, PersistentDataName=RevivesArcade),
	(StatName=DownsArcade, PersistentDataName=DownsArcade),
	(StatName=RevivesMP, PersistentDataName=RevivesMP),
	(StatName=HeadshotsMP, PersistentDataName=HeadshotsMP),
	(StatName=KillsMP, PersistentDataName=KillsMP),
	(StatName=DeathsMP, PersistentDataName=DeathsMP),
	(StatName=KillsAsLeaderMP, PersistentDataName=KillsAsLeaderMP),
	(StatName=AssistsMP, PersistentDataName=AssistsMP),
	(StatName=DownsMP, PersistentDataName=DownsMP),
	(StatName=FemaleCharMP, PersistentDataName=FemaleCharMP),
	(StatName=GrenadesDestroyedMP, PersistentDataName=GrenadesDestroyedMP),
	(StatName=FacePunchesMP, PersistentDataName=FacePunchesMP),
	(StatName=CurbStompsMP, PersistentDataName=CurbStompsMP),
	(StatName=ScoreMP, PersistentDataName=ScoreMP),
	(StatName=CoverTimeMP, PersistentDataName=CoverTimeMP),
	(StatName=DownsFromCoverMP, PersistentDataName=DownsFromCoverMP),
	(StatName=ExecutionsMP, PersistentDataName=ExecutionsMP),
	(StatName=LeaderSavesMP, PersistentDataName=LeaderSavesMP),
	(StatName=GamesPlayedMP, PersistentDataName=GamesPlayedMP),
	(StatName=GamesWonMP, PersistentDataName=GamesWonMP),
	(StatName=GamesLostMP, PersistentDataName=GamesLostMP),
	(StatName=GamesFirstMP, PersistentDataName=GamesFirstMP),
	(StatName=RoundsWonMP, PersistentDataName=RoundsWonMP),
	(StatName=RoundsLostMP, PersistentDataName=RoundsLostMP),
	(StatName=RoundsDrawnMP, PersistentDataName=RoundsDrawnMP),
	(StatName=RoundsWonAsLeaderMP, PersistentDataName=RoundsWonAsLeaderMP),
	(StatName=RoundsFirstMP, PersistentDataName=RoundsFirstMP),
	(StatName=CTLPlayed, PersistentDataName=CTLPlayed),
	(StatName=KOTHPlayed, PersistentDataName=KOTHPlayed),
	(StatName=WarzonePlayed, PersistentDataName=WarzonePlayed),
	(StatName=ExecutionPlayed, PersistentDataName=ExecutionPlayed),
	(StatName=TDMPlayed, PersistentDataName=TDMPlayed),
	(StatName=WingmanPlayed, PersistentDataName=WingmanPlayed),
	(StatName=HordePlayed, PersistentDataName=HordePlayed),
	(StatName=SiegePlayed, PersistentDataName=SiegePlayed),
	(StatName=SpottedPlayerMP, PersistentDataName=SpottedPlayerMP),
	(StatName=ShotgunKillsMP, PersistentDataName=ShotgunKillsMP),
	(StatName=HeavyKillsMP, PersistentDataName=HeavyKillsMP),
	(StatName=PistolKillsMP, PersistentDataName=PistolKillsMP),
	(StatName=PickupKillsMP, PersistentDataName=PickupKillsMP),
	(StatName=GrenadeKillsMP, PersistentDataName=GrenadeKillsMP),
	(StatName=MeleeKnockdownsMP, PersistentDataName=MeleeKnockdownsMP),
	(StatName=WeaponARSuperSuccessSP, PersistentDataName=WeaponARSuperSuccessSP),
	(StatName=WeaponARSuperSuccessMP, PersistentDataName=WeaponARSuperSuccessMP),
	(StatName=LancerKillsSP, PersistentDataName=LancerKillsSP),
	(StatName=LancerKillsMP, PersistentDataName=LancerKillsMP),
	(StatName=HammerburstKillsSP, PersistentDataName=HammerburstKillsSP),
	(StatName=HammerburstKillsMP, PersistentDataName=HammerburstKillsMP),
	(StatName=CogPistolKillsSP, PersistentDataName=CogPistolKillsSP),
	(StatName=CogPistolKillsMP, PersistentDataName=CogPistolKillsMP),
	(StatName=FlailKillsSP, PersistentDataName=FlailKillsSP),
	(StatName=FlailKillsMP, PersistentDataName=FlailKillsMP),
	(StatName=BoomshotKillsSP, PersistentDataName=BoomshotKillsSP),
	(StatName=BoomshotKillsMP, PersistentDataName=BoomshotKillsMP),
	(StatName=ScorcherKillsSP, PersistentDataName=ScorcherKillsSP),
	(StatName=ScorcherKillsMP, PersistentDataName=ScorcherKillsMP),
	(StatName=TorqueBowKillsSP, PersistentDataName=TorqueBowKillsSP),
	(StatName=TorqueBowKillsMP, PersistentDataName=TorqueBowKillsMP),
	(StatName=CleaverKillsSP, PersistentDataName=CleaverKillsSP),
	(StatName=CleaverKillsMP, PersistentDataName=CleaverKillsMP),
	(StatName=DiggerLauncherKillsSP, PersistentDataName=DiggerLauncherKillsSP),
	(StatName=DiggerLauncherKillsMP, PersistentDataName=DiggerLauncherKillsMP),
	(StatName=FragGrenadeKillsSP, PersistentDataName=FragGrenadeKillsSP),
	(StatName=FragGrenadeKillsMP, PersistentDataName=FragGrenadeKillsMP),
	(StatName=IncendiaryGrenadeKillsSP, PersistentDataName=IncendiaryGrenadeKillsSP),
	(StatName=IncendiaryGrenadeKillsMP, PersistentDataName=IncendiaryGrenadeKillsMP),
	(StatName=InkGrenadeKillsSP, PersistentDataName=InkGrenadeKillsSP),
	(StatName=InkGrenadeKillsMP, PersistentDataName=InkGrenadeKillsMP),
	(StatName=CoopMinigunKillsSP, PersistentDataName=CoopMinigunKillsSP),
	(StatName=CoopMinigunKillsMP, PersistentDataName=CoopMinigunKillsMP),
	(StatName=MulcherKillsSP, PersistentDataName=MulcherKillsSP),
	(StatName=MulcherKillsMP, PersistentDataName=MulcherKillsMP),
	(StatName=MortarKillsSP, PersistentDataName=MortarKillsSP),
	(StatName=MortarKillsMP, PersistentDataName=MortarKillsMP),
	(StatName=LongshotKillsSP, PersistentDataName=LongshotKillsSP),
	(StatName=LongshotKillsMP, PersistentDataName=LongshotKillsMP),
	(StatName=HeavySniperKillsSP, PersistentDataName=HeavySniperKillsSP),
	(StatName=HeavySniperKillsMP, PersistentDataName=HeavySniperKillsMP),
	(StatName=HammerOfDawnKillsSP, PersistentDataName=HammerOfDawnKillsSP),
	(StatName=HammerOfDawnKillsMP, PersistentDataName=HammerOfDawnKillsMP),
	(StatName=GorgonKillsSP, PersistentDataName=GorgonKillsSP),
	(StatName=GorgonKillsMP, PersistentDataName=GorgonKillsMP),
	(StatName=BoltokKillsSP, PersistentDataName=BoltokKillsSP),
	(StatName=BoltokKillsMP, PersistentDataName=BoltokKillsMP),
	(StatName=MeleeKillsSP, PersistentDataName=MeleeKillsSP),
	(StatName=MeleeKillsMP, PersistentDataName=MeleeKillsMP),
	(StatName=ChainsawKillsSP, PersistentDataName=ChainsawKillsSP),
	(StatName=ChainsawKillsMP, PersistentDataName=ChainsawKillsMP),
	(StatName=BayonetKillsSP, PersistentDataName=BayonetKillsSP),
	(StatName=BayonetKillsMP, PersistentDataName=BayonetKillsMP),
	(StatName=RetroLancerKillsSP, PersistentDataName=RetroLancerKillsSP),
	(StatName=RetroLancerKillsMP, PersistentDataName=RetroLancerKillsMP),
	(StatName=GnasherKillsSP, PersistentDataName=GnasherKillsSP),
	(StatName=GnasherKillsMP, PersistentDataName=GnasherKillsMP),
	(StatName=SawedOffShotgunKillsSP, PersistentDataName=SawedOffShotgunKillsSP),
	(StatName=SawedOffShotgunKillsMP, PersistentDataName=SawedOffShotgunKillsMP),
	(StatName=RipperKillsSP, PersistentDataName=RipperKillsSP),
	(StatName=RipperKillsMP, PersistentDataName=RipperKillsMP),
	(StatName=SilverbackMinigunKillsSP, PersistentDataName=SilverbackMinigunKillsSP),
	(StatName=SilverbackMinigunKillsMP, PersistentDataName=SilverbackMinigunKillsMP),
	(StatName=SilverbackRocketLauncherKillsSP, PersistentDataName=SilverbackRocketLauncherKillsSP),
	(StatName=SilverbackRocketLauncherKillsMP, PersistentDataName=SilverbackRocketLauncherKillsMP),
	(StatName=MultiLancerKillsSP, PersistentDataName=MultiLancerKillsSP),
	(StatName=MultiLancerKillsMP, PersistentDataName=MultiLancerKillsMP),
	(StatName=MultiRetroKillsSP, PersistentDataName=MultiRetroKillsSP),
	(StatName=MultiRetroKillsMP, PersistentDataName=MultiRetroKillsMP),
	(StatName=MultiHammerburstKillsSP, PersistentDataName=MultiHammerburstKillsSP),
	(StatName=MultiHammerburstKillsMP, PersistentDataName=MultiHammerburstKillsMP),
	(StatName=MultiBoomshotKillsSP, PersistentDataName=MultiBoomshotKillsSP),
	(StatName=MultiBoomshotKillsMP, PersistentDataName=MultiBoomshotKillsMP),
	(StatName=MultiGnasherKillsSP, PersistentDataName=MultiGnasherKillsSP),
	(StatName=MultiGnasherKillsMP, PersistentDataName=MultiGnasherKillsMP),
	(StatName=SubmarineTurretKillsSP, PersistentDataName=SubmarineTurretKillsSP),
	(StatName=SubmarineTurretKillsMP, PersistentDataName=SubmarineTurretKillsMP),
	(StatName=LancerShotsFiredSP, PersistentDataName=LancerShotsFiredSP),
	(StatName=LancerShotsFiredMP, PersistentDataName=LancerShotsFiredMP),
	(StatName=HammerburstShotsFiredSP, PersistentDataName=HammerburstShotsFiredSP),
	(StatName=HammerburstShotsFiredMP, PersistentDataName=HammerburstShotsFiredMP),
	(StatName=CogPistolShotsFiredSP, PersistentDataName=CogPistolShotsFiredSP),
	(StatName=CogPistolShotsFiredMP, PersistentDataName=CogPistolShotsFiredMP),
	(StatName=FlailShotsFiredSP, PersistentDataName=FlailShotsFiredSP),
	(StatName=FlailShotsFiredMP, PersistentDataName=FlailShotsFiredMP),
	(StatName=BoomshotShotsFiredSP, PersistentDataName=BoomshotShotsFiredSP),
	(StatName=BoomshotShotsFiredMP, PersistentDataName=BoomshotShotsFiredMP),
	(StatName=ScorcherShotsFiredSP, PersistentDataName=ScorcherShotsFiredSP),
	(StatName=ScorcherShotsFiredMP, PersistentDataName=ScorcherShotsFiredMP),
	(StatName=TorqueBowShotsFiredSP, PersistentDataName=TorqueBowShotsFiredSP),
	(StatName=TorqueBowShotsFiredMP, PersistentDataName=TorqueBowShotsFiredMP),
	(StatName=CleaverShotsFiredSP, PersistentDataName=CleaverShotsFiredSP),
	(StatName=CleaverShotsFiredMP, PersistentDataName=CleaverShotsFiredMP),
	(StatName=DiggerLauncherShotsFiredSP, PersistentDataName=DiggerLauncherShotsFiredSP),
	(StatName=DiggerLauncherShotsFiredMP, PersistentDataName=DiggerLauncherShotsFiredMP),
	(StatName=FragGrenadeShotsFiredSP, PersistentDataName=FragGrenadeShotsFiredSP),
	(StatName=FragGrenadeShotsFiredMP, PersistentDataName=FragGrenadeShotsFiredMP),
	(StatName=IncendiaryGrenadeShotsFiredSP, PersistentDataName=IncendiaryGrenadeShotsFiredSP),
	(StatName=IncendiaryGrenadeShotsFiredMP, PersistentDataName=IncendiaryGrenadeShotsFiredMP),
	(StatName=InkGrenadeShotsFiredSP, PersistentDataName=InkGrenadeShotsFiredSP),
	(StatName=InkGrenadeShotsFiredMP, PersistentDataName=InkGrenadeShotsFiredMP),
	(StatName=CoopMinigunShotsFiredSP, PersistentDataName=CoopMinigunShotsFiredSP),
	(StatName=CoopMinigunShotsFiredMP, PersistentDataName=CoopMinigunShotsFiredMP),
	(StatName=MulcherShotsFiredSP, PersistentDataName=MulcherShotsFiredSP),
	(StatName=MulcherShotsFiredMP, PersistentDataName=MulcherShotsFiredMP),
	(StatName=MortarShotsFiredSP, PersistentDataName=MortarShotsFiredSP),
	(StatName=MortarShotsFiredMP, PersistentDataName=MortarShotsFiredMP),
	(StatName=LongshotShotsFiredSP, PersistentDataName=LongshotShotsFiredSP),
	(StatName=LongshotShotsFiredMP, PersistentDataName=LongshotShotsFiredMP),
	(StatName=HeavySniperShotsFiredSP, PersistentDataName=HeavySniperShotsFiredSP),
	(StatName=HeavySniperShotsFiredMP, PersistentDataName=HeavySniperShotsFiredMP),
	(StatName=HammerOfDawnShotsFiredSP, PersistentDataName=HammerOfDawnShotsFiredSP),
	(StatName=HammerOfDawnShotsFiredMP, PersistentDataName=HammerOfDawnShotsFiredMP),
	(StatName=GorgonShotsFiredSP, PersistentDataName=GorgonShotsFiredSP),
	(StatName=GorgonShotsFiredMP, PersistentDataName=GorgonShotsFiredMP),
	(StatName=BoltokShotsFiredSP, PersistentDataName=BoltokShotsFiredSP),
	(StatName=BoltokShotsFiredMP, PersistentDataName=BoltokShotsFiredMP),
	(StatName=MeleeShotsFiredSP, PersistentDataName=MeleeShotsFiredSP),
	(StatName=MeleeShotsFiredMP, PersistentDataName=MeleeShotsFiredMP),
	(StatName=ChainsawShotsFiredSP, PersistentDataName=ChainsawShotsFiredSP),
	(StatName=ChainsawShotsFiredMP, PersistentDataName=ChainsawShotsFiredMP),
	(StatName=BayonetShotsFiredSP, PersistentDataName=BayonetShotsFiredSP),
	(StatName=BayonetShotsFiredMP, PersistentDataName=BayonetShotsFiredMP),
	(StatName=RetroLancerShotsFiredSP, PersistentDataName=RetroLancerShotsFiredSP),
	(StatName=RetroLancerShotsFiredMP, PersistentDataName=RetroLancerShotsFiredMP),
	(StatName=GnasherShotsFiredSP, PersistentDataName=GnasherShotsFiredSP),
	(StatName=GnasherShotsFiredMP, PersistentDataName=GnasherShotsFiredMP),
	(StatName=SawedOffShotgunShotsFiredSP, PersistentDataName=SawedOffShotgunShotsFiredSP),
	(StatName=SawedOffShotgunShotsFiredMP, PersistentDataName=SawedOffShotgunShotsFiredMP),
	(StatName=RipperShotsFiredSP, PersistentDataName=RipperShotsFiredSP),
	(StatName=RipperShotsFiredMP, PersistentDataName=RipperShotsFiredMP),
	(StatName=SilverbackMinigunShotsFiredSP, PersistentDataName=SilverbackMinigunShotsFiredSP),
	(StatName=SilverbackMinigunShotsFiredMP, PersistentDataName=SilverbackMinigunShotsFiredMP),
	(StatName=SilverbackRocketLauncherShotsFiredSP, PersistentDataName=SilverbackRocketLauncherShotsFiredSP),
	(StatName=SilverbackRocketLauncherShotsFiredMP, PersistentDataName=SilverbackRocketLauncherShotsFiredMP),
	(StatName=MultiLancerShotsFiredSP, PersistentDataName=MultiLancerShotsFiredSP),
	(StatName=MultiLancerShotsFiredMP, PersistentDataName=MultiLancerShotsFiredMP),
	(StatName=MultiRetroShotsFiredSP, PersistentDataName=MultiRetroShotsFiredSP),
	(StatName=MultiRetroShotsFiredMP, PersistentDataName=MultiRetroShotsFiredMP),
	(StatName=MultiHammerburstShotsFiredSP, PersistentDataName=MultiHammerburstShotsFiredSP),
	(StatName=MultiHammerburstShotsFiredMP, PersistentDataName=MultiHammerburstShotsFiredMP),
	(StatName=MultiBoomshotShotsFiredSP, PersistentDataName=MultiBoomshotShotsFiredSP),
	(StatName=MultiBoomshotShotsFiredMP, PersistentDataName=MultiBoomshotShotsFiredMP),
	(StatName=MultiGnasherShotsFiredSP, PersistentDataName=MultiGnasherShotsFiredSP),
	(StatName=MultiGnasherShotsFiredMP, PersistentDataName=MultiGnasherShotsFiredMP),
	(StatName=SubmarineTurretShotsFiredSP, PersistentDataName=SubmarineTurretShotsFiredSP),
	(StatName=SubmarineTurretShotsFiredMP, PersistentDataName=SubmarineTurretShotsFiredMP),
	(StatName=LancerShotsHitSP, PersistentDataName=LancerShotsHitSP),
	(StatName=LancerShotsHitMP, PersistentDataName=LancerShotsHitMP),
	(StatName=HammerburstShotsHitSP, PersistentDataName=HammerburstShotsHitSP),
	(StatName=HammerburstShotsHitMP, PersistentDataName=HammerburstShotsHitMP),
	(StatName=CogPistolShotsHitSP, PersistentDataName=CogPistolShotsHitSP),
	(StatName=CogPistolShotsHitMP, PersistentDataName=CogPistolShotsHitMP),
	(StatName=FlailShotsHitSP, PersistentDataName=FlailShotsHitSP),
	(StatName=FlailShotsHitMP, PersistentDataName=FlailShotsHitMP),
	(StatName=BoomshotShotsHitSP, PersistentDataName=BoomshotShotsHitSP),
	(StatName=BoomshotShotsHitMP, PersistentDataName=BoomshotShotsHitMP),
	(StatName=ScorcherShotsHitSP, PersistentDataName=ScorcherShotsHitSP),
	(StatName=ScorcherShotsHitMP, PersistentDataName=ScorcherShotsHitMP),
	(StatName=TorqueBowShotsHitSP, PersistentDataName=TorqueBowShotsHitSP),
	(StatName=TorqueBowShotsHitMP, PersistentDataName=TorqueBowShotsHitMP),
	(StatName=CleaverShotsHitSP, PersistentDataName=CleaverShotsHitSP),
	(StatName=CleaverShotsHitMP, PersistentDataName=CleaverShotsHitMP),
	(StatName=DiggerLauncherShotsHitSP, PersistentDataName=DiggerLauncherShotsHitSP),
	(StatName=DiggerLauncherShotsHitMP, PersistentDataName=DiggerLauncherShotsHitMP),
	(StatName=FragGrenadeShotsHitSP, PersistentDataName=FragGrenadeShotsHitSP),
	(StatName=FragGrenadeShotsHitMP, PersistentDataName=FragGrenadeShotsHitMP),
	(StatName=IncendiaryGrenadeShotsHitSP, PersistentDataName=IncendiaryGrenadeShotsHitSP),
	(StatName=IncendiaryGrenadeShotsHitMP, PersistentDataName=IncendiaryGrenadeShotsHitMP),
	(StatName=InkGrenadeShotsHitSP, PersistentDataName=InkGrenadeShotsHitSP),
	(StatName=InkGrenadeShotsHitMP, PersistentDataName=InkGrenadeShotsHitMP),
	(StatName=CoopMinigunShotsHitSP, PersistentDataName=CoopMinigunShotsHitSP),
	(StatName=CoopMinigunShotsHitMP, PersistentDataName=CoopMinigunShotsHitMP),
	(StatName=MulcherShotsHitSP, PersistentDataName=MulcherShotsHitSP),
	(StatName=MulcherShotsHitMP, PersistentDataName=MulcherShotsHitMP),
	(StatName=MortarShotsHitSP, PersistentDataName=MortarShotsHitSP),
	(StatName=MortarShotsHitMP, PersistentDataName=MortarShotsHitMP),
	(StatName=LongshotShotsHitSP, PersistentDataName=LongshotShotsHitSP),
	(StatName=LongshotShotsHitMP, PersistentDataName=LongshotShotsHitMP),
	(StatName=HeavySniperShotsHitSP, PersistentDataName=HeavySniperShotsHitSP),
	(StatName=HeavySniperShotsHitMP, PersistentDataName=HeavySniperShotsHitMP),
	(StatName=HammerOfDawnShotsHitSP, PersistentDataName=HammerOfDawnShotsHitSP),
	(StatName=HammerOfDawnShotsHitMP, PersistentDataName=HammerOfDawnShotsHitMP),
	(StatName=GorgonShotsHitSP, PersistentDataName=GorgonShotsHitSP),
	(StatName=GorgonShotsHitMP, PersistentDataName=GorgonShotsHitMP),
	(StatName=BoltokShotsHitSP, PersistentDataName=BoltokShotsHitSP),
	(StatName=BoltokShotsHitMP, PersistentDataName=BoltokShotsHitMP),
	(StatName=MeleeShotsHitSP, PersistentDataName=MeleeShotsHitSP),
	(StatName=MeleeShotsHitMP, PersistentDataName=MeleeShotsHitMP),
	(StatName=ChainsawShotsHitSP, PersistentDataName=ChainsawShotsHitSP),
	(StatName=ChainsawShotsHitMP, PersistentDataName=ChainsawShotsHitMP),
	(StatName=BayonetShotsHitSP, PersistentDataName=BayonetShotsHitSP),
	(StatName=BayonetShotsHitMP, PersistentDataName=BayonetShotsHitMP),
	(StatName=RetroLancerShotsHitSP, PersistentDataName=RetroLancerShotsHitSP),
	(StatName=RetroLancerShotsHitMP, PersistentDataName=RetroLancerShotsHitMP),
	(StatName=GnasherShotsHitSP, PersistentDataName=GnasherShotsHitSP),
	(StatName=GnasherShotsHitMP, PersistentDataName=GnasherShotsHitMP),
	(StatName=SawedOffShotgunShotsHitSP, PersistentDataName=SawedOffShotgunShotsHitSP),
	(StatName=SawedOffShotgunShotsHitMP, PersistentDataName=SawedOffShotgunShotsHitMP),
	(StatName=RipperShotsHitSP, PersistentDataName=RipperShotsHitSP),
	(StatName=RipperShotsHitMP, PersistentDataName=RipperShotsHitMP),
	(StatName=SilverbackMinigunShotsHitSP, PersistentDataName=SilverbackMinigunShotsHitSP),
	(StatName=SilverbackMinigunShotsHitMP, PersistentDataName=SilverbackMinigunShotsHitMP),
	(StatName=SilverbackRocketLauncherShotsHitSP, PersistentDataName=SilverbackRocketLauncherShotsHitSP),
	(StatName=SilverbackRocketLauncherShotsHitMP, PersistentDataName=SilverbackRocketLauncherShotsHitMP),
	(StatName=MultiLancerShotsHitSP, PersistentDataName=MultiLancerShotsHitSP),
	(StatName=MultiLancerShotsHitMP, PersistentDataName=MultiLancerShotsHitMP),
	(StatName=MultiRetroShotsHitSP, PersistentDataName=MultiRetroShotsHitSP),
	(StatName=MultiRetroShotsHitMP, PersistentDataName=MultiRetroShotsHitMP),
	(StatName=MultiHammerburstShotsHitSP, PersistentDataName=MultiHammerburstShotsHitSP),
	(StatName=MultiHammerburstShotsHitMP, PersistentDataName=MultiHammerburstShotsHitMP),
	(StatName=MultiBoomshotShotsHitSP, PersistentDataName=MultiBoomshotShotsHitSP),
	(StatName=MultiBoomshotShotsHitMP, PersistentDataName=MultiBoomshotShotsHitMP),
	(StatName=MultiGnasherShotsHitSP, PersistentDataName=MultiGnasherShotsHitSP),
	(StatName=MultiGnasherShotsHitMP, PersistentDataName=MultiGnasherShotsHitMP),
	(StatName=SubmarineTurretShotsHitSP, PersistentDataName=SubmarineTurretShotsHitSP),
	(StatName=SubmarineTurretShotsHitMP, PersistentDataName=SubmarineTurretShotsHitMP),
	(StatName=LancerARSuccessSP, PersistentDataName=LancerARSuccessSP),
	(StatName=LancerARSuccessMP, PersistentDataName=LancerARSuccessMP),
	(StatName=HammerburstARSuccessSP, PersistentDataName=HammerburstARSuccessSP),
	(StatName=HammerburstARSuccessMP, PersistentDataName=HammerburstARSuccessMP),
	(StatName=CogPistolARSuccessSP, PersistentDataName=CogPistolARSuccessSP),
	(StatName=CogPistolARSuccessMP, PersistentDataName=CogPistolARSuccessMP),
	(StatName=FlailARSuccessSP, PersistentDataName=FlailARSuccessSP),
	(StatName=FlailARSuccessMP, PersistentDataName=FlailARSuccessMP),
	(StatName=BoomshotARSuccessSP, PersistentDataName=BoomshotARSuccessSP),
	(StatName=BoomshotARSuccessMP, PersistentDataName=BoomshotARSuccessMP),
	(StatName=ScorcherARSuccessSP, PersistentDataName=ScorcherARSuccessSP),
	(StatName=ScorcherARSuccessMP, PersistentDataName=ScorcherARSuccessMP),
	(StatName=TorqueBowARSuccessSP, PersistentDataName=TorqueBowARSuccessSP),
	(StatName=TorqueBowARSuccessMP, PersistentDataName=TorqueBowARSuccessMP),
	(StatName=CleaverARSuccessSP, PersistentDataName=CleaverARSuccessSP),
	(StatName=CleaverARSuccessMP, PersistentDataName=CleaverARSuccessMP),
	(StatName=DiggerLauncherARSuccessSP, PersistentDataName=DiggerLauncherARSuccessSP),
	(StatName=DiggerLauncherARSuccessMP, PersistentDataName=DiggerLauncherARSuccessMP),
	(StatName=FragGrenadeARSuccessSP, PersistentDataName=FragGrenadeARSuccessSP),
	(StatName=FragGrenadeARSuccessMP, PersistentDataName=FragGrenadeARSuccessMP),
	(StatName=IncendiaryGrenadeARSuccessSP, PersistentDataName=IncendiaryGrenadeARSuccessSP),
	(StatName=IncendiaryGrenadeARSuccessMP, PersistentDataName=IncendiaryGrenadeARSuccessMP),
	(StatName=InkGrenadeARSuccessSP, PersistentDataName=InkGrenadeARSuccessSP),
	(StatName=InkGrenadeARSuccessMP, PersistentDataName=InkGrenadeARSuccessMP),
	(StatName=CoopMinigunARSuccessSP, PersistentDataName=CoopMinigunARSuccessSP),
	(StatName=CoopMinigunARSuccessMP, PersistentDataName=CoopMinigunARSuccessMP),
	(StatName=MulcherARSuccessSP, PersistentDataName=MulcherARSuccessSP),
	(StatName=MulcherARSuccessMP, PersistentDataName=MulcherARSuccessMP),
	(StatName=MortarARSuccessSP, PersistentDataName=MortarARSuccessSP),
	(StatName=MortarARSuccessMP, PersistentDataName=MortarARSuccessMP),
	(StatName=LongshotARSuccessSP, PersistentDataName=LongshotARSuccessSP),
	(StatName=LongshotARSuccessMP, PersistentDataName=LongshotARSuccessMP),
	(StatName=HeavySniperARSuccessSP, PersistentDataName=HeavySniperARSuccessSP),
	(StatName=HeavySniperARSuccessMP, PersistentDataName=HeavySniperARSuccessMP),
	(StatName=HammerOfDawnARSuccessSP, PersistentDataName=HammerOfDawnARSuccessSP),
	(StatName=HammerOfDawnARSuccessMP, PersistentDataName=HammerOfDawnARSuccessMP),
	(StatName=GorgonARSuccessSP, PersistentDataName=GorgonARSuccessSP),
	(StatName=GorgonARSuccessMP, PersistentDataName=GorgonARSuccessMP),
	(StatName=BoltokARSuccessSP, PersistentDataName=BoltokARSuccessSP),
	(StatName=BoltokARSuccessMP, PersistentDataName=BoltokARSuccessMP),
	(StatName=MeleeARSuccessSP, PersistentDataName=MeleeARSuccessSP),
	(StatName=MeleeARSuccessMP, PersistentDataName=MeleeARSuccessMP),
	(StatName=ChainsawARSuccessSP, PersistentDataName=ChainsawARSuccessSP),
	(StatName=ChainsawARSuccessMP, PersistentDataName=ChainsawARSuccessMP),
	(StatName=BayonetARSuccessSP, PersistentDataName=BayonetARSuccessSP),
	(StatName=BayonetARSuccessMP, PersistentDataName=BayonetARSuccessMP),
	(StatName=RetroLancerARSuccessSP, PersistentDataName=RetroLancerARSuccessSP),
	(StatName=RetroLancerARSuccessMP, PersistentDataName=RetroLancerARSuccessMP),
	(StatName=GnasherARSuccessSP, PersistentDataName=GnasherARSuccessSP),
	(StatName=GnasherARSuccessMP, PersistentDataName=GnasherARSuccessMP),
	(StatName=SawedOffShotgunARSuccessSP, PersistentDataName=SawedOffShotgunARSuccessSP),
	(StatName=SawedOffShotgunARSuccessMP, PersistentDataName=SawedOffShotgunARSuccessMP),
	(StatName=RipperARSuccessSP, PersistentDataName=RipperARSuccessSP),
	(StatName=RipperARSuccessMP, PersistentDataName=RipperARSuccessMP),
	(StatName=SilverbackMinigunARSuccessSP, PersistentDataName=SilverbackMinigunARSuccessSP),
	(StatName=SilverbackMinigunARSuccessMP, PersistentDataName=SilverbackMinigunARSuccessMP),
	(StatName=SilverbackRocketLauncherARSuccessSP, PersistentDataName=SilverbackRocketLauncherARSuccessSP),
	(StatName=SilverbackRocketLauncherARSuccessMP, PersistentDataName=SilverbackRocketLauncherARSuccessMP),
	(StatName=MultiLancerARSuccessSP, PersistentDataName=MultiLancerARSuccessSP),
	(StatName=MultiLancerARSuccessMP, PersistentDataName=MultiLancerARSuccessMP),
	(StatName=MultiRetroARSuccessSP, PersistentDataName=MultiRetroARSuccessSP),
	(StatName=MultiRetroARSuccessMP, PersistentDataName=MultiRetroARSuccessMP),
	(StatName=MultiHammerburstARSuccessSP, PersistentDataName=MultiHammerburstARSuccessSP),
	(StatName=MultiHammerburstARSuccessMP, PersistentDataName=MultiHammerburstARSuccessMP),
	(StatName=MultiBoomshotARSuccessSP, PersistentDataName=MultiBoomshotARSuccessSP),
	(StatName=MultiBoomshotARSuccessMP, PersistentDataName=MultiBoomshotARSuccessMP),
	(StatName=MultiGnasherARSuccessSP, PersistentDataName=MultiGnasherARSuccessSP),
	(StatName=MultiGnasherARSuccessMP, PersistentDataName=MultiGnasherARSuccessMP),
	(StatName=SubmarineTurretARSuccessSP, PersistentDataName=SubmarineTurretARSuccessSP),
	(StatName=SubmarineTurretARSuccessMP, PersistentDataName=SubmarineTurretARSuccessMP),
	(StatName=LancerARSuperSuccessSP, PersistentDataName=LancerARSuperSuccessSP),
	(StatName=LancerARSuperSuccessMP, PersistentDataName=LancerARSuperSuccessMP),
	(StatName=HammerburstARSuperSuccessSP, PersistentDataName=HammerburstARSuperSuccessSP),
	(StatName=HammerburstARSuperSuccessMP, PersistentDataName=HammerburstARSuperSuccessMP),
	(StatName=CogPistolARSuperSuccessSP, PersistentDataName=CogPistolARSuperSuccessSP),
	(StatName=CogPistolARSuperSuccessMP, PersistentDataName=CogPistolARSuperSuccessMP),
	(StatName=FlailARSuperSuccessSP, PersistentDataName=FlailARSuperSuccessSP),
	(StatName=FlailARSuperSuccessMP, PersistentDataName=FlailARSuperSuccessMP),
	(StatName=BoomshotARSuperSuccessSP, PersistentDataName=BoomshotARSuperSuccessSP),
	(StatName=BoomshotARSuperSuccessMP, PersistentDataName=BoomshotARSuperSuccessMP),
	(StatName=ScorcherARSuperSuccessSP, PersistentDataName=ScorcherARSuperSuccessSP),
	(StatName=ScorcherARSuperSuccessMP, PersistentDataName=ScorcherARSuperSuccessMP),
	(StatName=TorqueBowARSuperSuccessSP, PersistentDataName=TorqueBowARSuperSuccessSP),
	(StatName=TorqueBowARSuperSuccessMP, PersistentDataName=TorqueBowARSuperSuccessMP),
	(StatName=CleaverARSuperSuccessSP, PersistentDataName=CleaverARSuperSuccessSP),
	(StatName=CleaverARSuperSuccessMP, PersistentDataName=CleaverARSuperSuccessMP),
	(StatName=DiggerLauncherARSuperSuccessSP, PersistentDataName=DiggerLauncherARSuperSuccessSP),
	(StatName=DiggerLauncherARSuperSuccessMP, PersistentDataName=DiggerLauncherARSuperSuccessMP),
	(StatName=FragGrenadeARSuperSuccessSP, PersistentDataName=FragGrenadeARSuperSuccessSP),
	(StatName=FragGrenadeARSuperSuccessMP, PersistentDataName=FragGrenadeARSuperSuccessMP),
	(StatName=IncendiaryGrenadeARSuperSuccessSP, PersistentDataName=IncendiaryGrenadeARSuperSuccessSP),
	(StatName=IncendiaryGrenadeARSuperSuccessMP, PersistentDataName=IncendiaryGrenadeARSuperSuccessMP),
	(StatName=InkGrenadeARSuperSuccessSP, PersistentDataName=InkGrenadeARSuperSuccessSP),
	(StatName=InkGrenadeARSuperSuccessMP, PersistentDataName=InkGrenadeARSuperSuccessMP),
	(StatName=CoopMinigunARSuperSuccessSP, PersistentDataName=CoopMinigunARSuperSuccessSP),
	(StatName=CoopMinigunARSuperSuccessMP, PersistentDataName=CoopMinigunARSuperSuccessMP),
	(StatName=MulcherARSuperSuccessSP, PersistentDataName=MulcherARSuperSuccessSP),
	(StatName=MulcherARSuperSuccessMP, PersistentDataName=MulcherARSuperSuccessMP),
	(StatName=MortarARSuperSuccessSP, PersistentDataName=MortarARSuperSuccessSP),
	(StatName=MortarARSuperSuccessMP, PersistentDataName=MortarARSuperSuccessMP),
	(StatName=LongshotARSuperSuccessSP, PersistentDataName=LongshotARSuperSuccessSP),
	(StatName=LongshotARSuperSuccessMP, PersistentDataName=LongshotARSuperSuccessMP),
	(StatName=HeavySniperARSuperSuccessSP, PersistentDataName=HeavySniperARSuperSuccessSP),
	(StatName=HeavySniperARSuperSuccessMP, PersistentDataName=HeavySniperARSuperSuccessMP),
	(StatName=HammerOfDawnARSuperSuccessSP, PersistentDataName=HammerOfDawnARSuperSuccessSP),
	(StatName=HammerOfDawnARSuperSuccessMP, PersistentDataName=HammerOfDawnARSuperSuccessMP),
	(StatName=GorgonARSuperSuccessSP, PersistentDataName=GorgonARSuperSuccessSP),
	(StatName=GorgonARSuperSuccessMP, PersistentDataName=GorgonARSuperSuccessMP),
	(StatName=BoltokARSuperSuccessSP, PersistentDataName=BoltokARSuperSuccessSP),
	(StatName=BoltokARSuperSuccessMP, PersistentDataName=BoltokARSuperSuccessMP),
	(StatName=MeleeARSuperSuccessSP, PersistentDataName=MeleeARSuperSuccessSP),
	(StatName=MeleeARSuperSuccessMP, PersistentDataName=MeleeARSuperSuccessMP),
	(StatName=ChainsawARSuperSuccessSP, PersistentDataName=ChainsawARSuperSuccessSP),
	(StatName=ChainsawARSuperSuccessMP, PersistentDataName=ChainsawARSuperSuccessMP),
	(StatName=BayonetARSuperSuccessSP, PersistentDataName=BayonetARSuperSuccessSP),
	(StatName=BayonetARSuperSuccessMP, PersistentDataName=BayonetARSuperSuccessMP),
	(StatName=RetroLancerARSuperSuccessSP, PersistentDataName=RetroLancerARSuperSuccessSP),
	(StatName=RetroLancerARSuperSuccessMP, PersistentDataName=RetroLancerARSuperSuccessMP),
	(StatName=GnasherARSuperSuccessSP, PersistentDataName=GnasherARSuperSuccessSP),
	(StatName=GnasherARSuperSuccessMP, PersistentDataName=GnasherARSuperSuccessMP),
	(StatName=SawedOffShotgunARSuperSuccessSP, PersistentDataName=SawedOffShotgunARSuperSuccessSP),
	(StatName=SawedOffShotgunARSuperSuccessMP, PersistentDataName=SawedOffShotgunARSuperSuccessMP),
	(StatName=RipperARSuperSuccessSP, PersistentDataName=RipperARSuperSuccessSP),
	(StatName=RipperARSuperSuccessMP, PersistentDataName=RipperARSuperSuccessMP),
	(StatName=SilverbackMinigunARSuperSuccessSP, PersistentDataName=SilverbackMinigunARSuperSuccessSP),
	(StatName=SilverbackMinigunARSuperSuccessMP, PersistentDataName=SilverbackMinigunARSuperSuccessMP),
	(StatName=SilverbackRocketLauncherARSuperSuccessSP, PersistentDataName=SilverbackRocketLauncherARSuperSuccessSP),
	(StatName=SilverbackRocketLauncherARSuperSuccessMP, PersistentDataName=SilverbackRocketLauncherARSuperSuccessMP),
	(StatName=MultiLancerARSuperSuccessSP, PersistentDataName=MultiLancerARSuperSuccessSP),
	(StatName=MultiLancerARSuperSuccessMP, PersistentDataName=MultiLancerARSuperSuccessMP),
	(StatName=MultiRetroARSuperSuccessSP, PersistentDataName=MultiRetroARSuperSuccessSP),
	(StatName=MultiRetroARSuperSuccessMP, PersistentDataName=MultiRetroARSuperSuccessMP),
	(StatName=MultiHammerburstARSuperSuccessSP, PersistentDataName=MultiHammerburstARSuperSuccessSP),
	(StatName=MultiHammerburstARSuperSuccessMP, PersistentDataName=MultiHammerburstARSuperSuccessMP),
	(StatName=MultiBoomshotARSuperSuccessSP, PersistentDataName=MultiBoomshotARSuperSuccessSP),
	(StatName=MultiBoomshotARSuperSuccessMP, PersistentDataName=MultiBoomshotARSuperSuccessMP),
	(StatName=MultiGnasherARSuperSuccessSP, PersistentDataName=MultiGnasherARSuperSuccessSP),
	(StatName=MultiGnasherARSuperSuccessMP, PersistentDataName=MultiGnasherARSuperSuccessMP),
	(StatName=SubmarineTurretARSuperSuccessSP, PersistentDataName=SubmarineTurretARSuperSuccessSP),
	(StatName=SubmarineTurretARSuperSuccessMP, PersistentDataName=SubmarineTurretARSuperSuccessMP),
	(StatName=LancerARFailSP, PersistentDataName=LancerARFailSP),
	(StatName=LancerARFailMP, PersistentDataName=LancerARFailMP),
	(StatName=HammerburstARFailSP, PersistentDataName=HammerburstARFailSP),
	(StatName=HammerburstARFailMP, PersistentDataName=HammerburstARFailMP),
	(StatName=CogPistolARFailSP, PersistentDataName=CogPistolARFailSP),
	(StatName=CogPistolARFailMP, PersistentDataName=CogPistolARFailMP),
	(StatName=FlailARFailSP, PersistentDataName=FlailARFailSP),
	(StatName=FlailARFailMP, PersistentDataName=FlailARFailMP),
	(StatName=BoomshotARFailSP, PersistentDataName=BoomshotARFailSP),
	(StatName=BoomshotARFailMP, PersistentDataName=BoomshotARFailMP),
	(StatName=ScorcherARFailSP, PersistentDataName=ScorcherARFailSP),
	(StatName=ScorcherARFailMP, PersistentDataName=ScorcherARFailMP),
	(StatName=TorqueBowARFailSP, PersistentDataName=TorqueBowARFailSP),
	(StatName=TorqueBowARFailMP, PersistentDataName=TorqueBowARFailMP),
	(StatName=CleaverARFailSP, PersistentDataName=CleaverARFailSP),
	(StatName=CleaverARFailMP, PersistentDataName=CleaverARFailMP),
	(StatName=DiggerLauncherARFailSP, PersistentDataName=DiggerLauncherARFailSP),
	(StatName=DiggerLauncherARFailMP, PersistentDataName=DiggerLauncherARFailMP),
	(StatName=FragGrenadeARFailSP, PersistentDataName=FragGrenadeARFailSP),
	(StatName=FragGrenadeARFailMP, PersistentDataName=FragGrenadeARFailMP),
	(StatName=IncendiaryGrenadeARFailSP, PersistentDataName=IncendiaryGrenadeARFailSP),
	(StatName=IncendiaryGrenadeARFailMP, PersistentDataName=IncendiaryGrenadeARFailMP),
	(StatName=InkGrenadeARFailSP, PersistentDataName=InkGrenadeARFailSP),
	(StatName=InkGrenadeARFailMP, PersistentDataName=InkGrenadeARFailMP),
	(StatName=CoopMinigunARFailSP, PersistentDataName=CoopMinigunARFailSP),
	(StatName=CoopMinigunARFailMP, PersistentDataName=CoopMinigunARFailMP),
	(StatName=MulcherARFailSP, PersistentDataName=MulcherARFailSP),
	(StatName=MulcherARFailMP, PersistentDataName=MulcherARFailMP),
	(StatName=MortarARFailSP, PersistentDataName=MortarARFailSP),
	(StatName=MortarARFailMP, PersistentDataName=MortarARFailMP),
	(StatName=LongshotARFailSP, PersistentDataName=LongshotARFailSP),
	(StatName=LongshotARFailMP, PersistentDataName=LongshotARFailMP),
	(StatName=HeavySniperARFailSP, PersistentDataName=HeavySniperARFailSP),
	(StatName=HeavySniperARFailMP, PersistentDataName=HeavySniperARFailMP),
	(StatName=HammerOfDawnARFailSP, PersistentDataName=HammerOfDawnARFailSP),
	(StatName=HammerOfDawnARFailMP, PersistentDataName=HammerOfDawnARFailMP),
	(StatName=GorgonARFailSP, PersistentDataName=GorgonARFailSP),
	(StatName=GorgonARFailMP, PersistentDataName=GorgonARFailMP),
	(StatName=BoltokARFailSP, PersistentDataName=BoltokARFailSP),
	(StatName=BoltokARFailMP, PersistentDataName=BoltokARFailMP),
	(StatName=MeleeARFailSP, PersistentDataName=MeleeARFailSP),
	(StatName=MeleeARFailMP, PersistentDataName=MeleeARFailMP),
	(StatName=ChainsawARFailSP, PersistentDataName=ChainsawARFailSP),
	(StatName=ChainsawARFailMP, PersistentDataName=ChainsawARFailMP),
	(StatName=BayonetARFailSP, PersistentDataName=BayonetARFailSP),
	(StatName=BayonetARFailMP, PersistentDataName=BayonetARFailMP),
	(StatName=RetroLancerARFailSP, PersistentDataName=RetroLancerARFailSP),
	(StatName=RetroLancerARFailMP, PersistentDataName=RetroLancerARFailMP),
	(StatName=GnasherARFailSP, PersistentDataName=GnasherARFailSP),
	(StatName=GnasherARFailMP, PersistentDataName=GnasherARFailMP),
	(StatName=SawedOffShotgunARFailSP, PersistentDataName=SawedOffShotgunARFailSP),
	(StatName=SawedOffShotgunARFailMP, PersistentDataName=SawedOffShotgunARFailMP),
	(StatName=RipperARFailSP, PersistentDataName=RipperARFailSP),
	(StatName=RipperARFailMP, PersistentDataName=RipperARFailMP),
	(StatName=SilverbackMinigunARFailSP, PersistentDataName=SilverbackMinigunARFailSP),
	(StatName=SilverbackMinigunARFailMP, PersistentDataName=SilverbackMinigunARFailMP),
	(StatName=SilverbackRocketLauncherARFailSP, PersistentDataName=SilverbackRocketLauncherARFailSP),
	(StatName=SilverbackRocketLauncherARFailMP, PersistentDataName=SilverbackRocketLauncherARFailMP),
	(StatName=MultiLancerARFailSP, PersistentDataName=MultiLancerARFailSP),
	(StatName=MultiLancerARFailMP, PersistentDataName=MultiLancerARFailMP),
	(StatName=MultiRetroARFailSP, PersistentDataName=MultiRetroARFailSP),
	(StatName=MultiRetroARFailMP, PersistentDataName=MultiRetroARFailMP),
	(StatName=MultiHammerburstARFailSP, PersistentDataName=MultiHammerburstARFailSP),
	(StatName=MultiHammerburstARFailMP, PersistentDataName=MultiHammerburstARFailMP),
	(StatName=MultiBoomshotARFailSP, PersistentDataName=MultiBoomshotARFailSP),
	(StatName=MultiBoomshotARFailMP, PersistentDataName=MultiBoomshotARFailMP),
	(StatName=MultiGnasherARFailSP, PersistentDataName=MultiGnasherARFailSP),
	(StatName=MultiGnasherARFailMP, PersistentDataName=MultiGnasherARFailMP),
	(StatName=SubmarineTurretARFailSP, PersistentDataName=SubmarineTurretARFailSP),
	(StatName=SubmarineTurretARFailMP, PersistentDataName=SubmarineTurretARFailMP),
	(StatName=LancerPickupsSP, PersistentDataName=LancerPickupsSP),
	(StatName=LancerPickupsMP, PersistentDataName=LancerPickupsMP),
	(StatName=HammerburstPickupsSP, PersistentDataName=HammerburstPickupsSP),
	(StatName=HammerburstPickupsMP, PersistentDataName=HammerburstPickupsMP),
	(StatName=CogPistolPickupsSP, PersistentDataName=CogPistolPickupsSP),
	(StatName=CogPistolPickupsMP, PersistentDataName=CogPistolPickupsMP),
	(StatName=FlailPickupsSP, PersistentDataName=FlailPickupsSP),
	(StatName=FlailPickupsMP, PersistentDataName=FlailPickupsMP),
	(StatName=BoomshotPickupsSP, PersistentDataName=BoomshotPickupsSP),
	(StatName=BoomshotPickupsMP, PersistentDataName=BoomshotPickupsMP),
	(StatName=ScorcherPickupsSP, PersistentDataName=ScorcherPickupsSP),
	(StatName=ScorcherPickupsMP, PersistentDataName=ScorcherPickupsMP),
	(StatName=TorqueBowPickupsSP, PersistentDataName=TorqueBowPickupsSP),
	(StatName=TorqueBowPickupsMP, PersistentDataName=TorqueBowPickupsMP),
	(StatName=CleaverPickupsSP, PersistentDataName=CleaverPickupsSP),
	(StatName=CleaverPickupsMP, PersistentDataName=CleaverPickupsMP),
	(StatName=DiggerLauncherPickupsSP, PersistentDataName=DiggerLauncherPickupsSP),
	(StatName=DiggerLauncherPickupsMP, PersistentDataName=DiggerLauncherPickupsMP),
	(StatName=FragGrenadePickupsSP, PersistentDataName=FragGrenadePickupsSP),
	(StatName=FragGrenadePickupsMP, PersistentDataName=FragGrenadePickupsMP),
	(StatName=IncendiaryGrenadePickupsSP, PersistentDataName=IncendiaryGrenadePickupsSP),
	(StatName=IncendiaryGrenadePickupsMP, PersistentDataName=IncendiaryGrenadePickupsMP),
	(StatName=InkGrenadePickupsSP, PersistentDataName=InkGrenadePickupsSP),
	(StatName=InkGrenadePickupsMP, PersistentDataName=InkGrenadePickupsMP),
	(StatName=CoopMinigunPickupsSP, PersistentDataName=CoopMinigunPickupsSP),
	(StatName=CoopMinigunPickupsMP, PersistentDataName=CoopMinigunPickupsMP),
	(StatName=MulcherPickupsSP, PersistentDataName=MulcherPickupsSP),
	(StatName=MulcherPickupsMP, PersistentDataName=MulcherPickupsMP),
	(StatName=MortarPickupsSP, PersistentDataName=MortarPickupsSP),
	(StatName=MortarPickupsMP, PersistentDataName=MortarPickupsMP),
	(StatName=LongshotPickupsSP, PersistentDataName=LongshotPickupsSP),
	(StatName=LongshotPickupsMP, PersistentDataName=LongshotPickupsMP),
	(StatName=HeavySniperPickupsSP, PersistentDataName=HeavySniperPickupsSP),
	(StatName=HeavySniperPickupsMP, PersistentDataName=HeavySniperPickupsMP),
	(StatName=HammerOfDawnPickupsSP, PersistentDataName=HammerOfDawnPickupsSP),
	(StatName=HammerOfDawnPickupsMP, PersistentDataName=HammerOfDawnPickupsMP),
	(StatName=GorgonPickupsSP, PersistentDataName=GorgonPickupsSP),
	(StatName=GorgonPickupsMP, PersistentDataName=GorgonPickupsMP),
	(StatName=BoltokPickupsSP, PersistentDataName=BoltokPickupsSP),
	(StatName=BoltokPickupsMP, PersistentDataName=BoltokPickupsMP),
	(StatName=MeleePickupsSP, PersistentDataName=MeleePickupsSP),
	(StatName=MeleePickupsMP, PersistentDataName=MeleePickupsMP),
	(StatName=ChainsawPickupsSP, PersistentDataName=ChainsawPickupsSP),
	(StatName=ChainsawPickupsMP, PersistentDataName=ChainsawPickupsMP),
	(StatName=BayonetPickupsSP, PersistentDataName=BayonetPickupsSP),
	(StatName=BayonetPickupsMP, PersistentDataName=BayonetPickupsMP),
	(StatName=RetroLancerPickupsSP, PersistentDataName=RetroLancerPickupsSP),
	(StatName=RetroLancerPickupsMP, PersistentDataName=RetroLancerPickupsMP),
	(StatName=GnasherPickupsSP, PersistentDataName=GnasherPickupsSP),
	(StatName=GnasherPickupsMP, PersistentDataName=GnasherPickupsMP),
	(StatName=SawedOffShotgunPickupsSP, PersistentDataName=SawedOffShotgunPickupsSP),
	(StatName=SawedOffShotgunPickupsMP, PersistentDataName=SawedOffShotgunPickupsMP),
	(StatName=RipperPickupsSP, PersistentDataName=RipperPickupsSP),
	(StatName=RipperPickupsMP, PersistentDataName=RipperPickupsMP),
	(StatName=SilverbackMinigunPickupsSP, PersistentDataName=SilverbackMinigunPickupsSP),
	(StatName=SilverbackMinigunPickupsMP, PersistentDataName=SilverbackMinigunPickupsMP),
	(StatName=SilverbackRocketLauncherPickupsSP, PersistentDataName=SilverbackRocketLauncherPickupsSP),
	(StatName=SilverbackRocketLauncherPickupsMP, PersistentDataName=SilverbackRocketLauncherPickupsMP),
	(StatName=MultiLancerPickupsSP, PersistentDataName=MultiLancerPickupsSP),
	(StatName=MultiLancerPickupsMP, PersistentDataName=MultiLancerPickupsMP),
	(StatName=MultiRetroPickupsSP, PersistentDataName=MultiRetroPickupsSP),
	(StatName=MultiRetroPickupsMP, PersistentDataName=MultiRetroPickupsMP),
	(StatName=MultiHammerburstPickupsSP, PersistentDataName=MultiHammerburstPickupsSP),
	(StatName=MultiHammerburstPickupsMP, PersistentDataName=MultiHammerburstPickupsMP),
	(StatName=MultiBoomshotPickupsSP, PersistentDataName=MultiBoomshotPickupsSP),
	(StatName=MultiBoomshotPickupsMP, PersistentDataName=MultiBoomshotPickupsMP),
	(StatName=MultiGnasherPickupsSP, PersistentDataName=MultiGnasherPickupsSP),
	(StatName=MultiGnasherPickupsMP, PersistentDataName=MultiGnasherPickupsMP),
	(StatName=SubmarineTurretPickupsSP, PersistentDataName=SubmarineTurretPickupsSP),
	(StatName=SubmarineTurretPickupsMP, PersistentDataName=SubmarineTurretPickupsMP),
	(StatName=LancerHoldingDeathSP, PersistentDataName=LancerHoldingDeathSP),
	(StatName=LancerHoldingDeathMP, PersistentDataName=LancerHoldingDeathMP),
	(StatName=HammerburstHoldingDeathSP, PersistentDataName=HammerburstHoldingDeathSP),
	(StatName=HammerburstHoldingDeathMP, PersistentDataName=HammerburstHoldingDeathMP),
	(StatName=CogPistolHoldingDeathSP, PersistentDataName=CogPistolHoldingDeathSP),
	(StatName=CogPistolHoldingDeathMP, PersistentDataName=CogPistolHoldingDeathMP),
	(StatName=FlailHoldingDeathSP, PersistentDataName=FlailHoldingDeathSP),
	(StatName=FlailHoldingDeathMP, PersistentDataName=FlailHoldingDeathMP),
	(StatName=BoomshotHoldingDeathSP, PersistentDataName=BoomshotHoldingDeathSP),
	(StatName=BoomshotHoldingDeathMP, PersistentDataName=BoomshotHoldingDeathMP),
	(StatName=ScorcherHoldingDeathSP, PersistentDataName=ScorcherHoldingDeathSP),
	(StatName=ScorcherHoldingDeathMP, PersistentDataName=ScorcherHoldingDeathMP),
	(StatName=TorqueBowHoldingDeathSP, PersistentDataName=TorqueBowHoldingDeathSP),
	(StatName=TorqueBowHoldingDeathMP, PersistentDataName=TorqueBowHoldingDeathMP),
	(StatName=CleaverHoldingDeathSP, PersistentDataName=CleaverHoldingDeathSP),
	(StatName=CleaverHoldingDeathMP, PersistentDataName=CleaverHoldingDeathMP),
	(StatName=DiggerLauncherHoldingDeathSP, PersistentDataName=DiggerLauncherHoldingDeathSP),
	(StatName=DiggerLauncherHoldingDeathMP, PersistentDataName=DiggerLauncherHoldingDeathMP),
	(StatName=FragGrenadeHoldingDeathSP, PersistentDataName=FragGrenadeHoldingDeathSP),
	(StatName=FragGrenadeHoldingDeathMP, PersistentDataName=FragGrenadeHoldingDeathMP),
	(StatName=IncendiaryGrenadeHoldingDeathSP, PersistentDataName=IncendiaryGrenadeHoldingDeathSP),
	(StatName=IncendiaryGrenadeHoldingDeathMP, PersistentDataName=IncendiaryGrenadeHoldingDeathMP),
	(StatName=InkGrenadeHoldingDeathSP, PersistentDataName=InkGrenadeHoldingDeathSP),
	(StatName=InkGrenadeHoldingDeathMP, PersistentDataName=InkGrenadeHoldingDeathMP),
	(StatName=CoopMinigunHoldingDeathSP, PersistentDataName=CoopMinigunHoldingDeathSP),
	(StatName=CoopMinigunHoldingDeathMP, PersistentDataName=CoopMinigunHoldingDeathMP),
	(StatName=MulcherHoldingDeathSP, PersistentDataName=MulcherHoldingDeathSP),
	(StatName=MulcherHoldingDeathMP, PersistentDataName=MulcherHoldingDeathMP),
	(StatName=MortarHoldingDeathSP, PersistentDataName=MortarHoldingDeathSP),
	(StatName=MortarHoldingDeathMP, PersistentDataName=MortarHoldingDeathMP),
	(StatName=LongshotHoldingDeathSP, PersistentDataName=LongshotHoldingDeathSP),
	(StatName=LongshotHoldingDeathMP, PersistentDataName=LongshotHoldingDeathMP),
	(StatName=HeavySniperHoldingDeathSP, PersistentDataName=HeavySniperHoldingDeathSP),
	(StatName=HeavySniperHoldingDeathMP, PersistentDataName=HeavySniperHoldingDeathMP),
	(StatName=HammerOfDawnHoldingDeathSP, PersistentDataName=HammerOfDawnHoldingDeathSP),
	(StatName=HammerOfDawnHoldingDeathMP, PersistentDataName=HammerOfDawnHoldingDeathMP),
	(StatName=GorgonHoldingDeathSP, PersistentDataName=GorgonHoldingDeathSP),
	(StatName=GorgonHoldingDeathMP, PersistentDataName=GorgonHoldingDeathMP),
	(StatName=BoltokHoldingDeathSP, PersistentDataName=BoltokHoldingDeathSP),
	(StatName=BoltokHoldingDeathMP, PersistentDataName=BoltokHoldingDeathMP),
	(StatName=MeleeHoldingDeathSP, PersistentDataName=MeleeHoldingDeathSP),
	(StatName=MeleeHoldingDeathMP, PersistentDataName=MeleeHoldingDeathMP),
	(StatName=ChainsawHoldingDeathSP, PersistentDataName=ChainsawHoldingDeathSP),
	(StatName=ChainsawHoldingDeathMP, PersistentDataName=ChainsawHoldingDeathMP),
	(StatName=BayonetHoldingDeathSP, PersistentDataName=BayonetHoldingDeathSP),
	(StatName=BayonetHoldingDeathMP, PersistentDataName=BayonetHoldingDeathMP),
	(StatName=RetroLancerHoldingDeathSP, PersistentDataName=RetroLancerHoldingDeathSP),
	(StatName=RetroLancerHoldingDeathMP, PersistentDataName=RetroLancerHoldingDeathMP),
	(StatName=GnasherHoldingDeathSP, PersistentDataName=GnasherHoldingDeathSP),
	(StatName=GnasherHoldingDeathMP, PersistentDataName=GnasherHoldingDeathMP),
	(StatName=SawedOffShotgunHoldingDeathSP, PersistentDataName=SawedOffShotgunHoldingDeathSP),
	(StatName=SawedOffShotgunHoldingDeathMP, PersistentDataName=SawedOffShotgunHoldingDeathMP),
	(StatName=RipperHoldingDeathSP, PersistentDataName=RipperHoldingDeathSP),
	(StatName=RipperHoldingDeathMP, PersistentDataName=RipperHoldingDeathMP),
	(StatName=SilverbackMinigunHoldingDeathSP, PersistentDataName=SilverbackMinigunHoldingDeathSP),
	(StatName=SilverbackMinigunHoldingDeathMP, PersistentDataName=SilverbackMinigunHoldingDeathMP),
	(StatName=SilverbackRocketLauncherHoldingDeathSP, PersistentDataName=SilverbackRocketLauncherHoldingDeathSP),
	(StatName=SilverbackRocketLauncherHoldingDeathMP, PersistentDataName=SilverbackRocketLauncherHoldingDeathMP),
	(StatName=MultiLancerHoldingDeathSP, PersistentDataName=MultiLancerHoldingDeathSP),
	(StatName=MultiLancerHoldingDeathMP, PersistentDataName=MultiLancerHoldingDeathMP),
	(StatName=MultiRetroHoldingDeathSP, PersistentDataName=MultiRetroHoldingDeathSP),
	(StatName=MultiRetroHoldingDeathMP, PersistentDataName=MultiRetroHoldingDeathMP),
	(StatName=MultiHammerburstHoldingDeathSP, PersistentDataName=MultiHammerburstHoldingDeathSP),
	(StatName=MultiHammerburstHoldingDeathMP, PersistentDataName=MultiHammerburstHoldingDeathMP),
	(StatName=MultiBoomshotHoldingDeathSP, PersistentDataName=MultiBoomshotHoldingDeathSP),
	(StatName=MultiBoomshotHoldingDeathMP, PersistentDataName=MultiBoomshotHoldingDeathMP),
	(StatName=MultiGnasherHoldingDeathSP, PersistentDataName=MultiGnasherHoldingDeathSP),
	(StatName=MultiGnasherHoldingDeathMP, PersistentDataName=MultiGnasherHoldingDeathMP),
	(StatName=SubmarineTurretHoldingDeathSP, PersistentDataName=SubmarineTurretHoldingDeathSP),
	(StatName=SubmarineTurretHoldingDeathMP, PersistentDataName=SubmarineTurretHoldingDeathMP),
	(StatName=BloodmountKillsArcade, PersistentDataName=BloodmountKillsArcade),
	(StatName=BloodmountKillsHorde, PersistentDataName=BloodmountKillsHorde),
	(StatName=WretchKillsArcade, PersistentDataName=WretchKillsArcade),
	(StatName=WretchKillsHorde, PersistentDataName=WretchKillsHorde),
	(StatName=DroneKillsArcade, PersistentDataName=DroneKillsArcade),
	(StatName=DroneKillsHorde, PersistentDataName=DroneKillsHorde),
	(StatName=SniperKillsArcade, PersistentDataName=SniperKillsArcade),
	(StatName=SniperKillsHorde, PersistentDataName=SniperKillsHorde),
	(StatName=TickerKillsArcade, PersistentDataName=TickerKillsArcade),
	(StatName=TickerKillsHorde, PersistentDataName=TickerKillsHorde),
	(StatName=GunkerKillsArcade, PersistentDataName=GunkerKillsArcade),
	(StatName=GunkerKillsHorde, PersistentDataName=GunkerKillsHorde),
	(StatName=HunterKillsArcade, PersistentDataName=HunterKillsArcade),
	(StatName=HunterKillsHorde, PersistentDataName=HunterKillsHorde),
	(StatName=TheronKillsArcade, PersistentDataName=TheronKillsArcade),
	(StatName=TheronKillsHorde, PersistentDataName=TheronKillsHorde),
	(StatName=KantusKillsArcade, PersistentDataName=KantusKillsArcade),
	(StatName=KantusKillsHorde, PersistentDataName=KantusKillsHorde),
	(StatName=KantusArmorKillsArcade, PersistentDataName=KantusArmorKillsArcade),
	(StatName=KantusArmorKillsHorde, PersistentDataName=KantusArmorKillsHorde),
	(StatName=BoomerKillsArcade, PersistentDataName=BoomerKillsArcade),
	(StatName=BoomerKillsHorde, PersistentDataName=BoomerKillsHorde),
	(StatName=BoomerFlameKillsArcade, PersistentDataName=BoomerFlameKillsArcade),
	(StatName=BoomerFlameKillsHorde, PersistentDataName=BoomerFlameKillsHorde),
	(StatName=BoomerFlailKillsArcade, PersistentDataName=BoomerFlailKillsArcade),
	(StatName=BoomerFlailKillsHorde, PersistentDataName=BoomerFlailKillsHorde),
	(StatName=BoomerGatlingKillsArcade, PersistentDataName=BoomerGatlingKillsArcade),
	(StatName=BoomerGatlingKillsHorde, PersistentDataName=BoomerGatlingKillsHorde),
	(StatName=BoomerButcherKillsArcade, PersistentDataName=BoomerButcherKillsArcade),
	(StatName=BoomerButcherKillsHorde, PersistentDataName=BoomerButcherKillsHorde),
	(StatName=BerserkerKillsArcade, PersistentDataName=BerserkerKillsArcade),
	(StatName=BerserkerKillsHorde, PersistentDataName=BerserkerKillsHorde),
	(StatName=BerserkerLambentKillsArcade, PersistentDataName=BerserkerLambentKillsArcade),
	(StatName=BerserkerLambentKillsHorde, PersistentDataName=BerserkerLambentKillsHorde),
	(StatName=CorpserKillsArcade, PersistentDataName=CorpserKillsArcade),
	(StatName=CorpserKillsHorde, PersistentDataName=CorpserKillsHorde),
	(StatName=CorpserBabyKillsArcade, PersistentDataName=CorpserBabyKillsArcade),
	(StatName=CorpserBabyKillsHorde, PersistentDataName=CorpserBabyKillsHorde),
	(StatName=SavageDroneKillsArcade, PersistentDataName=SavageDroneKillsArcade),
	(StatName=SavageDroneKillsHorde, PersistentDataName=SavageDroneKillsHorde),
	(StatName=SavageBoomerKillsArcade, PersistentDataName=SavageBoomerKillsArcade),
	(StatName=SavageBoomerKillsHorde, PersistentDataName=SavageBoomerKillsHorde),
	(StatName=SavageHunterKillsArcade, PersistentDataName=SavageHunterKillsArcade),
	(StatName=SavageHunterKillsHorde, PersistentDataName=SavageHunterKillsHorde),
	(StatName=SavageTheronKillsArcade, PersistentDataName=SavageTheronKillsArcade),
	(StatName=SavageTheronKillsHorde, PersistentDataName=SavageTheronKillsHorde),
	(StatName=SerapedeKillsArcade, PersistentDataName=SerapedeKillsArcade),
	(StatName=SerapedeKillsHorde, PersistentDataName=SerapedeKillsHorde),
	(StatName=LambentPolypKillsArcade, PersistentDataName=LambentPolypKillsArcade),
	(StatName=LambentPolypKillsHorde, PersistentDataName=LambentPolypKillsHorde),
	(StatName=LambentDroneKillsArcade, PersistentDataName=LambentDroneKillsArcade),
	(StatName=LambentDroneKillsHorde, PersistentDataName=LambentDroneKillsHorde),
	(StatName=LambentHumanKillsArcade, PersistentDataName=LambentHumanKillsArcade),
	(StatName=LambentHumanKillsHorde, PersistentDataName=LambentHumanKillsHorde),
	(StatName=LambentLocustFormerKillsArcade, PersistentDataName=LambentLocustFormerKillsArcade),
	(StatName=LambentLocustFormerKillsHorde, PersistentDataName=LambentLocustFormerKillsHorde),
	(StatName=DrudgeKillsArcade, PersistentDataName=DrudgeKillsArcade),
	(StatName=DrudgeKillsHorde, PersistentDataName=DrudgeKillsHorde),
	(StatName=DrugeHeadWormKillsArcade, PersistentDataName=DrugeHeadWormKillsArcade),
	(StatName=DrugeHeadWormKillsHorde, PersistentDataName=DrugeHeadWormKillsHorde),
	(StatName=ReaverKillsArcade, PersistentDataName=ReaverKillsArcade),
	(StatName=ReaverKillsHorde, PersistentDataName=ReaverKillsHorde),
	(StatName=MarcusKillsSiege, PersistentDataName=MarcusKillsSiege),
	(StatName=DomKillsSiege, PersistentDataName=DomKillsSiege),
	(StatName=BairdKillsSiege, PersistentDataName=BairdKillsSiege),
	(StatName=AnyaKillsSiege, PersistentDataName=AnyaKillsSiege),
	(StatName=SamKillsSiege, PersistentDataName=SamKillsSiege),
	(StatName=DizzyKillsSiege, PersistentDataName=DizzyKillsSiege),
	(StatName=CarmineKillsSiege, PersistentDataName=CarmineKillsSiege),
	(StatName=ClaytonCarmineKillsSiege, PersistentDataName=ClaytonCarmineKillsSiege),
	(StatName=JaceKillsSiege, PersistentDataName=JaceKillsSiege),
	(StatName=PrescottKillsSiege, PersistentDataName=PrescottKillsSiege),
	(StatName=TaiKillsSiege, PersistentDataName=TaiKillsSiege),
	(StatName=ColeKillsSiege, PersistentDataName=ColeKillsSiege),
	(StatName=HoffmanKillsSiege, PersistentDataName=HoffmanKillsSiege),
	(StatName=CogKillsSiege, PersistentDataName=CogKillsSiege),
	(StatName=StrandedKillsSiege, PersistentDataName=StrandedKillsSiege),
	(StatName=TokensEarned, PersistentDataName=TokensEarned),
	(StatName=TokensSpent, PersistentDataName=TokensSpent),
	(StatName=Beast1Kills, PersistentDataName=Beast1Kills),
	(StatName=Beast2Kills, PersistentDataName=Beast2Kills),
	(StatName=Beast3Kills, PersistentDataName=Beast3Kills),
	(StatName=Beast4Kills, PersistentDataName=Beast4Kills),
	(StatName=Beast5Kills, PersistentDataName=Beast5Kills),
	(StatName=Beast6Kills, PersistentDataName=Beast6Kills),
	(StatName=Beast7Kills, PersistentDataName=Beast7Kills),
	(StatName=Beast8Kills, PersistentDataName=Beast8Kills),
	(StatName=Beast9Kills, PersistentDataName=Beast9Kills),
	(StatName=Beast10Kills, PersistentDataName=Beast10Kills),
	(StatName=Beast11Kills, PersistentDataName=Beast11Kills),
	(StatName=Beast12Kills, PersistentDataName=Beast12Kills),
	(StatName=Beast13Kills, PersistentDataName=Beast13Kills),
	(StatName=Beast14Kills, PersistentDataName=Beast14Kills),
	(StatName=Beast15Kills, PersistentDataName=Beast15Kills),
	(StatName=Beast16Kills, PersistentDataName=Beast16Kills),
	(StatName=Beast1Spawns, PersistentDataName=Beast1Spawns),
	(StatName=Beast2Spawns, PersistentDataName=Beast2Spawns),
	(StatName=Beast3Spawns, PersistentDataName=Beast3Spawns),
	(StatName=Beast4Spawns, PersistentDataName=Beast4Spawns),
	(StatName=Beast5Spawns, PersistentDataName=Beast5Spawns),
	(StatName=Beast6Spawns, PersistentDataName=Beast6Spawns),
	(StatName=Beast7Spawns, PersistentDataName=Beast7Spawns),
	(StatName=Beast8Spawns, PersistentDataName=Beast8Spawns),
	(StatName=Beast9Spawns, PersistentDataName=Beast9Spawns),
	(StatName=Beast10Spawns, PersistentDataName=Beast10Spawns),
	(StatName=Beast11Spawns, PersistentDataName=Beast11Spawns),
	(StatName=Beast12Spawns, PersistentDataName=Beast12Spawns),
	(StatName=Beast13Spawns, PersistentDataName=Beast13Spawns),
	(StatName=Beast14Spawns, PersistentDataName=Beast14Spawns),
	(StatName=Beast15Spawns, PersistentDataName=Beast15Spawns),
	(StatName=Beast16Spawns, PersistentDataName=Beast16Spawns),
	(StatName=CashEarned, PersistentDataName=CashEarned),
	(StatName=CashSpent, PersistentDataName=CashSpent),
	(StatName=WallDestroyed, PersistentDataName=WallDestroyed),
	(StatName=CommandCenterDestroyed, PersistentDataName=CommandCenterDestroyed),
	(StatName=DecoyDestroyed, PersistentDataName=DecoyDestroyed),
	(StatName=FlagDestroyed, PersistentDataName=FlagDestroyed),
	(StatName=SentryDestroyed, PersistentDataName=SentryDestroyed),
	(StatName=SilverbackDestroyed, PersistentDataName=SilverbackDestroyed),
	(StatName=TurretDestroyed, PersistentDataName=TurretDestroyed),
	(StatName=WallSpent, PersistentDataName=WallSpent),
	(StatName=CommandCenterSpent, PersistentDataName=CommandCenterSpent),
	(StatName=DecoySpent, PersistentDataName=DecoySpent),
	(StatName=FlagSpent, PersistentDataName=FlagSpent),
	(StatName=SentrySpent, PersistentDataName=SentrySpent),
	(StatName=SilverbackSpent, PersistentDataName=SilverbackSpent),
	(StatName=TurretSpent, PersistentDataName=TurretSpent),
		)}
}
