//
// SFRMPlayerController
//
// Monitor SpecForce specific player input
//


class SFRMPlayerController extends PlayerController
	native;

var PickupInteraction			PickupInteractionClass; 
var SearchableActorInteraction  MySAInteraction;
var RumbleDescription				HitRumbleDes;
 
var input float aRightTrigger, aLeftTrigger;

var ObjectiveManager ObjectiveManager;

var TweakInteraction ti;
var Interaction sfi; // kkm--Safe Frame

var class<Interaction> LevelLoadInteractionClass;

var config bool bAutoRespawn;
var bool bRandomClass;
var bool bPlacingSOFLAM;
var DarkenScene DarkenSceneOverlay;
var bool IsSceneDarkened;
var bool RestoreDark;
var bool IsShowDoors;
var float	TimeFlashed;
//var float RespawnTime; //kkm--a variable just like this already exists in PlayerController (WaitDelay)

var bool isDoingWeaponSwitch;
var sound EmptySlotSound;

var Weapon LastGrenadeWeapon;
var Weapon PreGrenadeWeapon;
var bool bAwaitingRelease;

//var Texture NVMask;
//var FinalBlend NVGrain;

//var Sound NVOnSnd;
//var Sound NVOffSnd;

var Sound TinnitusOnSnd;
var Sound TinnitusOffSnd;
var Sound BeepSound;

var bool bCanReload;

var float curWaterRoll;
var float curWaterRollDir;
var float curWaterRollTime;

//MPData
var int NumRespawns;
//end MPData

var RumbleDescription SpecialRumbleDes;
var RumbleDescription HeartbeatRumbleDes;
var bool HeartbeatOn;

var rotator OldBaseRotation;

//var ZombieMenuBase.EGameType savedGT;

// Weapon change when going in/out of water
//var Weapon PreSwimWeapon;

var float  TimeOfLastZoomIn;

var float  TimeGrenPress;
var float  TimeGrenRelease;

var() bool bEnableZoomToggle;	// If set to true, users can flick zoom on and flick it off (instead of having to hold zoom control down)
var bool   GotFirstZoomOut;
var bool   bDoingWaterTransition;
var bool   bTransDestinationWater;

var bool GTIsMP;

var bool   LastZoomWasToggle;	// True if last zoom was started by toggling-on zoom (flick zoom control) and not by holding down zoom control
var bool   GotEarlyIUL;				// True if aStrafeAtUnlean has been set
var float  aStrafeAtUnlean;

// Related to moving player view weapon slightly when rotating
var float  PVWeapMovementXOffset, PVWeapMovementYOffset, PVWeapMovementZOffset;
var float  aTurnAccum, aLookUpAccum;
var float  YawSwayAngle, PitchSwayAngle; 
var float  NewCoeff, AccumCoeff;
var float  VXAccum, VYAccum, VZAccum;
var float  NewCoeffRot, AccumCoeffRot, NewCoeffXY, AccumCoeffXY, NewCoeffZ, AccumCoeffZ;
var rotator SwayRotationOffset;
var bool   bDisableSway;

var float	LastLookAtTime;

var StatManager StatMgr;

var Actor AimAct;
var Pawn SavedPawn;//kkm--moved from GTVipPlayerController for AdvanceMySpectators
var config int LastLevelCompleted;

replication
{
	// Functions client can call.
	reliable if( Role<ROLE_Authority )
        SetMPClass;
    
    //variables the server sends to clients
    reliable if( Role==ROLE_Authority )
		NumRespawns, bRandomClass;
	
	// Functions server can call.
	reliable if( Role==ROLE_Authority )
		ShowRespawnScreen, ShowSpectating, LocalSetMPClass, SetCHIndex,
		OwnerHit, ClearLocalMessages, PlayerLeft, PlayerEntered, ClientLog,
		ClientSetRespawnTime;
	
	//variables client sends to server
	reliable if( Role<ROLE_Authority )
		ServerLogClientPlayerInv,ServerLog,SetRandomClass,bAutoRespawn;

    //send this to server
    reliable if( Role<ROLE_Authority )
		AdvanceMySpectators, ServerSetViewPitch, ServerReleaseNade, ServerPullNade;
}

native function AdvanceMySpectators();
native function ServerSetViewPitch ( byte NewViewPitch );
native function SetViewPitch ( byte NewViewPitch );
native function ServerPullNade( );
native function ServerReleaseNade( );

simulated function ClientSetRespawnTime( float Delay )
{
	WaitDelay = Level.TimeSeconds + Delay;
}

function SetRespawnTime( float Delay )
{
	WaitDelay = Level.TimeSeconds + Delay;
	ClientSetRespawnTime( Delay );
}

event SetRandomClass( bool on )
{
	bRandomClass = on;
}

function PlayerEntered(string xuidStr)
{
	//log("Got PlayerEntered: " $ xuidStr);
	ProxyMenuManager(Player.BasePlayerMenu).XBLiveMgr.PlayerEntered(xuidStr);
}

function PlayerLeft(PlayerReplicationInfo departingPlayer)
{
	//log("Got PlayerLeft: " $ departingPlayer.Gamertag);
	ProxyMenuManager(Player.BasePlayerMenu).XBLiveMgr.PlayerLeft(departingPlayer);
}

exec function DelayCountdown()
{
	local SFRMMultiplayer Game;

	if( Level.NetMode == NM_ListenServer && GameReplicationInfo.bMatchPending )
	{
		Game = SFRMMultiplayer(Level.Game);
		if( Game.bReadyToStart )
			Game.bDelayCountdown = !Game.bDelayCountdown;
		else
			Game.bDelayCountdown = false;
	}
}

exec function ScrollScoresUp()
{
	local ZombieScoreboard scoreboard;
	scoreboard = ZombieScoreBoard(myHUD.Scoreboard);
	if( scoreboard != none && myHUD.bShowScores && scoreboard.PRIStart > 0 )
		scoreboard.PRIStart--;
}

exec function ScrollScoresDown()
{
	local ZombieScoreboard scoreboard;
	scoreboard = ZombieScoreBoard(myHUD.Scoreboard);
	if( scoreboard != none && myHUD.bShowScores && scoreboard.PRIStart < GameReplicationInfo.PRIArray.Length-1 )
		scoreboard.PRIStart++;
}

exec function ShowScoreMessages()
{
	if( myHUD.Scoreboard != none )
	{
		myHUD.Scoreboard.bDisplayMessages = !myHUD.Scoreboard.bDisplayMessages;
	}
}

exec function ShowSafeFrame()
{
	if( sfi == none )
	{
		sfi = Player.InteractionMaster.AddInteraction( "ZombieGame.SafeFrameInteraction" );
	}
	else
	{
		sfi.bVisible = !sfi.bVisible;
	}
}

exec function Use()
{
	local Interactions.EInputKey hackIK;
	local Interactions.EInputAction hackIST;

	if( ZombieWeapon(Pawn.Weapon) != None )
	{
		// If weapon is doing a zoom transition, don't allow use to happen
		// (But if weapon is fully zoomed or fully non-zoomed, it's ok).
        if ( ZombieWeapon(Pawn.Weapon).bDoingZoom && !ZombieWeapon(Pawn.Weapon).bZoomed )
			return;

		if( Pawn.Weapon.IsInState('ShotgunReloadingBase')  
		 || Pawn.Weapon.IsInState('ShotgunReloading') )
			Pawn.Weapon.GotoState('ShotgunEndReloading');

	//	if ( ZombieWeapon(Pawn.Weapon).IsInState('Reloading') )
	//		return;
	}

	Super.Use();

	if( MySAInteraction.bActive )
	{
		hackIK = IK_Enter;
		hackIST = IST_Press;
		MySAInteraction.HandlePCKeyEvent( hackIK, hackIST, 0 );
	}
	//log("LeftSFRMUse");
}

exec function UnUse()
{
	local Interactions.EInputKey hackIK;
	local Interactions.EInputAction hackIST;

	if( MySAInteraction.bActive )
	{
		hackIK = IK_Enter;
		hackIST = IST_Release;
		MySAInteraction.HandlePCKeyEvent( hackIK, hackIST, 0 ); 
	}
}

exec function LogT()
{
	LogTouch();
}

exec function LogTouch()
{
	local Actor A;
	local ZombieDoor ZD;

	Log("");
	Log("####### SFRMPlayerController.LogTouch ######  time:"$ FormatTime( Level.Hour*3600 + Level.Minute*60 + Level.Second ) $"  Level.TimeSeconds:"$ Level.TimeSeconds );
	Log("* mySAInteraction:"$ mySAInteraction );
	if( mySAInteraction != None )
	{
		Log("  mySAInteraction MyPawn:"$ mySAInteraction.MyPawn $"  MySearchableActor:"$ mySAInteraction.MySearchableActor );
		Log("       DeadGuy:"$ mySAInteraction.DeadGuy $"  tempAmmoClass:"$ mySAInteraction.tempAmmoClass );
		Log("       startTime:"$ mySAInteraction.startTime $"  currTime:"$ mySAInteraction.currTime $"  oldTime:"$ mySAInteraction.oldTime $"  holdTime:"$ mySAInteraction.holdTime $"  totalTime:"$ mySAInteraction.totalTime );
		Log("       keyHeld:"$ mySAInteraction.keyHeld $"  bisADoor:"$ mySAInteraction.bisADoor $"  bisALockedDoor:"$ mySAInteraction.bisALockedDoor $"  bisAUnlockingDoor:"$ mySAInteraction.bisAUnlockingDoor $"  bCanSeeDoor:"$ mySAInteraction.bCanSeeDoor );
		Log("       bisaDeadEnemy:"$ mySAInteraction.bisaDeadEnemy $"  bReceivedAmmo:"$ mySAInteraction.bReceivedAmmo );
	}
	Log("* IsInState('PlayerLeaning'):"$ IsInState('PlayerLeaning') $"  if either of these is true, will not do use");
	if( ZombieWeapon(Pawn.Weapon) != None )
		Log("  weap bDoingZoom && !bZoomed:"$ ZombieWeapon(Pawn.Weapon).bDoingZoom && !ZombieWeapon(Pawn.Weapon).bZoomed $"   if true, is in a zoom transition and will not do use");

	if( Pawn != None )
		Log("* Pawn doing touching:  Location:"$ Pawn.Location $"  state:"$ Pawn.GetStateName() );
	else
	{
		Log("* This controller has no pawn");
		Log("");
		return;
	}

	Log("* Actors pawn is touching: ");
	ForEach Pawn.TouchingActors(class'Actor', A)
	{
		if( A != None )
		{
			Log("   *touching actor: "$ A $" ("$ A.class $")");
			Log("         state:"$ A.GetStateName() $"   phys:"$ A.Physics $"   loc:"$ A.Location $" (loc delta from pawn:"$ A.Location-Pawn.Location $"  ["$VSize(A.Location-Pawn.Location) $"])");
			Log("         use cyl col:"$ A.bUseCylinderCollision $"   coll rad:"$ A.CollisionRadius $"   coll rad:"$ A.CollisionHeight );
			ZD = ZombieDoor(A); 
			if( ZombieDoorTrigger(A) != None )
			{
				Log("         myDoor:"$ ZombieDoorTrigger(A).myDoor $"  bOpen:"$ ZombieDoorTrigger(A).bOpen $"  bCanSee:"$ ZombieDoorTrigger(A).bCanSee );
				if( ZombieDoorTrigger(A).myDoor != None )
				{
					Log("          - state:"$ ZombieDoorTrigger(A).myDoor.GetStateName() $"   phys:"$ ZombieDoorTrigger(A).myDoor.Physics $"   loc:"$ ZombieDoorTrigger(A).myDoor.Location 
						$"  (loc delta from pawn:"$ ZombieDoorTrigger(A).myDoor.Location-Pawn.Location $"  ["$ VSize(ZombieDoorTrigger(A).myDoor.Location-Pawn.Location) $"])");
					logDoorInfo( ZombieDoorTrigger(A).myDoor, "  -" );
				}
			}
			else if( ZD != None )
			{
				logDoorInfo( ZD, "" );
			}
		}
		else
			Log("    touching actor is none (huh???)");
	}
	Log("");
}

function logDoorInfo( ZombieDoor ZD, String ltxt )
{
	Log( "        "$ ltxt $" DoorState:"$ ZD.DoorState $"  bBlocked:"$ ZD.bBlocked );
	Log( "        "$ ltxt $" OpenRotation:"$ ZD.OpenRotation $"  TimeToOpen:"$ ZD.TimeToOpen $"  TimeBeforeClose:"$ ZD.TimeBeforeClose );
	Log( "        "$ ltxt $" ShowMessage:"$ ZD.ShowMessage $"  Message:"$ ZD.Message );
	Log( "        "$ ltxt $" ZombieDoorType:"$ ZD.ZombieDoorType );
	Log( "        "$ ltxt $" TypeWhenUnlocked:"$ ZD.TypeWhenUnlocked $"  bUnlockable:"$ ZD.bUnlockable $"  TagWhenUnlocked:"$ ZD.TagWhenUnlocked );
	Log( "        "$ ltxt $" MessageWhenUnlocked:"$ ZD.MessageWhenUnlocked $"  ShowMessageWhenUnlocked:"$ ZD.ShowMessageWhenUnlocked );
	Log( "        "$ ltxt $" TriggerOffset:"$ ZD.TriggerOffset $"  TriggerVerticalOffset:"$ ZD.TriggerVerticalOffset $"  TriggerHeight:"$ ZD.TriggerHeight	$"  TriggerRadius:"$ ZD.TriggerRadius );
	Log( "        "$ ltxt $" bAutoClose:"$ ZD.bAutoClose $"  bNPCAutoUse"$ ZD.bNPCAutoUse $"  bNPCIgnoreDoorState"$ ZD.bNPCIgnoreDoorState $"  bCloseOnDeadBodies"$ ZD.bCloseOnDeadBodies );
	Log( "        "$ ltxt $" bNPCAutoUse:"$ ZD.bNPCAutoUse $"  bNPCIgnoreDoorState:"$ ZD.bNPCIgnoreDoorState $"  bCloseOnDeadBodies:"$ ZD.bCloseOnDeadBodies );
	Log( "        "$ ltxt $" openTime:"$ ZD.openTime $"  resetTime:"$ ZD.resetTime $"  doorNormal:"$ ZD.doorNormal $"  doorVector:"$ ZD.doorVector );
}

exec function ShowDoors()
{
	local ZombieDoorTrigger DT;

	If(!IsShowDoors)
	{
		foreach	AllActors(class	'ZombieDoorTrigger',DT)
		{
			//Change the default props to display door collision
			DT.bhidden=false;
			DT.bhiddened=false;
			DT.busecylindercollision=true;
			//ConsoleCommand("Rend Collision");
		}
		IsShowDoors=True;
	}

	Else
	{
		foreach	AllActors(class	'ZombieDoorTrigger',DT)
		{
			//Change the default props to hide door	collision
			DT.bhidden=true;
			DT.bhiddened=true;
			DT.busecylindercollision=false;
			//ConsoleCommand("Rend Collision");
		}

		IsShowDoors=false;
	}
	ConsoleCommand("Rend Collision");
}
exec function MarkLog()
{
	Log("*******************************************************************************");
	Log("***************************Log Marked******************************************");
	Log("*******************************************************************************");
}

exec function loginventory()
{
	loginv();
}

exec function loginv()
{
//	ConsoleCommand("HIDELOG");
	Log("");
	Log("##############################################################");
	Log("START COPYING HERE !!!!!    START COPYING HERE !!!!!    START COPYING HERE !!!!!   ");
	Log("");

	LogPlayerInv();

	if( Role < ROLE_Authority )
		ServerLogClientPlayerInv(AimAct);

//	if( Role == ROLE_Authority || Level.NetMode == NM_Standalone )
//		ConsoleCommand("SHOWLOG");
}

simulated function LogPlayerInv()
{
	local inventory inv;
	local name Anim;
	local float frame,rate;
	local ZombieWeapon weap;

	if( Pawn != None )
		inv = Pawn.Inventory;

	// Print appropriate header info before inventory info
	Log("  time:"$ getTimeString() );

	if( SFRMSinglePlayer(Level.Game) != None )
		Log("  >Level of Difficulty:"$ Level.Game.GameDifficulty );

	if( Pawn == None )
	{
		Log("   ## No player pawn (or PlayerController doesn't have a pawn)  ");
	}
	else if( inv == None )
	{
		Log("   ## Player has no inventory   ");
	}
	else
	{
		Log("   ## Printing player inventory ");
	}
	Log("    # PlayerController state:"$ GetStateName() $"   Level.TimeSeconds:"$ Level.TimeSeconds );//$"   < TimeOfLastNoWeapFix:"$ TimeOfLastNoWeapFix $" >");

	// Pring some info about the pawn
	if( Pawn != None )
	{
		Log("    # Pawn state:"$ Pawn.GetStateName() $"             Physics:"$ Pawn.Physics $"  loc:"$ Pawn.Location $"  rot:"$ Pawn.Rotation $"  collison ht:"$ Pawn.CollisionHeight $" EyeHeight:"$ Pawn.EyeHeight );
		if( Pawn.PlayerReplicationInfo != None )
			Log("      PlayerReplicationInfo: PlayerReplicationInfo: ClassIdx:"$ Pawn.PlayerReplicationInfo.ClassIdx $" bTerrorist:"$ Pawn.PlayerReplicationInfo.bTerrorist );
		else
			Log("	   No PlayerReplicationInfo ");
	}

	// Log pawn's inventory
	if( inv != None )
	{
		if( Pawn.Weapon != None )
		{
			Pawn.Weapon.GetAnimParams(0,Anim,frame,rate);
			Log("     # Player weapon:"$ Pawn.Weapon.class $"  Anim:"$ Anim $"  frame:"$ frame $"  rate:"$ rate );
		}
		else
			Log("     # Player weapon: None");
		if( Pawn.PendingWeapon != None )
			Log("     # Player Pawn.PendingWeapon:"$ Pawn.PendingWeapon.class );
		else
			Log("     # Player Pawn.PendingWeapon: None");

//		Log("    # SFRMPlayerController.bReleasedQuickGrenadeButton:"$ bReleasedQuickGrenadeButton );
		if( AimAct != None )
			Log("   ># AimAct:"$ AimAct.class $"            loc:"$ AimAct.Location $"         rot:"$ AimAct.Rotation );
		else
			Log("   ># AimAct:"$ none );

		do
		{
			if( Ammunition(inv) != None )
				Log("         inv:"$inv.class $"        state:"$inv.GetStateName() $"  ammo amount:"$Ammunition(inv).AmmoAmount $"  bHideAmmoCount:"$SFRMAmmunition(inv).bHideAmmoCount $"    instance:"$ inv);
			else if( ZombieWeapon(inv) != None )
			{
				weap = ZombieWeapon(inv);
				inv.GetAnimParams(0,Anim,frame,rate);
				Log("        *inv:"$inv.class $"        state:"$inv.GetStateName() );
				Log("             RC:"$ weap.ReloadCount $"  BurstCounter:"$ weap.BurstCounter $"  bZoomed:"$ weap.bZoomed $"  bGoInactiveAfterDown:"$ weap.bGoInactiveAfterDown );
				Log("             bZoomOnNextIdle:"$ weap.bZoomOnNextIdle $"  bReleasedFireSinceLastShot:"$ weap.bReleasedFireSinceLastShot $"  bJustSelected:"$ weap.bJustSelected $"  bCanCheckForHoldingFire:"$ weap.bCanCheckForHoldingFire );
				Log("             Anim: "$ Anim $"   frame:"$ frame $"  rate:"$ rate $"    bChangeWeapon:"$ Weapon(inv).bChangeWeapon );
				Log("             mesh:"$ weap.mesh $"  WeapAttachment:"$ weap.WeapAttachment );
				Log("             PVO:"$ weap.PlayerViewOffset $"  Targ PVO:"$ weap.TargetPlayerViewOffset $"  Neut PVO:"$ weap.NeutralPlayerViewOffset );
				Log("             Targ PVRotO:"$ weap.TargetPlayerViewRotationOffset $"  Neut PVRotO:"$ weap.NeutralPlayerViewRotationOffset $"  instance:"$ inv );
				if( ABSTRACT_WeapGrenade(weap) != None )
				{
					Log("             bCookingOff:"$ ABSTRACT_WeapGrenade(weap).bCookingOff $"  CookoffStartTime:"$ ABSTRACT_WeapGrenade(weap).CookoffStartTime $"  (LTS) TimeOfLastProjectile:"$ ABSTRACT_WeapGrenade(weap).TimeOfLastProjectile $"  bFireAfterReload:"$ ABSTRACT_WeapGrenade(weap).bFireAfterReload );
				}
			}
			else
				Log("        *inv:"$inv.class $"        state:"$inv.GetStateName() $"        instance:"$ inv);
			inv = inv.Inventory;  // Go to next item in list
		}until( inv == None )
	}
}

// Prints the inventory a client player has on the server
function ServerLogClientPlayerInv(Actor ClientAimAct)
{
	local inventory inv;
	local string tempStr[8];
	local int inx;
	local name Anim;
	local float frame,rate;
	local ZombieWeapon weap;

	if( Pawn != None )
		inv = Pawn.Inventory;

	// Print appropriate header info before inventory info
	SCLog("  time:"$ getTimeString() );
	if( Pawn == None )
	{
		SCLog("   ## No player pawn (or PlayerController doesn't have a pawn)  ON SERVER");
	}
	else if( inv == None )
	{
		SCLog("   ## Player has no inventory  ON SERVER");
	}
	else
	{
		SCLog("   ## Player inventory ON SERVER");
	}
	SCLog("    # PlayerController state ON SERVER:"$ GetStateName() $"   Level.TimeSeconds:"$ Level.TimeSeconds );

	// Pring some info about the pawn
	if( Pawn != None )
	{
		SCLog("    # Pawn state ON SERVER:"$ Pawn.GetStateName() $"   Physics:"$ Pawn.Physics $"  loc:"$ Pawn.Location $"  rot:"$ Pawn.Rotation $"  collison ht:"$ Pawn.CollisionHeight );

		if( Pawn.PlayerReplicationInfo != None )
		{
			SCLog("      PlayerReplicationInfo: PlayerReplicationInfo: ClassIdx:"$ Pawn.PlayerReplicationInfo.ClassIdx $" bTerrorist:"$ Pawn.PlayerReplicationInfo.bTerrorist );
		}
		else
		{
			SCLog("      No PlayerReplicationInfo ");
		}
	}

	// Log pawn's inventory on server
	if( inv != None )
	{
		if( Pawn.Weapon != None )
			SCLog("     # Player weapon ON SERVER:"$ Pawn.Weapon.class );
		else
			SCLog("     # Player weapon ON SERVER: None");
		if( Pawn.PendingWeapon != None )
			SCLog("     # Player Pawn.PendingWeapon ON SERVER:"$ Pawn.PendingWeapon.class );
		else
			SCLog("     # Player Pawn.PendingWeapon ON SERVER: None");

	//	SCLog("    # SFRMPlayerController.bReleasedQuickGrenadeButton ON SERVER:"$ bReleasedQuickGrenadeButton );

		if( AimAct != None )
		{
			SCLog("    # AimAct:"$ AimAct.class $"   loc:"$ AimAct.Location $"  rot:"$ AimAct.Rotation );
		}
		else
		{
			SCLog("    # AimAct:"$ none );
		}

		if( ClientAimAct != None )
		{
			SCLog("   ># Client's AimAct:"$ ClientAimAct.class $"   loc on svr:"$ ClientAimAct.Location $"  rot on svr:"$ ClientAimAct.Rotation );
		}
		else
		{
			SCLog("   ># Client's AimAct:"$ none );
		}

		do
		{
			if( Ammunition(inv) != None )
				tempStr[0] = ("         inv:"$inv.class $"        state:"$inv.GetStateName() $"  ammo amount:"$Ammunition(inv).AmmoAmount $"    instance:"$ inv);
			else if( ZombieWeapon(inv) != None )
			{
				weap = ZombieWeapon(inv);
				inv.GetAnimParams(0,Anim,frame,rate);
				tempStr[0] = ("        *inv:"$inv.class $"        state:"$inv.GetStateName() );
				tempStr[1] = ("             RC:"$ weap.ReloadCount $"  BurstCounter:"$ weap.BurstCounter $"  bZoomed:"$ weap.bZoomed $"  bGoInactiveAfterDown:"$ weap.bGoInactiveAfterDown );
				tempStr[2] = ("             bZoomOnNextIdle:"$ weap.bZoomOnNextIdle $"  bReleasedFireSinceLastShot:"$ weap.bReleasedFireSinceLastShot $"  bJustSelected:"$ weap.bJustSelected $"  bCanCheckForHoldingFire:"$ weap.bCanCheckForHoldingFire );
				tempStr[3] = ("             Anim: "$ Anim $"   frame:"$ frame $"  rate:"$ rate $"    bChangeWeapon:"$ weap.bChangeWeapon );
				tempStr[4] = ("             mesh:"$ weap.mesh $"  WeapAttachment:"$ weap.WeapAttachment );
				tempStr[5] = ("             PVO:"$ weap.PlayerViewOffset $"  Targ PVO:"$ weap.TargetPlayerViewOffset $"  Neut PVO:"$ weap.NeutralPlayerViewOffset );
				tempStr[6] = ("             Targ PVRotO:"$ weap.TargetPlayerViewRotationOffset $"  Neut PVRotO:"$ weap.NeutralPlayerViewRotationOffset $"  instance:"$ inv );

				if( ABSTRACT_WeapGrenade(weap) != None )
				{
					tempStr[7]=("             bCookingOff:"$ ABSTRACT_WeapGrenade(weap).bCookingOff $"  CookoffStartTime:"$ ABSTRACT_WeapGrenade(weap).CookoffStartTime $"  (LTS) TimeOfLastProjectile:"$ ABSTRACT_WeapGrenade(weap).TimeOfLastProjectile $"  bFireAfterReload:"$ ABSTRACT_WeapGrenade(weap).bFireAfterReload );
				}
			}
			else
				tempStr[0] = ("        *inv:"$inv.class $"        state:"$inv.GetStateName() $"        instance:"$ inv);

			Log( tempStr[0] );
			ClientLog( tempStr[0] );
			if( Weapon(inv) != None )
			{
				for( inx = 1 ; inx < 7 ; inx++ )
				{
					SCLog( tempStr[inx] );
				}
			//	if( ABSTRACT_WeapGrenade(inv) != None )
			//	{
			//		SCLog( tempStr[6] );
			//	}
			}

			inv = inv.Inventory;  // Go to next item in list
		}until( inv == None )
	}

	SCLog("");
	SCLog("");
//	ClientShowLog();
}

simulated function string getTimeString()
{
	local string TimeString;

	TimeString = ( WithLeadingZero(Level.Hour) $":"$ WithLeadingZero(Level.Minute) $":"$ 
				WithLeadingZero(Level.Second) $"."$ WithLeadingZero(Level.Second, 3) );

	return TimeString;
}

simulated function string WithLeadingZero( int timeNum, optional int places )
{
	local string outStr;

	if( places == 0 )
		places = 2;

	if( timeNum < 10 && places > 1 )
		outStr = "0";
	if( timeNum < 100 && places > 2 )
		outStr = "0";
	outStr = (outStr $ timeNum);

	return outstr;
}

// Lets client print something on server's log
function ServerLog( string strIn )
{
	Log( strIn );
}

// Lets server print something on its own log and the client's log
simulated function SCLog( string strIn )
{
	Log( strIn );
	ClientLog( strIn );
}

// Lets server print something on client's log
simulated function ClientLog( string strIn )
{
	Log( strIn );
}


native function DoSkipScene();

event SceneEnded()
{
//FIXME_OLDMENUS
//	local MenuManager MM;
//
//	//kkm--activate deferred controller menu
//	MM = MenuManager(Player.BasePlayerMenu);
//	MM.MovieDone();
//	log( "SENDING MOVIEDONE" );
}

function SetCHIndex(int ch, int weaponIndex)
{
//	log(self$"::SetCHIndex, myHud="$myHud);
	if(myHud != None)
	{
		BasicHUD(myHud).SetCHIndex(ch, weaponIndex);
	}
}

function OwnerHit(vector Momentum, bool shouldPlayRumble)
{
//	log(self$"::SetCHIndex, myHud="$myHud);
	if(myHud != None)
	{
		BasicHUD(myHud).OwnerHit(Momentum);
	}
	
	if (shouldPlayRumble && (HitRumbleDes != none))
	{
		PlayRumble(HitRumbleDes);
	}
}

function ClearLocalMessages(optional class<LocalMessage> MsgClass)
{
	BasicHUD(myHud).ClearLocalMessages(MsgClass);
}

function class<MPClass> GetMPClass()
{
	return class'ZombieGame.MPClass'.static.GetClassFromIdx(PlayerReplicationInfo.ClassIDX);
}

event SetMPClass(int classChoice)
{
	//log( "SetMPClass:" @ classChoice @ PlayerReplicationInfo.bTerrorist );
	
	if (PlayerReplicationInfo != none)
	{
		if( classChoice != 6 )
		{
			if( bRandomClass )
			{
				do
				{
					classChoice = 1+rand(5);
					//log( PlayerReplicationInfo.PlayerName @ "random class:" @ classChoice );
				}
				until( GameReplicationInfo.CanChangeClass( int(PlayerReplicationInfo.bTerrorist), classChoice, PlayerReplicationInfo ) );
			}
			else if( !GameReplicationInfo.CanChangeClass( int(PlayerReplicationInfo.bTerrorist), classChoice, PlayerReplicationInfo ) )
			{
				//log( PlayerReplicationInfo.PlayerName @ "change class to" @ classChoice @ "was DENIED" );
				return;
			}
		}
		PlayerReplicationInfo.ClassIdx=classChoice;
		PlayerReplicationInfo.NextClassIdx=classChoice;
	}
	LocalSetMPClass(classChoice);
}

event ServerStartMatch()
{
	Level.Game.StartMatch();
}

simulated function LocalSetMPClass(int classChoice)
{
	if (PlayerReplicationInfo != none)
	{
		PlayerReplicationInfo.ClassIdx=classChoice;
	}
}

//SOFLAM BIT
event SetPlacingSOFLAM(bool b)
{
	bPlacingSOFLAM = b;
}

event bool isPlacingSOFLAM()
{
	return bPlacingSOFLAM;
}

simulated event Destroyed()
{
	//log("Destroying PlayerController: " $ Player);

	if (Player != none)
	{
		if (PickupInteractionClass != none)
		{
			Player.InteractionMaster.RemoveInteraction(PickupInteractionClass);
			////log("SFRMPC Destroyed: deleting: PickupInteractionClass");
		}
		if (MySAInteraction != none)
		{
			Player.InteractionMaster.RemoveInteraction(MySAInteraction);
			////log("SFRMPC Destroyed: deleting: MySAInteraction");
		}
	}
	
	if (ObjectiveManager != none)
	{
		ObjectiveManager.Owner = none;
	}

	super.Destroyed();
}


exec function SetDifficulty(int newDiff)
{
	Level.Game.GameDifficulty = newDiff;
}

exec function StartTweaker()
{
	if (ti==none)
	{
		ti = TweakInteraction( Player.InteractionMaster.AddInteraction("ZombieGame.TweakInteraction",Player));
	}
	
	ti.ToggleActive();
}

// <kris>
exec function ShowMenu()
{
	local string menuName;

	if( IsMP() ) menuName = "MultiplayerIG";
	else         menuName = "SinglePlayerIG";

	ClientOpenMenu( menuName );
}
// </kris>

function ClientSetHUD(class<HUD> newHUDType, class<Scoreboard> newScoringType)
{
	super.ClientSetHUD( newHUDType, newScoringType );
}

event PostBeginPlay()
{
	local bool bIsMP;

	Super.PostBeginPlay();

	if(MySAInteraction != None)
	{
		MySAInteraction.PickupIcons[0]=IC_None;
		MySAInteraction.PickupIcons[1]=IC_None;
	}

////	log(self$" Obj Manager is " $ ObjectiveManager);

//	if (ObjectiveManager == none)
//	{
		ObjectiveManager = new class'ZombieGame.ObjectiveManager';
//	}

//	log("Now it's " $ ObjectiveManager @ ObjectiveManager.Outer);

	ObjectiveManager.Init(self);

	if (level.Game != none)
	{
		bIsMP = ClassIsChildOf ( Level.Game.Class, class'ZombieGame.SFRMMultiplayer' );
	}
	else
	{
		bIsMP = true;
	}

	// do we not have one?  Is this is not MP or it's coop, make one
	if ((StatMgr == none) && !bIsMP  )
	{
		StatMgr = spawn(class'ZombieGame.StatManager', self);
		//log(self$" Creating StatManager " $ StatMgr);
	}

	LastLookAtTime = 0.0;
}

simulated event UpdatePlayer( string profileName )
{
	local BaseGUIController MM;
	MM = BaseGUIController(Player.BasePlayerMenu);

	log( "SFRMPC: UpdatePlayer: " $ MM @ Player.InteractionMaster.BaseMenu);

	if( MM == Player.InteractionMaster.BaseMenu )
	{
//		log( "*********************setting volumes....." @ PlayerInput.MusicVolume @ PlayerInput.SoundVolume);
//		ConsoleCommand( "MUSICVOLUME" @ PlayerInput.MusicVolume );
//		ConsoleCommand( "SFXVOLUME" @ PlayerInput.SoundVolume );
	}

	super.UpdatePlayer( profileName );
}

simulated function PlayBeepSound()
{
	PlaySound( BeepSound, SLOT_Interface, 1.0 );
}

event OnViewportRestored()
{
}

//this is the first place where player is valid.
event InitInputSystem()
{
//	local Interaction I;
	local bool IsMP;

	super.InitInputSystem();

	//load up our MP start interaction if this is an MP game	

	if (level.Game != none)
	{
		IsMP = ClassIsChildOf(Level.Game.Class, class'ZombieGame.SFRMMultiplayer');
	}
	else
	{
		IsMP = true;
	}
	
	if (IsMP)
	{
		ClientSetHUD(class'ZombieGame.MPHud',none);
		SetupMPPlayer();
	}
	else
	{
		log("Calling UpdatePlayer in InitInputSystem");
		UpdatePlayer(ProfileName);
	}
	//MySAinteraction = SearchableActorinteraction (Player.InteractionMaster.AddInteractionByClass(class'Zombiegame.SearchableActorinteraction', Player));
}

function ShowSpectating()
{
	StopAllRumble();
	HeartbeatOn = false;
	GotoState('Spectating');
	//ServerViewNextPlayer();
}

function ShowRespawnScreen()
{
	// only show the menu if auto respawn is disabled
	if( !bAutoRespawn )
	{
		ClientOpenMenu( "MultiplayerIG" );
	}
}

function ClientGameStarted(bool AllowJIP)
{
	local ProxyMenuManager MM;
	MM = ProxyMenuManager(Player.BasePlayerMenu);

	if (MM.XBLiveMgr.IsLiveGame)
	{
		MM.XBLiveMgr.GameStarted(true);
	}
	else
	{
		//log("SFRMPlayerController: Not Sending GameStarted: " $ MM.XBLiveMgr @ MM.XBLiveMgr.IsLiveGame);
	}

	// kill active viewports
	if( !Player.bActive )
	{
		if( Level.NetMode == NM_Client )
			ConsoleCommand( "DISCONNECT" );
		else
			ConsoleCommand( "DISABLESPLIT" );
	}
}

native function SetupMPPlayer();

function ClientPostLogin(bool IsMP)
{	
	GTIsMP = IsMP;
	
	if (IsMP && (Level.NetMode == NM_Client) && !IsSharingScreen())	//if we're the first client
	{
		SetMPClientStatus(MPCS_Pending);
		ConsoleCommand("SENDCLIENTSTATUS");	//tell the server we're joining
	}
}

exec function ForceReload()
{
	local ZombieWeapon ZWeap;

	if (isPlacingSOFLAM())
		return; 

	if ( (Pawn != None) && (Pawn.Weapon != None) && Pawn.Weapon.GetReloadCount() != Pawn.Weapon.GetDefaultReloadCount())
	{
		ZWeap = ZombieWeapon(Pawn.Weapon);

		if( ZWeap != None )
		{
			// In multiplayer
			if( GTIsMP )
			{
				// Don't allow reload to start if we're switching weapons
				if( isDoingWeaponSwitch )
					return;

				// Don't allow reload to start if we're in a zoom transition
				if( ZWeap.bDoingZoom && !ZWeap.bZoomed )
					return;
			}

			if(ZWeap.IsAdjustingZoom)
				return;

		//	if(ZWeap.bZoomed)
		//	{
		//		WeaponZoomOutFaster();
		//	}
		}

		Pawn.Weapon.ForceReload();
	}
}


function bool CanZoom()
{
	return false;
}

function ServerUse()
{
	//log("EnteredSFRM.ServerUse");
	super.ServerUse();
	//log("LeftSFRM.ServerUse");
}


// Function used to toggle zooming (e.g. from the keyboard)
exec function WeaponZoom()
{
	local ZombieWeapon zWeap;
//	Log("SFRMPC.WeaponZoom    t:"$Level.TimeSeconds);

	if( Pawn == None )
		return;
	zWeap = ZombieWeapon(Pawn.Weapon);
	if( zWeap == None )
		return;

	if( zWeap.IsAdjustingZoom )
		return;

	if( zWeap.bDoingZoom )
	{
		// If weapon is able to buffer zoom control clicks, return
		if( zWeap.ForceNextZoomPhase() )
			return;
	}

	if( ABSTRACT_WeapGrenade(Pawn.Weapon) != None && ABSTRACT_WeapGrenade(Pawn.Weapon).bZoomed && PreGrenadeWeapon != None )
		ZombieWeapon(PreGrenadeWeapon).bZoomOnNextIdle = false;

	// If this is multiplayer, and the player's weapon is likely about to try to
	// reload, then do not allow zoom in
	if( GTIsMP && Pawn.Weapon.ReloadCount == 0 && Pawn.Weapon.HasAmmo() && !zWeap.bZoomed )
		return;

	// Don't zoom if already switching weapon
	if( Pawn.PendingWeapon != None && Pawn.Weapon.IsInState('DownWeapon') )
	{
		// Instead, tell next weapon to zoom when able
		if( ZombieWeapon(Pawn.PendingWeapon) != None && (!zWeap.bZoomed || Pawn.Weapon == None) )
			ZombieWeapon(Pawn.PendingWeapon).bZoomOnNextIdle = true;
		return;
	}

	//if ( (Pawn != None) && (Pawn.Weapon != None) && bIsPlayer )
//	Log(" SFRMPC.WeaponZoom   CanZoom():"$CanZoom() );
	if ( (Pawn != None) && (Pawn.Weapon != None) && bIsPlayer && CanZoom())
	{
		if( !zWeap.bZoomed )
		{
			TimeOfLastZoomIn=Level.TimeSeconds;
			LastZoomWasToggle=true;
		}
		else if( zWeap.bZoomed && zWeap.fFOVChangeMax > 0 && zWeap.GetZoomFraction() < 1.0 )
		{
			zWeap.StepZoomIn();
			return;
		}

		ZombiePlayerPawn(Pawn).Zoom();
	}
}

exec function WeaponZoomIn()
{
	if (Level.Pauser!=None) return;

//	Log("SFRMPC.WeaponZoomIn    t:"$Level.TimeSeconds);
	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;

	// If this is multiplayer, and the player's weapon is likely about to try to
	// reload, then do not allow zoom in
//	Log("SFRMPC.WeaponZoomIn   GTIsMP:"$ GTIsMP );
	if( GTIsMP && Pawn.Weapon.ReloadCount == 0 && Pawn.Weapon.HasAmmo() )
		return;

	// Don't zoom if already switching weapon
	if( Pawn.PendingWeapon != None && Pawn.Weapon.IsInState('DownWeapon') )
	{
		// Instead, tell next weapon to zoom when able
		if( ZombieWeapon(Pawn.PendingWeapon) != None )
			ZombieWeapon(Pawn.PendingWeapon).bZoomOnNextIdle = true;
		return;
	}

//	Log(" SFRMPC.WeaponZoomIn   bDoingZoom:"$ZombieWeapon(Pawn.Weapon).bDoingZoom );
	if ( (Pawn != None) && (Pawn.Weapon != None) && bIsPlayer && CanZoom())
	{
		if(!ZombieWeapon(Pawn.Weapon).bZoomed )
		{
			if( !(LastZoomWasToggle && ZombieWeapon(Pawn.Weapon).bDoingZoom) )
			{
				ZombiePlayerPawn(Pawn).Zoom();
			}
			GotFirstZoomOut=false;
		}
		TimeOfLastZoomIn=Level.TimeSeconds;
		LastZoomWasToggle=false;  // Until proven otherwise, assume this is a held-down zoom
	}
}

exec event WeaponZoomOut()
{
//	Log("SFRMPC.WeaponZoomOut    t:"$Level.TimeSeconds);
	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;

	if( ABSTRACT_WeapGrenade(Pawn.Weapon) != None && PreGrenadeWeapon != None )
		ZombieWeapon(PreGrenadeWeapon).bZoomOnNextIdle = false;
	if( Pawn.PendingWeapon != None )
		ZombieWeapon(Pawn.PendingWeapon).bZoomOnNextIdle = false;

	ZombieWeapon(Pawn.Weapon).bZoomOnNextIdle=false;  // MAT Fix for DEMO - Prevent bug where if you quick-grenade when zoomed, and then unzoom during switch back to previous weapon, previous weapon would zoom

	if( ABSTRACT_WeapGrenade(Pawn.PendingWeapon) != None )
		ABSTRACT_WeapGrenade(Pawn.PendingWeapon).UnZoom();

	// If this is multiplayer, and the player's weapon is likely about to try to
	// reload, AND weapon is not already zoomed, then do not allow zoom out attempt right now
	if( GTIsMP && Pawn.Weapon.ReloadCount == 0 && Pawn.Weapon.HasAmmo() && !ZombieWeapon(Pawn.Weapon).bZoomed )
		return;

	// If user released zoom button very soon after clicking it, it very likely
	// means the user wanted to toggle the zoom on or off,
	// as opposed to zooming only as long as the trigger is held down.
	if( Level.TimeSeconds < TimeOfLastZoomIn+0.4 && bEnableZoomToggle )
	{
		LastZoomWasToggle=true;

		// If this is the first time zoom-out is called during this zoom, 
		// then this toggle was starting a zoom.
		if( Pawn != None && Pawn.Weapon != None && ZombieWeapon(Pawn.Weapon) != None && !GotFirstZoomOut )
		{
			GotFirstZoomOut = true;
			return;		// So don't unzoom
		}
	}

	if ( (Pawn != None) && (Pawn.Weapon != None) && bIsPlayer)
	{
		if(ZombieWeapon(Pawn.Weapon).bZoomed )
		{
			//ZombieWeapon(Pawn.Weapon).EndZoom();  // EndZoom will unzoom without the scope-lowering animation
			//log ("calling unzoom on "@ ZombieWeapon(Pawn.Weapon));
			ZombieWeapon(Pawn.Weapon).UnZoom();
		}
		else if( ZombieWeapon(Pawn.Weapon).bDoingZoom ) 
		{
			WeaponZoomOutFaster();
		}
		else
		{
			return;
		}
	}
}

function WeaponZoomOutFaster()
{
//	Log("SFRMPC.WeaponZoomOutFaster    t:"$Level.TimeSeconds);

	if ( (Pawn != None) && (Pawn.Weapon != None) && bIsPlayer)
	{
	//	if(ZombieWeapon(Pawn.Weapon).bZoomed )
		if(ZombieWeapon(Pawn.Weapon).bDoingZoom )
		{
			ZombieWeapon(Pawn.Weapon).UnZoomFaster();
		}
	}
}

exec function TestSubMsg()
{
	Level.Game.BroadcastLocalized( self, class'SubtitleMessage');
}


exec function Fire(optional float F)
{
	if (Level.Pauser!=None) return;

	if (isPlacingSOFLAM())
		return;

	Super.Fire(F); 
}

event PlayerTick(float Delta)
{
	local Interactions.EInputKey hackIK;
	local Interactions.EInputAction hackIST;

	if ( ZombiePlayerPawn(Pawn) != None )
		ZombiePlayerPawn(Pawn).RestoreViews(Delta);

	FindAimTarget();

	if (Pawn != none)
	{
		if (HeartbeatOn)
		{
			if (!GetRumbleState())
			{
				HeartbeatOn = false;
			}
		}
	
		if (Pawn.Health<=25)
		{
			if (!HeartbeatOn && GetRumbleState())
			{
				HeartbeatOn = PlayRumble(HeartbeatRumbleDes);
			}
		}
		else if (HeartbeatOn)
		{
			StopRumble(HeartbeatRumbleDes);
			HeartbeatOn = false;
		}
	
		DoPlayerPawnLookAt ( Delta );
	}
	
	Super.PlayerTick(Delta);

	if( MySAInteraction != none && MySAInteraction.bActive && bUse != 0 )
	{
		hackIK = IK_Enter;
		hackIST = IST_Press;
		MySAInteraction.HandlePCKeyEvent( hackIK, hackIST, 0 );
	}

	// auto respawn check
	if( bAutoRespawn && IsDead() && !PlayerReplicationInfo.bOutOfLives && WaitDelay < Level.TimeSeconds )
	{
		AskForPawn();
	}
}

function DoPlayerPawnLookAt ( float Delta )
{
	local int	FullViewPitch;
	local byte	NewViewPitch;
	local ZombieBipedPawn MyAnimPawn;

	MyAnimPawn = ZombieBipedPawn ( Pawn );

	if ( MyAnimPawn == None )
	{
		return;
	}

	if	(	( Level.NetMode == NM_ListenServer && LastLookAtTime > 0.1 ) ||			// 10 updates per second
			( Level.Game == None && LastLookAtTime > 0.1 ) ||						// 10 updates per second
			( Level.Netmode == NM_Standalone && LastLookAtTime > 0.02 ) )			// assume 50fps for standalone games
	{
		////log ( "*** SFRMPlayerController:DoPlayerPawnLookAt - LastLookAtTime is"@LastLookAtTime@"- Updating Look Position and Leaning." );
		LastLookAtTime = 0.0;
	}
	else
	{
		LastLookAtTime += Delta;
		return;
	}

	// 'fix' to be between -32768 & 32768
	FullViewPitch = Rotation.Pitch & 65535;
	if ( FullViewPitch > 32768 )
	{
		FullViewPitch -= 65535;
	}
	// clamp to prevent badness			
	FullViewPitch = Clamp ( FullViewPitch, -15000, 15000 );

    // 0 to 127 == 0 to 15000	
	// 128 to 255 == 0 to -15000
	if ( FullViewPitch > 0 )
	{
		NewViewPitch = byte ( ( FullViewPitch * 127 ) / 15000 );
	}
	else
	{
		NewViewPitch = byte ( ( -FullViewPitch * 127 ) / 15000 );
		if ( NewViewPitch > 127 )
		{
			NewViewPitch = 255;
		}
		else
		{
			NewViewPitch += 128;
		}
	}
	//log ( "NewViewPitch is"@NewViewPitch );
	// client?
	if ( Level.Game == None )
	{
		// call it on the server
		ServerSetViewPitch ( NewViewPitch );
	}
	// call it locally
	SetViewPitch ( NewViewPitch );

	// call lean update on the server
	MyAnimPawn.SetLean ( bLeanView, 2*CurLeanPosX, CurLeanPosY );
}

function findAimTarget()
{
	local vector HitLoc;
	local vector HitNormal;
	local vector StartTrace, EndTrace, X, Y, Z;
	local Actor oldAimAct;
	local SearchableActor Temp;
	local ZombieBipedPawn SearchableDeadGuy;  //needed?
	local Zombiedoor Tempdoor;
    oldAimAct = AimAct;
	AimAct = none;

	if ((Pawn != none) && (Pawn.Weapon != none))
	{
		//
		if(MySAInteraction == none)
		{
			MySAinteraction = SearchableActorinteraction (Player.InteractionMaster.AddInteractionByClass(class'Zombiegame.SearchableActorinteraction', Player));
		}
		GetAxes(Pawn.GetViewRotation(),X,Y,Z);
		StartTrace = Pawn.Weapon.GetFireStart(X,Y,Z); 
		EndTrace = StartTrace + 10000 * X; 
		aimAct = Trace(HitLoc,HitNormal,EndTrace,StartTrace,True,,,true);

//		log("AimAct: " $ aimAct);

		if ( aimAct == Pawn )
		{
			AimAct = oldAimAct;
//			//log("AimAct Swapping to: " $ aimAct);
		}
		if ( MYSAInteraction != None )
		{
			//log(self@"IfMYZsa==1");			
			Temp = SearchableActor(aimact);
			SearchableDeadGuy = ZombieBipedPawn(aimAct);
			TempDoor=ZombieDoor(Aimact);
			//log("Temp ="@temp);
			//log("SearchableDeadGuy ="@SearchableDeadGuy);
			//log("TempDoor ="@TempDoor);
				//if(Tempdoor == None)
				//{
				//	bisadoor=false;
				//}

			if ( Temp != None && temp.babletosearch && VSize ( Temp.Location - Pawn.Location ) <= Temp.MaxDist )
			{
				//if(!MYSAInteraction.bisadoor)
				//{	
					BasicHUD(myHud).bDrawingSpecial= true;
					MYSAInteraction.setfocus();
					MYSAInteraction.MySearchableActor = Temp;
					MYSAInteraction.MyPawn = ZombiePlayerpawn(Pawn);
					MYSAInteraction.MySearchableActor.MyPawn = ZombiePlayerpawn(Pawn);
					MySAInteraction.bisADoor=false;
					MySAInteraction.bCanSeeDoor=false;
					MYSAInteraction.bisaDeadEnemy = false;
				//}
			}
			
			else if ( (SearchableDeadGuy!=none) &&  SearchableDeadGuy.bPlayedDeath && !SearchableDeadGuy.beenSearched && (SearchableDeadGuy != Pawn) && 
					(SearchableDeadGuy.GetFaction() != ZombieBipedPawn(Pawn).GetFaction()) && 
					(SearchableDeadGuy.GetFaction() != FACTION_Civilian && !ZombieWeapon(Pawn.Weapon).bZoomed)&& VSize ( SearchableDeadGuy.Location - Pawn.Location ) <= 150
			)
			
			{
				//if(!MYSAInteraction.bisadoor)
				//{
					BasicHUD(myHud).bDrawingSpecial= true;
					MYSAInteraction.bisaDeadEnemy = true;
					MYSAInteraction.setfocus();				
					MYSAInteraction.MyPawn=ZombiePlayerpawn(Pawn);
					MYSAInteraction.DeadGuy=SearchableDeadGuy;
					MySAInteraction.bisADoor=false;
					MySAInteraction.bCanSeeDoor=False;
					//log("we got a searchabledeadguy!");
				//}
			}
			else if(Tempdoor != None && VSize ( TempDoor.Location - Pawn.Location ) <= 150)
			{
					//log("LOOKING AT DOORTYPE"@TempDoor.ZombieDoorType);
					MYSAInteraction.bisaDeadEnemy = false;
					if( TempDoor.ZombieDoorType == ZDT_LOCKEDDOOR)
					{
						BasicHUD( myHUD ).bDrawingSpecial=true;
						//log("bDrawingSpecial "$BasicHUD (myHUD ).bDrawingSpecial);
						MySAInteraction.bisALockedDoor=true;
						MySAInteraction.bisADoor=false;
						MySAInteraction.bisAUnlockingDoor=false;
						
						//log("bisDoor = "$MySAInteraction.bisALockedDoor);
					}
					else if( TempDoor.ZombieDoorType == ZDT_UNLOCKINGDOOR)
					{
						BasicHUD( myHUD ).bDrawingSpecial=true;
						//log("bDrawingSpecial "$BasicHUD (myHUD ).bDrawingSpecial);
						MySAInteraction.bisALockedDoor=false;
						MySAInteraction.bisADoor=false;
						MySAInteraction.bisAUnlockingDoor=true;
						//log("bisDoor = "$MySAInteraction.bisAUnlockingDoor);
					}
					else
					{
						BasicHUD( myHUD ).bDrawingSpecial=true;
						//log("bDrawingSpecial "$BasicHUD ( myHUD ).bDrawingSpecial);
						MySAInteraction.bisALockedDoor=false;
						MySAInteraction.bisADoor=true;
						MySAInteraction.bisAUnlockingDoor=false;
						//log("bislockedDoor = "$MySAInteraction.bisADoor);
					}
				//log("I see zombiedoor"@tempdoor);
				//log("it is this far away"@VSize ( TempDoor.Location - Pawn.Location ));
				BasicHud(myHUD).bDrawingSpecial=true;
				TempDoor.doorTrigger.bCanSee=true;
				MySAInteraction.bCanSeeDoor=true;
			}
			else
			{
//			    log("set everything to zero in player controller");
				
				MYSAInteraction.MySearchableActor = None;
				if( MYSAInteraction.DeadGuy != none )
				{
					MYSAInteraction.DeadGuy.AmbientSound=None;
					MYSAInteraction.DeadGuy=None;
				}
				SearchableDeadguy = None;
				MYSAInteraction.KeyHeld=false;
				MYSAInteraction.holdtime=0.0;
				MYSAInteraction.Starttime=0.0;
				MYSAInteraction.bisadeadenemy=false;
				MySAInteraction.bCanSeeDoor=False;
				//log("bcanSeeDoor just set false");
				BasicHUD(myHud).bDrawingSpecial= false;
				MySAInteraction.bisADoor=false;
				MySAInteraction.bisALockedDoor=false;
				MySAInteraction.bisAUnlockingDoor=false;
				if(tempdoor!=None)
				{
					TempDoor.doorTrigger.bCanSee=false;
					TempDoor = None;
				}
				
			}
			
		}
		
		


		
		//if we hit an opposing AI, tell them they're targeted
		/*
		TODO - REHOOK TO ZombieBipedPawn
		if ( (aimAct != Pawn) && (SpecForcePawn(aimAct)!=none) && (Pawn(aimAct).Health > 0) && 
				(SpecForcePawn(aimAct).GetFaction() != ZombiePawn(Pawn).GetFaction()) && 
				(SpecForcePawn(aimAct).GetFaction() != FACTION_Civilian && !ZombieWeapon(Pawn.Weapon).bZoomed)
			)
		{
			SpecForcePawn(aimAct).IsTargeted(HitLoc,HitNormal);
		}
		*/
	}
}

exec function SkipScene()
{
	DoSkipScene();
}

exec function DarkenSceneToggle()
{
	if (!bInterpolating)
	{
		if (IsSceneDarkened)
		{
			DarkenSceneOff();
		}
		else
		{
			DarkenSceneOn();
		}
	}
}


exec function DarkenSceneOn()
{
	if (!bInterpolating && !IsSceneDarkened)
	{
		if (DarkenSceneOverlay == none)
		{
			DarkenSceneOverlay = new class'DarkenScene';
		}
		AddCameraEffect(DarkenSceneOverlay);
	}
	
	IsSceneDarkened = true;
}

exec function DarkenSceneOff()
{
	if (!bInterpolating)
	{
		RemoveCameraEffect(DarkenSceneOverlay);
	}
	
	IsSceneDarkened = false;
}

//
// switch to previous weapon in the inventory group
// there is no base unreal support for that.
//
exec function PreviousWeapon()
{
	PrevWeapon();
}

exec function PrevWeapon()
{
	local Weapon newWeap;

	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;
	if (isPlacingSOFLAM())
		return; 

	if( Pawn.HeadVolume.bWaterVolume )
		return;

	// For multiplayer, do an abbreviated check for whether player has one weapon or no
	// weapon.  If so (one or no weap), then go no further
	if( GTIsMP && NumWeaponsInSlots(true) <= 1 )
		return;

	// If player is holding down fire or alt fire trigger, don't switch
	if( Pawn.PressingFire() || Pawn.PressingAltFire() )
		return;

	// Try to find next weapon
	newWeap = Pawn.Inventory.PrevWeapon(None, Pawn.Weapon);

	// If we couldn't find another weapon, then go no further
	if( newWeap == None )
		return;

	// If weapon is in the process of zooming in/out, or fully zoomed-in, don't switch.
	if( ZombieWeapon(Pawn.Weapon).bDoingZoom )
		WeaponZoomOutFaster();

	// Do the switch
	SwitchWeapon( newWeap.InventoryGroup );
//	setLean(false);
}

exec function NextWeapon()
{
	local Weapon newWeap;

	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;
	if (isPlacingSOFLAM())
		return; 

	if( Pawn.HeadVolume.bWaterVolume )
		return;

	// For multiplayer, do an abbreviated check for whether player has one weapon or no
	// weapon.  If so (one or no weap), then go no further
	if( GTIsMP && NumWeaponsInSlots(true) <= 1 )
		return;

	// If player is holding down fire or alt fire trigger, don't switch
	if( Pawn.PressingFire() || Pawn.PressingAltFire() )
		return;

	// Try to find next weapon
	newWeap = Pawn.Inventory.NextWeapon(None, Pawn.Weapon);

	// If we couldn't find another weapon, then go no further
	if( newWeap == None )
		return;

	// If weapon is in the process of zooming in/out, or fully zoomed-in, don't switch.
	if( ZombieWeapon(Pawn.Weapon).bDoingZoom )
		WeaponZoomOutFaster();

	// Do the switch
	SwitchWeapon( newWeap.InventoryGroup );
//	setLean(false);
}

function int NumWeaponsInSlots( optional bool CountRocketSlot )
{
	local int inx, weapCtr;
	local ZombiePlayerPawn SFPP;

	weapCtr = 0;
	SFPP = ZombiePlayerPawn(Pawn);
	if( SFPP != None )
	{
		// Count normal slots
		for( inx = 0 ; inx < 4 ; inx++ )
		{
			if( SFPP.Weapons[inx] != None )
				++weapCtr;
		}

		if( CountRocketSlot && SFPP.RocketWeapon != None )
			++weapCtr;
	}

	return weapCtr;
}

simulated function Weapon GetGrenadeWeapon()
{
	LastGrenadeWeapon = Weapon(ZombiePlayerPawn(Pawn).FindInventoryOfClassType(class'ABSTRACT_WeapGrenade'));

	return LastGrenadeWeapon;
}

simulated function int GetGrenadeAmmoCount()
{
	local Ammunition GrenadeAmmo;
	
	//ensure we have a last grenade weapon
	if (LastGrenadeWeapon == None)
		GetGrenadeWeapon();
	
	if( LastGrenadeWeapon != None )
	{
		GrenadeAmmo = LastGrenadeWeapon.AmmoType;
	
		if( GrenadeAmmo == None)
			GrenadeAmmo = Ammunition(Pawn.FindInventoryType(LastGrenadeWeapon.default.AmmoName));

		if( GrenadeAmmo != None )
			return GrenadeAmmo.AmmoAmount + LastGrenadeWeapon.ReloadCount;
		else
			return 0;
	}
	else
		return 0;
}

//
// Overload to handle weapon modes when looking for a 
// best weapon in the inventory
//
exec function SwitchToBestWeapon()
{
	if ( Pawn.Inventory == None )
		return;

	if( Pawn.HeadVolume.bWaterVolume )
		return;
	
	if( ZombieWeapon(Pawn.Weapon).bZoomed )
		WeaponZoomOut();

	Super.SwitchToBestWeapon(); 
}

function MissionFailed( string reason )
{
	ClientOpenMenu( "MissionFailed", reason );
}

function CancelSOFLAM()
{
	local DynamicSOFLAMAttachment dsa;
	if (Pawn== None) return;
	foreach Pawn.TouchingActors(class'DynamicSOFLAMAttachment',dsa)
	{
		dsa.UnUsedBy(Pawn);	
		
	}
	
}

function CancelWeaponActivity()
{
	//inMP cancel firing, quickgrenades and zoom
	if (Pawn!=None && ZombieWeapon(Pawn.Weapon)!=None)
	{
		ZombieWeapon(Pawn.Weapon).ForceStopFiring();
//		ZombieWeapon(Pawn.Weapon).CancelQuickGrenade();				

		if( ZombieWeapon(Pawn.Weapon).bZoomed )
			WeaponZoomOut();
	}
}
event bool SetPause( BOOL bPause )
{
	local ZombiePlayerPawn SFPP;

	SFPP = ZombiePlayerPawn ( Pawn );
	// if we are actually pausing
	if ( bPause )
	{
		// cancel weapon stuff
		CancelSOFLAM();
		CancelWeaponActivity();
	}
	// unpausing and we have no weapon set?
	else if ( SFPP != None && SFPP.Weapon == None && SFPP.Weapons[SFPP.StartingWeapSlot] != None )
	{
		// Faison 4/17 - fixes the 'starting with no weapon when pulling out controller at exactly the right time' bug
		// TODO: Could this cause undesired weapon switching upon unpausing?  Is there ever a valid case where Pawn.Weapon == None?
		SFPP.Weapon = SFPP.Weapons[SFPP.StartingWeapSlot];
		SFPP.Weapon.BringUp ( );
	}

	//don't pause netgames but do pause CoOp
	if (!IsMP())
	{
		// okay to call up to super
		return Super.SetPause(bPause);
	}
	else
	{
		// netgames..
		return false;
	}
}

event SetLean(bool newLean)
{
	local ZombieWeapon weap;
//	local rotator SkelMeshRotOffset;

	if (isPlacingSOFLAM()) return; 
	else
	{
		if ( !newLean && ZombieBipedPawn ( Pawn ) != None )
		{
			// turn off leaning
			ZombieBipedPawn ( Pawn ).SetLean ( false, 0.0, 0.0 );
		}

		// Make sure weapon is at a good position and rotation when we leave lean
	//	if ( !newLean && Pawn.Weapon != None )
		if ( Pawn.Weapon != None )
		{
			weap = ZombieWeapon(Pawn.Weapon);
			if( weap != None )
			{
				//if( weap.bZoomed )
				//{
				//	SkelMeshRotOffset = weap.ZoomRotationOffset;
				//	weap.PlayerViewOffset = weap.default.ZoomPlayerViewOffset;
				//}
				//else
				//{
				//	SkelMeshRotOffset.Pitch=0;
				//	SkelMeshRotOffset.Roll=0;
				//	SkelMeshRotOffset.Yaw=0;
				//	weap.PlayerViewOffset = weap.default.PlayerViewOffset;
				//}
				//weap.SetSkelMeshRotationOffset( SkeletalMesh(weap.mesh), weap, SkelMeshRotOffset );
				weap.MoveToLeanPV(0.20, newLean);
			}
		}

		Super.SetLean(newLean);
	}
}

exec function ToggleLean()
{
	//bLeanView = !bLeanView;	
	SetLean(!bLeanView);
}

//Objective Manager Interface
function bool VerifyCompletion() 
{
	return ObjectiveManager.VerifyCompletion();
}

exec function ShowObjectives()
{
	if(bInterpolating || ShowingFMV)
		return;
	
	if( Level.NetMode != NM_Standalone || ClassIsChildOf( Level.Game.class, class'ZombieGame.SFRMMultiPlayer' ) )
		myHUD.ShowScores();
	else
	{
		ClientOpenMenu( "Objectives" );

		// Cancel firing, quickgrenades and zoom
		if (Pawn!=None && ZombieWeapon(Pawn.Weapon)!=None)
		{
			ZombieWeapon(Pawn.Weapon).ForceStopFiring();

			if( ZombieWeapon(Pawn.Weapon).bZoomed )
				WeaponZoomOut();
		}
	}
}

exec function ShowHelp()
{
//FIXME_OLDMENUS
//	local MenuManager MM;
//	MM = MenuManager(Player.BasePlayerMenu);
//	if(!MM.MenuLocked)
//	{
//		MM.SetMenu('HelpMenu');
//		MM.SetActive();
//
//		// Cancel firing, quickgrenades and zoom
//		if (Pawn!=None && ZombieWeapon(Pawn.Weapon)!=None)
//		{
//			ZombieWeapon(Pawn.Weapon).ForceStopFiring();
//
//			if( ZombieWeapon(Pawn.Weapon).bZoomed )
//				WeaponZoomOut();
//		}
//	}
}

function float GetHUDBasePos()
{
	return BasicHUD(myHUD).basePos;
}

exec function HideHUD(optional bool force)
{
	BasicHUD(myHUD).HideHUD(force);
}

exec function ShowHUD(optional bool force)
{
	BasicHUD(myHUD).ShowHUD(force);
}

function HandlePickup(Pickup pick)
{
	ReceiveLocalizedMessage(pick.MessageClass,,,,pick.class);
}
event Possess(Pawn p)
{
	Super.Possess(p);
	LastGrenadeWeapon=None; //very important.  
}
function UnPossess()
{
	Super.UnPossess(); 
	LastGrenadeWeapon=None; //very important.  
}

function HandleDoubleClickMove(eDoubleClickDir DoubleClickMove, float DeltaTime)
{
	//local rotator ViewRotation;
	if (DoubleClickMove == DCLICK_Back)
	{
		bTurn180 = 1;
		DoubleClickDir = DCLICK_Done;
	}
	else if (DoubleClickMove == DCLICK_Forward)
	{
		//fix it. Interp to center for a few frames
		bCenterView = true;
		DoubleClickDir = DCLICK_Done;
	}
	else if (ZombiePlayerPawn(Pawn) != none)
	{
		ZombiePlayerPawn(Pawn).Dodge2(DoubleClickMove);
	}
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	if (ZombiePlayerPawn(Pawn) == none)
	{
		return false;
	}

	return ZombiePlayerPawn(Pawn).Dodge(DoubleClickMove);
}

state PlayerLeaning
{
	function bool CanZoom()
	{
		return !isPlacingSOFLAM();
	}
	
	event UpdateRotation(float DeltaTime, float maxPitch) 
	{
		PVWeaponMovementSway(DeltaTime);
		Super.UpdateRotation(DeltaTime, maxPitch);
	}
}

function CalcLeanView(out vector CameraLocation, out rotator CameraRotation, float Dist)
{

	local rotator LeanRotOffset;
	local ZombieWeapon weap;
	if (Pawn.IsLocallyControlled() && PlayerInput==None)  log("PLAYER INPUT IS NULLL!");
	weap = ZombieWeapon(Pawn.Weapon);

	Super.CalcLeanView(CameraLocation, CameraRotation, Dist);

	// Roll the playerview weapon so that it rolls with the player while leaning
	if( weap != None )
	{
		// If this weapon has a scope (has a scope-on anim) and is doing zoom, go no further.
		if( weap.bHasScope && weap.bDoingZoom )
			return;

		// Compute roll correction for PV weapon
		LeanRotOffset = weap.NeutralPlayerViewRotationOffset;
		// Compute adjustment (for iron sight zoom) for PV weapon position (due to how the 
		// roll and pitch axes are oriented on the PV weapon's static mesh)
		if( weap.bDoingZoom )
		{
			weap.PlayerViewOffset.Y = weap.NeutralPlayerViewOffset.Y - 2.7*weap.ZoomLeanPVYCorr*CurLeanPosX;
			weap.PlayerViewOffset.Z = weap.NeutralPlayerViewOffset.Z - 2.7*weap.ZoomLeanPVZCorr*CurLeanPosX;
		}
		else
		{
			weap.PlayerViewOffset.Y = weap.NeutralPlayerViewOffset.Y - 2.7*weap.LeanPVYCorr*CurLeanPosX;
			weap.PlayerViewOffset.Z = weap.NeutralPlayerViewOffset.Z - 2.7*weap.LeanPVZCorr*CurLeanPosX;
		}

	//	LeanRotOffset.Pitch -= 750*CurLeanPosX;      // Note: pitch and roll are swapped on a weapon static mesh
		LeanRotOffset.Pitch += CameraRotation.Roll;  // Note: pitch and roll are swapped on a weapon static mesh

		if( weap.bDoingZoom )
			LeanRotOffset.Roll  += CameraRotation.Roll*weap.ZoomLeanPitchCorr;  // Note: pitch and roll are swapped on a weapon static mesh
		else
			LeanRotOffset.Roll  += CameraRotation.Roll*weap.LeanPitchCorr;  // Note: pitch and roll are swapped on a weapon static mesh

		// Apply roll correction for PV weapon
		weap.SetSkelMeshRotationOffset( SkeletalMesh(weap.mesh), weap, LeanRotOffset );
	}
}

// For lean (does not require zoom)
exec function StartLean()
{
	SetLean(true);
}
exec function EndLean()
{
	SetLean(false);
}

native function rotator CalcPVWeaponMovementRotSway(float DeltaTime);
					
native function vector CalcPVWeaponMovementSway(float DeltaTime);
	
function PVWeapNudgeCrouch( float DeltaTime )
{
	aLookUpAccum -= DeltaTime*4000;
	VZAccum += DeltaTime*300;
}

function PVWeapNudgeUnCrouch( float DeltaTime )
{
	aLookUpAccum += DeltaTime*4000;
	VZAccum -= DeltaTime*300;
}

exec function SwayOff()
{
	bDisableSway = true;
}

exec function SwayOn()
{
	bDisableSway = false;
}

function bool IsMoving()
{
	if( abs(aTurnAccum) > 0.9 || abs(aLookUpAccum) > 0.9 
	 || abs(VXAccum) > 1.2 || abs(VYAccum) > 1.2 || abs(VZAccum) > 1.2 )
	{
		return true;
	}
	else
		return false;
}

function bool RecentlyMoved()
{
//	Log("SFRMPC.RecentlyMoved  accums: turn:"$ aTurnAccum*1000 $" lookUp:"$ aLookUpAccum*1000 
//		$"  v:"$ VXAccum*1000 $","$ VYAccum*1000 $","$ VZAccum*1000 $" t="$ Level.TimeSeconds );
	if( abs(aTurnAccum) > 0.00001 || abs(aLookUpAccum) > 0.00001 
	 || abs(VXAccum) > 0.0001 || abs(VYAccum) > 0.0001 || abs(VZAccum) > 0.001 )
	{
		return true;
	}
	else
		return false;
}

function PVWeaponMovementSway(float DeltaTime)
{
	local ZombieWeapon weap;
	local vector OffsetVect;
	local rotator OffsetRot;
//	local rotator TestRot;

	if( ZombieWeapon(Pawn.Weapon) == None )
		return;
	else if( Pawn.Weapon.mesh == None )
		return;
	else
	{
		weap = ZombieWeapon(Pawn.Weapon);

		// Compute sway rotation offset and playerview offset
		SwayRotationOffset = CalcPVWeaponMovementRotSway( DeltaTime );
		OffsetVect = CalcPVWeaponMovementSway( DeltaTime );

		OffsetRot.Roll = -SwayRotationOffset.Pitch;
		OffsetRot.Pitch = SwayRotationOffset.Roll;
		OffsetRot.Yaw   = SwayRotationOffset.Yaw;

//		Log("//// SFRMPC.PVWeaponMovementSway  Get SkeletalMeshRotation: "$ZombieWeapon(Pawn.Weapon).GetSkelMeshRotation( SkeletalMesh(ZombieWeapon(Pawn.Weapon).mesh) ) );

		if( bDisableSway )
		{
			return;
		}
		else if( !weap.bDoingZoom )
		{
			// Apply rotation sway offset to playerview weapon
			weap.SetSkelMeshRotationOffset( SkeletalMesh(weap.mesh), weap, weap.NeutralPlayerViewRotationOffset + OffsetRot);

			// Apply sway offset to playerview weapon position
			weap.PlayerViewOffset = weap.NeutralPlayerViewOffset + OffsetVect;
		}
		else
		{
			weap.SetSkelMeshRotationOffset( SkeletalMesh(weap.mesh), weap, weap.NeutralPlayerViewRotationOffset );

			weap.PlayerViewOffset = weap.NeutralPlayerViewOffset;
		}
	}
	
}

state PlayerWalking
{
	event UpdateRotation(float DeltaTime, float maxPitch) 
	{
		PVWeaponMovementSway(DeltaTime);
		Super.UpdateRotation(DeltaTime, maxPitch);
	}

	function bool CanZoom()
	{
		if (Pawn != none)// && (Pawn.Physics == PHYS_Walking))
		{
			return !isPlacingSOFLAM();
		}
		
		return false;
	}

	//event ProcessMove ( float DeltaTime, vector newAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	//{
	//	if ( !InvoluntaryUnLean )
	//		Super.ProcessMove ( DeltaTime, newAccel, DoubleClickMove, DeltaRot);
	//	else
	//	{
	//	//	Log("t="$ Level.TimeSeconds $" SFRMPC.PM  IUL:"$ InvoluntaryUnLean $"  TLE:"$ TimeLeanEnded );
	//		if( LastZoomWasToggle )
	//			Super.ProcessMove ( DeltaTime, newAccel*0.001, DoubleClickMove, DeltaRot);
	//		else
	//			Super.ProcessMove ( DeltaTime, vect(0,0,0), DoubleClickMove, DeltaRot);
	//	}
	//}

	function EndState()
	{
		Super.EndState(); 
	}
}

function TurnAround()
{
	Super.TurnAround();
//	log("Desired: " $ DesiredRotation.Yaw $ " Rot: " $ Rotation.Yaw);
	//if (DesiredRotation.Yaw == Rotation.Yaw)
	if ((DesiredRotation.Yaw%65536) == (Rotation.Yaw%65536))
	{
		bTurn180 = 0;
//		log("Zeroed bTurn180");
	}
}

function CenterView(float DeltaTime, out rotator ViewRotation)
{
	Super.CenterView(DeltaTime, ViewRotation);
	if (ViewRotation.Pitch == CenterPitch)
	{
		bCenterView = false;
	}
}

simulated function bool IsMP()
{
	return ((Level.NetMode != NM_Standalone) || 
			(Level.Game == none) || 
			ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer')
			);
}

event AddCameraEffect(CameraEffect NewEffect,optional bool RemoveExisting)
{
	//wrc cheap dirty hack.
	//Motion blur doesn't play well with multiple viewports.
	if (NewEffect.IsA('MotionBlur') && IsSharingScreen())
		return;
		
	Super.AddCameraEffect(NewEffect,RemoveExisting);
}

function ClientGameEnded()
{
	//log("ClientGameEnded0: " $ (Level.NetMode == NM_Standalone));
	if (!IsMP())
	{
		return;
	}

	//log("ClientGameEnded1: " $ Player.SplitIndex);

	if( ProxyMenuManager(Player.basePlayerMenu).XBLiveMgr.IsLiveGame )
	{
		ProxyMenuManager(Player.basePlayerMenu).XBLiveMgr.GameEnded();
	}

	if (Player.SplitIndex == 0)				//Player 1 controls...
	{
		StopAllRumble();
		//log("ClientGameEnded2: " $ GameReplicationInfo.GameClass);
		ClientCloseMenu( true ); // close all menus so we can see the score properly
	}
	else
	{
		//log("ClientGameEnded3: " );
		SetRumbleState(false);
		ConsoleCommand("DISABLESPLITTEMP");
	}

	super.ClientGameEnded();
}

function ClientRoundEnded()
{
	super.ClientRoundEnded();
}

function PawnDied(Pawn P)
{
	if( P == Pawn )
	{
		SavedPawn = P;
	}

	super.PawnDied(P);

	//bBehindView = false; //kkm--Do we really want to unset this in multiplayer?
	LastGrenadeWeapon=None; //very important.  
	TimeGrenPress=0;
	TimeGrenRelease=0;

	bDuck=0;
	StopAllRumble();
	if (BasicHUD(myHud)!=None)
		BasicHUD(myHud).ClearLocalMessages(class'ZombieGame.ZombieWeaponMessage');
}
function bool shouldFade()
{
	return true;
}

state Dead
{
ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon, NextWeapon, PrevWeapon, Fire, AltFire, StartLean, EndLean;

	/*
	event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
	{
		bBehindView = true;

		if(LastPawn != None)
		{
			ViewActor = LastPawn;
			CameraLocation = ViewActor.Location;
		}

		CameraLocation.Z += 100;	//to keep us out of the floor...
		CameraLocation.X -= 100;

		CameraRotation = Rotator(Normal(ViewActor.Location - CameraLocation));

		return;
	}
	*/

	function BeginState()
	{
		// make absolutely sure the client gets into this state!
		if( Level.NetMode != NM_Client )
		{
			ClientGotoState( 'Dead', 'Begin' );
		}
		super.BeginState();
		LastGrenadeWeapon=None; 
		bDuck=0;
		myHUD.bShowScores=true;
	}
	
	function EndState()
	{
		super.EndState();
		bDuck=0;
	}

Begin:
	//log( "Begin label:" @ GetStateName() );
	Sleep(3.0);

	//log("Sending OwnerDied2");
    if ((Level.NetMode == NM_Standalone) && !ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer'))	//if we're not Multiplayer
    {
		//log("Died: Not MP");
		// the complement to this is in ShowRespawnScreen
		ClientOpenMenu( "SinglePlayerIG" );
	}
	else
	{
		//log("Died: Is MP");
		if (SFRMMultiPlayer(Level.Game) == none)
		{
			//log("!!!Player died and no GameInfo: " $ Level.Game);
		}
		//log("Died: Plr Died");
		SFRMMultiPlayer(Level.Game).PlayerDied(self);
	}
	//log ("End of Dead state");
}


function ResetWaterTransition()
{
	bDoingWaterTransition = false;
}

function bool GoodWaterTransition()
{
	return (Pawn.HeadVolume.bWaterVolume == bTransDestinationWater);
}


// Player movement.
// Player Swimming
state PlayerSwimming
{
	function BeginState()
	{
		// If player is spawned underwater, switch the player's weapon to the water weapon
		if( Pawn.HeadVolume.bWaterVolume )
		{
			if( bDoingWaterTransition == false )
			{
				bTransDestinationWater = true;
				bDoingWaterTransition = true;
			}
		}

		Super.BeginState();
	}
	
	event bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
	{	
		if (NewVolume.bWaterVolume)
		{
			if (curWaterRollTime == 0)
			{
				curWaterRollTime=Level.TimeSeconds;
			}
		}
		
		return super.NotifyHeadVolumeChange(NewVolume);
	}
}

state PlayerClimbing
{
	ignores StartLean, EndLean;

	function bool CanZoom()
	{
		return true;
	}

	event UpdateRotation(float DeltaTime, float maxPitch) 
	{
		PVWeaponMovementSway(DeltaTime);
		Super.UpdateRotation(DeltaTime, maxPitch);
	}
}

state GameEnded
{
ignores Fire, ReleaseFire, AltFire, SwitchWeapon, NextWeapon, PrevWeapon, StartLean, EndLean;

//	exec function ShowMenu()
//	{
//		if( Level.NetMode != NM_Client && Player.InteractionMaster.BaseMenu == Player.BasePlayerMenu )
//			global.ShowMenu();
//	}
}

state RoundEnded
{
ignores SwitchWeapon, ReleaseFire, NextWeapon, PrevWeapon, StartLean, EndLean;
}

state Spectating
{
ignores StartLean, EndLean, ReleaseFire;
}
	
event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local float deltaTime;
	local float rollSpeed;
	local float rollLimit;
	local float rollMult;
	local float bobDir;
	local float bobSpeed;
	local rotator TestRot;
	local bool noRoll;
	
	super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);

	//!!!! NOTE: The code below is bugged and causes the zoom-lean-autoReload full roll bug. If we want bob again, we'll need to rewrite it
	return;
//!!!!

//	TestRot = ZombieWeapon(Pawn.Weapon).GetBoneRotation( 'bone_root' );
//	Log("TestRot:"$TestRot );

	TestRot.Yaw+=182;
	
//	ZombieWeapon(Pawn.Weapon).SetBoneRotation( 'bone_root', TestRot, 0 );


	rollSpeed = 1000;
	rollMult = 1.0f;
	noRoll = false;
			
	if ((Pawn != None) && (Pawn.bIsCrouched) && PlayerInput.bWasMoving && !bLeanView)
	{
		bobSpeed = 0.5f;
	
		rollSpeed = 2800;
		rollMult = 0.15f;
		
		noRoll = true;
		
//		rollMult = 0.0f;
		
//		log("StartWaddle: " $ curWaterRollTime @ (VSize(Pawn.Velocity)));
		
		if (curWaterRollTime == 0)
		{
			curWaterRollTime=Level.TimeSeconds;
		}
	}
	else if ((Pawn != None) && (Pawn.bIsCrouched))
	{
		noRoll = true; //this might cause problems if we have water later...
	}
	else
	{
		bobSpeed = 0;
	}
			
	if (( (Pawn != None) && (Pawn.HeadVolume != None)  && (Pawn.HeadVolume.bWaterVolume) ) ||
		((Pawn != None) && (Pawn.bIsCrouched) && PlayerInput.bWasMoving && !bLeanView))
	{
		rollLimit = rollSpeed*rollMult;
	
		DeltaTime = Level.TimeSeconds - curWaterRollTime;
		curWaterRollTime = Level.TimeSeconds;
		
		curWaterRoll += rollSpeed*DeltaTime*curWaterRollDir;
		
//		log("Bob: " $ curWaterRoll @ rollLimit );
		
		if (abs(CameraRotation.Roll+curWaterRoll) > rollLimit)
		{
			curWaterRoll = curWaterRollDir * (rollLimit - (abs(curWaterRoll) - rollLimit));
							
			curWaterRollDir *= -1.0f;
		}

		bobDir = curWaterRoll/rollLimit;
		if (bobDir != 0)
		{
			bobDir = bobDir * -2 * (bobDir/abs(bobDir)) + 1;
		}
		
		CameraLocation.Z += bobSpeed*bobDir;
		
		if (!noRoll)
		{
			CameraRotation.Roll += curWaterRoll;
		}
	}
	else if ((curWaterRoll != 0) && !noRoll)
	{
		//reset me please...
		
//		log("WaterRoll Reset: " $ curWaterRoll @ rollLimit @ noRoll);
				
		curWaterRollDir = -curWaterRoll/abs(curWaterRoll);
		
		DeltaTime = Level.TimeSeconds - curWaterRollTime;
		curWaterRollTime = Level.TimeSeconds;
		
		curWaterRoll += rollSpeed*3*DeltaTime*curWaterRollDir;
		
		if (-curWaterRoll/abs(curWaterRoll) != curWaterRollDir)
		{
			//our sign flipped, so we're done.
			curWaterRoll = 0;
			curWaterRollDir = 1;
			curWaterRollTime = 0;
			
//			log("Water roll reset");
		}
		else
		{
			CameraRotation.Roll += curWaterRoll;
		}
	}
}

exec function EquipSlot(byte SlotID)
{
//	if( SlotID == 2 )  // Disable grenade slot
//		return;

	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;
	if (isPlacingSOFLAM())
		return; 

	if( Pawn.HeadVolume.bWaterVolume )
		return;

	// If weapon is in the process of zooming in/out, but not fully zoomed-in, don't switch.
	if( ZombieWeapon(Pawn.Weapon).bDoingZoom && !ZombieWeapon(Pawn.Weapon).bZoomed )
		return;

	// If player is holding down fire or alt fire trigger, don't switch
	if( Pawn.PressingFire() || Pawn.PressingAltFire() )
		return;

	if( ZombieWeapon(Pawn.Weapon).bZoomed )
	{
		WeaponZoomOutFaster();
	}

	if (ZombieWeapon(Pawn.Weapon) == none)
	{
		Pawn.PlaySound(EmptySlotSound,SLOT_Interface,,,60.0);  // arg 2: slot, arg 5: radius
		return;	
	}

	if( ZombiePlayerPawn(Pawn).EquipWillBeValid(SlotID) )
	{
	//	if( ZombieWeapon(Pawn.Weapon).bZoomed )
	//	{
	//		WeaponZoomOutFaster();
	//		return;
	//	}

		ZombiePlayerPawn(Pawn).EquipWeapon(SlotID); 
	}
	else
	{
		if( ZombieBipedPawn(Pawn).Weapons[SlotID] == None )
			Pawn.PlaySound(EmptySlotSound,SLOT_Interface,,,60.0);  // arg 2: slot, arg 5: radius
	}
} 
exec function StartAdjustZoomIn()
{
	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;

	if( ZombieWeapon(Pawn.Weapon).bZoomed )
		ZombieWeapon(Pawn.Weapon).AdjustZoomIn();
}

exec function StartAdjustZoomOut()
{
	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;

	if( ZombieWeapon(Pawn.Weapon).bZoomed )
		ZombieWeapon(Pawn.Weapon).AdjustZoomOut();
}

exec function StopZoomAdjust()
{
	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;

	ZombieWeapon(Pawn.Weapon).AdjustZoomStop();
}

exec function StepZoomIn()
{
	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;

	if( ZombieWeapon(Pawn.Weapon).bZoomed )
		ZombieWeapon(Pawn.Weapon).StepZoomIn();
}

exec function StepZoomOut()
{
	if( Pawn == None )
		return;
	else if( Pawn.Weapon == None )
		return;

	if( ZombieWeapon(Pawn.Weapon).bZoomed )
		ZombieWeapon(Pawn.Weapon).StepZoomOut();
}

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	Super.DisplayDebug(Canvas,YL,YPos);

	class'ZombieFontDescriptor'.static.SetHUDFont(Canvas, 24);
	
	Canvas.SetDrawColor(0,255,0);

	Canvas.SetPos(50,YPos);
	
	Canvas.DrawText("Rumble "$SpecialRumbleDes.class, false);
	YPos += 20;
	Canvas.SetPos(55,YPos);
	
	Canvas.DrawText("Min "$ZombieRumbleDesc(specialRumbleDes).MinStrength$" Max "$ZombieRumbleDesc(specialRumbleDes).MaxStrength, false);
	YPos += 20;
	Canvas.SetPos(55,YPos);
	
	Canvas.DrawText("Left "$ZombieRumbleDesc(specialRumbleDes).UseLeftMotor$" Right "$ZombieRumbleDesc(specialRumbleDes).UseRightMotor, false);
	YPos += 20;
	Canvas.SetPos(55,YPos);
	
	Canvas.DrawText("Duration "$ZombieRumbleDesc(specialRumbleDes).Duration, false);
	YPos += 20;
	Canvas.SetPos(55,YPos);
	
	if (RumbleSawtooth(SpecialRumbleDes) != none)
	{
		Canvas.DrawText("Frequency "$RumbleSawtooth(SpecialRumbleDes).Frequency, false);
		YPos += 20;
		Canvas.SetPos(55,YPos);
	}
	else if (RumbleSin(SpecialRumbleDes) != none)
	{
		Canvas.DrawText("Frequency "$RumbleSin(SpecialRumbleDes).Frequency, false);
		YPos += 20;
		Canvas.SetPos(55,YPos);
	}
	
	class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	Canvas.Font = Canvas.SmallFont;
}

exec function ToggleLMotor()
{
	ZombieRumbleDesc(specialRumbleDes).UseLeftMotor = !ZombieRumbleDesc(specialRumbleDes).UseLeftMotor;
}

exec function ToggleRMotor()
{
	ZombieRumbleDesc(specialRumbleDes).UseRightMotor = !ZombieRumbleDesc(specialRumbleDes).UseRightMotor;
}

exec function IncMaxStrength()
{
	ZombieRumbleDesc(specialRumbleDes).MaxStrength = FMin(ZombieRumbleDesc(specialRumbleDes).MaxStrength+0.05, 1);
}
exec function DecMaxStrength()
{
	ZombieRumbleDesc(specialRumbleDes).MaxStrength = FMax(ZombieRumbleDesc(specialRumbleDes).MaxStrength-0.05, 0);
}

exec function IncMinStrength()
{
	ZombieRumbleDesc(specialRumbleDes).MinStrength = FMin(ZombieRumbleDesc(specialRumbleDes).MinStrength+0.05, 1);
}
exec function DecMinStrength()
{
	ZombieRumbleDesc(specialRumbleDes).MinStrength = FMax(ZombieRumbleDesc(specialRumbleDes).MinStrength-0.05, 0);
}

exec function IncFrequency()
{
	if (RumbleSawtooth(SpecialRumbleDes) != none)
	{
		RumbleSawtooth(SpecialRumbleDes).Frequency += 0.05;
	}
	else if (RumbleSin(SpecialRumbleDes) != none)
	{
		RumbleSin(SpecialRumbleDes).Frequency += 0.05;
	}
}
exec function DecFrequency()
{
	if (RumbleSawtooth(SpecialRumbleDes) != none)
	{
		RumbleSawtooth(SpecialRumbleDes).Frequency -= 0.05;
	}
	else if (RumbleSin(SpecialRumbleDes) != none)
	{
		RumbleSin(SpecialRumbleDes).Frequency -= 0.05;
	}
}

exec function IncDuration()
{
	ZombieRumbleDesc(specialRumbleDes).Duration += 0.05;
}
exec function DecDuration()
{
	ZombieRumbleDesc(specialRumbleDes).Duration -= 0.05;
}

exec function NextWave()
{
	local RumbleSawtooth saw;
	local RumbleSin sin;
	local RumbleConst constR;

	if (RumbleSawtooth(SpecialRumbleDes) != none)
	{
		//sin
		saw = RumbleSawtooth(SpecialRumbleDes);
		SpecialRumbleDes = new class'ZombieGame.RumbleSin';
		
		RumbleSin(SpecialRumbleDes).MinStrength=Saw.MinStrength;
		RumbleSin(SpecialRumbleDes).MaxStrength=Saw.MaxStrength;
		RumbleSin(SpecialRumbleDes).Frequency=Saw.Frequency;
		RumbleSin(SpecialRumbleDes).Duration=Saw.Duration;
		RumbleSin(SpecialRumbleDes).UseRightMotor=Saw.UseRightMotor;
		RumbleSin(SpecialRumbleDes).UseLeftMotor=Saw.UseLeftMotor;
	}
	else if (RumbleSin(SpecialRumbleDes) != none)
	{
		//const
		sin = RumbleSin(SpecialRumbleDes);
		SpecialRumbleDes = new class'ZombieGame.RumbleConst';
		
		RumbleConst(SpecialRumbleDes).MinStrength=sin.MinStrength;
		RumbleConst(SpecialRumbleDes).MaxStrength=sin.MaxStrength;
		RumbleConst(SpecialRumbleDes).Duration=sin.Duration;
		RumbleConst(SpecialRumbleDes).UseRightMotor=sin.UseRightMotor;
		RumbleConst(SpecialRumbleDes).UseLeftMotor=sin.UseLeftMotor;
	}
	else if (RumbleConst(SpecialRumbleDes) != none)
	{
		//saw
		constR = RumbleConst(SpecialRumbleDes);
		SpecialRumbleDes = new class'ZombieGame.RumbleSawtooth';
		
		RumbleSawtooth(SpecialRumbleDes).MinStrength=constR.MinStrength;
		RumbleSawtooth(SpecialRumbleDes).MaxStrength=constR.MaxStrength;
		RumbleSawtooth(SpecialRumbleDes).Frequency=constR.Duration;
		RumbleSawtooth(SpecialRumbleDes).Duration=constR.Duration;
		RumbleSawtooth(SpecialRumbleDes).UseRightMotor=constR.UseRightMotor;
		RumbleSawtooth(SpecialRumbleDes).UseLeftMotor=constR.UseLeftMotor;
	}
}

exec function TestSpecialRumble()
{
	PlayRumble(SpecialRumbleDes);
}

exec function Smartbomb()
{
	/*
	local SpecForceEnemyPawn p;
	foreach Pawn.RadiusActors(class'SpecForceEnemyPawn',p,2000)
	{
		if (p.GetFaction() != ZombiePawn(Pawn).GetFaction())
		{
			Spawn(class'ZombieEffects.explosion_grenade',,,p.location,);
			p.Velocity = Normal(Pawn.Location - p.location)*350;
			p.Velocity.Z = 260;

			p.Died( self, class'Suicided', p.Location );
		}
	}
	*/
}

// Unlock all single-player maps
exec function UnlockAllSPMaps()
{
//FIXME_OLDMENUS
//	local MenuManager MM;
//
//	Log("Cheat exec: Unlocking all single-player maps (note: this cannot be undone)");
//	MM = MenuManager(Player.BasePlayerMenu);
//
//	MM.User.LastLevelCompleted = MM.NUM_SP_MAPS;
//	MM.ViewportOwner.Actor.SaveProfileConfig();
}

// Unlock all single-player and cooperative-play maps
exec function UnlockAllSPCMaps()
{
//FIXME_OLDMENUS
//	local MenuManager MM;
//
//	Log("Cheat exec: Unlocking all single-player and coop maps (note: this cannot be undone)");
//	MM = MenuManager(Player.BasePlayerMenu);
//
//	MM.User.LastLevelCompleted = MM.NUM_SP_MAPS;
//	MM.ViewportOwner.Actor.SaveProfileConfig();
//
//	MM.User.LastCoOpMapCompleted = MM.NUM_COOP_MAPS;
//	MM.ViewportOwner.Actor.SaveProfileConfig();
}

exec event SetProgressTime( float T )
{
	//this is a really horrible hack. See UnPenLev, and look for: ParseCommand(&Text,TEXT("FAILURE"))
	if (T == -2)
	{
		Player.GUIController.ShowMessageBox("ServerFull");
	}
	ProgressTimeOut = T + Level.TimeSeconds;
}

event ClientNameChange()
{
    local PlayerController PC;

	ForEach DynamicActors(class'PlayerController', PC)
		PC.ReceiveLocalizedMessage( class'ZombieMPMessage', 15, PlayerReplicationInfo );
}

simulated event PreClientTravel( out string url )
{
	local int namePos, nextPos;
	local string lefty, righty;

	log( "PreClientTravel IN" @ url );

	namePos = InStr( url, "?Name=" );
	if( namePos >= 0 )
	{
		lefty = Left( url, namePos );
		righty = Mid( url, namePos+1 );
		nextPos = InStr( righty, "?" );
		if( nextPos >= 0 )
		{
			url = lefty $ Mid( righty, nextPos );
		}
		else
		{
			url = lefty;
		}
	}

	url = url $ "?Name=" $ UnSpace(ProfileName);

	log( "PreClientTravel OUT" @ url );
}

native function SetLastLevelCompleted();


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: RumbleConst'SFRMPlayerController.PlayerHitRumble'
    begin object name=PlayerHitRumble class=Class'RumbleConst'
        MaxStrength=0.7000000
        Duration=0.1000000
    end object
    HitRumbleDes=PlayerHitRumble
    LevelLoadInteractionClass=Class'LevelLoadInteraction'
    EmptySlotSound=Sound'CBW_DYN_weapons.USP45.dryfire'
    TinnitusOnSnd=Sound'CBW_DYN_interface.tinnitus.tinnitus'
    TinnitusOffSnd=Sound'CBW_DYN_interface.tinnitus.fadeout_sound'
    BeepSound=Sound'CBW_DYN_interface.teletype.Type'
    curWaterRollDir=1.0000000
    // Reference: RumbleSawtooth'SFRMPlayerController.SpecialRumble'
    begin object name=SpecialRumble class=Class'RumbleSawtooth'
        Frequency=0.3500000
        MaxStrength=0.8000000
        Duration=0.3500000
    end object
    SpecialRumbleDes=SpecialRumble
    // Reference: RumbleHeartbeat'SFRMPlayerController.HeartRumble'
    begin object name=HeartRumble class=Class'RumbleHeartbeat'
    end object
    HeartbeatRumbleDes=HeartRumble
    CenterPitch=64443.0000000
    FovAngle=90.0000000
    IsZController=true
    PawnClass=Class'ZombiePlayerPawn'
}