/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// CheatManager
// Object within playercontroller that manages "cheat" commands
// only spawned in single player mode
//=============================================================================

class GearCheatManager extends CheatManager within GearPC
	native;

`include(GearPlayerPersistentDataConstants.uci)
`include(GearLeaderboardConstants.uci)

var transient protected bool bDebugGUDSStreaming;

var transient bool bIronSightsEnabled;

/** for testing player storage read/write */
var transient OnlinePlayerStorage TestPlayerStorage;

/** for testing leaderboard read/write */
var transient OnlineStatsRead StatsRead;

struct native SpawnPawnInfo
{
	var	String			PawnName;
	var String			ClassName;
	var class<GearAI>	AIClass;
	var byte TeamNum;

	structdefaultproperties
	{
		TeamNum=255
	}
};
var	Array<SpawnPawnInfo>	SpawnPawnList;

var transient bool bMPCheats;

var() editinline GearExplosion TestBoom;

/** true to enable rendering of mesh beacon stats on screen */
var bool bDebugRenderMeshBeacon;

// forces log output (even in FINAL_RELEASE) use with caution!
function native static ForceLog(coerce string s, optional name LogTag);

function native bool FindSpawnInfoFromAIFactory(string PawnName, out class<Pawn> out_PawnClass, out class<AIController> out_ControllerClass, out byte TeamNum);

`if(`notdefined(FINAL_RELEASE))

/** Overridden to skip PendingClientWeaponSet stuff for debug weapons. */
simulated function Weapon GiveWeapon( String WeaponClassStr )
{
	local Weapon W;
	local class<Weapon> WeaponClass;

	WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassStr, class'Class'));
	if (Pawn.FindInventoryType(WeaponClass) == None)
	{
		W = super.GiveWeapon(WeaponClassStr);
		W.GotoState('Inactive');
		return W;
	}

	return Super.GiveWeapon(WeaponClassStr);
}

exec function GiveShield()
{
	Pawn.CreateInventory(class<GearShield>(DynamicLoadObject("GearGameContent.BoomerShield", class'Class')));
}

/** Give player all available weapons */
exec function AllWeapons()
{
	local bool						bOldWeaponCountEnforcement;
	local GearInventoryManager		GIM;

	if( (WorldInfo.NetMode!=NM_Standalone && !bMPCheats) || (Pawn == None) )
	{
		return;
	}

	// tell inv manager we're cheating and allowing >4 weapons
	GIM = GearInventoryManager(Pawn.InvManager);
	bOldWeaponCountEnforcement = GIM.bDebugIgnoreWeaponCountLimit;
	GIM.bDebugIgnoreWeaponCountLimit = TRUE;

	// COG Weapons
	GiveWeapon("GearGame.GearWeap_COGPistol");
	GiveWeapon("GearGame.GearWeap_AssaultRifle");
	GiveWeapon("GearGame.GearWeap_Shotgun");
	GiveWeapon("GearGame.GearWeap_Shotgun_SawedOff");
	GiveWeapon("GearGame.GearWeap_SniperRifle");
	GiveWeapon("GearGame.GearWeap_Boomshot");
	GiveWeapon("GearGameContentWeapons.GearWeap_HOD");
	GiveWeapon("GearGameContentWeapons.GearWeap_FlameThrower");
	GiveWeapon("GearGame.GearWeap_RetroLancer");
	GiveWeapon("GearGameContentWeapons.GearWeap_DiggerLauncher_Content");
	GiveWeapon("GearGameContentWeapons.GearWeap_HeavySniper");
	GiveWeapon("GearGameContentWeapons.GearWeap_HeavyMortar");
	// Locust weapons
	GiveWeapon("GearGame.GearWeap_LocustPistol");
	GiveWeapon("GearGameContentWeapons.GearWeap_LocustBurstPistol");
	GiveWeapon("GearGame.GearWeap_LocustAssaultRifle");
	GiveWeapon("GearGame.GearWeap_Bow");
	GiveWeapon("GearGameContentWeapons.GearWeap_Cleaver");
	GiveWeapon("GearGameContentWeapons.GearWeap_HeavyFlail");
	GiveWeapon("GearGameContentWeapons.GearWeap_Ripper_Content");


	// Grenades
	GiveWeapon("GearGame.GearWeap_FragGrenade");
	GiveWeapon("GearGameContentWeapons.GearWeap_InkGrenade");
	GiveWeapon("GearGameContentWeapons.GearWeap_IncendiaryGrenade");
	GiveWeapon("GearGame.GearWeap_SmokeGrenade");

	// back to weaponcount-enforcing behavior
	GIM.bDebugIgnoreWeaponCountLimit = bOldWeaponCountEnforcement;

	Outer.bWeaponsLoaded = true;
}

exec function SetSticks(int StickConfig)
{
	GearPRI(PlayerReplicationInfo).StickConfig = EGearStickConfigOpts(StickConfig);
	UpdateControllerConfig();
}


/** Toggle between the normal control scheme and the alternate one that separates going into and out of cover */
exec function ToggleControls()
{
	SetAlternateControls(!bUseAlternateControls);
	ClientMessage( bUseAlternateControls ? "Alternate Controls" : "Normal Controls" );
}

/** Sets maximum ammo on all weapons */
exec function AllAmmo()
{
	local GearWeapon	Weap;

	if (Pawn == None)
		return;

	ForEach Pawn.InvManager.InventoryActors(class'GearWeapon', Weap)
	{
		Weap.SpareAmmoCount = Weap.WeaponMaxSpareAmmo;
		Weap.AmmoUsedCount	= 0;
	}
}

/**
 * DanS function for prototyping the OnlineCommunityContentInterface
 */
exec function InitCommunityContent()
{
	local OnlineCommunityContentInterface CommunityContent;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		`if(`notdefined(FINAL_RELEASE))
			bWasSuccessful = CommunityContent.Init();
			`Log("CommunityContent.Init() returned "$bWasSuccessful);
		`else
			CommunityContent.Init();
		`endif
	}
}

/**
 * DanS function for prototyping the OnlineCommunityContentInterface
 */
exec function ExitCommunityContent()
{
	local OnlineCommunityContentInterface CommunityContent;

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		CommunityContent.Exit();
		`Log("CommunityContent.Exit()");
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
exec function ReadContentList()
{
	local OnlineCommunityContentInterface CommunityContent;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		CommunityContent.AddReadContentListCompleteDelegate(ReadContentListComplete);
		`if(`notdefined(FINAL_RELEASE))
			bWasSuccessful = CommunityContent.ReadContentList(0, 0, 100);
			`Log("CommunityContent.ReadContentList() returned "$bWasSuccessful);
		`else
				CommunityContent.ReadContentList(0, 0, 100);
		`endif
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
function ReadContentListComplete(bool bWasSuccessful)
{
	`Log("CommunityContent.ReadContentList() completed, result: "$bWasSuccessful);
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
exec function GetContentList()
{
	local OnlineCommunityContentInterface CommunityContent;
	local array<CommunityContentFile> ContentFiles;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		`if(`notdefined(FINAL_RELEASE))
			bWasSuccessful = CommunityContent.GetContentList(0, ContentFiles);
			`Log("CommunityContent.GetContentList() returned "$bWasSuccessful);
		`else
			CommunityContent.GetContentList(0, ContentFiles);
		`endif
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
exec function ReadFriendsContentList()
{
	local OnlineCommunityContentInterface CommunityContent;
	local array<OnlineFriend> Friends;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		// Check for friends
		OnlineSub.PlayerInterface.GetFriendsList(0, Friends);
		if(Friends.length >= 1)
		{
			CommunityContent.AddReadFriendsContentListCompleteDelegate(ReadFriendsContentListComplete);
			`if(`notdefined(FINAL_RELEASE))
				bWasSuccessful = CommunityContent.ReadFriendsContentList(0, Friends, 0, 100);
				`Log("CommunityContent.ReadFriendsContentList() returned "$bWasSuccessful);
			`else
				CommunityContent.ReadFriendsContentList(0, Friends, 0, 100);
			`endif
		}
		else
		{
			`Log("No friends");
		}
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
function ReadFriendsContentListComplete(bool bWasSuccessful)
{
	`Log("CommunityContent.ReadFriendsContentList() completed, result: "$bWasSuccessful);
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
exec function GetFriendsContentList()
{
	local OnlineCommunityContentInterface CommunityContent;
	local array<CommunityContentFile> ContentFiles;
	local array<OnlineFriend> Friends;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		// Check for friends
		OnlineSub.PlayerInterface.GetFriendsList(0, Friends);
		if(Friends.length >= 1)
		{
			`if(`notdefined(FINAL_RELEASE))
				bWasSuccessful = CommunityContent.GetFriendsContentList(0, Friends[0], ContentFiles);
				`Log("CommunityContent.GetFriendsContentList() returned "$bWasSuccessful);
			`else
				CommunityContent.GetFriendsContentList(0, Friends[0], ContentFiles);
			`endif
		}
		else
		{
			`Log("No friends");
		}
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
/*exec function UploadContent()
{
	local OnlineCommunityContentInterface CommunityContent;
	local int ContentType;
	local array<byte> Payload;
	local int PayloadLength;
	local int Index;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		ContentType = 0;  // test content
		PayloadLength = 100;
		Payload.length = PayloadLength;
		for(Index = 0; Index < PayloadLength; Index++)
		{
			Payload[Index] = Index;
		}
		CommunityContent.AddUploadContentCompleteDelegate(UploadContentComplete);
		`if(`notdefined(FINAL_RELEASE))
			bWasSuccessful = CommunityContent.UploadContent(0,ContentType,Payload);
			`Log("CommunityContent.UploadContent() returned "$bWasSuccessful);
		`else
			CommunityContent.UploadContent(0,ContentType,Payload);
		`endif
	}
}*/

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
function UploadContentComplete(bool bWasSuccessful,CommunityContentFile UploadedFile)
{
	`Log("CommunityContent.UploadContent() completed for content id: "$UploadedFile.ContentId$", result: "$bWasSuccessful);
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
exec function DownloadContent()
{
	local OnlineCommunityContentInterface CommunityContent;
	local CommunityContentFile DownloadFile;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		CommunityContent.AddDownloadContentCompleteDelegate(DownloadContentComplete);
		DownloadFile.ContentId = 56;
		`if(`notdefined(FINAL_RELEASE))
			bWasSuccessful = CommunityContent.DownloadContent(0,DownloadFile);
			`Log("CommunityContent.DownloadContent() returned "$bWasSuccessful);
		`else
			CommunityContent.DownloadContent(0,DownloadFile);
		`endif
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
function DownloadContentComplete(bool bWasSuccessful,CommunityContentFile DownloadedFile)
{
	`Log("CommunityContent.DownloadContent() completed for content id: "$DownloadedFile.ContentId$", result: "$bWasSuccessful$", size: "$DownloadedFile.FileSize);
	`Log("Downloads: "$DownloadedFile.DownloadCount$", Average Rating: "$DownloadedFile.AverageRating);
	`Log("LastRatingGiven: "$DownloadedFile.LastRatingGiven$", RatingCount: "$DownloadedFile.RatingCount);
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
exec function GetPayload()
{
	local OnlineCommunityContentInterface CommunityContent;
	local CommunityContentFile File;
	`if(`notdefined(FINAL_RELEASE))
		local bool bWasSuccessful;
	`endif

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		CommunityContent.AddGetContentPayloadCompleteDelegate(GetPayloadContentComplete);
		File.ContentId = 56;
		File.FileSize = 100;
		`if(`notdefined(FINAL_RELEASE))
			bWasSuccessful = CommunityContent.GetContentPayload(0,File);
			`Log("CommunityContent.GetContentPayload() returned "$bWasSuccessful);
		`else
			CommunityContent.GetContentPayload(0,File);
		`endif
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
function GetPayloadContentComplete(bool bWasSuccessful,CommunityContentFile FileDownloaded,const out array<byte> Payload)
{
	local int Index;
	`Log("CommunityContent.GetContentPayload() completed for content id: "$FileDownloaded.ContentId$", result: "$bWasSuccessful$", size: "$Payload.length);
	for(Index = 0; Index < Payload.length; Index++)
	{
		if(Payload[Index] != Index)
		{
			`Log("!!Payload doesn't match what was uploaded!!");
		}
	}
}

/**
* DanS function for prototyping the OnlineCommunityContentInterface
*/
exec function RateContent()
{
	local OnlineCommunityContentInterface CommunityContent;
	local CommunityContentFile ContentFile;

	// Ask for the interface by name and cast to our well known type
	CommunityContent = OnlineCommunityContentInterface(OnlineSub.GetNamedInterface('CommunityContent'));
	if (CommunityContent != None)
	{
		ContentFile.ContentId = 56;
		CommunityContent.RateContent(0,ContentFile,100);
	}
}

/** shortcut for the lazy :-) **/
exec function UA()
{
	UnlimitedAmmo();
}

/** Gives all carried weapons unlimited ammo */
exec function UnlimitedAmmo()
{
	local GearWeapon	Weap;

	if( (WorldInfo.NetMode!=NM_Standalone && !bMPCheats) || (Pawn == None) )
		return;

	ClientMessage("Unlimited ammo!");
	if( GearPawn(Pawn) != None )
	{
		GearPawn(Pawn).bUnlimitedAmmo = true;
	}

	ForEach Pawn.InvManager.InventoryActors(class'GearWeapon', Weap)
	{
		Weap.SetInfiniteMagazineSize();	// disable reloads
		Weap.SetInfiniteSpareAmmo();	// unlimited spare ammo
	}
}

/** shortcut for the lazy :) */
exec function UC()
{
	UnlimitedClips();
}

/** gives unlimited clips */
exec function UnlimitedClips()
{
	if( (WorldInfo.NetMode!=NM_Standalone && !bMPCheats) || (Pawn == None) )
		return;

	ClientMessage("Unlimited clips!");
	if( GearPawn(Pawn) != None )
	{
		GearPawn(Pawn).SetUnlimitedClips( TRUE );
	}
}

exec function HUDHate()
{
	MyGearHUD.AddWeaponTakenMessage(PlayerReplicationInfo,class'GDT_ShieldBash');
	MyGearHUD.AddWeaponTakenMessage(PlayerReplicationInfo,class'GDT_FragGrenade');
	MyGearHUD.AddWeaponTakenMessage(PlayerReplicationInfo,class'GDT_FragGrenade');
}

exec function ChangeDifficulty(coerce string NewDifficulty)
{
	local class<DifficultySettings> Difficulty;
	if (NewDifficulty ~= "Casual")
	{
		Difficulty = class'DifficultySettings_Casual';
	}
	else if (NewDifficulty ~= "Normal")
	{
		Difficulty = class'DifficultySettings_Normal';
	}
	else if (NewDifficulty ~= "Hardcore")
	{
		Difficulty = class'DifficultySettings_Hardcore';
	}
	else if (NewDifficulty ~= "Insane")
	{
		Difficulty = class'DifficultySettings_Insane';
	}
	GearPRI(PlayerReplicationInfo).Difficulty = Difficulty;
	Difficulty.static.ApplyDifficultySettings(Outer);
	MyGearPawn.MessagePlayer("OK! changed difficulty to "@Difficulty);
}

/**
* This will give you cash in addition to what CheatManager gives you.
**/
exec function Loaded()
{
	if( WorldInfo.Netmode!=NM_Standalone && !bMPCheats )
		return;

	//Super.Loaded();
	AllWeapons();
	AllAmmo();

	UC();
}

exec function SuperDamage()
{
	ClientMessage("Super damage!");
	MyGearPawn.SuperDamageMultiplier += 8.f;
}

exec function Badass()
{
	UC();
	SuperDamage();
	if (!bGodMode)
	{
		God();
	}
	ClientMessage("Badass!");
}

exec function GodLoaded()
{
	Loaded();
	if (!bGodMode)
	{
		God();
	}
}

exec function Invisible()
{
    Invis();
}
exec function Invis()
{
	local GearAI AI;
	local int Idx;

	bInvisible = !bInvisible;
	ClientMessage( "Invisiblility"@bInvisible );

	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		Idx = AI.TargetList.Find( Pawn );
		if( Idx >= 0 )
		{
			AI.TargetList.Remove( Idx, 1 );
		}

		if( AI.Enemy == Pawn ||
			AI.FireTarget == Pawn )
		{
			AI.SelectTarget();
		}
	}
}
exec function IgnorePlayer() { Invis(); }

exec function CoverHead()
{
	local GearPawn GP;

	`log(self@GetFuncName());

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		GP.Cringe();
	}
}

/**
 * TakeDamage on the controlled pawn
 *
 * @param AmountOfPain - how much damage to give
 */
exec function Pain(int AmountOfPain)
{
	MyGearPawn.TakeDamage(AmountOfPain, None, MyGearPawn.Location, vect(0,0,1), class'GDT_ScriptedDBNO');
}

/**
 * TakeDamage on a team member
 *
 * @param AmountOfPain - how much damage to give
 */
exec function SquadPain(int AmountOfPain)
{
	local GearPawn GP;

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (MyGearPawn != GP && GP.IsSameTeam(MyGearPawn))
		{
			GP.TakeDamage(AmountOfPain, GP.Controller, GP.Location, vect(0,0,1), class'GDT_ScriptedDBNO');
			return;
		}
	}
}

/** Test DBNO, test cubstomp */
exec function ForceDBNO(optional bool bHumansToo, optional bool bDBNOForeverCheat)
{
	local GearPawn GP;

	`log(self@GetFuncName());

	// Forces Pawns to stay DBNO and not auto revive/die
	if( bDBNOForeverCheat )
	{
		GearGame(WorldInfo.Game).bDBNOForeverCheat = TRUE;
	}

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		ForcePawnToDBNO(GP,bHumansToo);
	}
}

function ForcePawnToDBNO(GearPawn InGP, bool bHumans)
{
	local PlayerController PC;

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		break;
	}

	if( (!InGP.IsDBNO()) && (bHumans || GearPC(InGP.Controller) == None) && InGP.bCanDBNO && (InGP.Health > 0) )
	{
		InGP.EnterDBNO(PC, class'GearDamageType', vector(InGP.Rotation));
	}
}

exec function DBNOMyTarget()
{
	local Actor HitActor;
	local vector HitLocation;
	local vector HitNormal;
	local vector TraceStart;
	local vector TraceEnd;
	local Gearpawn GP;


	TraceStart = Pawn.GetPawnViewLocation();
	TraceEnd = TraceStart + Vector(Pawn.GetViewRotation()) * 1024.f;
	HitActor = Trace(Hitlocation,HitNormal,TraceEnd,TraceStart,true);
	if(HitActor == none)
	{
		ClientMessage("Trace didn't hit anything!");
		return;
	}

	GP = GearPawn(HitActor);
	if(GP != none)
	{
		ClientMessage("Forcing "$GP$" to DBNO.");
		ForcePawnToDBNO(GP,true);
	}
	else
	{
		ClientMessage("Trace Didn't hit a GearPawn!");
	}

}

/** DBNO all friends */
exec function DBNOFriends()
{
	local Gearpawn GP;

	if (MyGearPawn != None)
	{
		foreach WorldInfo.AllPawns(class'GearPawn', GP)
		{
			if (MyGearPawn.IsSameTeam(GP) && GP != Pawn)
			{
				ForcePawnToDBNO(GP, true);
			}
		}
	}
}

/** DBNO all enemies */
exec function DBNOEnemies()
{
	local Gearpawn GP;

	if (MyGearPawn != None)
	{
		foreach WorldInfo.AllPawns(class'GearPawn', GP)
		{
			if (!MyGearPawn.IsSameTeam(GP))
			{
				ForcePawnToDBNO(GP, true);
			}
		}
	}
}

exec function KillMyTarget()
{
	local Actor HitActor;
	local vector HitLocation;
	local vector HitNormal;
	local vector TraceStart;
	local vector TraceEnd;
	local Gearpawn GP;


	TraceStart = Pawn.GetPawnViewLocation();
	TraceEnd = TraceStart + Vector(Pawn.GetViewRotation()) * 65535.f;
	HitActor = Trace(Hitlocation,HitNormal,TraceEnd,TraceStart,true);
	if(HitActor == none)
	{
		ClientMessage("Trace didn't hit anything!");
		return;
	}

	GP = GearPawn(HitActor);
	if(GP != none)
	{
		ClientMessage("Killing "$GP$"!");
		GP.ScriptedDeath();
	}
	else
	{
		ClientMessage("Trace Didn't hit a GearPawn!");
	}

}

exec function DBNOMe(optional bool bDBNOForeverCheat)
{
	local GearPawn GP;

	GearGame(WorldInfo.Game).bDBNOForeverCheat = bDBNOForeverCheat;

	GP = MyGearPawn;
	if (GP == None && Turret(Pawn) != None && Turret(Pawn).Driver != None)
	{
		GP = GearPawn(Turret(Pawn).Driver);
	}

	ForcePawnToDBNO(GP, TRUE);
}


exec function TestDueling(optional bool bFollower)
{
	local AIController	AIController;
	local GearPawn		GP;

	`log(self@GetFuncName());

	AIController = SpawnLocust();
	GP = GearPawn(AIController.Pawn);

	// Throw all weapons
	GP.ThrowActiveWeapon();
	GP.DropExtraWeapons( class'GearDamageType' );

	// Give Chainsaws
	GP.CreateInventory(class'GearWeap_AssaultRifle');

	if (bFollower)
	{
		GP.ServerDoSpecialMove(SM_ChainsawDuel_Leader, TRUE, MyGearPawn);
	}
	else
	{
		MyGearPawn.ServerDoSpecialMove(SM_ChainsawDuel_Leader, TRUE, GP);
	}
}

exec function ChainsawMe(optional bool bFromRear)
{
	local AIController	AIController;
	local GearPawn		GP;

	`log(self@GetFuncName());

	AIController = SpawnLocust();
	GP = GearPawn(AIController.Pawn);

	// Throw all weapons
	GP.ThrowActiveWeapon();
	GP.DropExtraWeapons( class'GearDamageType' );

	// Give Chainsaws
	GP.CreateInventory(class'GearWeap_AssaultRifle');

	if (bFromRear)
	{
		GP.ServerDoSpecialMove(SM_ChainSawAttack, TRUE, MyGearPawn);
	}
	else
	{
		GP.ServerDoSpecialMove(SM_ChainSawAttack, TRUE, MyGearPawn, 4);
	}
}

/**
 * Adjusts the free camera distance, for vid capture.
 */
exec function AdjustFreeCamDistance(float Amount)
{
	PlayerCamera.FreeCamDistance += Amount;
}
exec function AdjustFreeCamOffset(float XAmount,float YAmount,float ZAmount)
{
	PlayerCamera.FreeCamOffset.X += XAmount;
	PlayerCamera.FreeCamOffset.Y += YAmount;
	PlayerCamera.FreeCamOffset.Z += ZAmount;
}

simulated exec function TeleportToLocation( float x, float y, float z, int Yaw, int Pitch, int Roll )
{
	local vector        SetLocation;
	local rotator       SetRotation;
	GetPlayerViewPoint( SetLocation, SetRotation );
	SetLocation.X = x;
	SetLocation.Y = y;
	SetLocation.Z = z;
	SetRotation.Yaw = Yaw;

	// Most of the time I just want to set the Yaw and I want the Pitch and Roll to remain the same
	// so passing in -1 for Pitch and -1 for Roll will do that.  Other wise update them as well
	if(Roll !=-1)
	{
		SetRotation.Roll = Roll;
	}
	if(Pitch !=-1)
	{
		SetRotation.Pitch = Pitch;
	}
	ClientSetLocation(SetLocation,SetRotation);
}

/**
 * Toggles between reviving/normal for testing stuffs.
 */
exec function TestReviving( optional bool bDBNOForeverCheat )
{
	if( MyGearPawn.IsDBNO() )
	{
		ServerReviveSelf();
	}
	else
	{
		if (bDBNOForeverCheat)
		{
			GearGame(WorldInfo.Game).bDBNOForeverCheat = bDBNOForeverCheat;
			GearPawn(Pawn).EnterDBNO(Outer, class'GearDamageType', vector(Pawn.Rotation));
		}
		else
		{
			MyGearPawn.PlayBurstDamageWarningSoundSemaphore = TRUE;
			MyGearPawn.TakeDamage(MyGearPawn.Health,None,MyGearPawn.Location,vect(0,0,1),class'GDT_Ballistic');
			MyGearPawn.PlayBurstDamageWarningSoundSemaphore = FALSE;
		}
	}
}

/** Revive DBNO players in the level, for testing. */
exec function Revive()
{
	local GearPawn	GP;

	GearGame(WorldInfo.Game).bDBNOForeverCheat = FALSE;

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if( GP.IsDBNO() )
		{
			GP.DoRevival(GP);
		}
	}
}

exec function SelfRevive()
{
	SetTimer(0.1f, TRUE, nameof(SelfReviveLoop), self);
}

protected function SelfReviveLoop()
{
	if (Outer.IsInState('Reviving'))
	{
		PressedActionButton_Reviving();
	}
	else
	{
		ClearTimer(nameof(SelfReviveLoop), self);
	}
}

exec function AIRevive()
{
	local GearAI AI;
	local GearPC PC;

	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		break;
	}
	foreach LocalPlayerControllers( class'GearPC', PC )
	{
		break;
	}

	if( AI != None && PC != None )
	{
		class'AICmd_Revive'.static.Revive( AI, GearPawn(PC.Pawn) );
	}
}

exec function AIExecute()
{
	local GearAI AI;
	local GearPC PC;

	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		break;
	}
	foreach LocalPlayerControllers( class'GearPC', PC )
	{
		break;
	}

	if( AI != None && PC != None )
	{
		class'AICmd_Execute'.static.Execute( AI, GearPawn(PC.Pawn) );
	}
}


/**
* This will cause us to do the warefare type suicide.  So normal
* suicide will cause the pawn to DIE DIE DIE DIE.  This will emulate
* what happens in Gear when a player is killed.
*
**/
exec function GearSuicide()
{
	// go straight to death
	MyGearPawn.TakeDamage( 10000, None, vect(0,0,0), vect(0,0,0), class'GDT_ScriptedRagdoll' );
}


exec function HeadshotMe()
{
	// go straight to death
	MyGearPawn.TakeDamage( 10000, None, vect(0,0,0), vect(0,0,0), class'GDT_Headshot' );
}

exec function GibMe()
{
	local Controller C, EnemyC;

	// try to find controller on the other team
	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (C.GetTeamNum() != GetTeamNum())
		{
			EnemyC = C;
			break;
		}
	}

	// go straight to death
	MyGearPawn.TakeDamage( 10000, EnemyC, vect(0,0,0), vect(0,0,0), class'GDT_ScriptedGib' );
}


exec function VerifyNavList()
{
	WorldInfo.VerifyNavList();
}

exec function AddAIFilter( coerce string Filter )
{
	local GearAI AI;
	local int Idx;
	local Name N;

	N = Name(Filter);
	foreach WorldInfo.AllControllers(class'GearAI',AI)
	{
		Idx = AI.AILogFilter.Find( N );
		if( Idx < 0 )
		{
			AI.AILogFilter[AI.AILogFilter.Length] = N;
		}
	}
}
exec function RemoveAIFilter( coerce string Filter )
{
	local GearAI AI;
	local int Idx;
	local Name N;

	N = Name(Filter);
	foreach WorldInfo.AllControllers(class'GearAI',AI)
	{
		Idx = AI.AILogFilter.Find( N );
		if( Idx >= 0 )
		{
			Pawn.MessagePlayer( "Removed Filter"@Filter );
			AI.AILogFilter.Remove( Idx, 1 );
		}
	}
}

exec function Teleport()
{
	TeleportToPlayer();
}

exec function TestBloodPool()
{
	MyGearPawn.SpawnBloodPool();
}

/** This will show the current health recharge settings.  usefult for testing difficulty settings **/
exec function ShowHealthRecharge()
{
	`log( "HealthRechargePercentPerSecond: " $ MyGearPawn.HealthRechargePercentPerSecond );
	`log( "HealthRechargeDelay: " $ MyGearPawn.HealthRechargeDelay );
}

exec function SpawnDummy()
{
	SpawnLocust("",true);
}

exec function CmdTest()
{
    local GearAI AI;
    AI = GearAI(SpawnLocust("",true));
//    class'AICmd_MoveToGoal'.static.MoveToPoint( AI, Pawn.Location + vect(300,0,0) );
	class'AICmd_Move_Evade'.static.Evade( AI, SM_EvadeFwd );
}

/** Left this in for legacy reasons. */
exec function AIController SpawnLocust(optional string Type, optional bool bRetarded)
{
	return SpawnPawn(Type, bRetarded);
}

/** Can spawn AI w.r.t string Type and possess the pawn for player. */
exec function bool SpawnPlayerPawn(optional string Type)
{
	local AIController NewAI;
	local Pawn OldPawn;

	NewAI = SpawnPawn(Type, FALSE);

	if (NewAI!=None && NewAI.Pawn!=None)
	{
		// save old pawn
		OldPawn = Pawn;

		Possess(NewAI.Pawn,FALSE);

		// set default game info
		WorldInfo.Game.SetPlayerDefaults(Pawn);

		// destroy old pawn
		if (OldPawn!=None)
		{
			OldPawn.Destroy();
		}

		return TRUE;
	}

	return FALSE;
}

/** Exec command to test layering system in any map. */
exec function TestLayerSystem()
{
	local NavigationPoint Nav;
	local class<Pawn> PawnClass;
	local Pawn NewPawn, OldPawn;

	if (Pawn != None)
	{
		Nav = class'NavigationPoint'.static.GetNearestNavToActor(Pawn,,,128.f);
	}
	if (Nav == None)
	{
		Nav = class'NavigationPoint'.static.GetNearestNavToPoint((Pawn != None) ? Pawn : Outer, (Pawn != None) ? Pawn.Location : Location);
	}
	if (Nav == None)
	{
		if (Pawn != None)
		{
			Nav = Pawn.Anchor;
		}
	}

	PawnClass = class<Pawn>(DynamicLoadObject("GearGameContent.GearPawn_LayeredTestPawn", class'class'));
	NewPawn = Spawn(PawnClass,,,Nav.Location, rotator(Pawn.Location - Nav.Location));

	// detach TargetPawn from its controller and kill its controller.
	NewPawn.DetachFromController( TRUE );

	// detach player from current pawn and possess targetpawn
	if( Pawn != None )
	{
		OldPawn = Pawn;
		Pawn.DetachFromController();
	}

	Possess(NewPawn, FALSE);

	// Destroy our ex pawn
	if( OldPawn != None )
	{
		OldPawn.Destroy();
	}
}

/** Can spawn friendlies or enemies. */
exec function AIController SpawnPawn(optional string Type, optional bool bRetarded)
{
	local NavigationPoint Nav;
	local Pawn NewPawn;
	local AIController NewAI;
	local class<Pawn> PawnClass;
	local class<AIController> AIClass;
	local INT	i;
	local bool	bFound;
	local byte TeamNum;

	if (Pawn != None)
	{
		Nav = class'NavigationPoint'.static.GetNearestNavToActor(Pawn,,,128.f);
	}
	if (Nav == None)
	{
		Nav = class'NavigationPoint'.static.GetNearestNavToPoint((Pawn != None) ? Pawn : Outer, (Pawn != None) ? Pawn.Location : Location);
	}
	if (Nav == None)
	{
		if (Pawn != None)
		{
			Nav = Pawn.Anchor;
		}
	}

	if (Nav != None)
	{
		// See if we can find a matching creature type.
		for(i=0; i<SpawnPawnList.Length; i++)
		{
			if( SpawnPawnList[i].PawnName ~= Type )
			{
				PawnClass = class<Pawn>(DynamicLoadObject(SpawnPawnList[i].ClassName,class'class'));
				AIClass = SpawnPawnList[i].AIClass;
				TeamNum = SpawnPawnList[i].TeamNum;
				bFound = TRUE;
				break;
			}
		}

		if( !bFound )
		{
 			if(!FindSpawnInfoFromAIFactory(Type,PawnClass,AIClass, TeamNum))
			{
				PawnClass = class<Pawn>(DynamicLoadObject("GearGameContent.GearPawn_LocustDrone",class'class'));
				AIClass = class'GearAI_Locust';
				TeamNum = 1;
			}
		}

		if (bRetarded)
		{
			AIClass = class'GearAI';
		}
		if (PawnClass != None && AIClass != None)
		{
			`DLog("Spawning type:" @ Type @ "PawnClass:" @ PawnClass @ "AIClass:" @ AIClass @ "at" @ Nav);

			NewPawn = Spawn(PawnClass,,,Nav.Location,rotator(Pawn.Location - Nav.Location));
			if (NewPawn != None)
			{
				if (Vehicle_Reaver_Base(NewPawn) != None)
				{
					Vehicle_Reaver_Base(NewPawn).ServerBeginLanding(Nav);
				}
				NewAI = Spawn(AIClass);
				if (NewAI != None)
				{
					if (TeamNum != 255)
					{
						NewAI.SetTeam(TeamNum);
					}
					else if (GearAI_COGGear(NewAI) != None)
					{
						NewAI.SetTeam(0);
					}
					else
					{
						NewAI.SetTeam(1);
					}

					NewAI.Possess(NewPawn,FALSE);
					NewPawn.AddDefaultInventory();

					if ( bRetarded && (GearAI(NewAI) != None) )
					{
						GearAI(NewAI).bAllowCombatTransitions = FALSE;
					}
					//@STATS - Record player spawn in (cheat manager)
					`RecordPlayerSpawn(NewAI,NewPawn.Class,NewAI.GetTeamNum());
				    return NewAI;
				}
				else
				{
					NewPawn.Destroy();
				}
			}
		}
	}
    return None;
}

exec function MeleeAI()
{
	local GearAI AI;
	SpawnDummy();
	foreach WorldInfo.AllControllers(class'GearAI',AI)
	{
		AI.SetEnemy(Pawn);
		AI.PushState('SubAction_LoopingMeleeAttack');
	}
}

exec function DumpCommandStacks()
{
	local GearAI AI;
	foreach WorldInfo.AllControllers(class'GearAI', AI )
	{
		AI.DumpCommandStack();
	}
}

exec function DumpPathConstraints()
{
	local GearAI AI;
	foreach WorldInfo.AllControllers(class'GearAI', AI )
	{
		AI.DumpPathConstraints();
	}
}

exec function SteveCheat()
{
	Badass();
	UA();
	DebugSteve();
}

exec function DebugSteve()
{
	DebugAI( 'Default' );
	DebugAI( 'pathing' );
	DebugAI( 'enemy' );
}

exec function Banzai()
{
	class'AICmd_Attack_Banzai'.static.EveryoneAttack(WorldInfo);
}


exec function TestLensFX(string WhichFX)
{
	local GearPC GPC;

	foreach LocalPlayerControllers(class'GearPC', GPC)
	{
		if ( (WhichFX ~= "blood") || (WhichFX ~= "shotgun") )
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Shotgun');
		}
		else if (WhichFX ~= "fire")
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_CameraScorch');
		}
		else if ( (WhichFX ~= "goo") || (WhichFX ~= "imulsion") )
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_Camera_Immulsion');
		}
		else if ( (WhichFX ~= "drip") || (WhichFX ~= "chainsaw") )
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Chainsaw');
		}
		else if (WhichFX ~= "ink")
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_CameraInk');
		}
		else if (WhichFX ~= "hod")
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_CameraHOD');
		}
		else if (WhichFX ~= "drudgevomit")
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_Camera_DrudgeVomit');
		}
		else if (WhichFX ~= "polypsplat")
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_Camera_PolypSplat');
		}
		else if (WhichFX ~= "drudgesplat")
		{
			GPC.ClientSpawnCameraLensEffect(class'Emit_Camera_Drudge_Tent_Splat');
		}
	}


}

exec function TestEnemySpottedGUDS()
{
	local GearPawn EnemyPawn, P;

	// find an enemy
	foreach WorldInfo.AllPawns(class'GearPawn', P)
	{
		if (!MyGearPawn.IsSameTeam(P))
		{
			EnemyPawn = P;
			break;
		}
	}

	if (EnemyPawn != None)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_NoticedEnemyGeneric, Pawn, EnemyPawn);
	}
	else
	{
		`log("*** No enemies found.");
	}
}

/** Toggle GUDS debug info. */
exec function GUDDebug()
{
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.bShowGUDDebugText = !GearGame(WorldInfo.Game).UnscriptedDialogueManager.bShowGUDDebugText;
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.bDebugGUDEvents = GearGame(WorldInfo.Game).UnscriptedDialogueManager.bShowGUDDebugText;
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.bDebugGUDSLogging = !GearGame(WorldInfo.Game).UnscriptedDialogueManager.bDebugGUDSLogging;
	ClientMessage("GUDS debugging set to"@GearGame(WorldInfo.Game).UnscriptedDialogueManager.bShowGUDDebugText);
};

exec function GUDLogging()
{
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.bDebugGUDSLogging = !GearGame(WorldInfo.Game).UnscriptedDialogueManager.bDebugGUDSLogging;
	ClientMessage("GUDS logging set to"@GearGame(WorldInfo.Game).UnscriptedDialogueManager.bDebugGUDSLogging);
}

exec function ScreenshotMode()
{
	local GearPlayerInput_Screenshot NewInput;

	if (GearPlayerInput_Screenshot(PlayerInput) != None)
	{
		PopPlayerInput();
		ClientMessage("Left screenshot mode");
		`log("Left screenshot mode");
	}
	else
	{
		NewInput = new(Outer) class'GearPlayerInput_Screenshot';
		NewInput.OnInputObjectCreate();
		PushPlayerInput(NewInput);
		PlayerInput = NewInput;
		ClientMessage("Entered screenshot mode");
		`log("Entered screenshot mode");
	}
}

exec function TestWeather(Int Type)
{
	GearGRI(WorldInfo.GRI).SetCurrentWeather(EWeatherType(Type));
}

exec function UnlockAchievement( EGearAchievement AchievementId )
{
	`log("Unlocking achievement" @ `showenum(EGearAchievement,AchievementId));
	ClientUnlockAchievement(AchievementId);
}

exec function UnlockAllAchievements()
{
	local int Count;

	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		for (Count = 50; Count > 0; Count--)
		{
			// Read this title's achivements for player 0
			OnlineSub.PlayerInterface.UnlockAchievement(0,Count);
		}
	}
}

exec function UnlockAllGamerpics()
{
	OnlineSub.PlayerInterfaceEx.UnlockGamerPicture(0,1);
	OnlineSub.PlayerInterfaceEx.UnlockGamerPicture(0,2);
}

/** Used to read the achievements for a user */
exec function ReadAchievements( optional int TitleId )
{
	if (OnlineSub != None &&
		OnlineSub.PlayerInterfaceEx != None)
	{
		OnlineSub.PlayerInterface.AddReadAchievementsCompleteDelegate(0,OnReadAchievementsComplete);
		// Read this title's achivements for player 0
		OnlineSub.PlayerInterface.ReadAchievements(0,TitleId);
	}
}

/** Dumps the achievements that were read */
function OnReadAchievementsComplete(int TitleId)
{
	local int Index;
	local array<AchievementDetails> Details;

	OnlineSub.PlayerInterface.ClearReadAchievementsCompleteDelegate(0,OnReadAchievementsComplete);

	OnlineSub.PlayerInterface.GetAchievements(0,Details,TitleId);
	`Log("Found "$Details.Length$" achievements for titleId:" @ TitleId);
	`Log("");
	// Iterate through the achievements and dump them out
	for (Index = 0; Index < Details.Length; Index++)
	{
		`Log("Id = "$Details[Index].Id);
		`Log("Name = "$Details[Index].AchievementName);
		`Log("Description = "$Details[Index].Description);
		`Log("HowTo = "$Details[Index].HowTo);
		`Log("Worth = "$Details[Index].GamerPoints);
		`Log("bIsSecret = "$Details[Index].bIsSecret);
		`Log("bWasAchievedOnline = "$Details[Index].bWasAchievedOnline);
		`Log("bWasAchievedOffline = "$Details[Index].bWasAchievedOffline);
		`Log("");
	}
}

/** Used to read the achievements for a user */
exec function ReadGears1Achievements()
{
	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.AddReadAchievementsCompleteDelegate(0,OnReadAchievementsComplete);
		// Read this title's achivements for player 0
		OnlineSub.PlayerInterface.ReadAchievements(0,0x4D530842);
	}
}

exec function DebugSaveProfile()
{
	SaveProfile();
}

/**
 * Sends the profile to MCP for stats aggregation
 */
exec function UploadProfile()
{
	ProfileSettings.bForceProfileUpload = true;
	UploadProfileToMCP();
}

exec function ClearXP()
{
	StatManager.ModifyStat('XP',0, GEARSTATMODTYPE_Set);
	StatManager.UpdateLevelFromXP();
}

exec function GiveXP(int Amount)
{
	StatManager.ModifyStat('XP',Amount,GEARSTATMODTYPE_Delta);
	StatManager.UpdateLevelFromXP();
}

exec function LogXP()
{
	`Log("Level is "$StatManager.GetStatValueByName('Level'));
	`Log("XP is "$StatManager.GetStatValueByName('XP'));
}

/**
 * Used to test the custom player list
 */
exec function CustomPlayerList()
{
	local array<UniqueNetId> Players;
	local PlayerReplicationInfo PRI;
	local UniqueNetId ZeroId;

	if (OnlineSub != None && OnlineSub.PlayerInterfaceEx != None)
	{
		if (WorldInfo.GRI != None)
		{
			foreach WorldInfo.GRI.PRIArray(PRI)
			{
				if (PRI.UniqueId != ZeroId)
				{
					Players.AddItem(PRI.UniqueId);
				}
			}
		}
		else
		{
			OnlineSub.PlayerInterface.GetUniquePlayerId(0,ZeroId);
			Players.AddItem(ZeroId);
		}
		OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(0,Players,"Joe Rocks","No, really, Joe rocks!");
	}
}

/**
 * Used to test TMS file reading
 */
exec function ReadTMS()
{
	if (OnlineSub != None && OnlineSub.TitleFileInterface != None)
	{
		OnlineSub.TitleFileInterface.ReadTitleFile("*.*");
	}
}

/**
 * Delegate function triggered on completion of player storage read (used for testing)
 */
function OnReadPlayerStorageComplete(byte LocalUserNum,bool bWasSuccessful)
{
	if (bWasSuccessful == true)
	{
		`Log(GetFuncName()$": Successful read of online player storage data for local Id("$LocalUserNum$")");
	}
	else
	{
		`Log(GetFuncName()$": Failed read of online player storage data for local Id("$LocalUserNum$")");
	}
	TestPlayerStorage = None;
	if (OnlineSub != None && OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.ClearReadPlayerStorageCompleteDelegate(LocalUserNum,OnReadPlayerStorageComplete);
	}
}

/**
 * Delegate function triggered on completion of player storage read (used for testing)
 */
function OnReadPlayerStorageForNetIdComplete(UniqueNetId NetId,bool bWasSuccessful)
{
	if (bWasSuccessful == true)
	{
		`Log(GetFuncName()$": Successful read of online player storage data for remote Id("$class'OnlineSubsystem'.static.UniqueNetIdToString(NetId)$")");
	}
	else
	{
		`Log(GetFuncName()$": Failed read of online player storage for remote Id("$class'OnlineSubsystem'.static.UniqueNetIdToString(NetId)$")");
	}
	TestPlayerStorage = None;
	if (OnlineSub != None && OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.ClearReadPlayerStorageForNetIdCompleteDelegate(NetId,OnReadPlayerStorageForNetIdComplete);
	}
}

/**
 * Exec to test player storage read
 */
exec function TestReadPlayerStorage(bool bRemoteUser,int DeviceId)
{
	local OnlinePlayerInterface PlayerInterface;
	local int PlayerControllerId;
	local UniqueNetId ZeroId;


	if (OnlineSub != None)
	{
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			if (TestPlayerStorage == None )
			{
				TestPlayerStorage = new(self) class'OnlinePlayerStorage';
				TestPlayerStorage.DeviceId = DeviceId;
			}
			PlayerControllerId = GetControllerId();
			if (bRemoteUser)
			{
				if (GearPRI(PlayerReplicationInfo) != None &&
					GearPRI(PlayerReplicationInfo).UniqueId != ZeroId)
				{
					PlayerInterface.AddReadPlayerStorageForNetIdCompleteDelegate(GearPRI(PlayerReplicationInfo).UniqueId,OnReadPlayerStorageForNetIdComplete);
					if (PlayerInterface.ReadPlayerStorageForNetId(PlayerControllerId,GearPRI(PlayerReplicationInfo).UniqueId,TestPlayerStorage) == false)
					{
						`Log(GetFuncName()$": Failed to read online player storage data for remote Id("$class'OnlineSubsystem'.static.UniqueNetIdToString(GearPRI(PlayerReplicationInfo).UniqueId)$")");
					}
				}
			}
			else
			{
				PlayerInterface.AddReadPlayerStorageCompleteDelegate(PlayerControllerId,OnReadPlayerStorageComplete);
				if (PlayerInterface.ReadPlayerStorage(PlayerControllerId,TestPlayerStorage,TestPlayerStorage.DeviceId) == false)
				{
					`Log(GetFuncName()$": Failed to read online player storage data for local Id("$PlayerControllerId$")");
				}
			}
		}
	}
}

/**
 * Delegate function triggered on completion of player storage write (used for testing)
 */
function OnWritePlayerStorageComplete(byte LocalUserNum,bool bWasSuccessful)
{
	if (bWasSuccessful == true)
	{
		`Log(GetFuncName()$": Successful write of online player storage data.");
	}
	else
	{
		`Log(GetFuncName()$": Failed write of online player storage data.");
	}
	TestPlayerStorage = None;
	if (OnlineSub != None && OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.ClearWritePlayerStorageCompleteDelegate(LocalUserNum,OnWritePlayerStorageComplete);
	}
}

/**
 * Exec to test player storage writes
 */
exec function TestWritePlayerStorage(int DeviceId)
{
	local OnlinePlayerInterface PlayerInterface;
	local int PlayerControllerId;

	if (OnlineSub != None)
	{
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			PlayerControllerId = GetControllerId();
			PlayerInterface.AddWritePlayerStorageCompleteDelegate(PlayerControllerId,OnWritePlayerStorageComplete);

			if (TestPlayerStorage == None )
			{
				TestPlayerStorage = new(self) class'OnlinePlayerStorage';
				TestPlayerStorage.DeviceId = DeviceId;
			}

			if (PlayerInterface.WritePlayerStorage(PlayerControllerId,TestPlayerStorage,TestPlayerStorage.DeviceId) == false)
			{
				`Log(GetFuncName()$": Failed to write online player storage data for"
					$" PlayerId="$PlayerControllerId
					$" DeviceId="$DeviceId);
			}
		}
	}
}

`if(`notdefined(FINAL_RELEASE))
/*
 *   Test Rich Presence strings by setting the current players rich presence
 * @RPId - Rich presence ID (from GearOnlineConstants.uci)
 * @ChapterOrWave - Chapter for Coop Presence, Wave for Horde/Beast, not used otherwise
 * @CoopPlayerIndex - Player Context Index for Coop Presence (from GearOnlineConstants.uci), not used otherwise
 * @MapName	- Map name, of the form, mp_mapname, for Versus Presence, not used otherwise
 * @MPType - Versus mode, for Versus Presence, not used otherwise
 */
exec function TestRichPresence(int RPId, int ChapterOrWave, int CoopPlayerIndex, string MapName, EGearMPTypes MPType)
{
	local int ActId;
	local int NormalizedChapter;
	local GearCampaignActData ActData;
	local LocalPlayer LP;
	local array<LocalizedStringSetting> StringSettings;
	local array<SettingsProperty> Properties;
	local SettingsProperty Prop;
	local byte MapNameId;

	LP = LocalPlayer(Player);

	switch (RPId)
	{
	case class'GearGame'.const.CONTEXT_PRESENCE_MENUPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_PARTYJOINABLEWAITPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_PARTYPRIVATEWAITPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_SYSTEMLINKPARTYPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_LOCALPARTYPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_RANKEDPARTYSEARCHPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_SOCIALPARTYSEARCHPRESENCE: 
	case class'GearGame'.const.CONTEXT_PRESENCE_CAMPAIGNPARTYSEARCHPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_TRAININGGROUNDSPRESENCE:

		ClientSetRichPresenceString(RPId);
		break;

	case class'GearGame'.const.CONTEXT_PRESENCE_VERSUSPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_PLAYERVERSUSPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_SYSTEMLINKVERSUSPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_PRIVATEVERSUSPRESENCE:

		MapNameId = byte(class'GearLeaderboardSettings'.static.GetMapIdFromName(name(MapName)));
		ClientSetVersusRichPresenceString(RPId, MpType, MapNameId);
		break;

	case class'GearGame'.const.CONTEXT_PRESENCE_HORDEPRESENCE:
	case class'GearGame'.const.CONTEXT_PRESENCE_SIEGEPRESENCE:

		StringSettings.Length = 1;
		// Set the map name for rich presence
		StringSettings[0].AdvertisementType = ODAT_OnlineService;
		StringSettings[0].Id = class'GearGame'.const.CONTEXT_MAPNAME;
		StringSettings[0].ValueIndex = class'GearLeaderboardSettings'.static.GetMapIdFromName(name(MapName));
		// Add the wave as a property
		Prop.PropertyId = `PROPERTY_WAVE;
			Prop.AdvertisementType = ODAT_OnlineService;
		class'Settings'.static.SetSettingsDataInt(Prop.Data,ChapterOrWave);
		Properties.AddItem(Prop);

		OnlineSub.PlayerInterface.SetOnlineStatus(LP.ControllerId, RPId, StringSettings, Properties);
		break;

	case class'GearGame'.const.CONTEXT_PRESENCE_COOPPRESENCE:

		ActData = class'GearUIDataStore_GameResource'.static.GetActDataProviderUsingChapter(ChapterOrWave);
		if (ActData != None)
		{
			ActId = ActData.ActNum + 1;
		}
		Prop.PropertyId = class'GearGame'.const.PROPERTY_ACTNUM;
		Prop.AdvertisementType = ODAT_OnlineService;
		class'Settings'.static.SetSettingsDataInt(Prop.Data,ActId);
		Properties.AddItem(Prop);
		// Now get the chapter number to display in rich presence
		NormalizedChapter = class'GearUIDataStore_GameResource'.static.GetActChapterProviderIndexFromChapterId(ChapterOrWave) + 1;
		Prop.PropertyId = class'GearGame'.const.PROPERTY_CHAPTERNUM;
		class'Settings'.static.SetSettingsDataInt(Prop.Data,NormalizedChapter);
		Properties.AddItem(Prop);
		// Finally set the person they are playing as
		StringSettings.Length = 1;
		StringSettings[0].AdvertisementType = ODAT_OnlineService;
		StringSettings[0].Id = class'GearGame'.const.CONTEXT_COOPCHARNAME;
		switch (CoopPlayerIndex)
		{
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_MARCUS:
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_DOM:
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_ANYA:
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_DIZZY:
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_COLE:
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_BAIRD:
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_SAM:
		case class'GearGame'.const.CONTEXT_COOPCHARNAME_BERNIE:
			StringSettings[0].ValueIndex = CoopPlayerIndex;
			break;
		}

		OnlineSub.PlayerInterface.SetOnlineStatus(LP.ControllerId, class'GearGame'.const.CONTEXT_PRESENCE_COOPPRESENCE, StringSettings, Properties);
		break;

	}
}

/**
 * Read online stats from LIVE (testing with no WarJournal)
 * @param ControllerIndex - Index of the player controller (0,1,etc)
 * @param ClassName - full classname of the stats read object to query
 */
exec function ReadOnlineStats(int ControllerIndex, string ClassName)
{
	local array<UniqueNetId> Players;
	local class<OnlineStatsRead> StatsReadClass;
	local UniqueNetId PlayerId;

	if (StatsRead != None)
	{
		OnlineSub.StatsInterface.FreeStats(StatsRead);
	}

	StatsReadClass = class<OnlineStatsRead>(FindObject(ClassName, class'Class'));
	if (StatsReadClass != None)
	{
		StatsRead = new StatsReadClass;
		if (StatsRead != None)
		{
			if (GearLeaderboardHorde(StatsRead) != None)
			{
				GearLeaderboardHorde(StatsRead).UpdateViewIdFromName(class'WorldInfo'.static.GetWorldInfo().GetMapName(true));
			}
			else if (GearLeaderboardSiege(StatsRead) != None)
			{
				GearLeaderboardSiege(StatsRead).UpdateViewIdFromName(class'WorldInfo'.static.GetWorldInfo().GetMapName(true));
			}
			else if (GearLeaderboardArcadeAllTime(StatsRead) != None)
			{
				GearLeaderboardArcadeAllTime(StatsRead).UpdateViewIdFromChapter(GearGRI_SP(WorldInfo.GRI).ChapterNum);
			}

			OnlineSub.PlayerInterface.GetUniquePlayerId(ControllerIndex, PlayerId);
			Players[0] = PlayerId;
			OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnStatsReadComplete);
			if (OnlineSub.StatsInterface.ReadOnlineStats(Players, StatsRead) == false)
			{
				`warn("Querying Player Stats failed.");
			}
		}
	}
	else
	{
		`Log(" DEBUGJM(): ReadOnlineStats INVALID CLASSNAME");
	}
}

/** Print out all stats columns for each row of data after the read query is complete */
simulated function OnStatsReadComplete(bool bWasSuccessful)
{
	local int RowIdx, ColIdx, IntValue;

	`Log(" DEBUGJM(): OnStatsReadComplete"@bWasSuccessful);
	OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnStatsReadComplete);

	for (RowIdx=0; RowIdx<StatsRead.Rows.length; RowIdx++)
	{
	   for (ColIdx=0; ColIdx<StatsRead.ColumnIds.length; ColIdx++)
	   {
		   StatsRead.GetIntStatValueForPlayer(StatsRead.Rows[RowIdx].PlayerId, StatsRead.ColumnIds[ColIdx], IntValue);
		   `Log(" DEBUGJM(): Row["$RowIdx$"]["$StatsRead.ColumnIds[ColIdx]$"]="$IntValue);
	   }
	}
}
`endif

exec function ListEfforts(optional bool bAll)
{
	local array<GearSoundGroup> DumpedGroups;
	local class<GearPawn> PawnClass;
	local int i;

	if (bAll)
	{
		for(i=0; i<SpawnPawnList.Length; i++)
		{
			PawnClass = class<GearPawn>(DynamicLoadObject(SpawnPawnList[i].ClassName,class'class'));
			if ( (PawnClass.default.SoundGroup != None) && (DumpedGroups.Find(PawnClass.default.SoundGroup) == INDEX_NONE) )
			{
				PawnClass.default.SoundGroup.DumpMemoryUsage(false);
				DumpedGroups[DumpedGroups.length] = PawnClass.default.SoundGroup;
			}
		}
	}
	else
	{
		MyGearPawn.SoundGroup.DumpMemoryUsage(true);
	}

}

exec function AbortAllAICommands()
{
	local GearAI GAI;
	foreach WorldInfo.AllControllers(class'GearAI', GAI)
	{
		`log("Aborting all commands for "$GAI$"...");
		GAI.AbortCOmmand(GAI.CommandList);
	}
}

exec function DeleteEveryoneWhenStale()
{
	local GearAI GAI;
	foreach WorldInfo.AllControllers(class'GearAI', GAI)
	{
		GAI.SetEnableDeleteWhenStale(TRUE);
	}
}

function DumpInfoForAI(GearAI AI)
{
	local float DistFromPlayer, TimeSinceLastRender;
	DistFromPlayer = AI.GetMinDistanceToAnyPlayer();
	TimeSinceLastRender = `TimeSince(AI.Pawn.LastRenderTime);

	ForceLog("  ... "$AI$"(ActvCmd:"$AI.GetActionString()$")  -- DistFromPlayer:"@DistFromPlayer@"TimeSinceLastRender:"@TimeSinceLastRender@"Enemy:"@AI.Enemy@"AILoc:"@AI.Pawn.Location);
}

function DumpInfoForAITeam(EGearTeam Team,out int Out_Total,out int Out_WithEnemy,out int Out_Rendered)
{
	local GearAI GAI;
	local int Total,WithEnemy,Rendered;
	ForceLog("  "$Team$" AI:");
	foreach WorldInfo.AllControllers(class'GearAI', GAI)
	{
		if(GAI.GetTeamNum() != Team)
		{
			continue;
		}
		Total++;
		if(GAI.Enemy != none)
		{
			WithEnemy++;
		}
		if(`TimeSince(GAI.Pawn.LastRenderTime) < 0.08f)
		{
			Rendered++;
		}
		DumpInfoForAI(GAI);
	}
	ForceLog("  "$team$" Totals: (HaveEnemy/RenderedRecently/Total) ("$WithEnemy$"/"$Rendered$"/"$Total$")");
	Out_Total += Total;
	Out_WithEnemy += WithEnemy;
	Out_Rendered += Rendered;
}
exec function DumpAIStats()
{
	local int Total,WithEnemy,Rendered;
	ForceLog("-------------         AI STATS         -------------");
	DumpInfoForAITeam(TEAM_COG,Total,WithEnemy,Rendered);
	DumpInfoForAITeam(TEAM_LAMBENT,Total,WithEnemy,Rendered);
	DumpInfoForAITeam(TEAM_LOCUST,Total,WithEnemy,Rendered);
	ForceLog(" Overall Totals: (HaveEnemy/RenderedRecently/Total) ("$WithEnemy$"/"$Rendered$"/"$Total$")");
	ForceLog("----------------------------------------------------");

}

exec function FlushAILogs()
{
	local GearAI GAI;

	if(!WorldInfo.bPlayersOnly)
	{
		DebugFreezeGame();
	}
	foreach WorldInfo.AllControllers(class'GearAI', GAI)
	{
		if(GAI.AILogFile != none)
		{
			GAI.AILogFile.CloseLog();
			GAI.AILogFile.Destroy();
			GAI.AILogFile = none;
		}
	}
}

// UnlockAllChapters in GearPC now for tester use purposes

/** Relock all the chapters */
exec function LockAllChapters()
{
	local GearPC PC;

	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersCasual1, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersCasual2, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersNormal1, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersNormal2, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersHard1, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersHard2, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersInsane1, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`CompletedChaptersInsane2, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`UnlockedChapterAccess1, 0);
		PC.ProfileSettings.SetProfileSettingValueInt(`UnlockedChapterAccess2, 0);
		PC.SaveProfile();
	}
	`log("Locked all Chapters for all difficulties");
}

/** Unlocks all the chapters for a specific difficulty */
exec function UnlockChaptersDiff(EDifficultyLevel DiffType,bool bWasArcade, int NumCoopPlayers)
{
	local GearPC PC;
	local int ChapIndex, TotalChapters;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ChapterProviders;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if ( GameResourceDS.GetResourceProviders('Chapters', ChapterProviders) )
	{
		TotalChapters = ChapterProviders.Length;
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			for (ChapIndex = 0; ChapIndex < TotalChapters; ChapIndex++)
			{
				PC.ClientCompleteChapter(ChapIndex,DiffType,bWasArcade,NumCoopPlayers);
			}
		}
	}
	`log("Unlocked all Chapters for " $ DiffType);
}

/** Completes a chapter for a specific difficulty */
exec function CompleteChapter(int Chapter, EDifficultyLevel DiffType, bool bWasArcade, int NumCoopPlayers)
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		PC.ClientCompleteChapter(Chapter,DiffType,bWasArcade,NumCoopPlayers);
		PC.SaveProfile();
	}
	`log("Completed chapter" @ Chapter @ "for" @ DiffType);
}

/** Sets values for progression achievements */
exec function SetProgression(EGearAchievement Achievement, int Value)
{
	local GearPC PC;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ProfileSettings.SetCurrentProgressValueForAchievement(Achievement, Value);
	}
	`log("Progression for" @ Achievement @ "set to"@Value@"!");
}

/** Sets values for progression achievements */
exec function SetMedal(int Value)
{
	local GearPC PC;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ProfileSettings.SetProfileSettingValueInt(`SelectedMedal, Value);
		PC.bProfileSettingsUpdated = TRUE;
	}
	`log("Medal is now index" @ Value$"!");
}

/** Marks a chapter as complete for the coop achievements */
exec function CompleteCoopChapter(int Chapter, bool FullCoop)
{
	local GearPC PC;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ProfileSettings.MarkCoopChapterComplete(Chapter, PC, FullCoop ? 4 : 2);
	}
	`log("Coop chapter" @ Chapter @ "completed!");
}

/** Marks a map as completed for testing the AroundTheWorld achievement */
exec function CompleteMPMap(EGearMapsShipped MapType)
{
	local GearPC PC;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ProfileSettings.UpdateMPMatchProgression(0, MapType, PC);
	}
	`log("MP Map" @ MapType @ "completed!");
}

/** Marks a Horde wave as completed for testing the Horde achievements */
exec function CompleteHordeWave(int Wave)
{
	local GearPC PC;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ProfileSettings.MarkHordeWaveAsCompleted(Wave, PC);
	}
	`log("Horde wave" @ Wave @ "completed!");
}

/** Marks a Siege wave as completed for testing the Siege achievements */
exec function CompleteSiegeWave(int Wave)
{
	local GearPC PC;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ProfileSettings.MarkSiegeWaveAsCompleted(Wave, PC);
	}
	`log("Siege wave" @ Wave @ "completed!");
}

exec function DebugFaceCam(optional bool bEnableGUDSBrowsing)
{
	bDebugFaceCam = TRUE;
	bDebugGUDBrowser = bEnableGUDSBrowsing;
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.bEnableGUDSBrowsing = bEnableGUDSBrowsing;
	MyGearHud.bShowHUD = !(bDebugGUDBrowser || bDebugEffortBrowser);
}

exec function GUDSBrowser()
{
	bDebugGUDBrowser = !bDebugGUDBrowser;
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.bEnableGUDSBrowsing = bDebugGUDBrowser;
	MyGearHud.bShowHUD = !bDebugGUDBrowser;
}

exec function EffortBrowser()
{
	bDebugEffortBrowser = !bDebugEffortBrowser;
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.bEnableEffortsBrowsing = bDebugEffortBrowser;
	MyGearHud.bShowHUD = !bDebugEffortBrowser;
}

exec function DebugGUDSStreaming()
{
	bDebugGUDSStreaming = !bDebugGUDSStreaming;
	MyGearHud.SetDebugDraw( DebugDraw_GUDSStreaming, bDebugGUDSStreaming );
}
simulated function DebugDraw_GUDSStreaming( GearHUD_Base H )
{
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.DrawDebugStreaming(H.Canvas);
}

/**
 * Sets the most restrictive NAT setting that can host
 *
 * @param the new NAT setting to use
 */
exec function SetCanHostVersusMatch(ENATType NatType)
{
	class'GearPartyGame_Base'.default.CanHostVersusNatType = NatType;
	class'GearPreGameLobbyGame_Base'.default.CanHostVersusNatType = NatType;
	class'GearMenuGame'.default.CanHostVersusNatType = NatType;
	GearMenuGame(WorldInfo.Game).CanHostVersusNatType = NatType;
	`Log("class'GearMenuGame'.default.CanHostVersusNatType = "$class'GearMenuGame'.default.CanHostVersusNatType);
}

/**
 * Sets the most restrictive NAT setting that can host partial parties
 *
 * @param the new NAT setting to use
 */
exec function SetCanHostPartyMatch(ENATType NatType)
{
	class'GearPartyGame_Base'.default.CanHostPartyNatType = NatType;
	class'GearPreGameLobbyGame_Base'.default.CanHostPartyNatType = NatType;
	class'GearMenuGame'.default.CanHostPartyNatType = NatType;
	GearMenuGame(WorldInfo.Game).CanHostPartyNatType = NatType;
	`Log("class'GearMenuGame'.default.CanHostPartyNatType = "$class'GearMenuGame'.default.CanHostPartyNatType);
}

/**
 * Sets the most restrictive NAT setting that can invite players
 *
 * @param the new NAT setting to use
 */
exec function SetCanInviteToMatch(ENATType NatType)
{
	class'GearPartyGame_Base'.default.CanInviteNatType = NatType;
	class'GearPreGameLobbyGame_Base'.default.CanInviteNatType = NatType;
	class'GearMenuGame'.default.CanInviteNatType = NatType;
	GearMenuGame(WorldInfo.Game).CanInviteNatType = NatType;
	`Log("class'GearMenuGame'.default.CanInviteNatType = "$class'GearMenuGame'.default.CanInviteNatType);
}

exec function LogSquadEnemyList()
{
	local Pawn E;
	local int Idx;
	local GearAI AI;

	`log( GetFuncName()@Squad );
	if( Squad != None )
	{
		Idx = 0;
		foreach Squad.AllEnemies( class'Pawn', E )
		{
			`log( "Iterator"@Idx@E );
			Idx++;
		}
		`log( "Total Squad Enemies"@Idx );

		foreach Squad.AllMembers( class'GearAI', AI )
		{
			`log( "AI Local List"@AI@AI.LocalEnemyList.Length );
			for( Idx = 0; Idx < AI.LocalEnemyList.Length; Idx++ )
			{
				`log( AI@"Local"@Idx@AI.LocalEnemyList[Idx].Pawn );
			}
		}
	}
}

/** Show the discoverable scene for the discoverable */
exec function DisplayCollectible( EGearDiscoverableType DiscType )
{
	local GearPC_SP PC;

	PC = GearPC_SP(Outer);
	if (PC != None &&
		DiscType != InvalidDiscoverable)
	{
		DiscoverType = DiscType;
		PC.StartDiscoverableUI();
	}
}

/** Debug hook to unlock various collectibles  needs to go he**/
exec function UnlockCollectable( EGearDiscoverableType DiscType )
{
	UnlockCollectible( DiscType );
}

/** Debug hook to unlock various collectibles **/
exec function UnlockCollectible( EGearDiscoverableType DiscType )
{
	local GearPC PC;

	// Mark as having been picked up by all local players
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		// Mark the pickup as found in the profile
		if (PC.ProfileSettings != None)
		{
			// Set and mark the profile
			PC.ProfileSettings.MarkDiscoverableAsFoundButNotViewed(DiscType,PC);
		}
	}
}

exec function UnlockAllCollectables()
{
	UnlockAllCollectibles();
}
exec function UnlockAllCollectibles()
{
	local byte i;
	local EGearDiscoverableType DiscType;

	if( ProfileSettings != None )
	{
		`log(`location @ "unlocking all collectibles");

		// Set and mark the profile
		for ( i = InvalidDiscoverable + 1; i < EGearDiscoverableType_MAX; i++ )
		{
			DiscType = EGearDiscoverableType(i);
			ProfileSettings.MarkDiscoverableAsFoundButNotViewed(DiscType, Outer, false);
		}

		SaveProfile();
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

exec function LockAllCollectibles()
{
	if ( ProfileSettings != None )
	{
		`log(`location @ "locking all collectibles!");
		ProfileSettings.SetProfileSettingValueInt( `DiscoverFound1, 0 );
		ProfileSettings.SetProfileSettingValueInt( `DiscoverNeedsViewed1, 0 );
		ProfileSettings.SetProfileSettingValueInt( `DiscoverFound2, 0 );
		ProfileSettings.SetProfileSettingValueInt( `DiscoverNeedsViewed2, 0 );
		SaveProfile();
	}
}

/** 
 * Lock/Unlock all characters
 * @param bLock - TRUE to lock the character again
 */
exec function UnlockAllCharacters(bool bLock=false)
{
	local int i;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> CharacterProviders;
	local GearGameCharacterSummary CurrentCharacter;

	if (AwardManager != None)
	{
		GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
		if( GameResourceDS != None )
		{
			GameResourceDS.GetResourceProviders('COGs', CharacterProviders);
			for( i = 0; i < CharacterProviders.Length; i++ )
			{
				CurrentCharacter = GearGameCharacterSummary(CharacterProviders[i]);
				if(CurrentCharacter != None && CurrentCharacter.AwardName != '')
				{
					if (!bLock)
					{
						`log(`location @ "Unlocking Character" @ CurrentCharacter.Name);
						Outer.NotifyEarnedAward(CurrentCharacter.AwardName);
					}
					else
					{
						`log(`location @ "Locking Character" @ CurrentCharacter.Name);
						Outer.AwardManager.ClearAward(CurrentCharacter.AwardName);
					}
				}
			}

			GameResourceDS.GetResourceProviders('Locusts', CharacterProviders);
			for( i = 0; i < CharacterProviders.Length; i++ )
			{
				CurrentCharacter = GearGameCharacterSummary(CharacterProviders[i]);
				if(CurrentCharacter != None && CurrentCharacter.AwardName != '')
				{
					if (!bLock)
					{
						`log(`location @ "Unlocking Character" @ CurrentCharacter.Name);
						Outer.NotifyEarnedAward(CurrentCharacter.AwardName);
					}
					else
					{
						`log(`location @ "Locking Character" @ CurrentCharacter.Name);
						Outer.AwardManager.ClearAward(CurrentCharacter.AwardName);
					}
				}
			}
		}
	}
}

/** 
 * Lock/Unlock characters by character name (perobjectconfig)
 * @param CharName - name of character to unlock
 * @param bLock - TRUE to lock the character again
 */
exec function UnlockCharacter(string CharName, bool bLock=false)
{
	local int i;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> CharacterProviders;
	local GearGameCharacterSummary CurrentCharacter, FoundCharacter;

	if (AwardManager != None)
	{
		GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
		if( GameResourceDS != None )
		{
			GameResourceDS.GetResourceProviders('COGs', CharacterProviders);
			for( i = 0; i < CharacterProviders.Length; i++ )
			{
				CurrentCharacter = GearGameCharacterSummary(CharacterProviders[i]);
				if(CurrentCharacter != None && CurrentCharacter.Name == name(CharName))
				{
					FoundCharacter = CurrentCharacter;
					break;
				}
			}
			if (FoundCharacter != None)
			{		
				GameResourceDS.GetResourceProviders('Locusts', CharacterProviders);
				for( i = 0; i < CharacterProviders.Length; i++ )
				{
					CurrentCharacter = GearGameCharacterSummary(CharacterProviders[i]);
					if(CurrentCharacter != None && CurrentCharacter.Name == name(CharName))
					{
						FoundCharacter = CurrentCharacter;
						break;
					}
				}
			}

			if (FoundCharacter != None && FoundCharacter.AwardName != '')
			{
				if (!bLock)
				{
					`log(`location @ "Unlocking Character" @ CharName);
					Outer.NotifyEarnedAward(FoundCharacter.AwardName);
				}
				else
				{
					`log(`location @ "Locking Character" @ CharName);
					Outer.AwardManager.ClearAward(FoundCharacter.AwardName);
				}
			}
		}
	}
}

exec function UnlockUnlockable( int Unlockable )
{
	if ( ProfileSettings != None )
	{
		`log(`location @ "unlocking" @ Unlockable);
		ProfileSettings.MarkUnlockableAsUnlockedButNotViewed(Unlockable, Outer);
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

exec function UnlockAllUnlockables()
{
	if( ProfileSettings != None )
	{
		`log(`location @ "Unlocking all unlockables NOT including DLC characters.");
		UnlockMultipleUnlockables(ProfileSettings.LastCampaignUnlockable);
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

exec function UnlockAllUnlockablesDLC()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> UnlockableProviders;


	if( ProfileSettings != None )
	{
		`log(`location @ "Unlocking all unlockables including DLC characters.");
		GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
		if ( GameResourceDS.GetResourceProviders('Unlockables', UnlockableProviders) )
		{
			UnlockMultipleUnlockables(UnlockableProviders.Length-1);
		}
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

private function UnlockMultipleUnlockables( int MaxUnlockableValue )
{
	local byte i;

	if( ProfileSettings != None )
	{
		// Set and mark the profile
		for ( i = 0; i <= MaxUnlockableValue; i++ )
		{
			ProfileSettings.MarkUnlockableAsUnlockedButNotViewed(i, Outer);
		}
		SaveProfile();
	}
}

/** Relocks all of the unlockables */
exec function RelockAllUnlockables()
{
	if (ProfileSettings != None)
	{
		ProfileSettings.RelockAllUnlockables();
		SaveProfile();
	}
}

exec function ResetAchievements()
{
	if ( ProfileSettings != None )
	{
		`log(`location @ "re-locking all achievements");
		ProfileSettings.SetProfileSettingValueInt(`COMPLETED_ACHIEVEMENT_MASK_A, 0);
		ProfileSettings.SetProfileSettingValueInt(`COMPLETED_ACHIEVEMENT_MASK_B, 0);
		ProfileSettings.SetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_A, 0);
		ProfileSettings.SetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_B, 0);
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

exec function ShowAchievementMasks()
{
	local int Value;

	if ( ProfileSettings != None )
	{
		`log(`location @ "showing all achievements");
		ProfileSettings.GetProfileSettingValueInt(`COMPLETED_ACHIEVEMENT_MASK_A, Value);
		`log("COMPLETED ACHIEVEMENT MASK A:" @ Value);

		ProfileSettings.GetProfileSettingValueInt(`COMPLETED_ACHIEVEMENT_MASK_B, Value);
		`log("COMPLETED ACHIEVEMENT MASK B:" @ Value);

		ProfileSettings.GetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_A, Value);
		`log("UNVIEWED ACHIEVEMENT MASK A:" @ Value);

		ProfileSettings.GetProfileSettingValueInt(`UNVIEWED_ACHIEVEMENT_MASK_B, Value);
		`log("UNVIEWED ACHIEVEMENT MASK A:" @ Value);
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

exec function ResetAllCollectibles()
{
	if ( ProfileSettings != None )
	{
		`log(`location @ "re-locking all collectibles");
		ProfileSettings.SetProfileSettingValueInt(`DiscoverFound1, 0);
		ProfileSettings.SetProfileSettingValueInt(`DiscoverNeedsViewed1, 0);
		ProfileSettings.SetProfileSettingValueInt(`DiscoverFound2, 0);
		ProfileSettings.SetProfileSettingValueInt(`DiscoverNeedsViewed2, 0);

		SaveProfile();
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

exec function ResetUnlockables()
{
	if ( ProfileSettings != None )
	{
		`log(`location @ "re-locking all unlockables");
		ProfileSettings.SetProfileSettingValueInt(`UnlockedUnlockables, 0);
		ProfileSettings.SetProfileSettingValueInt(`UnlockableNeedsViewed, 0);

		SaveProfile();
	}
	else
	{
		`log(`location @ Outer @ "has no profile!");
	}
}

/** exec for forcing the loading movie to play or stop - useful for cases where the loading movie is stuck on */
exec function ShowLoadingMovie( optional string EnableString )
{
	local bool bEnable;

	bEnable = true;
	if ( EnableString != "" )
	{
		bEnable = bool(EnableString);
	}

	ClientShowLoadingMovie(bEnable);
}

//@NOTE: these probably will not work right in COOP
exec function PrepMap( coerce name LevelName )
{
	`log( "Zoom Prepare:" @ LevelName );
	ClientPrepareMapChange( LevelName, TRUE, TRUE );
}
exec function CommitMap()
{
	ClientCommitMapChange();
}

exec function ShowDamage()
{
	class'GearGRI'.default.bDebugShowDamage = !class'GearGRI'.default.bDebugShowDamage;

	if (class'GearGRI'.default.bDebugShowDamage)
	{
		ClientMessage("ShowDamage ON");
	}
	else
	{
		ClientMessage("ShowDamage OFF");
	}
}

// - - - Progress Notification - - -
exec function splitalert()
{
	local GearPC PC;

	foreach LocalPlayerControllers( class'GearPC', PC )
	{
		PC.GetAlertManager().Alert( eALERT_Friend, "Testing", "Controller " $ string(PC) );
	}
}

exec function allachievements()
{
	local AchievementDetails AchievDetails;
	local float Current, Max;
	local int AchId;
	local AlertEvent EventToPush;

	Current = 33;
	Max = 100;

	for(AchId=0; AchId < eGA_MAX; AchId++)
	{
		OnlinePlayerData.AchievementsProvider.GetAchievementDetails(AchId, AchievDetails);
		EventToPush.Title = AchievDetails.AchievementName;
		`Log(AchievDetails.AchievementName);
		EventToPush.MsgOne = "";
		EventToPush.MsgTwo = "";
		EventToPush.TopNum = Current;
		EventToPush.BottomNum = Max;
		EventToPush.CustomIcon=OnlinePlayerData.AchievementsProvider.GetAchievementIconPathName(AchId);

		GetAlertManager().Alert(eALERT_Medal, EventToPush.Title, EventToPush.MsgOne, EventToPush.MsgTwo,
							EventToPush.TopNum, EventToPush.BottomNum, GEARAWARDPROGREP_Integer, EventToPush.CustomIcon);
	}
}

exec function alert(EAlertType type, string Title, string MsgOne, string MsgTwo, int TopNum, int BottomNum, string CustomIcon, int MedalRank)
{
	if (GetAlertManager() == None)
	{
		`Log("Oh no! AlertManager == None.");
	}
	GetAlertManager().Alert(type, Title, MsgOne, MsgTwo, TopNum, BottomNum, GEARAWARDPROGREP_Integer, CustomIcon, MedalRank);
}

/**
 * Allows locking out Alerts so that they won't appear while recording video
 */
exec function ToggleSuppressAlerts()
{
	if (GetAlertManager() == None)
	{
		`Log("Oh no! AlertManager == None.");
	}
	else
	{
		GetAlertManager().ToggleAlertLockout();
	}
}


exec function progtest( EGearAchievement Ach, int Current )
{
	local float Current_dump, Max;
	local string AchievementIcon;

	GetAchievementProgression(Ach, Current_dump, Max);
	AchievementIcon = OnlinePlayerData.AchievementsProvider.GetAchievementIconPathName(Ach);

	if (GetAlertManager().ShouldShowProgressionAlert(Ach, Current, Max))
	{
		`Log("Would show." @ string(Ach) @ string(Current) @ string(Max) );
		GetAlertManager().Alert(eALERT_Medal, "ProgressTest", "", "", Current, Max, GEARAWARDPROGREP_Integer, AchievementIcon);
	}
	else
	{
		`Log("No show." @ string(Ach) @ string(Current) @ string(Max) );
	}
}

exec function progstat( EGearAchievement Ach )
{
	local float Current, Max;
	local AchievementDetails AchievDetails;

	GetAchievementProgression(Ach, Current, Max);
	OnlinePlayerData.AchievementsProvider.GetAchievementDetails(Ach, AchievDetails);

	`Log("Achievement Stats:" @ AchievDetails.AchievementName @ "["$ string(Ach) $"]" @ string(Current) $ "/" $ string(Max) );
}

exec function supalert(string FriendName)
{
	GetAlertManager().Alert(eALERT_Friend, "Invitation Sent", "What's up, " $ FriendName);
}

exec function supalertall(int NumFriends)
{
	GetAlertManager().Alert(eALERT_Friend, "Invitation Sent", "What's up to " $ string(NumFriends) $ " e-friends.");
}

exec function loctest( string File, string Section, string LocString )
{
	//static function bool ShowUIMessage( name SceneTag, string Title, string Message, string Question, array<name> ButtonAliases, delegate<UIMessageBoxBase.OnOptionSelected> SelectionCallback, optional LocalPlayer ScenePlayerOwner, optional out UIMessageBoxBase out_CreatedScene, optional byte ForcedPriority )

	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local UIScene_MessageBox InstancedScene;

	ButtonAliases.AddItem('GenericAccept');

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	UIManager.ClearUIMessage('LocTestingMessage');

	UIManager.ShowUIMessage(	'LocTestingMessage', "Testing Loc",
									Localize( Section, LocString, File ), ButtonAliases, None, LocalPlayer(Player), InstancedScene);

	InstancedScene.bCloseOnLevelChange = false;
	//InstancedScene.bExemptFromAutoClose = true;
	InstancedScene.SetPriority(class'GearGFxMoviePlayer'.const.GEAR_SCENE_PRIORITY_MESSAGEBOX+1);
}

exec function ListBrokenCover()
{
	local CoverLink Link;
	local int SlotIdx, ActionIdx;

	`log( GetFuncName()@"..." );

	for( Link = WorldInfo.CoverList; Link != None; Link = Link.NextCoverLink )
	{
		for( SlotIdx = 0; SlotIdx < Link.Slots.Length; SlotIdx++ )
		{
			if( Link.Slots[SlotIdx].CoverType == CT_Standing )
			{
				for( ActionIdx = 0; ActionIdx < Link.Slots[SlotIdx].Actions.Length; ActionIdx++ )
				{
					if( Link.Slots[SlotIdx].Actions[ActionIdx] == CA_PopUp )
					{
						`log( "Popup action on standing cover!!!!"@Link@SlotIdx@ActionIdx );
					}
				}
			}
		}
	}
}


exec function ForceTeleport()
{
	Pawn.SetLocation(vect(0,0,0));
}

/** JoeG function to display what's going on in matchmaking */
exec function ShowMMState()
{
	ConsoleCommand("displayall gearpartygame_base MatchmakingState");
	ConsoleCommand("displayall GearPartyGameSettings LocalizedStringSettings");
	ConsoleCommand("displayall PartyBeaconHost Reservations");
	ConsoleCommand("displayall PartyBeaconHost NumConsumedReservations");
	ConsoleCommand("displayall PartyBeaconHost PotentialTeamChoices");
}

exec function DisplayCoverClaims()
{
	local CoverLink CurLink;
	local int i;
	foreach AllActors(class'CoverLink',CurLink)
	{
		for(i=0;i<CurLink.Slots.length;i++)
		{
			if( CurLink.Slots[i].SlotOwner != none )
			{
				`log(CurLink@"Slot"@i@"Owner"@CurLink.Slots[i].SlotOwner);
			}
		}
	}
}

exec function TestVRandCone(int num, optional float ang=3.14159f)
{
	local vector V, B;
	local int i;

	FlushPersistentDebugLines();

	B = VRand();
	DrawDebugLine(Pawn.Location, Pawn.Location + B * 200, 255, 255, 255, TRUE);

	for (i=0; i<num; ++i)
	{
		V = VRandCone(B, Ang);
		DrawDebugLine(Pawn.Location, Pawn.Location + V * 100, 255, 255, 0, TRUE);
	}
}

exec function TestVRandCone2(int num, optional float hAng=3.14195, optional float vAng = 1.57)
{
	local vector V, B;
	local int i;

	FlushPersistentDebugLines();

	B = VRand();
	DrawDebugLine(Pawn.Location, Pawn.Location + B * 200, 255, 255, 255, TRUE);

	for (i=0; i<num; ++i)
	{
		V = VRandCone2(B, hAng, vAng);
		DrawDebugLine(Pawn.Location, Pawn.Location + V * 100, 255, 255, 0, TRUE);
	}
}

exec function FlushDebugLines()
{
	FlushPersistentDebugLines();
}

exec function ToggleHidden()
{
	Pawn.SetHidden(!Pawn.bHidden);
}

exec function AddMut(string MutName)
{
	local class<Mutator> MutClass;

	MutClass = class<Mutator>(DynamicLoadObject("GearGame.GearMut_" $ MutName, class'Class'));
	if (MutClass != None)
	{
		WorldInfo.Game.AddMutator(PathName(MutClass), true);
	}
	else
	{
		ClientMessage("Couldn't find mutator named \"" $ MutName $ "\"");
	}
}

exec function PullCrate()
{
	local KActor_CoverCrateBase Crate;

	foreach AllActors( class'KActor_CoverCrateBase', Crate )
	{
		Crate.PullToward( Pawn, 200, Crate.Location, 60.f );
	}
}

exec function StopPullCrate()
{
	local KActor_CoverCrateBase Crate;
	foreach AllActors( class'KActor_CoverCrateBase', Crate )
	{
		Crate.PullToward( None );
	}
}

exec function GoArcade()
{
	local GearGameSP_Base Game;

	Game = GearGameSP_Base(WorldInfo.Game);
	if (Game != None)
	{
		// explicit call to show loading movie because this transition occurs via ServerTravel, which doesn't always call ClientTravel
		ClientShowLoadingMovie(true);
		WorldInfo.ServerTravel("geargame_p?game=geargamecontent.geargamesp_arcade_content?loadcheckpoint=0?chapter=" $ Game.CurrentChapter);
	}
}

exec function SetExp(int exp)
{
	StatManager.ModifyStat('XP',exp,GEARSTATMODTYPE_Set);
	StatManager.UpdateLevelFromXP();
	GetExp();
}

exec function GetExp()
{
	if (PersistentData == None)
	{
		`log("No persistent data!");
		return;
	}

	`log("EXP: "$ StatManager.GetStatValueByName('XP') $" LEVEL: "$ StatManager.GetStatValueByName('Level'));
}

/** Resets all GDOs */
exec function ResetGDOs()
{
	local GearDestructibleObject GDO;
	local GearDynamicDestructibleObject GDDO;

	foreach AllActors(class'GearDestructibleObject', GDO)
	{
		GDO.Reset();
	}
	foreach AllActors(class'GearDynamicDestructibleObject', GDDO)
	{
		GDDO.Reset();
	}
}

/**
 * Delegate function triggered on completion of persistent data write (used for testing)
 */
function OnWritePersistentDataComplete(byte LocalUserNum,bool bWasSuccessful)
{
	if (bWasSuccessful == true)
	{
		`Log(GetFuncName()$": Successful write of persistent data data.");
	}
	else
	{
		`Log(GetFuncName()$": Failed write of persistent data data.");
	}
	if (OnlineSub != None && OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.ClearWritePlayerStorageCompleteDelegate(LocalUserNum,OnWritePlayerStorageComplete);
	}
}

/** Saves the persistent data, including the StatManager stats */
exec function DebugSavePersistentData()
{
	PersistentData.bShouldBeSaved = TRUE;
	SavePersistentData();
	/*
	local OnlinePlayerInterface PlayerInterface;
	local int PlayerControllerId;


	if (PersistentData == None)
	{
		`log("No persistent data!");
		return;
	}

	if (OnlineSub != None)
	{
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			PlayerControllerId = GetControllerId();

			//Write the stats over to the persistent data
			StatManager.WriteToPersistentData();

			PlayerInterface.AddWritePlayerStorageCompleteDelegate(PlayerControllerId,OnWritePersistentDataComplete);

			if (PlayerInterface.WritePlayerStorage(PlayerControllerId,PersistentData) == false)
			{
				`Log(GetFuncName()$": Failed to write persistent data for Id("$PlayerControllerId$")");
			}
		}
	}
*/
}

// handy function for incendiary grenade and fire debugging.  nukes all fire.
exec function CleanUpFire()
{
	local Emit_StickyFire SF;
	local Emit_BouncyFire BF;

	foreach DynamicActors(class'Emit_StickyFire', SF)
	{
		SF.LifeSpan = 0.1;
	}
	foreach DynamicActors(class'Emit_BouncyFire', BF)
	{
		BF.LifeSpan = 0.1;
	}

	FlushDebugLines();
}

exec function ShowLadder(name StatName)
{
	local int i, Index, StatValue;
	local String Output, YouString;
	local bool bYouAdded;

	if (StatManager != None && StatManager.CarrotLadder != None)
	{
		Index = StatManager.CarrotLadder.AllLadderStats.Find('StatName', StatName);
		if (Index != INDEX_NONE)
		{
			Output = string(StatName);
			StatValue = StatManager.Stats[StatManager.CarrotLadder.AllLadderStats[Index].StatIndex].StatDataByPeriod[GEARPERIOD_Persistent];
			YouString = "YOU"$"("$StatValue$")";

			for (i=0; i<StatManager.CarrotLadder.AllLadderStats[Index].SortedPlayerData.length; i++)
			{
				if (StatManager.CarrotLadder.AllLadderStats[Index].CurrentCarrot == i)
				{
					Output = Output @ YouString;
					bYouAdded = true;
				}

				Output = Output@StatManager.CarrotLadder.AllLadderStats[Index].SortedPlayerData[i].PlayerName$"("$StatManager.CarrotLadder.AllLadderStats[Index].SortedPlayerData[i].PlayerValue$")";
			}

			if (!bYouAdded)
			{
			   Output = Output @ YouString;
			}

			`Log(Output);
			ClientMessage(Output);
		}
	}
}

/** Sets a specific stat value in the StatManager
 *	@param StatName the name of the stat to set
 *	@param Value the value to set the stat to
 */
exec function SetStat(name StatName, int Value)
{
	StatManager.ModifyStat(StatName, Value , GEARSTATMODTYPE_Set);
}

//Prints out the specified stat to the log
exec function GetStat(name StatName)
{
	local GearStat Stat;
	local String StatOutputString;

	Stat = StatManager.GetStatByName(StatName);

	if (Stat != None)
	{
		StatOutputString = Stat $ " - (P:" $ Stat.StatDataByPeriod[GEARPERIOD_Persistent] $
							"), (G:" $ Stat.StatDataByPeriod[GEARPERIOD_Game] $
							"), (R:" $ Stat.StatDataByPeriod[GEARPERIOD_Round] $
							"), (L:" $ Stat.StatDataByPeriod[GEARPERIOD_Life] $ ")";
		`Log(StatOutputString);
		ClientMessage(StatOutputString);
	}
}


/** Wipes out all stats for this player */
exec function ClearStats()
{
	StatManager.ClearManager(True);
	PersistentData.WipeNeedsViewedFlags();
	SavePersistentData();
}

//Gives you all of the medals
exec function GiveAllMedals()
{
	local GearAward Award;

	foreach AwardManager.Awards(Award)
	{
		if (Award.AwardType == GEARAWARDTYPE_Medal)
		{
			AwardManager.AwardEarned(Award);
		}
	}
}

//Gives you all of the executions
exec function GiveAllExecutions()
{
	local GearAward Award;

	foreach AwardManager.Awards(Award)
	{
		if (Award.AwardType == GEARAWARDTYPE_Execution)
		{
			AwardManager.AwardEarned(Award);
		}
	}
}

//Gives you all of the medals
exec function GiveAllRibbons()
{
	local GearAward Award;

	foreach AwardManager.Awards(Award)
	{
		if (Award.AwardType == GEARAWARDTYPE_Ribbon)
		{
			AwardManager.AwardEarned(Award);
		}
	}
}

//Gives you all of the awards. All of them.
exec function GiveAllAwards()
{
	local GearAward Award;

	foreach AwardManager.Awards(Award)
	{
		AwardManager.AwardEarned(Award);
	}
}

//This function will give you an award
exec function GiveAward(name AwardName)
{
	local GearAward Award;
	local GearPC GPC;

	foreach LocalPlayerControllers(class'GearPC', GPC)
	{
		Award = GPC.AwardManager.GetAwardByName(AwardName);
		if (Award != none)
		{
			GPC.AwardManager.AwardEarned(Award);
		}
	}
}

exec function DeployAllForts(optional int UpgradeLevel=0)
{
	local GearFortificationMarker Marker;

	foreach DynamicActors(class'GearFortificationMarker', Marker)
	{
		Marker.SpawnFortification(Outer, UpgradeLevel);
	}
}

exec function DestroyAllForts()
{
	local GearFortification Fort;
	foreach DynamicActors(class'GearFortification', Fort)
	{
		Fort.Explode(true);
	}

}

/** Useful for testing. */
exec function MPCheats()
{
	bMPCheats = !bMPCheats;
	ClientMessage( bMPCheats ? "MP Cheats Enabled" : "MP Cheats Disabled" );
}

exec function TestGetAllValidPointsForBox(float radius, optional float minRadius=0, optional float entityRadius = 32, optional bool bDirectOnly=true, optional int MaxPoints=-1,optional float ValidHitBoxSize)
{
	local array<vector> poses;
	local int i;
	local vector extent;
	local vector validhitbox;

	Extent.X = entityRadius;
	Extent.Y = entityRadius;
	Extent.Z = entityRadius;

	validhitbox = vect(1,1,1) * ValidHitBoxSize;
	NavigationHandle.GetValidPositionsForBox(Pawn.Location,radius,Extent,bDirectOnly,poses,MaxPoints,minRadius,validhitbox);
	for(i=0;i<Poses.length;++i)
	{
		DrawDebugCoordinateSystem(poses[i],rot(0,0,0),25.f,TRUE);
		if(i < poses.length-1 )
		{
			DrawDebugLine(poses[i],poses[i+1],255,255,0,TRUE);
		}

	}
}

/** Sets the players score to the designated value for testing
 *  @param NewScore - the value to set the score to
 */
exec function SetScore(int NewScore)
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		PC.PlayerReplicationInfo.Score=NewScore;
	}
}

/** Give damage to a pod on the submarine */
exec function DamagePod(int SeatIdx, int Damage)
{
	local GearWeaponPawn GearWP;
	local Vehicle_Submarine_Base Submarine;
	local vector SocketLocation;

	GearWP = GearWeaponPawn(Pawn);
	if (GearWP != None)
	{
		Submarine = Vehicle_Submarine_Base(GearWP.MyVehicle);
		if (Submarine != None &&
			SeatIdx > 0 && SeatIdx < Submarine.Seats.length)
		{
			Submarine.Seats[SeatIdx].Mesh.GetSocketWorldLocationAndRotation(Submarine.Seats[SeatIdx].SeatBone, SocketLocation);
			Submarine.TakeDamage(Damage, None, SocketLocation, vect(0,0,1),class'GDT_Ballistic');
		}
	}
}

/** toggle cover code debugging */
exec function DebugCover()
{
	local GearPC	PC;

	FlushPersistentDebugLines();

	// Toggle debug for all local players
	ForEach WorldInfo.AllControllers(class'GearPC', PC)
	{
		// toggle
		PC.bDebugCover = !bDebugCover;

		PC.SetBasicCoverDebug(GearPawn(PC.Pawn), PC.bDebugCover);

		// and hook/unhook our debug draw
		PC.MyGearHud.SetDebugDraw(DebugDraw_Cover, PC.bDebugCover);
	}
}

exec function DebugWeapon()
{
	if( MyGearPawn != None )
	{
		MyGearPawn.bWeaponDebug_Accuracy = !MyGearPawn.bWeaponDebug_Accuracy;
	}
}

/** toggle ai debugging */
exec function DebugAI(optional coerce name Category)
{
	local int i;
	local GearAI CurAI;

	if(Category == '')
	{
		Category = 'Default';

		if( DebugAIController != None )
		{
			DebugAIController.bAILogToWindow = FALSE;
		}
		DebugAIController = None;
	}

	if(Category == 'none')
	{
		GearGame(WorldInfo.Game).AIVisMan.bDrawVisTests = false;
		DebugAICategories.length=0;
		bDebugAI=false;
	}
	else
	{
		if(Category == 'sighttests')
		{
			GearGame(WorldInfo.Game).AIVisMan.bDrawVisTests = !GearGame(WorldInfo.Game).AIVisMan.bDrawVisTests;
		}

		i = DebugAICategories.Find(Category);
		if(i > -1)
		{
			ClientMessage( "DebugAI category"@Category@"disabled." );
			// if it's in the list already, then toggle it off
			DebugAICategories.Remove(i,1);
			bDebugAI=(DebugAICategories.length > 0);
		}
		else
		{
			ClientMessage( "DebugAI category"@Category@"enabled." );
			DebugAICategories.AddItem(Category);
			bDebugAI=true;
		}

		if(Category == 'wander' || Category == 'wanderplayerstarts')
		{
			if(i == -1)
			{
				foreach WorldInfo.AllControllers(class'GearAI',CurAI)
				{
					class'AICmd_Wander'.static.Wander(CurAI,(Category=='wanderplayerstarts'));
				}
			}
			else
			{
				foreach WorldInfo.AllControllers(class'GearAI',CurAI)
				{
					CurAI.AbortCommand(none,class'AICmd_Wander');
				}

			}
		}
	}

	// and hook/unhook our debug draw
	MyGearHud.SetDebugDraw(DebugDraw_AI,bDebugAI);
}

exec function DebugAICycle( optional bool bSkipFOVCheck = true, optional String StringContainedInName )
{
	local GearAI AI;
	local vector CamLoc;
	local rotator CamRot;

	if( !bDebugAI )
	{
		DebugAI();
	}

	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		if( AI == None || !AI.bAIDrawDebug || AI.Pawn == None )
		{
			continue;
		}

		if( Len( StringContainedInName ) != 0 &&
			InStr( AI.Name, StringContainedInName,, TRUE ) < 0 )
		{
			continue;
		}


		GetPlayerViewPoint(CamLoc,CamRot);
		if( !bSkipFOVCheck && (AI.Pawn.Location - CamLoc) dot vector(CamRot) < 0.f )
		{
			continue;
		}

		if( DebugAIController == None )
		{
			DebugAIController = AI;
			DebugAIController.bAILogToWindow = TRUE;
			return;
		}
		else if( DebugAIController == AI )
		{
			DebugAIController.bAILogToWindow = FALSE;
			DebugAIController = None;
		}
	}

	DebugAIController = None;
}



function DebugDraw_AI(GearHUD_Base H)
{
	local vector CamLoc;
	local rotator CamRot;
	local GearAI AI;
	local String Str;
	local float	X, Y;
	local int i;
	local Vector LeaderLoc, LeaderDir;
	local Canvas Canvas;

	local FormationPosition Info;
	local int Idx;

	Canvas = H.Canvas;

	if( DebugAIController != None )
	{
		if( DebugAIController.Pawn != None )
		{
			DrawDebugLine( DebugAIController.Pawn.Location, DebugAIController.Pawn.Location + vect(0,0,4096), 255, 0, 0 );
			DebugAIController.DrawDebug( H, 'Default', TRUE );

			for( i = 0; i < DebugAICategories.Length; i++ )
			{
				DebugAIController.DrawDebug( H, DebugAICategories[i] );
			}
		}
		else
		{
			DebugAIController.bAILogToWindow = FALSE;
			DebugAIController = None;
		}
	}
	else
	{
		H.Canvas.SetDrawColor(255,255,255);
		GetPlayerViewPoint(CamLoc,CamRot);
		foreach WorldInfo.AllControllers(class'GearAI', AI)
		{
			if (AI.Pawn != None && (AI.Pawn.Location - CamLoc) dot vector(CamRot) > 0.f)
			{
				for(i=0;i<DebugAICategories.length;i++)
				{
					AI.DrawDebug(H,DebugAICategories[i]);
				}
			}
		}
	}

	if( Squad != None && Squad.Leader == Outer )
	{
		if( Squad.SquadRoute != None )
		{
			LeaderLoc = Squad.GetSquadLeaderLocation();
			if( Squad.Formation != None )
			{
				LeaderDir = Squad.Formation.GetSquadLeaderDir();
			}
			if(Pawn != none)
			{
				DrawDebugLine( Pawn.Location, LeaderLoc, 255, 128, 255 );
			}
			DrawDebugCylinder( LeaderLoc, LeaderLoc, 128.f, 10, 255, 128, 255 );
			DrawDebugLine( LeaderLoc, LeaderLoc + LeaderDir * 128.f, 255, 128, 255 );
			DrawDebugStar( LeaderLoc + LeaderDir * 128.f, 16.f, 255, 128, 255 );
		}

		if( Squad.Formation != None && DebugAICategories.Find( 'Squad' ) >= 0 )
		{
			Canvas.SetPos( Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f );

			Idx = 0;
			foreach Squad.Formation.Positions( Info )
			{
				if( !IsZero(Info.ActualPosition) )
				{
					DrawDebugCylinder( Info.IdealPosition, Info.IdealPosition, 32.f, 10, 255, 0, 0 );
					DrawDebugCylinder( Info.ActualPosition, Info.ActualPosition, 32.f, 10, 0, 255, 0 );
					DrawDebugLine( Info.IdealPosition, Info.ActualPosition, 255, 0, 0 );

					DrawDebugText( H, FALSE, "Formation Pos:"@Idx@`showvar(Info.AI) );
				}

				Idx++;
			}
		}
	}

	X = H.SizeX - 160;
	Y = H.SizeY - 20;
	H.Canvas.SetPos( X, Y );

	Str = "Frame Time:"@WorldInfo.TimeSeconds;
	H.Canvas.DrawText( Str, TRUE );

	DebugDraw_AI_Rotation(H);
}

/**
 * Return true if DebugAI 'Category' is set
 * i.e. if DebugAI rotation is set, DebugAIOn('rotation') will return true
 * Made static variable so that we can access from anywhere...
 **/
static function bool DebugAIOn(name Category)
{
	local GearPC GPC;

	// now if debugAI is on, draw it...
	foreach class'WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(class'GearPC', GPC)
	{
		if(GPC.bDebugAI && GPC.DebugAICategories.Find(Category)>-1)
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * DebugDraw_AI_Rotation : Draw Rotation debug information
 * Called when 'DebugAI rotation' is on
 * HUD: HUD to draw on
 **/
simulated function DebugDraw_AI_Rotation(GearHUD_Base H)
{
	local GearAI	C;
	local float		Y_Pos;
	local Canvas	Canvas;

	Canvas = H.Canvas;

	// if rotation is set
	if( static.DebugAIOn('rotation') )
	{
		// set start up point;
		Y_Pos = 10;

		// help text
		Canvas.SetPos(5, Y_Pos);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawText( "Rotation/AimOffset/Mirror Transition", TRUE);
		Y_Pos += 12;
		Canvas.SetPos(5, Y_Pos);
		Canvas.DrawText( "Rotation: BOX RED(LockDesiredRotation On) BOX BLUE(DesiredRotation InUse) RED(PreciseRotation), BLUE(DesiredRotation), WHITE(Rotation)", TRUE);
		Y_Pos += 12;
		Canvas.SetPos(5, Y_Pos);
		Canvas.DrawText( "Mirror Transition: ORANGE(Doing transition - MIRRORED) RED(MIRRORED), SKY BLUE(Doing transition - UN-MIRRORED) BLUE(UN-MIRRORED)", TRUE);
		Y_Pos += 12;
		Canvas.SetPos(5, Y_Pos);
		Canvas.DrawText( "======================================================================", TRUE);
		Y_Pos += 12;
		Canvas.SetPos(5, Y_Pos);

		// call AI debug function, start with COGGear
		foreach WorldInfo.AllControllers(class'GearAI', C)
		{
			if ( C.PlayerReplicationInfo.Team.TeamIndex == 0 )
			{
				C.DrawRotationText(Canvas, Y_Pos);
			}
		}

		Canvas.SetPos(5, Y_Pos);
		Canvas.DrawText( "======================================================================", TRUE);
		Y_Pos += 12;
		Canvas.SetPos(5, Y_Pos);

		// call AI debug function, start with COGGear
		foreach WorldInfo.AllControllers(class'GearAI', C)
		{
			if ( C.PlayerReplicationInfo.Team.TeamIndex != 0 )
			{
				C.DrawRotationText(Canvas, Y_Pos);
			}
		}
		Canvas.SetPos(5, Y_Pos);
		Canvas.DrawText( "======================================================================", TRUE);
	}
}

/** Toggle MorphTarget debugging in engine */
exec function DebugMorphs()
{
	local GearPC	PC;

	FlushPersistentDebugLines();

	// Toggle debug for all local players
	ForEach WorldInfo.AllControllers(class'GearPC', PC)
	{
		// Toggle
		PC.bDebugMorphs = !PC.bDebugMorphs;

		// and hook/unhook our debug draw
		PC.MyGearHud.SetDebugDraw(DebugDraw_Morphs, PC.bDebugMorphs);
	}
}

function DebugDraw_Morphs(GearHUD_Base H)
{
	DebugDraw_Morphs_Worker(H, FALSE);
}

function DebugDraw_Morphs_Worker(GearHUD_Base H, bool bShadowPass)
{
	local Canvas        Canvas;
	local GearPawn	    DebugPawn;
	local int		    i;
	local MorphNodeBase MorphNode;
	local AnimTree      RootNode;

	Canvas = H.Canvas;
	if( PlayerCamera != None && PlayerCamera.ViewTarget.Target != None )
	{
		DebugPawn = GearPawn(PlayerCamera.ViewTarget.Target);
		if( DebugPawn == None && Controller(PlayerCamera.ViewTarget.Target) != None )
		{
			DebugPawn = GearPawn(Controller(PlayerCamera.ViewTarget.Target).Pawn);
		}
	}
	else
	{
		DebugPawn = MyGearPawn;
	}

	RootNode = DebugPawn.AnimTreeRootNode;

	Canvas.Font = class'Engine'.Static.GetTinyFont();
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	DebugTextMaxLen = 0.f;

	DrawDebugText(H, bShadowPass, "* MorphSets *");
	// List all morph sets
	for( i=0; i<DebugPawn.Mesh.MorphSets.Length; i++)
	{
		DrawDebugText(H, bShadowPass, i $ ":" @ DebugPawn.Mesh.MorphSets[i] );
	}

	H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
	DebugTextMaxLen = 0.f;
	if( bShadowPass )
	{
		H.Canvas.SetPos(H.Canvas.CurX, H.Canvas.CurY + 1.f);
	}

	DrawDebugText(H, bShadowPass, "* MorphNodes *");
	for(i=0; i<RootNode.RootMorphNodes.Length; i++)
	{
		MorphNode = RootNode.RootMorphNodes[i];
		WalkMorphNodesRecursively(MorphNode, H, bShadowPass, 0);
	}
}

function WalkMorphNodesRecursively(MorphNodeBase MorphNode, GearHUD_Base H, bool bShadowPass, INT Depth)
{
	local Canvas                        Canvas;
	local INT                           i, j;
	local MorphNodePose                 MorphPose;
	local MorphNodeWeightByBoneAngle    WeightByBoneAngle;
	local MorphNodeWeightBase           WeightBaseNode;
	local MorphNodeWeightByBoneRotation	WeightByBoneRotation;
	local string                        DepthString;

	if( MorphNode == None )
	{
		return;
	}

	Canvas = H.Canvas;

	for(i=0; i<Depth; i++)
	{
		DepthString = DepthString $ "   ";
	}

	MorphPose = MorphNodePose(MorphNode);
	WeightBaseNode = MorphNodeWeightBase(MorphNode);
	WeightByBoneAngle = MorphNodeWeightByBoneAngle(MorphNode);
	WeightByBoneRotation = MorphNodeWeightByBoneRotation(MorphNode);
	if( MorphPose != None )
	{
		if( !bShadowPass )
		{
			if( MorphPose.Weight < 0.00001f )
			{
				Canvas.SetDrawColor(255, 0, 0, 255);
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
		}
		DrawDebugText(H, bShadowPass, DepthString $ MorphPose.MorphName $ " (" $ MorphPose.NodeName $") W:" $ int(MorphPose.Weight*100.f) );
	}
	else if( WeightByBoneAngle != None )
	{
		if( !bShadowPass )
		{
			if( WeightByBoneAngle.NodeWeight < 0.00001f )
			{
				Canvas.SetDrawColor(255, 0, 0, 255);
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
		}
		DrawDebugText(H, bShadowPass, DepthString $ WeightByBoneAngle.Class $ " (" $ WeightByBoneAngle.NodeName $") W:" $ int(WeightByBoneAngle.NodeWeight*100.f) );
		for(i=0; i<WeightByBoneAngle.WeightArray.Length; i++)
		{
			DrawDebugText(H, bShadowPass, DepthString $ " " $ i @ "A:" $ WeightByBoneAngle.WeightArray[i].Angle @ "W:" $ int(WeightByBoneAngle.WeightArray[i].TargetWeight*100.f) );
		}
	}
	else if( WeightByBoneRotation != None )
	{
		if( !bShadowPass )
		{
			if( WeightByBoneRotation.NodeWeight < 0.00001f )
			{
				Canvas.SetDrawColor(255, 0, 0, 255);
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
		}
		DrawDebugText(H, bShadowPass, DepthString $ WeightByBoneRotation.Class $ " (" $ WeightByBoneRotation.NodeName $") W:" $ int(WeightByBoneRotation.NodeWeight*100.f) @ "A:" $ int(WeightByBoneRotation.Angle * 180.f / Pi) );
	}
	else
	{
		if( !bShadowPass )
		{
			Canvas.SetDrawColor(0, 255, 0, 255);
		}

		DrawDebugText(H, bShadowPass, DepthString $ MorphNode.Class $ " (" $ MorphNode.NodeName $")");
	}

	if( WeightBaseNode != None )
	{
		for(i=0; i<WeightBaseNode.NodeConns.Length; i++)
		{
			DrawDebugText(H, bShadowPass, DepthString $ " " $ i @ WeightBaseNode.NodeConns[i].ConnName);
			for(j=0; j<WeightBaseNode.NodeConns[i].ChildNodes.Length; j++)
			{
				WalkMorphNodesRecursively(WeightBaseNode.NodeConns[i].ChildNodes[j], H, bShadowPass, Depth + 1);
			}
		}
	}
}

function DebugDraw_Cover(GearHUD_Base H)
{
	local vector	CamLoc;
	local rotator	CamRot;
	local Canvas	Canvas;
	local GearPawn	WP;
	local string	Text;
	local float		FOVAngle1;
	local CoverSlot	Slot;

	Canvas = H.Canvas;
	GetPlayerViewPoint(CamLoc, CamRot);

	if( PlayerCamera != None && PlayerCamera.ViewTarget.Target != None )
	{
		WP	= GearPawn(PlayerCamera.ViewTarget.Target);
		if( WP == None && Controller(PlayerCamera.ViewTarget.Target) != None )
		{
			WP	= GearPawn(Controller(PlayerCamera.ViewTarget.Target).Pawn);
		}
	}
	else
	{
		WP = MyGearPawn;
	}


	if( WP != None )
	{
		DrawDebugCoordinateSystem(WP.Location+(vect(0,22,42) >> (WP.Rotation)),CamRot,16.f,FALSE);
		DrawDebugCoordinateSystem(WP.Location+(vect(0,-22,42) >> (WP.Rotation)),ControlsRemapRotation,16.f,FALSE);

		// Update cover debug flags
		SetBasicCoverDebug(WP, bDebugCover);

		if( IsInCoverState() )
		{
			// draw cover protection FOV
			FOVAngle1 = Sin(WP.CoverProtectionFOV.Y*Pi/180.f);
			DrawDebugCone(WP.Location, vector(WP.Rotation), 200.f, FOVAngle1, FOVAngle1, 16, MakeColor(255,192,64,255), FALSE);
		}

		Canvas.Font = class'Engine'.Static.GetSmallFont();
		Canvas.SetDrawColor(255, 0, 255, 255);

		Text = "Pawn CoverType:" @ WP.CoverType @ "CoverAction:" @ WP.CoverAction @ "CoverDirection:" @ WP.CoverDirection @ "At LeftEdge:"@ WP.IsAtCoverEdge(TRUE) $ "/" $ WP.IsAtCoverEdge(TRUE,TRUE) @ "At RightEdge:"@WP.isAtCoverEdge(FALSE) $ "/" $ WP.IsAtCoverEdge(FALSE,TRUE);
		Canvas.SetPos( 10, Canvas.SizeY * 0.1 );
		Canvas.DrawText(Text);

		Text = "Link:" @ WP.CurrentLink @ "bIsInStationaryCover:" @ WP.bIsInStationaryCover @ "CurrentSlotDirection:" $ WP.CurrentSlotDirection;
		Canvas.DrawText(Text);

		Text = "CurrentSlotIdx:" @ WP.CurrentSlotIdx @ "LeftSlotIdx:" @ WP.LeftSlotIdx @ "RightSlotIdx:" @ WP.RightSlotIdx @ "CurrentSlotPct:" @ WP.CurrentSlotPct @ "Closest:" @ WP.ClosestSlotIdx;
		Canvas.DrawText(Text);

		if( WP.CurrentLink != None )
		{
			if (WP.LeftSlotIdx >= 0 && WP.LeftSlotIdx < WP.CurrentLink.Slots.Length)
{
				Slot = WP.CurrentLink.Slots[WP.LeftSlotIdx];
				Text = " L - bEnabled:" @ Slot.bEnabled @ "bLeanLeft:" @ Slot.bLeanLeft @ "bLeanRight:" @ Slot.bLeanRight @ "Mantle:" @ Slot.bCanMantle;
				Canvas.DrawText(Text);
			}

			if (WP.RightSlotIdx >= 0 && WP.RightSlotIdx < WP.CurrentLink.Slots.Length)
			{
				Slot = WP.CurrentLink.Slots[WP.RightSlotIdx];
				Text = " R - bEnabled:" @ Slot.bEnabled @ "bLeanLeft:" @ Slot.bLeanLeft @ "bLeanRight:" @ Slot.bLeanRight @ "Mantle:" @ Slot.bCanMantle;
				Canvas.DrawText(Text);
			}
		}
	}

	// joy move
	Text = "JoyRight:"$PlayerInput.RawJoyRight$"/"$RemappedJoyRight @ "JoyUp:"$PlayerInput.RawJoyUp$"/"$RemappedJoyUp;
	Canvas.DrawText( Text );

	// joy look
	Text = "RawJoyLookRight:"$PlayerInput.RawJoyLookRight$"/"$PlayerInput.aTurn @ "RawJoyLookUp:"$PlayerInput.RawJoyLookUp $"/"$PlayerInput.aLookUp;
	Canvas.DrawText( Text );

	if (WP != None && WP.Mesh != None)
	{
		Canvas.DrawText("Root motion mode:"@WP.Mesh.RootMotionMode);
		Canvas.DrawText("Precise destination?:"@bPreciseDestination@"Physics:"@WP.Physics@"Collide World?:"@WP.bCollideWorld);
	}
}

function DrawDebugText(GearHUD_Base H, bool bShadowPass, String Text)
{
	local float XL, YL;

	if( H.Canvas.CurY >= H.Canvas.SizeY * 0.95f )
	{
		H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
		DebugTextMaxLen = 0.f;

		if( bShadowPass )
		{
			H.Canvas.SetPos(H.Canvas.CurX, H.Canvas.CurY + 1.f);
		}
	}

	H.Canvas.StrLen(Text, XL, YL);
	if( XL > DebugTextMaxLen )
	{
		DebugTextMaxLen = XL;
	}

	H.Canvas.DrawText(Text);
}

exec function Boom(optional vector Loc)
{
	local vector NudgedHitLocation;
	local GearExplosionActor ExplosionActor;

	if (TestBoom != None)
	{
		// using a hitlocation slightly away from the impact point is nice for certain things
		if (IsZero(Loc))
		{
			NudgedHitLocation = Pawn.Location + vect(0,0,-50);
		}
		else
		{
			NudgedHitLocation = Loc;
		}
		ExplosionActor = Spawn(class'GearExplosionActor',,, NudgedHitLocation, Rotation);
		TestBoom.ActorToIgnoreForDamage = Pawn;
		ExplosionActor.Explode(TestBoom);		// go bewm

// 		if (class'GDT_Boomer_Flail'.default.bDrawDebugGore)
// 			ExplosionActor.DrawDebug();
	}
}

/** Simulate being killed to the Guardian Angel system */
exec function GA_Killed()
{
	local GearPC GPC;

	foreach WorldInfo.AllControllers(class'GearPC', GPC)
	{
		GPC.GuardianAngelWasKilled();
	}
}

/** Simulate being downed to the Guardian Angel system */
exec function GA_Downed()
{
	local GearPC GPC;

	foreach WorldInfo.AllControllers(class'GearPC', GPC)
	{
		GPC.GuardianAngelWasDowned();
	}
}

/**
 * List connections and reservations of the persistent party host beacon
 */
exec function DumpPersistentParty()
{
	local PartyBeaconHost PersistentPartyBeacon;
	PersistentPartyBeacon = PartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
	if (PersistentPartyBeacon != None)
	{
		PersistentPartyBeacon.DumpReservations();
	}
	else
	{
		`Log("Persistent party host beacon does not exist.");
	}
}

/**
 * List connections and reservations of the player match host beacon
 */
exec function DumpPlayerMatchReservations()
{
	local GearGameMP_Base MPGame;

	MPGame = GearGameMP_Base(WorldInfo.Game);
	if (MPGame != None &&
		MPGame.HostPlayerMatchBeacon != None)
	{
		MPGame.HostPlayerMatchBeacon.DumpReservations();
	}
	else
	{
		`Log("Player match host beacon does not exist.");
	}
}

/**
 * List connections and reservations of the ranked match host beacon
 */
exec function DumpRankedMatchReservations()
{
	local GearPartyGame_Base PartyGame;

	PartyGame = GearPartyGame_Base(WorldInfo.Game);
	if (PartyGame != None &&
		PartyGame.HostVsReservationBeacon != None)
	{
		PartyGame.HostVsReservationBeacon.DumpReservations();
	}
	else
	{
		`Log("Ranked match host vs beacon does not exist.");
	}
}

/**
 * List connections and bandwidth histories mesh client/host beacon
 */
exec function DumpMeshBeacon()
{
	local GearPartyGame_Base PartyGame;

	PartyGame = GearPartyGame_Base(WorldInfo.Game);
	if (PartyGame != None)
	{
		if (PartyGame.HostMeshConnectionBeacon != None)
		{
			PartyGame.HostMeshConnectionBeacon.DumpConnections();
		}
		if (PartyGame.ClientMeshConnectionBeacon != None)
		{
			PartyGame.ClientMeshConnectionBeacon.DumpInfo();
		}
	}
	else
	{
		`Log("Ranked match host mesh beacon does not exist.");
	}
}

/**
 * List connections and reservations of the player match host beacon
 */
exec function DumpCoopMatchReservations()
{
	local GearGameSP_Base CoopGame;

	CoopGame = GearGameSP_Base(WorldInfo.Game);
	if (CoopGame != None &&
		CoopGame.HostCoopReservationBeacon != None)
	{
		CoopGame.HostCoopReservationBeacon.DumpReservations();
	}
	else
	{
		`Log("Coop match host beacon does not exist.");
	}
}

/**
 * Render debug information to the full screen canvas after the player views and UI have been rendered.
 *
 * @param Canvas canvas object to use for rendering debug info
 */
function DebugPostRender(Canvas Canvas)
{
	local GearPartyGame_Base PartyGame;

	if (WorldInfo != None)
	{
		PartyGame = GearPartyGame_Base(WorldInfo.Game);
		if (PartyGame != None)
		{
			if (bDebugRenderMeshBeacon)
			{
				if (PartyGame.HostMeshConnectionBeacon != None)
				{
					PartyGame.HostMeshConnectionBeacon.DebugRender(Canvas,PartyGame.OptimalHostSelection());
				}
				if (PartyGame.ClientMeshConnectionBeacon != None)
				{
					PartyGame.ClientMeshConnectionBeacon.DebugRender(Canvas);
				}
			}
		}
	}
}

/**
 * Toggles the rendering of on-screen info being updated by the mesh beacon
 */
exec function RenderMeshBeacon()
{
	bDebugRenderMeshBeacon = !bDebugRenderMeshBeacon;
}

/**
 * Add an entry to the bandwidth history of the player's profile
 */
exec function AddBandwidthHistory(int UpstreamBytesPerSec)
{
	local GearProfileSettings Profile;
	local int PlayerControllerId, MinutesSinceLastTest;
	local array<ConnectionBandwidthStats> BandwidthHistory;
	local ConnectionBandwidthStats NewBandwidthStats;

	NewBandwidthStats.UpstreamRate = UpstreamBytesPerSec;
	PlayerControllerId = GetControllerId();
	Profile = GearProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(PlayerControllerId));
	if (Profile != None)
	{
		// read current history and add the new entry but only keep a max of 5 total
		Profile.ReadBandwidthHistory(BandwidthHistory,MinutesSinceLastTest);
		if (BandwidthHistory.Length < 5)
		{
			BandwidthHistory.InsertItem(0,NewBandwidthStats);
		}
		else
		{
			BandwidthHistory.InsertItem(0,NewBandwidthStats);
			BandwidthHistory.Remove(5,BandwidthHistory.Length - 5);
		}
		// save new history and profile
		Profile.SaveBandwidthHistory(BandwidthHistory);
		SaveProfile();
	}
}

/**
 * Clear all entries of the bandwidth history of the player's profile
 */
exec function ClearBandwidthHistory()
{
	local GearProfileSettings Profile;
	local int PlayerControllerId;
	local array<ConnectionBandwidthStats> BandwidthHistory;

	PlayerControllerId = GetControllerId();
	Profile = GearProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(PlayerControllerId));
	if (Profile != None)
	{
		// save empty history to clear it
		Profile.SaveBandwidthHistory(BandwidthHistory);
		SaveProfile();
	}
}

exec function CTLCamTest()
{
	if (MyGearPawn.IsAKidnapper())
	{
		Possess(MyGearPawn.InteractionPawn, false);
	}
}

exec function TestBlood(int Type)
{
	MyGearPawn.bUnlimitedHealth = true;
	Outer.Pawn.TakeDamage(Type * 300 + 100, Outer, Outer.Pawn.Location + vect(0,0,1) * Outer.Pawn.GetCollisionHeight(), vector(Outer.Pawn.Rotation), class'GearDamageType');
}

/** Draw a sphere indicating headshot hit/miss and disable most enemy hit reactions/flinching */
exec function DebugHeadshots()
{
	// flip the variable on all pawns
	ConsoleCommand("set gearpawn bWeaponDebug_HeadShotLocation" @ !class'GearPawn'.default.bWeaponDebug_HeadShotLocation);

	ClientMessage("Headshot debugging:" @ (class'GearPawn'.default.bWeaponDebug_HeadShotLocation ? "On" : "Off"));
}

/** Pick Closest AI and return - utility function **/
function GearAI PickClosestAI()
{
	local GearAI AI, ClosestAI;
	local PlayerController PC;
	local float Distance, TempDistance;

	// Find player
	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		break;
	}

	Distance = 9999999;

	// Find closest AI and transform.
	foreach WorldInfo.AllControllers(class'GearAI',AI)
	{
		if ( AI.Pawn!=none )
		{
			TempDistance = VSizeSq(PC.ViewTarget.Location-AI.Pawn.Location);
			if (Distance > TempDistance)
			{
				Distance = TempDistance;
				ClosestAI = AI;
			}
		}
	}

	return ClosestAI;
}

/** Spawn a Drudge with the specified mutation probabilities */
exec function AIController SpawnDrudge(optional float HeadMutChance, optional float ArmMutChance, optional float LegMutChance)
{
	local AIController DrudgeAI;
	local GearPawn_LambentDroneMutatable DrudgePawn;

	if( HeadMutChance <= 0.f && ArmMutChance <= 0.f && LegMutChance <= 0.f )
	{
		return SpawnPawn("lambentdrone");
	}
	DrudgeAI = SpawnPawn("drudge");
	if( DrudgeAI != None && DrudgeAI.Pawn != None )
	{
		DrudgePawn = GearPawn_LambentDroneMutatable(DrudgeAI.Pawn);
		if( DrudgePawn != None )
		{
			DrudgePawn.HeadMutationChance = FClamp(HeadMutChance, 0.f, 1.f);
			DrudgePawn.ArmsMutationChance = FClamp(ArmMutChance, 0.f, 1.f);
			DrudgePawn.LegsMutationChance = FClamp(LegMutChance, 0.f, 1.f);
		}
	}
	return DrudgeAI;
}

/** Drudge Transform Command **/
exec function DrudgeTransform(optional INT TransformRequest)
{
	local GearAI RetardAI;
	local GearAI_LambentDrudge DrudgeAI;
	local GearPawn_LambentDroneMutatable Drudge;

	RetardAI = (PickClosestAI());

	DrudgeAI = GearAI_LambentDrudge(RetardAI);

	if ( DrudgeAI == none )
	{
		Drudge = GearPawn_LambentDroneMutatable(RetardAI.Pawn);

		if (Drudge!=none)
		{
			Drudge.Mutate(TransformRequest);
		}
	}
	else
	{
		// clear all commands and add mutate command
		class'AICmd_Drudge_Mutate'.static.Mutate( DrudgeAI, TransformRequest );
	}
}
exec function TestPathToNearestPickup()
{
	local GearWeaponPickupFactory Factory,ClosestFactory;

	local float ClosestDistSq;
	local float ThisDistSq;

	ClosestDistSq = -1;

	foreach WorldInfo.AllNavigationPoints( class'GearWeaponPickupFactory', Factory )
	{
		if (!Factory.bMP_ExcludeMeatflag)
		{
			ThisDistSq = VSizeSq(Factory.Location - Pawn.Location);

			if(ThisDistSq < ClosestDistSq || ClosestDistSq < 0)
			{
				ClosestDistSq = ThisDistSq;
				ClosestFactory = Factory;
			}
		}
	}

	if(ClosestFactory != none)
	{
		class'NavMeshGoal_At'.static.AtActor(NavigationHandle,ClosestFactory,, false);
		if(NavigationHandle.FindPath())
		{
			ClientMessage("SUCCESS! ("@ClosestFactory@")");
			DrawDebugLine(ClosestFactory.Location,Pawn.Location,0,255,0,TRUE);
		}
		else
		{
			ClientMessage("FAIL! ("@ClosestFactory@")");

			DrawDebugLine(ClosestFactory.Location,Pawn.Location,255,0,0,TRUE);
		}

	}
}

/** Toggles Drudge polyp spawning */
exec function DrudgeDisablePolypSpawn()
{
	local GearAI AI;
	local GearPawn_LambentDroneMutatable Drudge;

	foreach WorldInfo.AllControllers(class'GearAI', AI)
	{
		Drudge = GearPawn_LambentDroneMutatable(AI.Pawn);
		if ( Drudge != None )
		{
			Drudge.MaxPolypsAlive = 0;
		}
	}
}

/** Toggles AI Flocking for those that can flock */
exec function ToggleFlocking()
{
	local GearGame Game;

	Game = GearGame(WorldInfo.Game);
	if( Game != None )
	{
		Game.bDisallowFlocking = !Game.bDisallowFlocking;

		if( Game.bDisallowFlocking )
		{
			ClientMessage("Flocking OFF");
		}
		else
		{
			ClientMessage("Flocking ON");
		}
	}
}

/** Toggles drudge force head fire */
exec function DrudgeToggleForcedHeadFire()
{
	local GearPawn_LambentDroneMutatable Drudge;
	local GearAI_LambentDrudge AI;
	foreach WorldInfo.AllPawns(class'GearPawn_LambentDroneMutatable',Drudge)
	{
		if(!Drudge.bForceHeadFire)
		{
			AI = GearAI_LambentDrudge(Drudge.Controller);
			if(AI != none)
			{
				class'AICmd_Drudge_Mutate'.static.Mutate(AI,0x01);
			}

			Drudge.SetForceHeadFire(true);
			Drudge.GroundSpeed=0;
			AI.bGodMode=true;
		}
		else
		{
			Drudge.SetForceHeadFire(false);
			Drudge.GroundSpeed=Drudge.DefaultGroundSpeed;
			AI.bGodMode=false;
		}

	}
}

exec function IronSights(bool bEnable)
{
	bIronSightsEnabled = bEnable;

	ConsoleCommand("set gearweap_assaultrifle bCanDoIronsights"@bIronSightsEnabled);
	ConsoleCommand("set gearweap_cogpistol bCanDoIronsights"@bIronSightsEnabled);
	ConsoleCommand("set gearweap_locustpistol bCanDoIronsights"@bIronSightsEnabled);
	ConsoleCommand("set gearweap_locustburstpistol bCanDoIronsights"@bIronSightsEnabled);
	ConsoleCommand("set gearweap_retrolancer bCanDoIronsights"@bIronSightsEnabled);
	ConsoleCommand("set gearweap_locustassaultrifle bCanDoIronsights"@bIronSightsEnabled);
}

exec function BonusObjective(string ObjectiveName)
{
	local class<GearHordeBonusObjective> ObjectiveClass;
	local GearGameHorde_Base Game;

	ObjectiveClass = class<GearHordeBonusObjective>(FindObject("GearGame.GearHordeObjective_" $ ObjectiveName, class'Class'));
	if (ObjectiveClass != None)
		{
		Game = GearGameHorde_Base(WorldInfo.Game);
		if (Game.ActiveBonusObjective != None)
			{
			Game.ActiveBonusObjective.FailObjective();
		}
		Game.ActiveBonusObjective = new(Game) ObjectiveClass;
		Game.ActiveBonusObjective.Init();
	}
}


exec function TestCameraAnim(optional byte Space)
{
	local CameraAnimInst CAI;
	local GearPawn P;

	// CameraAnim'cameraanimtest.CA_TranslationRotationTest'
	//CAI = PlayerCamera.PlayCameraAnim(CameraAnim'Effects_Camera.Explosions.CA_Grenade_Explo_Front');
	CAI = PlayerCamera.PlayCameraAnim(CameraAnim'COG_MarcusFenix.Camera_Anims.Duel_Win_Cam01');	

	if (Space == CAPS_World)
	{
		CAI.SetPlaySpace(CAPS_World);
	}
	else if (Space == CAPS_UserDefined)
	{
		// relative to nearby pawn, for testing
		foreach WorldInfo.AllPawns(class'GearPawn', P)
		{
			if (P != MyGearPawn)
			{
				CAI.SetPlaySpace(CAPS_UserDefined, rotator(P.Location - MyGearPawn.Location));
				break;
			}
		}
	}
}

exec function TestSilverbackDamage()
{
	local GearPawn_SilverbackBase Silverback;

	foreach WorldInfo.AllPawns(class'GearPawn_SilverbackBase', Silverback)
	{
		Silverback.TestDamage();
	}
}

/** Clears any standby demerits for a player */
exec function ClearStandby()
{
	ProfileSettings.AdjustStandByDemeritsCount(-ProfileSettings.GetStandByDemerits());
}

/** Logs standby demerits of a player */
exec function LogStandby()
{
	`Log("Standby is "$ProfileSettings.GetStandByDemerits());
}

/**
 * Gives standby demerits to a player
 *
 * @param NumDemerits the number of demerits to give them
 */
exec function GiveStandbyDemerits(int NumDemerits)
{
	`Log("Standby was "$ProfileSettings.GetStandByDemerits());
	ProfileSettings.AdjustStandByDemeritsCount(NumDemerits);
	`Log("Standby is "$ProfileSettings.GetStandByDemerits());
}

/** Artificially adjust quit counts */
exec function AddQuit(int Delta)
{
	ProfileSettings.AdjustQuitCount(Delta);
}

/** Clears a player's quit count */
exec function ClearQuit()
{
	ProfileSettings.ClearQuitCount();
}

/** Logs a player's quit count */
exec function LogQuit()
{
	`Log("Quit count is "$ProfileSettings.GetQuitCount());
}

/**
 * Gives disconnects to a player
 *
 * @param NumDisconnects the number of disconnects to give them
 */
exec function GiveDisconnects(int NumDisconnects)
{
	`Log("Disconnects were "$ProfileSettings.GetDisconnectCount());
	ProfileSettings.AdjustDisconnectCount(NumDisconnects);
	`Log("Disconnects are "$ProfileSettings.GetDisconnectCount());
}

/**
 * Starts reading the latest news
 */
exec function ReadNews()
{
	// Figure out if we have an online subsystem registered
	if (OnlineSub != None)
	{
		// Grab the news interface to verify the subsystem supports it
		if (OnlineSub.NewsInterface != None)
		{
			// Start news read
			OnlineSub.NewsInterface.AddReadNewsCompletedDelegate(OnReadGameNewsCompleted);
			OnlineSub.NewsInterface.ReadNews(0,ONT_GameNews);

		}
		else
		{
			`Log("Missing the news interface object");
		}
	}
	else
	{
		`Log("Missing the online subsystem");
	}
}

/**
 * Delegate used in notifying the UI/game that the news read operation completed
 *
 * @param bWasSuccessful true if the read completed ok, false otherwise
 * @param NewsType the type of news this callback is for
 */
function OnReadGameNewsCompleted(bool bWasSuccessful,EOnlineNewsType NewsType)
{
	local string News;
	`Log("OnReadGameNewsCompleted("$bWasSuccessful$","$NewsType$")");

	OnlineSub.NewsInterface.ClearReadNewsCompletedDelegate(OnReadGameNewsCompleted);

	if (bWasSuccessful)
	{
		// Ask the online code for the news
		News = OnlineSub.NewsInterface.GetNews(0,ONT_GameNews);
		if (len(News) == 0)
		{
			`Log("News data was empty");
		}
		else
		{
			`Log("News = "$News);
		}
	}
}

/** Downloads the playlist data again */
exec function DownloadPlaylist()
{
	local OnlinePlaylistManager PlaylistMan;

	PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));

	// Read the playlist information
	if (PlaylistMan != None)
	{
		PlaylistMan.Reset();
		PlaylistMan.OnReadPlaylistComplete = OnPlaylistDownloadComplete;
		PlaylistMan.DownloadPlaylist();
	}
}

/*
 * Signal from the MCP playlist downloader that all files have been downloaded
 */
function OnPlaylistDownloadComplete()
{
	local OnlinePlaylistManager PlaylistMan;

	PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));

	// Read the playlist information
	if (PlaylistMan != None)
	{
		PlaylistMan.OnReadPlaylistComplete = None;
	}

	`Log("Playlist downloading is complete");
}

/**
 * Sets the custom data for the owning player
 *
 * @param Data1 the value to set in field 1
 * @param Data2 the value to set in field 2
 * @param Data3 the value to set in field 3
 * @param Data4 the value to set in field 4
 */
exec function SetPartyData(int Data1,int Data2,int Data3,int Data4)
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);

	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PartyChatInterface != None)
	{
		OnlineSub.PartyChatInterface.SetPartyMemberCustomData(LP.ControllerId,Data1,Data2,Data3,Data4);
	}
}

/**
 * Sets the custom data indicating a player leveled up
 *
 * @param Data1 the value to set in field 1
 */
exec function SendPartyLevelData(int NewLevel)
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);

	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PartyChatInterface != None)
	{
		OnlineSub.PartyChatInterface.SetPartyMemberCustomData(LP.ControllerId,PNT_LevelChange,NewLevel,0,0);
	}
}

/**
 * Reads the playlist population data from MCP
 */
exec function GetPlaylistPopulationData()
{
	local OnlinePlaylistManager PlaylistMan;

	PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));

	if (PlaylistMan != None)
	{
		PlaylistMan.ReadPlaylistPopulation();
	}
}

exec function ResetSiegeCharUnlocks()
{
	local GearPRI_Siege PRI;
	local int i;

	PRI = GearPRI_Siege(Outer.PlayerReplicationInfo);
	for (i = 0; i < ArrayCount(PRI.UnlockedCharacters); i++)
	{
		PRI.UnlockedCharacters[i] = `OPEN_LOCUSTLIST_TIER;
		PRI.bForceNetUpdate = true;
		if (LocalPlayer(Player) != None)
		{
			PRI.ReplicatedEvent(nameof(PRI.UnlockedCharacters));
		}
	}
}

`endif

exec function TestUpdatingScene(string TitleKey, string DescKey, bool bIsCheckpoint)
{
	class'GearUIManager'.static.OpenUpdatingScene(TitleKey, DescKey, bIsCheckpoint);
}

exec function CloseUpdatingScene(bool bIsCheckpoint)
{
	class'GearUIManager'.static.CloseUpdatingScene(bIsCheckpoint);
}

exec function TestObstacleLineCheck()
{
	local vector Start,End,Hit,Norm;

	Start = Pawn.Location;
	End = Pawn.Location + Vector(Pawn.GetViewRotation())*200;
	if( class'NavigationHandle'.static.ObstacleLineCheck(Start,End,vect(10,10,10),Hit,Norm) )
	{
		DrawDebugLine( Start,End, 0, 255, 0, TRUE);
	}
	else
	{
		DrawDebugLine( Start,End, 255, 0, 0, TRUE);
		DrawDebugCoordinateSystem(Hit,rotator(Norm),16,TRUE);
	}
}

exec function DebugCamera()
{
	GameThirdPersonCamera(GamePlayerCamera(PlayerCamera).CurrentCamera).bDrawDebug = !GameThirdPersonCamera(GamePlayerCamera(PlayerCamera).CurrentCamera).bDrawDebug;
}

exec function DumpSmallPartyPanel()
{
	local GearPC GPC;
	local GearMenuHUD MenuHUD;
	local UIWidget_SmallPartyPanel PartyPanel;
	local int SlotIdx;

	foreach WorldInfo.LocalPlayerControllers(class'GearPC', GPC)
	{
		break;
	}

	if (GPC != None)
	{
		MenuHUD = GearMenuHUD(GPC.myHUD);
		if (MenuHUD != None)
		{
			if (MenuHUD.FrontEndMovie != None)
			{
				PartyPanel = MenuHUD.FrontEndMovie.SmallPartyPanel;
			}
			else if (MenuHUD.PregameLobbyMovie != None)
			{
				PartyPanel = MenuHUD.PregameLobbyMovie.SmallPartyPanel;
			}

			if (PartyPanel != None)
			{
				`log("-----------PARTY PANEL DATA---------------");
				for (SlotIdx = 0; SlotIdx < PartyPanel.SlotList.Length; SlotIdx++)
				{
					`log("----------------------------------");
					`log("--Slot Index"@SlotIdx);
					`log("------SlotType:" $ PartyPanel.SlotList[SlotIdx].SlotType);
					`log("------PRI:" $ PartyPanel.SlotList[SlotIdx].PRI);
					if (PartyPanel.SlotList[SlotIdx].PRI != None)
					{
						`log("------PRI PlayerName:" $ PartyPanel.SlotList[SlotIdx].PRI.PlayerName);
					}
					`log("------bSpeakerIcon:" $ PartyPanel.SlotList[SlotIdx].bSpeakerIcon);
					`log("------SlotText:" $ PartyPanel.SlotList[SlotIdx].SlotText);
					`log("------LocalPlayerIndex:" $ PartyPanel.SlotList[SlotIdx].LocalPlayerIndex);
					`log("------Status:" $ PartyPanel.SlotList[SlotIdx].Status);
					`log("------StateString:" $ PartyPanel.SlotList[SlotIdx].StateString);
					`log("------PlayerRank:" $ PartyPanel.SlotList[SlotIdx].PlayerRank);
					`log("------MedalIndex:" $ PartyPanel.SlotList[SlotIdx].MedalIndex);
					`log("------BGColor:" $ PartyPanel.SlotList[SlotIdx].BGColor);
					`log("------VoiceColor:" $ PartyPanel.SlotList[SlotIdx].VoiceColor);
					`log("------TeamIndex:" $ PartyPanel.SlotList[SlotIdx].TeamIndex);
					`log("----------------------------------");
				}
				`log("-----------PARTY PANEL DATA---------------");
			}
		}
	}
}

/**
 * Sets the value in the profile to a unique skin value
 *
 * @param WeaponName - name of the weapon to set
 * @param UniqueSkinIndex the index to use
 */
exec function ChangeWeaponSkin(String WeaponName, int UniqueSkinId)
{
	local GearPC GPC;
	local EWeaponClass WeapType;

	foreach WorldInfo.LocalPlayerControllers(class'GearPC', GPC)
	{
		break;
	}

	if (GPC != None)
	{
		switch (WeaponName)
		{
			case "Lancer":
				WeapType = WC_Lancer;
				break;
			case "Hammer":
				WeapType = WC_Hammerburst;
				break;
			case "Retro":
				WeapType = WC_RetroLancer;
				break;
			case "Shotgun":
				WeapType = WC_Gnasher;
				break;
			case "SawedOff":
				WeapType = WC_SawedOffShotgun;
				break;
			default:
				`log("Invalid weapon name: Use Lancer, Hammer, Retro, Shotgun or SawedOff");
				return;
		}
		GPC.ProfileSettings.SetUniqueIdForWeaponSkin(WeapType, UniqueSkinId);
		GPC.SaveProfile();
	}
}

/**
 * Updates the bling skins for all weapons
 *
 * @param SkinIndex the index to use
 */
exec function ChangeWeaponBlingSkin(int SkinIndex)
{
	local GearPRI PRI;
	local GearWeapon GW;
	local GearInventoryManager InvManager;

	if (MyGearPawn != None)
	{
		InvManager = GearInventoryManager(MyGearPawn.InvManager);
	}

	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None && InvManager != None)
	{
		GW = GearWeapon(InvManager.GetInventoryInSlot(EASlot_RightShoulder));
		if (GW != None)
		{
			PRI.PrimaryWeaponSkin.WeapClass = GW.Class;
		}
		PRI.PrimaryWeaponSkin.WeaponSkinIndex = SkinIndex;

		GW = GearWeapon(InvManager.GetInventoryInSlot(EASlot_LeftShoulder));
		if (GW != None)
		{
			PRI.SecondaryWeaponSkin.WeapClass = GW.Class;
		}
		PRI.SecondaryWeaponSkin.WeaponSkinIndex = SkinIndex;
	}
}

// Postprocess testing
exec function PP(optional string Type, optional float BlendTime=2.f)
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);

	switch (Type)
	{
	case "menu":
		LP.OverridePostProcessSettings(MenuPPSettings, BlendTime);
		break;
	case "pause":
		LP.OverridePostProcessSettings(PausePPSettings, BlendTime);
		break;
	case "gameover":
		LP.OverridePostProcessSettings(GameoverPPSettings, BlendTime);
		break;
	case "taccom":
		LP.OverridePostProcessSettings(MyGearHud.TaccomPPSettings, BlendTime);
		break;
	case "bleedout":
		MyGearHUD.SetBleedOutEffectSettings(BlendTime);
		LP.OverridePostProcessSettings(MyGearHud.BleedOutPPSettings, 0.f);
		break;
	case "bleedout2":
		MyGearHUD.SetBleedOutEffectSettings(0.f);
		LP.OverridePostProcessSettings(MyGearHud.BleedOutPPSettings, BlendTime);
		break;

	default:
		LP.ClearPostProcessSettingsOverride(BlendTime);
	}
}


exec function StatifyFireLinks()
{
	local CoverLink Link;
	local int RecordedLinks;
	local int TouchedLinks;

	foreach AllActors(class'CoverLink',Link)
	{
		if( Link != none )
		{
			TouchedLinks++;
			RecordedLinks += GearGame(WorldInfo.Game).GameplayEventsWriter.RecordCoverLinkFireLinks(Link,Outer);
		}
	}

	`log(`showvar(RecordedLinks)@`showvar(TouchedLinks));
	// warning futsssssssss
	RecordedLinks = TouchedLinks;
	TouchedLinks = RecordedLinks;
}

/** Loads DLC for testing purposes */
exec function LoadDLC()
{
	local DownloadableContentManager DLCManager;

	DLCManager = class'GameEngine'.static.GetDLCManager();
	if (DLCManager != None)
	{
		if (class'WorldInfo'.static.IsMenuLevel())
		{
			DLCManager.RefreshDLC();
		}
		else
		{
			`Log("Not in the menu level skipping DLC loading");
		}
	}
}

/** Unloads DLC for testing purposes */
exec function UnloadDLC()
{
	local DownloadableContentManager DLCManager;

	DLCManager = class'GameEngine'.static.GetDLCManager();
	if (DLCManager != None)
	{
		if (class'WorldInfo'.static.IsMenuLevel())
		{
			DLCManager.ClearDLC();
		}
		else
		{
			`Log("Not in the menu level skipping DLC unloading");
		}
	}
}

/** Enumerates savegame files for testing purposes */
exec function EnumSaveGames()
{
	if (OnlineSub != None)
	{
		if (OnlineSub.ContentInterface != None)
		{
			// Add our read delegates
			OnlineSub.ContentInterface.AddReadContentComplete(0,OCT_SaveGame,OnSaveGameReadContentComplete);
			// Start the read
			OnlineSub.ContentInterface.ReadContentList(0,OCT_SaveGame,GetDeviceId());
		}
	}
}

/**
 * Prints out the results of the save game enumeration
 *
 * @param bWasSuccessful whether the enumeration worked or not
 */
function OnSaveGameReadContentComplete(bool bWasSuccessful)
{
	local array<OnlineContent> SaveGames;
	local int Index;
	local int InnerIndex;

	if (OnlineSub != None)
	{
		if (OnlineSub.ContentInterface != None)
		{
			OnlineSub.ContentInterface.ClearReadContentComplete(0,OCT_SaveGame,OnSaveGameReadContentComplete);
			OnlineSub.ContentInterface.GetContentList(0,OCT_SaveGame,SaveGames);
			`Log("Found "$SaveGames.Length$" save games");
			// Iterate through all items
			for (Index = 0; Index < SaveGames.Length; Index++)
			{
				`Log("Found '"$SaveGames[Index].FriendlyName$"' save game");
				`Log("   DeviceId "$SaveGames[Index].DeviceId);
				`Log("   ContentType "$SaveGames[Index].ContentType);
				`Log("   Filename "$SaveGames[Index].Filename);
				`Log("   ContentPath "$SaveGames[Index].ContentPath);
				`Log("");
				`Log("   Files in content package:");
				// List the internal files
				for (InnerIndex = 0; InnerIndex < SaveGames[Index].ContentFiles.Length; InnerIndex++)
				{
					`Log("   InternalFileName "$SaveGames[Index].ContentFiles[InnerIndex]);
				}
			}
		}
	}
}

/** Writes a save game for code validation */
exec function WriteSaveGame()
{
	local array<byte> SaveData;
	local int Index;

	// Build some data for validating
	SaveData.Length = 10;
	for (Index = 0; Index < 10; Index++)
	{
		SaveData[Index] = Index;
	}
	if (OnlineSub != None)
	{
		if (OnlineSub.ContentInterface != None)
		{
			// Add our write delegate
			OnlineSub.ContentInterface.AddWriteSaveGameDataComplete(0,OnWriteSaveGameDataComplete);
			// Write our fake data
			OnlineSub.ContentInterface.WriteSaveGameData(0,GetDeviceId(),"Joe's Test Data","TestData.dat","TestSave1",SaveData);
		}
	}
}

/**
 * Delegate used when the content write request has completed. Kicks off a read of the same data
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 * @param LocalUserNum the user that was initiating the data write
 * @param DeviceId the device to write the same game to
 * @param FriendlyName the friendly name of the save game
 * @param FileName the file to write to inside of the content package
 * @param SaveGameData the data to write to the save game file
 */
function OnWriteSaveGameDataComplete(bool bWasSuccessful,byte LocalUserNum,int DeviceId,string FriendlyName,string FileName,string SaveFileName)
{
	if (OnlineSub != None)
	{
		if (OnlineSub.ContentInterface != None)
		{
			// Clear our write delegate
			OnlineSub.ContentInterface.ClearWriteSaveGameDataComplete(0,OnWriteSaveGameDataComplete);
			`Log("Write was successful " $ bWasSuccessful $
				" for user " $ LocalUserNum $
				" on device " $ DeviceId $
				" for package " $ FriendlyName $
				" with file " $ FileName $
				" and save file " $ SaveFileName);
			if (bWasSuccessful)
			{
				// Add our read delegate
				OnlineSub.ContentInterface.AddReadSaveGameDataComplete(0,OnReadSaveGameDataComplete);
				// Read our test data
				OnlineSub.ContentInterface.ReadSaveGameData(LocalUserNum,DeviceId,FriendlyName,FileName,SaveFileName);
			}
		}
	}
}

/**
 * Delegate used when the content read request has completed. Copies the data into the buffer and logs it out
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 * @param LocalUserNum the user that was initiating the data read
 * @param DeviceId the device that the read was on
 * @param FriendlyName the friendly name of the save game that was returned by enumeration
 * @param FileName the file to read from inside of the content package
 * @param SaveFileName the file name of the save game inside the content package
 */
function OnReadSaveGameDataComplete(bool bWasSuccessful,byte LocalUserNum,int DeviceId,string FriendlyName,string FileName,string SaveFileName)
{
	local array<byte> SaveData;
	local int Index;

	if (OnlineSub != None)
	{
		if (OnlineSub.ContentInterface != None)
		{
			// Clear our write delegate
			OnlineSub.ContentInterface.ClearReadSaveGameDataComplete(0,OnReadSaveGameDataComplete);
			`Log("Read was successful " $ bWasSuccessful $
				" for user " $ LocalUserNum $
				" on device " $ DeviceId $
				" for package " $ FriendlyName $
				" with file " $ FileName $
				" and save file " $ SaveFileName);
			// Now get the save game bytes
			OnlineSub.ContentInterface.GetSaveGameData(LocalUserNum,DeviceId,FriendlyName,FileName,SaveFileName,SaveData);
			`Log("SaveData.Length = " $ SaveData.Length);
			// Build some data for validating
			for (Index = 0; Index < SaveData.Length; Index++)
			{
				`Log("SaveData[Index] = " $ SaveData[Index]);
			}
			OnlineSub.ContentInterface.DeleteSaveGame(LocalUserNum,DeviceId,FriendlyName,FileName);
			OnlineSub.ContentInterface.ClearContentList(LocalUserNum,OCT_SaveGame);
		}
	}
}

/** Grants all of the achievement based unlocks */
exec function GiveAchievementUnlocks()
{
	NotifyEarnedAward('PlayedPC');
	NotifyEarnedAward('PlayedUT');
	NotifyEarnedAward('PlayedSC');
	NotifyEarnedAward('PlayedBS');
	NotifyEarnedAward('AllCamp');
	NotifyEarnedAward('OldGuard');

	ProfileSettings.SetProfileSettingValueInt(`HasGearsPCCheevo,1);
	ProfileSettings.SetProfileSettingValueInt(`HasUT3Cheevo,1);
	ProfileSettings.SetProfileSettingValueInt(`HasSCCheevo,1);
	ProfileSettings.SetProfileSettingValueInt(`HasBSCheevo,1);
	ProfileSettings.SetProfileSettingValueInt(`HasGears1Camp,1);
	ProfileSettings.SetProfileSettingValueInt(`HasGears2Camp,1);
	ProfileSettings.SetProfileSettingValueInt(`HasGears3Camp,1);
	ProfileSettings.SetProfileSettingValueInt(`HasRookieGear,1);
	ProfileSettings.SetProfileSettingValueInt(`HasVeteranGear,1);
	ProfileSettings.SetProfileSettingValueInt(`HasHoardTheHorde,1);
	ProfileSettings.SetProfileSettingValueInt(`HasUT3Cheevo,1);
}

/** Wipes the player's profile and replaces it with defaults */
exec function ResetProfile()
{
	ProfileSettings.SetToDefaults();
}

/** Wipes the player's persistent data and replaces it with defaults */
exec function ResetPersistentData()
{
	PersistentData.SetToDefaults();
}

defaultproperties
{
	SpawnPawnList.Add( (PawnName="boomer",ClassName="GearGameContent.GearPawn_LocustBoomer",AIClass=class'GearAI_Boomer') )
	SpawnPawnList.Add( (PawnName="gatlingboomer",ClassName="GearGameContent.GearPawn_LocustBoomerGatling",AIClass=class'GearAI_Boomer_Gatling') )
	SpawnPawnList.Add( (PawnName="grinder",ClassName="GearGameContent.GearPawn_LocustBoomerGatling",AIClass=class'GearAI_Boomer_Gatling') )
	SpawnPawnList.Add( (PawnName="flameboomer",ClassName="GearGameContent.GearPawn_LocustBoomerFlame",AIClass=class'GearAI_Boomer_Flame') )
	SpawnPawnList.Add( (PawnName="flailboomer",ClassName="GearGameContent.GearPawn_LocustBoomerFlail",AIClass=class'GearAI_Boomer_Shield') )
	SpawnPawnList.Add( (PawnName="mauler",ClassName="GearGameContent.GearPawn_LocustBoomerFlail",AIClass=class'GearAI_Boomer_Shield') )
	SpawnPawnList.Add( (PawnName="shieldboomer",ClassName="GearGameContent.GearPawn_LocustBoomerFlail",AIClass=class'GearAI_Boomer_Shield') )
	SpawnPawnList.Add( (PawnName="butcherboomer",ClassName="GearGameContent.GearPawn_LocustBoomerButcher",AIClass=class'GearAI_Boomer_Melee') )
	SpawnPawnList.Add( (PawnName="butcher",ClassName="GearGameContent.GearPawn_LocustBoomerButcher",AIClass=class'GearAI_Boomer_Melee') )
	SpawnPawnList.Add( (PawnName="savagebutcher",ClassName="GearGameContent.GearPawn_LocustBoomerSavageButcher",AIClass=class'GearAI_Boomer_Melee') )
	SpawnPawnList.Add( (PawnName="mechanicboomer",ClassName="GearGameContent.GearPawn_LocustBoomerMechanic",AIClass=class'GearAI_Boomer_Melee') )
	SpawnPawnList.Add( (PawnName="savagedrone",ClassName="GearGameContent.GearPawn_LocustDroneSavage",AIClass=class'GearAI_SavageDrone') )
	SpawnPawnList.Add( (PawnName="savagespawner",ClassName="GearGameContent.GearPawn_LocustDroneSavageUnderground",AIClass=class'GearAI_SavageDroneUnderground') )
	SpawnPawnList.Add( (PawnName="savageboomer",ClassName="GearGameContent.GearPawn_LocustBoomerSavage",AIClass=class'GearAI_Boomer') )
	SpawnPawnList.Add( (PawnName="wretch",ClassName="GearGameContent.GearPawn_LocustWretch",AIClass=class'GearAI_Wretch') )
	SpawnPawnList.Add( (PawnName="darkwretch",ClassName="GearGameContent.GearPawn_LocustDarkWretch",AIClass=class'GearAI_Wretch') )
	SpawnPawnList.Add( (PawnName="theron",ClassName="GearGameContent.GearPawn_LocustTheron",AIClass=class'GearAI_Theron') )
	SpawnPawnList.Add( (PawnName="guard",ClassName="GearGameContent.GearPawn_LocustPalaceGuard",AIClass=class'GearAI_Theron') )
	SpawnPawnList.Add( (PawnName="palaceguard",ClassName="GearGameContent.GearPawn_LocustPalaceGuard",AIClass=class'GearAI_Theron') )
	SpawnPawnList.Add( (PawnName="lancerguard",ClassName="GearGameContent.GearPawn_LocustLancerGuard",AIClass=class'GearAI_Locust') )
	SpawnPawnList.Add( (PawnName="flameguard",ClassName="GearGameContent.GearPawn_LocustFlameGuard",AIClass=class'GearAI_FlameDrone') )
	SpawnPawnList.Add( (PawnName="savagetheroncleaver",ClassName="GearGameContent.GearPawn_SavageTheronWithCleaver",AIClass=class'GearAI_Locust') )
	SpawnPawnList.Add( (PawnName="kantus",ClassName="GearGameContent.GearPawn_LocustKantus",AIClass=class'GearAI_Kantus') )
	SpawnPawnList.Add( (PawnName="kantusarmor",ClassName="GearGameContent.GearPawn_LocustKantusArmor",AIClass=class'GearAI_KantusArmor') )
	SpawnPawnList.Add( (PawnName="priest",ClassName="GearGameContent.GearPawn_LocustKantus",AIClass=class'GearAI_Kantus') )
	SpawnPawnList.Add( (PawnName="hunter",ClassName="GearGameContent.GearPawn_LocustHunterArmorNoGrenades",AIClass=class'GearAI_Hunter') )
	SpawnPawnList.Add( (PawnName="hunternoarmormp",ClassName="GearGameContent.GearPawn_LocustHunterNoArmorMP",AIClass=class'GearAI_Hunter') )
	SpawnPawnList.Add( (PawnName="dom",ClassName="GearGame.GearPawn_COGDom",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="gus",ClassName="GearGameContent.GearPawn_COGGus",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="anya",ClassName="GearGameContent.GearPawn_COGAnya",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="baird",ClassName="GearGameContent.GearPawn_COGBaird",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="dizzy",ClassName="GearGameContent.GearPawn_COGDizzy",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="tai",ClassName="GearGameContent.GearPawn_COGTai",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="hoffman",ClassName="GearGameContent.GearPawn_COGHoffman",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="marcus",ClassName="GearGame.GearPawn_COGMarcus",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="carmine",ClassName="GearGameContent.GearPawn_COGCarmine",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="bernie",ClassName="GearGameContent.GearPawn_COGBernie",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="onyx",ClassName="GearGameContent.GearPawn_COGOnyxGuard",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="flamedrone",ClassName="GearGameContent.GearPawn_LocustFlameDrone",AIClass=class'GearAI_FlameDrone') )
	SpawnPawnList.Add( (PawnName="ticker",ClassName="GearGameContent.GearPawn_LocustTicker",AIClass=class'GearAI_Ticker') )
	SpawnPawnList.Add( (PawnName="nakedticker",ClassName="GearGameContent.GearPawn_LocustNakedTicker",AIClass=class'GearAI_NakedTicker') )
	SpawnPawnList.Add( (PawnName="bloodmount",ClassName="GearGameContent.GearPawn_LocustBloodMountWithDrone",AIClass=class'GearAI_Bloodmount') )
	SpawnPawnList.Add( (PawnName="bloodmountriderless",ClassName="GearGameContent.GearPawn_LocustBloodMountRiderless",AIClass=class'GearAI_Bloodmount') )
	SpawnPawnList.Add( (PawnName="bloodmountflamedrone",ClassName="GearGameContent.GearPawn_LocustBloodMountWithFlameDrone",AIClass=class'GearAI_Bloodmount') )
	SpawnPawnList.Add( (PawnName="bloodmounttheron",ClassName="GearGameContent.GearPawn_LocustBloodMountWithPalaceGuard",AIClass=class'GearAI_Bloodmount') )
	SpawnPawnList.Add( (PawnName="nemaslug",ClassName="GearGameContent.GearPawn_LocustNemaSlug",AIClass=class'GearAI_NemaSlug') )
	SpawnPawnList.Add( (PawnName="lambentpolyp",ClassName="GearGameContent.GearPawn_LambentPolyp",AIClass=class'GearAI_LambentPolyp',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="gunshrimp",ClassName="GearGameContent.GearPawn_SecurityBotFlying",AIClass=class'GearAI_SecurityBotFlying') )
	SpawnPawnList.Add( (PawnName="reaver",ClassName="GearGameContent.Vehicle_ReaverWithTheronSmall",AIClass=class'GearAI_Reaver') )
	SpawnPawnList.Add( (PawnName="reaverguard",ClassName="GearGameContent.Vehicle_ReaverWithPalaceGuard",AIClass=class'GearAI_Reaver') )
	SpawnPawnList.Add( (PawnName="franklin",ClassName="GearGameContent.GearPawn_NPCFranklin",AIClass=class'GearAI_NPCCOG') )
	SpawnPawnList.Add( (PawnName="franklinnodreads",ClassName="GearGameContent.GearPawn_NPCCOGFranklinWithNoDreads",AIClass=class'GearAI_NPCCOG') )
	SpawnPawnList.Add( (PawnName="drunk",ClassName="GearGameContent.GearPawn_NPCCOGDrunkMan",AIClass=class'GearAI_NPCCOG') )
	SpawnPawnList.Add( (PawnName="speedy",ClassName="GearGameContent.GearPawn_LocustSpeedy",AIClass=class'GearAI_Speedy') )
	SpawnPawnList.Add( (PawnName="sam",ClassName="GearGameContent.GearPawn_COGSam",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="adamfenix",ClassName="GearGameContent.GearPawn_COGAdamFenix",AIClass=class'GearAI_NPCUnarmed') )
	SpawnPawnList.Add( (PawnName="jace",ClassName="GearGameContent.GearPawn_COGJace",AIClass=class'GearAI_Jace') )
	SpawnPawnList.Add( (PawnName="brumak",ClassName="GearGameContent.GearPawn_LocustBrumak",AIClass=class'GearAI_Brumak') )
	SpawnPawnList.Add( (PawnName="serapede",ClassName="GearGameContent.GearPawn_LocustSerapede",AIClass=class'GearAI_Serapede') )
	SpawnPawnList.Add( (PawnName="claytoncarmine",ClassName="GearGameContent.GearPawn_CCarmine",AIClass=class'GearAI_COGGear') )

	SpawnPawnList.Add( (PawnName="carmineMP",ClassName="GearGameContent.GearPawn_COGCarmineMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="bairdMP",ClassName="GearGameContent.GearPawn_COGBairdMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="dizzyMP",ClassName="GearGameContent.GearPawn_COGDizzyMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="domMP",ClassName="GearGameContent.GearPawn_COGDomMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="gusMP",ClassName="GearGameContent.GearPawn_COGGusMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="gusThrashballMP",ClassName="GearGameContent.GearPawn_COGGusThrashballMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="taiMP",ClassName="GearGameContent.GearPawn_COGTaiMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="samMP",ClassName="GearGameContent.GearPawn_COGSamMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="anyaMP",ClassName="GearGameContent.GearPawn_COGAnyaMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="jaceMP",ClassName="GearGameContent.GearPawn_COGJaceMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="marcusMP",ClassName="GearGameContent.GearPawn_COGMarcusMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="hoffmanMP",ClassName="GearGameContent.GearPawn_COGHoffmanMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="prescottMP",ClassName="GearGameContent.GearPawn_COGPrescottMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="onyxMP",ClassName="GearGameContent.GearPawn_COGOnyxGuardMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="griffinMP",ClassName="GearGameContent.GearPawn_COGGriffinMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="KantusMP",ClassName="GearGameContent.GearPawn_LocustKantusMP",AIClass=class'GearAI_COGGear',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="SkorgeMP",ClassName="GearGameContent.GearPawn_LocustSkorgeMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="bernieMP",ClassName="GearGameContent.GearPawn_COGBernieMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="commandoDom",ClassName="GearGameContent.GearPawn_COGDomCommandoMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="GusCiv",ClassName="GearGameContent.GearPawn_COGGusCivMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="CorpserLarva",ClassName="GearGameContent.GearPawn_LocustCorpserLarvaUndergroundContent",AIClass=class'GearAI_CorpserLarvaUnderground') )
	SpawnPawnList.Add( (PawnName="MiniCorpser",ClassName="GearGameContent.GearPawn_LocustCorpserLarvaUndergroundContent",AIClass=class'GearAI_CorpserLarvaUnderground') )
	SpawnPawnList.Add( (PawnName="CorpserLarvaNaked",ClassName="GearGameContent.GearPawn_LocustCorpserLarvaUndergroundNakedContent",AIClass=class'GearAI_CorpserLarvaUnderground') )
	SpawnPawnList.Add( (PawnName="MiniCorpserNaked",ClassName="GearGameContent.GearPawn_LocustCorpserLarvaUndergroundNakedContent",AIClass=class'GearAI_CorpserLarvaUnderground') )
	SpawnPawnList.Add( (PawnName="Silverback",ClassName="GearGameContent.GearPawn_SilverbackArmed",AIClass=None) )
	SpawnPawnList.Add( (PawnName="gunker",ClassName="GearGameContent.GearPawn_LocustGunker",AIClass=class'GearAI_Gunker',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="gunkercq",ClassName="GearGameContent.GearPawn_LocustGunker",AIClass=class'GearAI_GunkerCloseQuarters',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="berserker",ClassName="GearGameContent.GearPawn_LocustBerserker",AIClass=class'GearAI_Berserker') )
	SpawnPawnList.Add( (PawnName="former",ClassName="GearGameContent.GearPawn_LambentHuman",AIClass=class'GearAI_LambentHuman',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="formerfemale",ClassName="GearGameContent.GearPawn_LambentHumanFemale",AIClass=class'GearAI_LambentHuman',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="lambentdrone",ClassName="GearGameContent.GearPawn_LambentDrone",AIClass=class'GearAI_LambentDrone',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="formerdrone",ClassName="GearGameContent.GearPawn_LambentLocustFormer",AIClass=class'GearAI_Locust',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="sniper",ClassName="GearGameContent.GearPawn_LocustSniper",AIClass=class'GearAI_Locust',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="drudge",ClassName="GearGameContent.GearPawn_DrudgePolypSpawning",AIClass=class'GearAI_LambentDrudge',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="drudgehead",ClassName="GearGameContent.GearPawn_DrudgeHeadWorm",AIClass=class'GearAI_DrudgeHeadWorm',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="Lamberserker",ClassName="GearGameContent.GearPawn_LocustBerserkerLambent",AIClass=class'GearAI_BerserkerLambent',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="myrrah",ClassName="GearGameContent.GearPawn_LocustMyrrah",AIClass=class'GearAI_COGGear',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="myrrahMP",ClassName="GearGameContent.GearPawn_LocustMyrrahMP",AIClass=class'GearAI_COGGear',TeamNum=2) )
	SpawnPawnList.Add( (PawnName="tempest",ClassName="GearGameContent.GearPawn_LocustTempest",AIClass=class'GearAI_LocustTempest') )
	SpawnPawnList.Add( (PawnName="savagehunter",ClassName="GearGameContent.GearPawn_LocustHunterSavageFlame",AIClass=class'GearAI_Hunter') )

	SpawnPawnList.Add( (PawnName="Clay",ClassName="GearGameContent.GearPawn_CCarmine",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="ClayMP",ClassName="GearGameContent.GearPawn_CCarmineMP",AIClass=class'GearAI_COGGear') )

	SpawnPawnList.Add( (PawnName="SummerRedshirt",ClassName="GearGameContent.GearPawn_COGSummerRedshirt",AIClass=class'GearAI_COGGear') )

	SpawnPawnList.Add( (PawnName="BabyCorpser",ClassName="GearGameContent.GearPawn_LocustBabyCorpser",AIClass=class'GearAI_BabyCorpser') )
	SpawnPawnList.Add( (PawnName="Corpser",ClassName="GearGameContent.GearPawn_LocustMomCorpser",AIClass=class'GearAI_MomCorpser') )

	SpawnPawnList.Add( (PawnName="commandodom",ClassName="GearGameContent.GearPawn_COGDomCommandoMP",AIClass=class'GearAI_COGGear') )
	SpawnPawnList.Add( (PawnName="flamedroneMP",ClassName="GearGameContent.GearPawn_LocustFlameDroneMP",AIClass=class'GearAI_FlameDrone') )
	SpawnPawnList.Add( (PawnName="stranded",ClassName="GearGameContent.GearPawn_Stranded",AIClass=class'GearAI_Stranded') )

	SpawnPawnList.Add( (PawnName="chicken",ClassName="GearGameContent.GearPawn_Chicken",AIClass=class'GearAI_Chicken') )
	SpawnPawnList.Add( (PawnName="attackchicken",ClassName="GearGameContent.GearPawn_Chicken_Attack",AIClass=class'GearAI_Chicken') )
}

