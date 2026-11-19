/**
 * Personal Progression Scene
 *
 * Show the player their progression over the past match
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_PersonalProgression extends GearGFxMoviePlayer
	config(UI);

`include(GearPlayerPersistentDataConstants.uci)

//Localized strings
var localized String TotalString;
var localized String ExpTitle;
var localized String LevelUpString;
var localized String LevelDownString;
var localized String StatNumTitle;
var localized String ExpGainTitle;
var localized String RibbonsTitle;
var localized String MedalsTitle;

//Localized strings for experience buckets
var localized array<string> ExpBucketNames;

//String to display as the button text
var String ButtonString;

//Reference to the main bag
var GFxObject MainBag;

//Reference to the label that displays the time left before the next round starts
var GFxObject TimeLeftLabel;

//Cached last time value shown in TimeLeftLabel, so we don't update the label needlessly
var int LastTimeShown;

//Whether or not the movie has started exiting
var bool bStartedExiting;

//Whether or not the tutorial has finished entering
var private bool bHasFinishedEntering;

//The amount of exp the player had before the round started
var int StartingExp;


//Timing Config Variables
//var config int ExpPerItemTallyTime_MSEC;
var config int TimeToFillExpBar_MSEC;
var config int MinTimeToTally_MSEC;
var config int RibbonPerItemTallyTime_MSEC;
var config int RibbonBreakTime_MSEC;
var config int MedalPerItemTallyTime_MSEC;
var config int MedalBreakTime_MSEC;
var config int BetweenScreenWaitTime_MSEC;
var config int DingWaitTime_MSEC;

/** 
 *  This should be called when a new GFxMoviePlayer is initialized.  Handles the setting up of the LocalPlayerIndex, as well as automatically starting / advancing the movie if desired 
 *
 *  @param LocPlay - The LocalPlayer that owns this movie
 */
function Init(optional LocalPlayer LocPlay)
{
	super.Init(LocPlay);
	GetGearPC().GetAlertManager().AlertMovie.bPersonalProgressionMode = true;
}

event OnClose()
{
	GetGearPC().GetAlertManager().AlertMovie.bPersonalProgressionMode = false;
	super.OnClose();
}

/** Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("Progression WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
	case 'MainBag':
		MainBag = Widget;
		//MainBag.SetFloat("ExpPerItemTallyTime",ExpPerItemTallyTime_MSEC);
		MainBag.SetFloat("TimeToFillExpBar",TimeToFillExpBar_MSEC);
		MainBag.SetFloat("MinTimeToTally",MinTimeToTally_MSEC);
		MainBag.SetFloat("RibbonPerItemTallyTime",RibbonPerItemTallyTime_MSEC);
		MainBag.SetFloat("RibbonBreakTime",RibbonBreakTime_MSEC);
		MainBag.SetFloat("MedalPerItemTallyTime",MedalPerItemTallyTime_MSEC);
		MainBag.SetFloat("MedalBreakTime",MedalBreakTime_MSEC);
		MainBag.SetFloat("BetweenScreenWaitTime",BetweenScreenWaitTime_MSEC);
		MainBag.SetFloat("DingWaitTime",DingWaitTime_MSEC);
		break;
	case 'lbl_Time':
		TimeLeftLabel = Widget;
		TimeLeftLabel.SetText("");
		break;
	default:
		return false;
	}
	return true;
}

/**
 * Callback after all widgets have been initialized in a frame
 */
function PostWidgetInit()
{
	local array<ASValue> args;
	local ASValue ASVal;

	local GearPC MyGearPC;
	local GearPRI PRI;
	local GearAward EquippedMedal;
	local int CurrentExp, CurrentLevel, NextLevelExp, CurrentLevelExp;

	MyGearPC = GetGearPC();

	//EXP
	StartingExp = MyGearPC.StatManager.PrevXP;
	CurrentExp = MyGearPC.StatManager.GetStatValueByName('XP');
	if (StartingExp == -1)
	{
		StartingExp = CurrentExp;
	}
	CurrentLevel = MyGearPC.StatManager.DetermineLevel(StartingExp,CurrentLevelExp,NextLevelExp);
	//Now that we've used PrevXP, set it to the current level of XP so we can reuse it for the next game
	MyGearPC.StatManager.PrevXP = CurrentExp;

	//Setup all of the gfx data for each subscreen
	SetupExp(CurrentExp-StartingExp);
	SetupRibbons();
	SetupMedals();

	/**
	 * Execute the AS function:
	 * Initialize(PlayerName:String, TotalString:String, ExpString:String, LevelString:String, Level:Number, InitialExp:Number, ThisLevelExp:Number, NextLevelExp:Number)
	 */

	//PlayerName
	ASVal.Type = AS_String;
	ASVal.s = GetPC().PlayerReplicationInfo.PlayerName;
	args.AddItem(ASVal);

	PRI = MyGearPC.GetPRI();
	if (PRI != none)
	{
		EquippedMedal = MyGearPC.AwardManager.FindAwardByPersistentDataID(PRI.MedalID);
	}

	//PlayerTitle
	if (EquippedMedal != none)
	{
		ASVal.s = class'GearAward'.static.GetTitleString(EquippedMedal.AwardName);
	}
	else
	{
		ASVal.s = "";
	}
	args.AddItem(ASVal);

	//PlayerMedalImg
	if (EquippedMedal != none)
	{
		ASVal.s = "img://" $ EquippedMedal.IconPath;
	}
	else
	{
		ASVal.s = "";
	}
	args.AddItem(ASVal);

	//PlayerMedalRank
	ASVal.Type = AS_Number;
	if (EquippedMedal != none)
	{
		ASVal.n = EquippedMedal.MedalRank;
	}
	else
	{
		ASVal.n = 0;
	}
	args.AddItem(ASVal);

	//TotalString
	ASVal.Type = AS_String;
	ASVal.s = TotalString;
	args.AddItem(ASVal);

	//ExpTitle
	ASVal.s = ExpTitle;
	args.AddItem(ASVal);

	//StatNumTitle
	ASVal.s = StatNumTitle;
	args.AddItem(ASVal);

	//ExpGainTitle
	ASVal.s = ExpGainTitle;
	args.AddItem(ASVal);

	//RibbonsTitle
	ASVal.s = RibbonsTitle;
	args.AddItem(ASVal);

	//MedalsTitle
	ASVal.s = MedalsTitle;
	args.AddItem(ASVal);

	//Level
	ASVal.Type = AS_Number;
	ASVal.n = CurrentLevel;
	args.AddItem(ASVal);

	//InitialExp
	ASVal.n = StartingExp;
	args.AddItem(ASVal);

	//ThisLevelExp
	ASVal.n = CurrentLevelExp;
	args.AddItem(ASVal);

	//NextLevelExp
	ASVal.n = NextLevelExp;
	args.AddItem(ASVal);

	MainBag.Invoke("Initialize",args);
}

/**
 * Delegate that updates the time left label
 *
 * @param   DeltaTime   Amount of time the movie has advanced
 */
function UpdateTime(float DeltaTime)
{
	local GearGRI GRI;
	local GearPC MyGearPC;

	if (TimeLeftLabel != none)
	{
		GRI = GearGRI(GetWorldInfo().GRI);

		if (GRI != none)
		{
			if (GRI.RoundTime != LastTimeShown)
			{
				LastTimeShown = GRI.RoundTime;
				TimeLeftLabel.SetText(String(LastTimeShown));
				//If we just turned to 0, close the scene!
				if (LastTimeShown == 0)
				{
					MyGearPC = GetGearPC();
					if (MyGearPC != none && MyGearPC.MyGearHud != none)
					{
						GearHUDMP_Base(MyGearPC.MyGearHud).CloseProgressionScene();
					}
				}
			}
		}
	}
}

/**
 * Sets up the GFx data structures necessary for the Exp screen
 * @param DeltaExp - The change in exp that this screen is going to explain
 */
function SetupExp(int DeltaExp)
{
	local GFxObject ExpSources, SourceItem;
	local int i, NumBucketsSkipped, StatAmount;
	local GearMPPRI PRI;

	PRI = GearMPPRI(GetPC().PlayerReplicationInfo);

	/** 
	 * Array of Exp source objects. Expected to be set directly from unrealscript.
	 * 
	 * Exp source objects have the following member vars:
	 * 
	 * Name : the localzed name of the category of experience this source represents
	 * ExpAmount : the amount of experience earned through this category
	 * StatAmount : the amount of the relevant stat that caused the amount of exp to be earned
	 */
	ExpSources = CreateArray();

	i = 0;
	NumBucketsSkipped = 0;

	for (i = 0; i < ArrayCount(PRI.ExpBuckets); i++)
	{
		if (i == eEXP_Awards)
		{
			NumBucketsSkipped++;
		}
		else
		{
			SourceItem = CreateObject("Object");
			SourceItem.SetString("Name", ExpBucketNames[i]);
			SourceItem.SetFloat("ExpAmount", PRI.ExpBuckets[i]);

			switch (i)
			{
			case eEXP_Kills:
				StatAmount = PRI.Score_Kills + PRI.Score_Takedowns;
				break;
			case eEXP_Revives:
				StatAmount = PRI.Score_Revives;
				break;
			case eEXP_Objectives:
				StatAmount = PRI.Score_GameSpecific1 + PRI.Score_GameSpecific2 + PRI.Score_GameSpecific3 + PRI.Score_GameSpecific4;
				break;
			case eEXP_Executions:
				StatAmount = PRI.NumExecutions;
				break;
			case eEXP_WinBonus:
				StatAmount = 0;
				break;
			case eEXP_ParticipationBonus:
				StatAmount = 0;
				break;
			case eEXP_QuitPenalty:
				StatAmount = 0;
				break;
			}
			
			SourceItem.SetFloat("StatAmount", StatAmount);
			ExpSources.SetElementObject(i-NumBucketsSkipped,SourceItem);
		}
	}

	MainBag.SetObject("ExpSources",ExpSources);
}

/**
 * Sets up the GFx data structures necessary for the Ribbons screen
 */
function SetupRibbons()
{
	local GFxObject Ribbons, RibbonItem;
	local int i, j, length;
	local GearStatManager StatManager;
	local GearAward Award;
	local string AwardName;
	local bool bIsDupe;

	/**
	 * Array of ribbon objects. Expected to be set directly from unrealscript.
	 * 
	 * Ribbon objects have the following member vars:
	 * 
	 * Name : the localized name of the ribbon
	 * PicPath : the path to the image of the ribbon
	 * Num : the number earned for this ribbon type
	 * Exp : number of exp earned by this group of ribbons
	 */
	Ribbons = CreateArray();

	i = 0;

	//Awards
	StatManager = GetGearPC().StatManager;
	if (StatManager != None)
	{
		foreach StatManager.EarnedAwards(Award)
		{
			switch (Award.AwardType)
			{
				case GEARAWARDTYPE_Ribbon:
					bIsDupe = false;
					//Get the name
					AwardName = class'GearAward'.static.GetNameString(Award.AwardName);
					//Get the length
					length = Ribbons.GetFloat("length");
					//Iterate over all ribbons we've already done to see if its a dupe
					//If it is, increment that ribbons' number
					for (j = 0; j < length; j++)
					{
						if (AwardName == Ribbons.GetElementMemberString(j,"Name"))
						{
							Ribbons.SetElementMemberFloat(j,"Num", Ribbons.GetElementMemberFloat(j,"Num") + 1);
							Ribbons.SetElementMemberFloat(j,"Exp", Ribbons.GetElementMemberFloat(j,"Exp") + Award.ExpBonus);
							bIsDupe = true;
							break;
						}
					}
					//If it's not a dupe, make a new entry!
					if (!bIsDupe)
					{
						RibbonItem = CreateObject("Object");
						RibbonItem.SetString("Name", AwardName);
						RibbonItem.SetString("PicPath", "img://"$Award.IconPath);
						RibbonItem.SetFloat("Num", 1);
						RibbonItem.SetFloat("Exp", Award.ExpBonus);
						Ribbons.SetElementObject(i,RibbonItem);
						i++;
					}
					break;
				default:
					break;
			}
		}
	}

	MainBag.SetObject("Ribbons",Ribbons);
}

/**
 * Sets up the GFx data structures necessary for the Medals screen
 */
function SetupMedals()
{
	local GFxObject Medals, MedalItem;
	local int i;
	local GearStatManager StatManager;
	local GearAward Award;

	/**
	 * Array of medal objects. Expected to be set directly from unrealscript.
	 * 
	 * Medal objects have the following member vars:
	 * 
	 * Name : the localized name of the medal
	 * PicPath : the path to the image of the medal
	 * Title : The title that goes along with this medal
	 * Level : rank of this medal
	 * Exp : exp earned from this medal
	 */
	Medals = CreateArray();

	i = 0;

	StatManager = GetGearPC().StatManager;
	if (StatManager != None)
	{
		foreach StatManager.EarnedAwards(Award)
		{
			switch (Award.AwardType)
			{
				case GEARAWARDTYPE_Medal:
					MedalItem = CreateObject("Object");
					MedalItem.SetString("Name", class'GearAward'.static.GetNameString(Award.AwardName));
					MedalItem.SetString("PicPath", "img://"$Award.IconPath);
					MedalItem.SetString("Title",class'GearAward'.static.GetTitleString(Award.AwardName));
					MedalItem.SetFloat("Level", Award.MedalRank);
					MedalItem.SetFloat("Exp", Award.ExpBonus);
					Medals.SetElementObject(i,MedalItem);
					i++;
					break;
				default:
					break;
			}
		}
	}

	MainBag.SetObject("Medals",Medals);
}

/**
 * This function is called by actionscript when it thinks that the experience tally has resulted in a level up
 * It is a request for information regarding how much experience the player will need to get to the next level
 * The correct way to respond is to invoke back into actionscript using the function "LevelUpUpdate"
 */
function Callback_LevelUp(float ExpEarned)
{
	local array<ASValue> args;
	local ASValue ASVal;
	local int NewLevel, CurrentLevelExp, NextLevelExp;
	local GearPC MyGearPC;

	MyGearPC = GetGearPC();

	NewLevel = MyGearPC.StatManager.DetermineLevel(StartingExp+ExpEarned,CurrentLevelExp, NextLevelExp);

	//NewLevel
	ASVal.Type = AS_Number;
	ASVal.n = NewLevel;
	args.AddItem(ASVal);

	//ThisLevelExp
	ASVal.n = CurrentLevelExp;
	args.AddItem(ASVal);

	//NextLevelExp
	ASVal.n = NextLevelExp;
	args.AddItem(ASVal);

	//LevelUpString
	ASVal.Type = AS_String;
	ASVal.s = LevelUpString;
	args.AddItem(ASVal);

	//LevelDownString
	ASVal.s = LevelDownString;
	args.AddItem(ASVal);

	//public function LevelUpUpdate(NewLevel:Number, NewThisLevelExp:Number, NewNextLevelExp:Number, TitleString:String)
	MainBag.Invoke("LevelUpUpdate",args);
}


//Callback from actionscript when the scene has finished exiting
function Callback_Finished()
{
	local GearPC MyGearPC;

	MyGearPC = GetGearPC();
	if (MyGearPC != none && MyGearPC.MyGearHud != none)
	{
		// Close the personal progression scene in the HUD, which will open up the scoreboard
		GearHUDMP_Base(MyGearPC.MyGearHud).CloseProgressionScene();
	}
}



defaultproperties
{
	Priority=GEAR_SCENE_PRIORITY_MPSCENE

	CaptureKeys.Empty()
	bAllowInput=false
	bAllowFocus=false
	bOnlyOwnerFocusable=true

	OnPostAdvance=UpdateTime

	bEnableMenuPostProcess=TRUE
	bPostProcessForAllLocalPlayers=TRUE
}
