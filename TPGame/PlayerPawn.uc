class PlayerPawn extends TPPawn
	placeable
	config(Game)
	dependson(TPPawn)
	native;

//	dependson(TPPlayerController)


//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 14

//***********************************************************************
// DEFINES
//***********************************************************************




var const float  HeightZ;

var config float SprintGroundSpeed,NormalGroundSpeed,BackwardGroundSpeed;
var config float ADSSpeedModifier;
var config float VaultStepHeight, MantleStepHeight;
var config float SprintJumpZ, NormalJumpZ;
var config float HealthRegenTime, HealthRegenAmount, HealthRegenIdleTime;

var repnotify transient TPDroppedPickup PendingPickup;
var repnotify transient TPPickupFactory PendingPickupFactory;
var Alarm PendingAlarm;







var config TPPawn.ShakeInfo CameraShake;

var float LastDamageTime;

var bool bShellShockActive;
var config float ShellShockTime;
var config float ShellShockGameSpeed;
var config int ShellShockDamageThreshold;
var config PostProcessSettings ShellShockPostSettings;
var config PostProcessSettings ShellShockDeathPostSettings;
var config PostProcessSettings BlindPostSettings;
var config float ShieldDamageMultiplier;
var config float GrappleDamageMultiplier;

var SoundCue ShellShockSound, ShellShockDeathSound;
var SoundCue DamageSound;
var SoundCue FireDamageSound;
var SoundCue MeleeDamageSound;
var SoundCue FallDamageSound;
var SoundCue LandSound;
var SoundCue JumpSound;
var SoundCue SprintSound;
var SoundCue GoggleStartSound, GoggleLoopSound, GoggleStopSound;
var SoundCue DeathSound;
var AudioComponent ShellShockAudio, GoggleEffectAudio;

var SpriteComponent teamIdentifierIconComponentNazi, teamIdentifierIconComponentPartisan;

var bool bShellShockKillPlayer;


// DOF effect variables
struct native DOFEffectInfo
{
    var float FocusInnerRadius;
    var float FocusDistance;
    var float FalloffExponent;
    var float BlurKernelSize;
    var float MaxNearBlurAmount;
    var float MaxFarBlurAmount;
};
var DOFEffectInfo     EffectInfo;
var DOFEffect         Effect;
var MaterialEffect    DistortionEffect;
var MaterialEffect    DistortionEffectWide;
var float             DofTimer;
var float             DofDebugTimer;
var float             DofTotalTime;
var float             DofCurrDistance;
var float             DofTargetDistance;
var bool              bDofFocus;

var bool              bInPostureVolume;

var bool			  bPlayerBlinded;
var float			  BlindAngle;
var AnimNodeScalePlayRate        anode_WalkRate;
var TPAnimBlendBySpeed           anode_speedBlend;
var SkelControlLookAt            skel_HeadTrack;
var	repnotify AnimNodeBlend      anode_WeaponBlend;
var AnimNodeBlend                anode_CrouchWeaponBlend;
var repnotify TPAnimNodeBlendList          anode_PostureBlend;
var AnimNodeBlend                anode_HangBlend;
var AnimNodeSequence             anode_WeaponUnequipStand;
var AnimNodeSequence             anode_WeaponUnequipCrouch;
var AnimNodeSequence             anode_ToCrouch;
var AnimNodeSequence             anode_ToStand;
var AnimNodeSequence             anode_WeaponSprinting;
var AnimNodeBlend                anode_HumanShield;
var bool						 bUsingHumanShield;
var	TPSkelControlPlayerPitch	 skel_SpinePitch;
var	TPSkelControlPlayerRoll	     skel_SpineRoll;
var Controller					 PlayerKiller;
var class<DamageType>			 PlayerKillerDamageType;

var float                        DefaultUnequipStandRate;
var float                        DefaultUnequipCrouchRate;

var repnotify SkeletalMeshComponent	MyMesh;

var float GoggleStartDur;

struct native DamageShakeInfo
{
    var config string                       DamageTypeString;
    var config TPPawn.ShakeInfo ShakeInfo;
};

var config array<DamageShakeInfo> DamageShakeParams;

var MaterialInstanceConstant	 DamagePostMIC;
var MaterialInstanceConstant	 MeleeHitPostMIC;
var bool						 bHaveNotResetPost;
var repnotify bool bClimbingLadder;

struct native ShellShockSoundConfig
{
	var name Group;
	var float DefaultVolume;
	var float ShellShockVolume;
	var float StartTime;
	var float EndTime;
	var float ChangePerSecond;
	var float CurrentVolume;
};

var config array<ShellShockSoundConfig> ShellShockSoundLevels;
var float ShellShockTimeLeft;
var config float ShellShockSoundFadeOutTime;
var repnotify int PostureIndex;

// var bool						bCamper;
// var bool						bGranny;

var float MeleeHitTotalTime;
var float MeleeHitCurrentTime;

var float LastJumpLandTime;

var config float m_FactorToSlowSimTimeWhenPlayerDying;
var config float m_HowLongToWaitToPlayDyingEffect;

replication
{
	if (bNetDirty && Role == ROLE_Authority)
		MyMesh, PendingPickup, PendingPickupFactory;
	if (bNetDirty && !bNetOwner && Role == ROLE_Authority)
		bClimbingLadder, PostureIndex;
}

simulated event ReplicatedEvent(name VarName)
{
	super.ReplicatedEvent(VarName);

	if ( VarName == 'PlayerReplicationInfo')
	{
		PostInitAnimTree(Mesh);
		ClientUpdateMeshBoneControllers();
	}
	else if (VarName == 'MyMesh')
	{
		SetSkeletalMesh(MyMesh);
	}
	else if (VarName == 'PendingPickup')
	{
		// Check for multiplayer spamming
		if (Controller != none)
		{
			if ( PendingPickup == None )
			{
				;
			}
			if (TPPlayerController(Controller).myHUD != none)
				TpHUD((TPPlayerController(Controller)).myHUD).PickupText=PendingPickup.GetPickupName ( );
		}
	}
	else if (VarName == 'PendingPickupFactory')
	{
		// Check for multiplayer spamming
		if (Controller != none)
		{
			if (TPPlayerController(Controller).myHUD != none)
				TpHUD((TPPlayerController(Controller)).myHUD).PickupText=PendingPickupFactory.GetPickupName ( );
		}
	}
	else if (VarName == 'bClimbingLadder')
	{
		if (bClimbingLadder)
			anode_WeaponBlend.SetBlendTarget(1.0, 0.0);
		else if (Weapon != none)
			anode_WeaponBlend.SetBlendTarget(0.0, 0.0);
	}
	else if (VarName == 'PostureIndex')
	{
		anode_PostureBlend.SetActiveChild(PostureIndex, 0.2);
	}
}

// Turns the scoreboard on and off
reliable client function ToggleScoreboard(bool bEnable)
{
	TpHUD(TPPlayerController(Controller).myHUD).bShowScores = bEnable;
}

// When respawning, turn the scoreboard off.
function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);

	ToggleScoreboard(false);
}

simulated event Vector GetPawnViewLocation()
{
    local vector  Loc;
    local rotator Rot;

    Mesh.GetSocketWorldLocationAndRotation('cameraLoc', Loc, Rot);

	//KMM testing smoother cam position
	//Loc = Location + vect(0,0,1) * BaseEyeHeight;


    return Loc;
}

simulated function DoMeleeAttack()
{
	if (!bMeleeAttacking)
	{
		bMeleeAttacking = true;
		ServerDoMeleeAttack();
	}
}

reliable server function ServerDoMeleeAttack()
{
	local PlayerPawn P;
	local vector LNormal;

	bMeleeAttacking = true;

	ForEach VisibleCollidingActors(class'PlayerPawn', P, CylinderComponent.CollisionRadius * 4, Location, true)
	{
		LNormal = Normal(P.Location - Location);
		if  (LNormal dot vector(Rotation) > 0.5)
			P.TakeDamage(P.Health, P.Controller, P.Location, LNormal * 100000.0, class'TPDamageTypeImpactMortarShell');
	}
}

reliable server function ServerSetClimbing(bool bIsClimbing)
{
	bClimbingLadder = bIsClimbing;
	if (bIsClimbing)
		anode_WeaponBlend.SetBlendTarget(1.0, 0.0);
	else
		anode_WeaponBlend.SetBlendTarget(0.0, 0.0);

}

function JumpOffPawn()
{
    ;
    Super.JumpOffPawn();
}

// Set the PlayerPawns Mesh in multiplayer
simulated function SetSkeletalMesh(SkeletalMeshComponent SkelM)
{
	Mesh.SetSkeletalMesh(SkelM.SkeletalMesh);
}

function MultiplayerDisplayInventory( HUD hud )
{
	local Canvas Canvas;
	local float out_YPos, XL, YL;
	local Inventory inv;
	local TPWeapon tpWeap;
	local PlayerPawn netPawn;
	local int mem_b, mem_kb, mem_mb, mem_gb;

	Canvas = HUD.Canvas;
	out_YPos = 500;
	Canvas.Font = class'Engine'.Static.GetTinyFont();
	Canvas.StrLen("X", XL, YL);
		

	Canvas.SetDrawColor(255,255,255,255);
	Canvas.SetPos(80, out_YPos + 75);
	Canvas.DrawText(" === Inventory === ");

	/*if ( WorldInfo.NetMode == NM_ListenServer )
	{
		ForEach DynamicActors(class'PlayerPawn', netPawn)
		{
			if ( !netPawn.IsLocallyControlled() )
				break;
		}
	}
	else*/
		netPawn = self;

	for (inv = netPawn.InvManager.InventoryChain; inv != None; inv = inv.Inventory)
	{
		out_YPos += YL;
		Canvas.SetPos(80, out_YPos + 75);
		tpWeap = TPWeapon(inv);

		if ( inv == Weapon )
		{
			Canvas.SetDrawColor(255,255,255,255);
		}
		else
		{
			Canvas.SetDrawColor(0,128,128,255);
		}

		if ( Grenade_Persistent(inv) != None )
			Canvas.DrawText(inv @ "[" $ tpWeap.bWeaponPutDown $"]" @ tpWeap.AmmoInMagazine $ "/" @ tpWeap.AmmoCount @ "(" @ tpWeap.GetStateName() @ ")" @ "  -->" @ "< Can Throw =" @ TPPlayerController(controller).bAllowGrenadeUse @ ">" @Grenade_persistent(inv).ActualCookTime );
		else
			Canvas.DrawText(inv @ "[" $ tpWeap.bWeaponPutDown $"]" @ tpWeap.AmmoInMagazine $ "/" @ tpWeap.AmmoCount @ "(" @ tpWeap.GetStateName() @ ") Reloaded Times:" @ tpWeap.timesReloaded @ "Shots Fired:" @ tpWeap.shotsFired @ "Shots Ended:" @ tpWeap.shotsCompleted @ "DebugN" @ tpWeap.debugCounter);
	}

	Canvas.SetDrawColor(255,0,0,255);
	Canvas.DrawText( "Emitters:" @ TPPlayerController(controller).numEmittersOnScreen @ "/" @ TPPlayerController(controller).numEmittersInMemory  );
	
	//Canvas.DrawText( "PrevWeaponOnGrenade =" @ TPPlayerController(controller).PrevWeaponOnGrenade );
	//Canvas.DrawText( "FOV =" @ TPPlayerController(controller).FOVAngle @ TPPlayerController(controller).DesiredFOV );

	out_YPos += ( 2 * YL);
	Canvas.SetPos(80, out_YPos + 75);

	Canvas.SetDrawColor(255,0,0,255);
	mem_b	= TPPlayerController(controller).GetParticleAvailableMemory();

	mem_gb	= mem_b / 1000000000;
	mem_b	-= ( mem_gb * 1000000000 );

	mem_mb	= mem_b / 1000000;
	mem_b	-= ( mem_mb * 1000000 );

	mem_kb	= mem_b / 1000;
	mem_b	-= ( mem_kb * 1000 );

	Canvas.DrawText( "Memory Available =" @ mem_gb @ "GB," @ mem_mb @ "MB," @ mem_kb @ "KB," @ mem_b @ "B" );
	//Canvas.DrawText( "Pending Fire =" @ tpWeap.PendingFire(0) );  //InvManager.PendingFire.Length

	out_YPos += ( YL);
	Canvas.SetPos(80, out_YPos + 75);

	Canvas.SetDrawColor(255,0,0,255);
	Canvas.DrawText( "Weapon Put Down =" @ tpWeap.bWeaponPutDown );


}

function MultiplayerDisplayNetMode(HUD hud)
{
	local Canvas Canvas;
	Canvas = HUD.Canvas;

	Canvas.SetDrawColor(0,255,0,255);
	Canvas.SetPos(0,10);
	Canvas.DrawText( "Net Mode:" @ WorldInfo.NetMode );

}

function int MultiplayerDisplayPlayers(HUD hud)
{
	local Canvas Canvas;
	local float out_YPos;
	local PlayerPawn PP;
	local int i;

	Canvas = HUD.Canvas;

	out_YPos = 50;
	// Iterate through each player
	ForEach DynamicActors(class'PlayerPawn', PP)
	{
		if ( PP != None && PP.PlayerReplicationInfo != None )
		{
			i++;
			Canvas.SetPos(0, out_YPos);
			if ( PP.PlayerReplicationInfo.Team == None || PP.PlayerReplicationInfo.Team.TeamIndex == 0 )
			{
				Canvas.SetDrawColor(0,255,0);
			}
			else
			{
				Canvas.SetDrawColor(255,0,0);
			}
			// Display their name
			Canvas.DrawText( "( " @ PP.PlayerReplicationInfo.PlayerID @ " )" @ PP.PlayerReplicationInfo.PlayerName @ "---" @ PP.Health @ "HP" );
			out_YPos += 15;
		}
	
	
		

		// Display if they are visible / if they are firing

		// Display their ping & packet loss
	}
	// End Loops
	Canvas.SetDrawColor(255,255,255);

	return i;

}

function MultiplayerDisplayPerformance( HUD hud, int numVisiblePlayers )
{
	local Canvas Canvas;
	local TPPlayerController tPC;

	tPC = TPPlayerController(controller);

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.SetPos(425,50);


	// Display the average frame rate
	Canvas.DrawText( "( " @ tPC.netPerformance.numFrames @ " ) Avg. Framerate =" @ tPC.netPerformance.FPS @ "FPS" );

	// number of players in game / Display number of players visible / # of players firing their weapons / 
	//Canvas.DrawText( "Players:" @ 0 @ "/" @ 0 @ "/" @ 0 );

	// Display # of particle FX + explosions + etc. TBD.
	//Canvas.DrawText( "FX:" @ WorldInfo.NetMode );
}

	

function MultiplayerDisplayDebug(HUD hud)
{
	local int numVisiblePlayers;

	// Draw the Net Mode
	MultiplayerDisplayNetMode( hud );

	// Draw the inventory
	MultiplayerDisplayInventory( hud );

	// Display the player info
	numVisiblePlayers = MultiplayerDisplayPlayers ( hud );

	// Display the system performance
	MultiplayerDisplayPerformance( hud, numVisiblePlayers );

}

function string GetLoginEnumString(ELoginStatus loginEnum)
{
	local string sRet;

	switch ( loginEnum )
	{
		case LS_NotLoggedIn:
			sRet = "LS_NotLoggedIn";
			break;

		case LS_UsingLocalProfile:
			sRet = "LS_UsingLocalProfile";
			break;

		case LS_LoggedIn:
			sRet = "LS_LoggedIn";
			break;

		default:
			sRet = "INVALID";
			break;
	}

	return sRet;


}
function ProfileDisplayDebug(HUD hud)
{

	local Canvas				Canvas;
	//local TPPlayerController	tPC;
	local float					XPos, YPos;
	local int					i;
	local string				loginEnum;
	local ELoginStatus			loginStatus;
//	tPC = TPPlayerController(controller);

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255,255);
	YPos = 50;
	XPos = 550;
	Canvas.SetPos(XPos,YPos);

	// For all players

	/*foreach WorldInfo.AllControllers(class'TPPlayerController', tPC);
	{
		if ( PP != None && PP.PlayerReplicationInfo != None )
		{
			Canvas.SetPos(25, YPos);
			Canvas.DrawText( PP.PlayerReplicationInfo.PlayerName @ PP.health $ "/300" );
			YPos += 15;
		}
	}*/
	for ( i = 0 ; i < 4 ; i++  )
	{
		Canvas.SetPos(XPos, YPos);
		loginStatus = TPPlayerController(controller).OnlineSub.PlayerInterface.GetLoginStatus(i);
		loginEnum = GetLoginEnumString( loginStatus );
		Canvas.DrawText( "Player" @ i $ ":" @ loginEnum );
		YPos += 15;
	}
		
}

function LocationalDamageDisplayDebug(HUD hud)
{
	local Canvas				Canvas;
//	local TPPlayerController	tPC;
	local PlayerPawn			PP;
	local float					XPos, YPos;

//	tPC = TPPlayerController(controller);

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255,255);
	YPos = 25;
	XPos = 25;
	Canvas.SetPos(XPos,YPos);

	// For all players

	ForEach DynamicActors(class'PlayerPawn', PP)
	{
		if ( PP != None && PP.PlayerReplicationInfo != None )
		{
			Canvas.SetPos(25, YPos);
			Canvas.DrawText( PP.PlayerReplicationInfo.PlayerName @ PP.health $ "/300" );
			YPos += 15;
		}
	}
	//TPMultiplayerGameInfo(WorldInfo.Game).BroadcastLocalized("<Fonts:EngineFonts.MediumFont>"$"foo"$"<Fonts:/>");

}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local TPWeapon tpWeap;
	local TPPawn P;
	local TPPlayerController tPC, localTPC, netTPC;
	local vector screenLoc, screenLocTL, X, Y, Z, cameraLoc;
	local float colHeight, colRadius;
	local rotator cameraRot;
	local float XL, YL;
	local Canvas Canvas;
	local Inventory inv;
	local string s;
	local int i, activeMasterID, weaponIndex;
	local SlaveChannel sChannel;
	local TPGameReplicationInfo GRI;
	local TPMultiplayerGameInfo MPGameInfo;
//	local PhysicsGrenade pG;

	GRI = TPGameReplicationInfo(WorldInfo.GRI);

	Canvas = HUD.Canvas;




	out_YPos = out_YL;
/*	Canvas.DrawText("MuzzleFlash: "@TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_MUZZLEFLASH)@" DynaLightFlash: "@TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_DYNALIGHT)@" HitEffects: "@TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_HITEFFECTS));
	Canvas.SetPos(4, out_YPos);
*/
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.StrLen("X", XL, YL);

	tPC = TPPlayerController(controller);

	// Draw out curent weapon inventory, highlighting the curWeapon.
	if ( IsLocallyControlled() )
	{
		if ( WorldInfo.NetMode != NM_Standalone )
		{
			MultiplayerDisplayDebug(hud);
			return;
		}
		/*if ( true )
		{
			//LocationalDamageDisplayDebug(hud);
			ProfileDisplayDebug(hud);
			return;
		}*/
		Canvas.SetDrawColor(0,255,0,255);
		Canvas.SetPos(200,200);
		Canvas.DrawText( "Game State:" @ GRI.GameStatus );

		tPC.myHUD.bShowHUD = false;

		// The PRI within each pawn is unreliable for team index info.  Painfully parse the GRI for the valid team indices for each net player.
		for (i=0;i<GRI.PRIArray.Length;i++)
		{
			Canvas.SetPos(500, out_YPos);
			Canvas.DrawText( GRI.PRIArray[i].PlayerID. @ GRI.PRIArray[i].Team.TeamIndex. @ GRI.PRIArray[i].PlayerName );
			out_YPos += 15;
		}

		/*ForEach DynamicActors(class'PlayerPawn', PP)
		{
			if ( PP != None && PP.PlayerReplicationInfo != None )
			{
				Canvas.SetPos(300, out_YPos);
				Canvas.DrawText( PP.PlayerReplicationInfo.PlayerID @ PP.PlayerReplicationInfo.Team.TeamIndex @ PP.PlayerReplicationInfo.PlayerName @ PP.health );
				out_YPos += 15;
			}
		}*/
		/*foreach DynamicActors(class'PhysicsGrenade', pG)
		{
			Canvas.SetPos(300, out_YPos);
			Canvas.DrawText( "Grenade Position:" @ pG.SkeletalMeshComponent.GetPosition() );
			out_YPos += 15;

		}*/

// 		for ( i = 0; i < 4; i++ )
// 		{
// 			Canvas.DrawText( "Damage Compass:" @ i @ "-" @ TpHUD(TPPlayerController(Controller).myHUD).DamageData[i].Fade );
// 		}


		if ( tPC.bLoadoutTest )
		{
			foreach WorldInfo.AllControllers(class'TPPlayerController', tPC)
			{
				if ( tPC.Pawn.IsLocallyControlled() )
					localTPC = tPC;
				else
					netTPC = tPC;

			}

			MPGameInfo = TPMultiplayerGameInfo(WorldInfo.Game);

			out_YPos = 350;
			Canvas.SetPos(25, out_YPos);
			Canvas.SetDrawColor(255,255,255,255);
			Canvas.DrawText("===== Client =====");
			out_YPos += 15;

			Canvas.DrawText("Name:    " @ netTPC.pawn.PlayerReplicationInfo.PlayerName );
			out_YPos += 15;

			weaponIndex = netTPC.connectInfo.AllyWeap;
			Canvas.DrawText("Partisan:" @ MPGameInfo.WeaponList[ weaponIndex ] @ "(" $ weaponIndex $ ")" );
			out_YPos += 15;

			weaponIndex = netTPC.connectInfo.AllyMesh;
			Canvas.DrawText("       Mesh:" @ netTPC.PartisanList[ weaponIndex ].DisplayName @ "(" $ weaponIndex $ ")" );
			out_YPos += 15;

			weaponIndex = netTPC.connectInfo.AxisWeap;
			Canvas.DrawText("Axis:       " @ MPGameInfo.WeaponList[ weaponIndex ] @ "(" $ weaponIndex $ ")" );
			out_YPos += 15;

			weaponIndex = netTPC.connectInfo.AxisMesh;
			Canvas.DrawText("       Mesh:" @ netTPC.NaziList[ weaponIndex ].DisplayName @ "(" $ weaponIndex $ ")" );
			out_YPos += 15;



			out_YPos = 350;
			Canvas.SetPos(325, out_YPos);
			Canvas.SetDrawColor(255,255,255,255);
			Canvas.DrawText("===== Server =====");

			Canvas.DrawText("Name:    " @ localTPC.Pawn.PlayerReplicationInfo.PlayerName);
			out_YPos += 15;

			weaponIndex = localTPC.connectInfo.AllyWeap;
			Canvas.DrawText("Partisan:" @ MPGameInfo.WeaponList[ weaponIndex ] @ "(" $ weaponIndex $ ")" );
			out_YPos += 15;

			weaponIndex = localTPC.connectInfo.AllyMesh;
			Canvas.DrawText("       Mesh:" @ localTPC.PartisanList[ weaponIndex ].DisplayName @ "(" $ weaponIndex $ ")" );
			out_YPos += 15;

			weaponIndex = localTPC.connectInfo.AxisWeap;
			Canvas.DrawText("Axis:       " @ MPGameInfo.WeaponList[ weaponIndex ] @ "(" $ weaponIndex $ ")" );


			weaponIndex = localTPC.connectInfo.AxisMesh;
			Canvas.DrawText("       Mesh:" @ localTPC.NaziList[ weaponIndex ].DisplayName @ "(" $ weaponIndex $ ")" );
			out_YPos += 60;
			Canvas.SetPos(0, out_YPos);

			return;
		}

		if ( tPC.bSoundTest )
		{
			// Dispay each of the soundgroups, their default volumes and their current volume
			Canvas.SetPos(25, 10);
			Canvas.SetDrawColor(255,255,255,255);
			Canvas.DrawText("===== SoundGroups ===== | ====.INI==== | ===Default=== | ===Current=== | ===Ducking=== ");

			out_YPos = 40;
			Canvas.Font = class'Engine'.Static.GetTinyFont();

			// for the soundgroupNames array size
			for ( i = 0 ; i < tPC.soundDucking.Length ; i++ )
			{
				Canvas.SetDrawColor(255,255,255,255);
				if ( tPC.soundDucking[i].isMaster )
					Canvas.SetDrawColor(255,0,0,255);
				if ( tPC.soundDucking[i].isSlave )
					Canvas.SetDrawColor(0,255,192,255);
				if ( tPC.activeMasterID != -1 && tPC.masterSoundChannels[tPC.activeMasterID].soundgroupID == i )
				{
					Canvas.SetPos(10, out_YPos);
					Canvas.SetDrawColor(255,255,0,255);
					Canvas.DrawText( "*" );
				}
				if ( GetSoundGroupIsPlaying(tPC.soundDucking[i].channelName) )
					s = "+ ";
				else
					s = "";

				Canvas.SetPos(25, out_YPos);
				Canvas.DrawText( s $ tPC.soundDucking[i].channelName );

				Canvas.SetDrawColor(0,255,0,255);
				Canvas.SetPos(180, out_YPos);
				Canvas.DrawText( tPC.soundDucking[i].iniLevel );

				Canvas.SetDrawColor(255,0,0,255);
				Canvas.SetPos(260, out_YPos);
				Canvas.DrawText( tPC.soundDucking[i].defLevel );

				Canvas.SetDrawColor(0,255,192,255);
				Canvas.SetPos(340, out_YPos);
				Canvas.DrawText( tPC.GetSoundGroupCurrentVolumeByID( i ) );

				if ( tPC.soundDucking[i].wasIndividuallyDucked )
					Canvas.SetDrawColor(255,255,0,255);
				else if ( tPC.soundDucking[i].duckLevel >= 1.0 )
					Canvas.SetDrawColor(192,192,192,128);
				else
					Canvas.SetDrawColor(255,255,255,255);

				Canvas.SetPos(420, out_YPos);
				Canvas.DrawText( tPC.soundDucking[i].duckLevel );

				out_YPos += 15;
			}

			out_YPos = 10;
			Canvas.SetDrawColor(255,255,255,255);
			Canvas.SetPos(500, out_YPos);
			Canvas.DrawText( "==Current Master Channel==" );

			out_YPos += 15;
			Canvas.SetPos(500, out_YPos);
			Canvas.SetDrawColor(0,255,0,255);

			activeMasterID = tPC.activeMasterID;

			// Print out the current active master sound ducking channel
			if ( activeMasterID == -1 )
			{
				Canvas.SetDrawColor(255,0,0,255);
				Canvas.DrawText( "NO MASTER CHANNEL" );
			}
			else
			{
				Canvas.SetDrawColor(255,255,0,255);
				if ( tPC.activeMasterID != -1 )
					Canvas.DrawText( "Tier:" @ tPC.masterSoundChannels[activeMasterID].tier @ "-" @ tPC.soundDucking[ tPC.masterSoundChannels[tPC.activeMasterID].soundgroupID ].channelName );
				else
					Canvas.DrawText( "Tier:" @ tPC.masterSoundChannels[activeMasterID].tier);

				out_YPos += 15;

				Canvas.SetDrawColor(255,255,255,255);
				Canvas.SetPos(500, out_YPos);
				Canvas.DrawText( "Ducking (Master):" @ tPC.masterSoundChannels[activeMasterID].masterDuckingFactor );
				out_YPos += 15;

				Canvas.SetPos(500, out_YPos);
				Canvas.DrawText( "Ducking (Slave): " @ tPC.masterSoundChannels[activeMasterID].slaveDuckingFactor );
				out_YPos += 15;

				Canvas.SetPos(500, out_YPos);
				Canvas.DrawText( "==Individual Ducks==" );
				out_YPos += 15;

				Canvas.SetDrawColor(255,255,0,255);
				for ( i = 0 ; i < tPC.masterSoundChannels[activeMasterID].individualDuckingFactor.Length; i++ )
				{
					sChannel = tPC.masterSoundChannels[activeMasterID].individualDuckingFactor[i];
					Canvas.SetPos(515, out_YPos);
					Canvas.DrawText( sChannel.ChannelName @ "-->" @ sChannel.duckingFactor );
					out_YPos += 15;
				}
			}

			// Draw the channel output
			Canvas.SetDrawColor(255,255,255,255);
			// Front Left
			Canvas.SetPos(470, 200);
			if ( false == ( QueryChannelVolume(0) ~= -1.0) )
				Canvas.DrawText( "Front Left" @ QueryChannelVolume(0) );

			// Front Right
			Canvas.SetPos(550, 200);
			Canvas.DrawText( "Front Right" @ QueryChannelVolume(1));

			// Front Center
			Canvas.SetPos(510, 250);
			Canvas.DrawText( "Front Center" @ QueryChannelVolume(2));

			// Back Left
			Canvas.SetPos(470, 300);
			Canvas.DrawText( "Back Left" @ QueryChannelVolume(4));

			// Back Right
			Canvas.SetPos(550, 300);
			Canvas.DrawText( "Back Right" @ QueryChannelVolume(5));

			// Voice Center
			Canvas.SetPos(470, 400);
			Canvas.DrawText( "Voice Center" @ QueryChannelVolume(6));

			// Reverb
			Canvas.SetPos(470, 420);
			Canvas.DrawText( "Reverb" @ QueryChannelVolume(7));

			// Radio
			Canvas.SetPos(470, 440);
			Canvas.DrawText( "Radio" @ QueryChannelVolume(8));

			// Reverb
			Canvas.SetPos(470, 460);
			Canvas.DrawText( "Low Frequency" @ QueryChannelVolume(3));

			// Spatialized Component
			Canvas.SetPos(470, 480);
			Canvas.DrawText( "=== Spatialize Factor === ->" @ QuerySpatializeFactor() );

			return;

		}

		if ( TPPlayerController(controller).bSpawnTest )
		{
			// Dispay the score of each spawn point
			Canvas.SetPos(285, 350);
			Canvas.SetDrawColor(255,255,255,255);
			Canvas.DrawText("Location:" @ location);
			// Yellow
			Canvas.SetPos(305, 400);
			Canvas.SetDrawColor(255,255,0,255);
			if ( TPPlayerController(Controller).spawnHolder[1].isSpawned )
				s = "x";
			else
				s = " ";
			Canvas.DrawText("[" $ s $ "] (" @ TPPlayerController(Controller).spawnHolder[1].location @ ") , Yellow:" @ TPPlayerController(Controller).spawnHolder[1].score);
			// Red
			Canvas.SetPos(305, 415);
			Canvas.SetDrawColor(255,0,0,255);
			if ( TPPlayerController(Controller).spawnHolder[2].isSpawned )
				s = "x";
			else
				s = " ";
			Canvas.DrawText("[" $ s $ "] (" @ TPPlayerController(Controller).spawnHolder[2].location @ ") , Red:" @ TPPlayerController(Controller).spawnHolder[2].score);
			// Blue
			Canvas.SetPos(305, 430);
			Canvas.SetDrawColor(0,0,255,255);
			if ( TPPlayerController(Controller).spawnHolder[3].isSpawned )
				s = "x";
			else
				s = " ";
			Canvas.DrawText("[" $ s $ "] (" @ TPPlayerController(Controller).spawnHolder[3].location @ ") , Blue:" @ TPPlayerController(Controller).spawnHolder[3].score);
			// Green
			Canvas.SetPos(305, 445);
			Canvas.SetDrawColor(0,255,0,255);
			if ( TPPlayerController(Controller).spawnHolder[0].isSpawned)
				s = "x";
			else
				s = " ";
			Canvas.DrawText("[" $ s $ "] (" @ TPPlayerController(Controller).spawnHolder[0].location @ ") , Green:" @ TPPlayerController(Controller).spawnHolder[0].score);

			return;
		}

		out_YPos = 300;
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.SetPos(80, out_YPos + 50);
		Canvas.DrawText(" === Inventory === ");

		for (inv = InvManager.InventoryChain; inv != None; inv = inv.Inventory)
		{
			out_YPos += out_YL;
			Canvas.SetPos(80, out_YPos + 75);
			tpWeap = TPWeapon(inv);

			if ( inv == Weapon )
			{
				Canvas.SetDrawColor(255,255,255,255);
			}
			else
			{
				Canvas.SetDrawColor(0,128,128,255);
			}

			if ( Grenade_Persistent(inv) != None )
				Canvas.DrawText(inv @ "[" $ tpWeap.bWeaponPutDown $"]" @ tpWeap.AmmoInMagazine $ "/" @ tpWeap.AmmoCount @ "(" @ tpWeap.GetStateName() @ ")" @ "  -->" @ "< Can Throw =" @ TPPlayerController(controller).bAllowGrenadeUse @ ">" @Grenade_persistent(inv).ActualCookTime );
			else
				Canvas.DrawText(inv @ "[" $ tpWeap.bWeaponPutDown $"]" @ tpWeap.AmmoInMagazine $ "/" @ tpWeap.AmmoCount @ "(" @ tpWeap.GetStateName() @ ") Reloaded Times:" @ tpWeap.timesReloaded @ "Shots Fired:" @ tpWeap.shotsFired @ "Shots Ended:" @ tpWeap.shotsCompleted @ "DebugN" @ tpWeap.debugCounter);
		}

		Canvas.SetDrawColor(255,0,0,255);
		Canvas.DrawText( "PrevWeaponOnGrenade =" @ tPC.PrevWeaponOnGrenade );

		out_YPos += ( 2 * out_YL);
		Canvas.SetPos(80, out_YPos + 75);

		Canvas.SetDrawColor(255,0,0,255);
		Canvas.DrawText( "Pending Fire =" @ tpWeap.PendingFire(0) );  //InvManager.PendingFire.Length

		out_YPos += ( out_YL);
		Canvas.SetPos(80, out_YPos + 75);

		Canvas.SetDrawColor(255,0,0,255);
		Canvas.DrawText( "Weapon Put Down =" @ tpWeap.bWeaponPutDown );





	}

	out_YPos = 50;
	super.DisplayDebug(HUD, out_YL, out_YPos);

	// Go through the inventory manager
	Canvas.SetDrawColor(255,255,255,255);

	ForEach DynamicActors(class'TPPawn', P)
	{
		screenLoc = Canvas.Project(P.Location);
		if (P.Health > 0				&&
			screenLoc.X >= 0			&&
			screenLoc.X < Canvas.ClipX	&&
			screenLoc.Y >= 0			&&
			screenLoc.Y < Canvas.ClipY	)
		{
			Controller.GetPlayerViewPoint(cameraLoc, cameraRot);

			if (vector(cameraRot) dot Normal(Location - P.Location) < 0)
			{
				colHeight = P.CylinderComponent.CollisionHeight;
				colRadius = P.CylinderComponent.COllisionRadius;
				// figure out the actor size so that we can get a useful scale
				//GetAxes(rotator(trig.Location - cameraLoc),X,Y,Z);
				GetAxes(cameraRot,X,Y,Z);
				screenLocTL = Canvas.Project(P.Location + colHeight * Z - colRadius * Y);

				Canvas.SetPos(screenLocTL.X,screenLocTL.Y);

				if ( P.PlayerReplicationInfo != None )
				{
					Canvas.DrawText("Name: "@P.PlayerReplicationInfo.PlayerName);
				}

				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+YL);
				Canvas.DrawText("Physics: "@P.Physics);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*2));
				if (P.CurrentWeaponAttachmentClass != none)
					Canvas.DrawText("Weapon: "@P.CurrentWeaponAttachmentClass.default.WeaponClass.default.WeapName, false);
				else
					Canvas.DrawText("Weapon: None", false);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*3));
				Canvas.DrawText("State: "@P.GetStateName(), false);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*4));
				Canvas.DrawText("AimOffset: "@P.AimOffset.Y, false);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*5));
				Canvas.DrawText("Role: "@P.Role, false);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*6));
				Canvas.DrawText("LadderAction: "@P.LadderAction@"LadderRight: "@P.LadderRight, false);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*7));
				Canvas.DrawText("In Reload: "@P.bIsReloading, false);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*9));
				Canvas.DrawText("FlashCount: "@P.FlashCount, false);
				Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*10));
				Canvas.DrawText("     ShotCount: "@P.ShotCount, false);
			}
		}
	}
}

function SetHumanShield(bool bTurnOn)
{
    if (bTurnOn)
        anode_HumanShield.SetBlendTarget(1, 0.2);
    else
        anode_HumanShield.SetBlendTarget(0, 0.2);

	bUsingHumanShield = bTurnOn;

}

function bool IsUsingHumanShield()
{
	return bUsingHumanShield;
}

simulated event StartCrouch(float HeightAdjust)
{
    //local TPPlayerController tppController;

    super.StartCrouch(HeightAdjust);
	PostureIndex = 1;
    anode_PostureBlend.SetActiveChild(1, 0.2);

    if (Weapon != None)
        TPWeapon(Weapon).ChangePosture(false);

    anode_ToCrouch.PlayAnim();
    anode_ToStand.StopAnim();

	//if (WorldInfo.NetMode == NM_Standalone)
	//{
	//	tppController = TPPlayerController(Controller);
	//	tppController.SetDesiredFOV(tppController.CrouchFOV, 30.0, true);
	//}
}

simulated event EndCrouch(float HeightAdjust)
{
    //local TPPlayerController tppController;

    super.EndCrouch(HeightAdjust);
	PostureIndex = 2;
    anode_PostureBlend.SetActiveChild(2, 0.2);

    if (Weapon != None)
        TPWeapon(Weapon).ChangePosture(true);

    anode_ToStand.PlayAnim();
    anode_ToCrouch.StopAnim();

	//if (WorldInfo.NetMode == NM_Standalone)
	//{
	//	tppController = TPPlayerController(Controller);
	//	tppController.SetDesiredFOV(tppController.default.DefaultFOV, 30.0, true);
	//}
}

simulated function ClientUpdateMeshBoneControllers()
{
	//anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
	if(bIsCrouched)
	{
		if (CurrentWeaponAttachmentClass == none)
			anode_CrouchWeaponBlend.SetBlendTarget(1.0, 0.2);
		else
			anode_CrouchWeaponBlend.SetBlendTarget(0.0, 0.2);
	}
	else
	{
		if (CurrentWeaponAttachmentClass == none)
			anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
		else
			anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
	}
	if(anode_PostureBlend != none)
	{
		// To crouch or not to crouch
		//if(bIsCrouched)
		//{
		//	//anode_PostureBlend.SetBlendTarget(1.0, 0.2);
  //          anode_PostureBlend.SetActiveChild(2, 0.2);
		//}
		//else
		//	anode_PostureBlend.SetACtiveChild(0, 0.2);
	}
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	if (SkelComp == Mesh)
	{
        if (anode_HumanShield == None)
        {
			anode_HumanShield = AnimNodeBlend(Mesh.Animations.FindAnimNode('HumanShield'));
			if(anode_HumanShield == none)
				;
            else
                anode_HumanShield.SetBlendTarget(0.0,0.0);
        }

        if (anode_WeaponUnequipStand == None)
        {
			anode_WeaponUnequipStand = AnimNodeSequence(Mesh.Animations.FindAnimNode('StandWeaponUnequippingAnimations'));
			if(anode_WeaponUnequipStand == none)
				;
            else
                DefaultUnequipStandRate = anode_WeaponUnequipStand.Rate;
        }
        if (anode_WeaponUnequipCrouch == None)
        {
			anode_WeaponUnequipCrouch = AnimNodeSequence(Mesh.Animations.FindAnimNode('CrouchWeaponUnequippingAnimations'));
			if(anode_WeaponUnequipCrouch == none)
				;
            else
                DefaultUnequipCrouchRate = anode_WeaponUnequipCrouch.Rate;
        }
        if (anode_ToCrouch == None)
        {
			anode_ToCrouch = AnimNodeSequence(Mesh.Animations.FindAnimNode('ToCrouch'));
			if(anode_ToCrouch == none)
				;
        }
        if (anode_ToStand == None)
        {
			anode_ToStand = AnimNodeSequence(Mesh.Animations.FindAnimNode('ToStand'));
			if(anode_ToStand == none)
				;
        }
        if (anode_WeaponSprinting == None)
        {
			anode_WeaponSprinting = AnimNodeSequence(Mesh.Animations.FindAnimNode('WeaponSprintingAnims'));
			if(anode_WeaponSprinting == none)
				;
        }
		if( anode_WeaponBlend == none)
		{
			anode_WeaponBlend = AnimNodeBlend(Mesh.Animations.FindAnimNode('WeaponBlend'));
			if(anode_WeaponBlend == none)
				;
		}
		if (skel_HeadTrack == none)
		{
			skel_HeadTrack = SkelControlLookAt(Mesh.FindSkelControl('HeadTrack'));
			if (skel_HeadTrack == none)
			{
				;
				//return false;
			}
		}
		if (anode_WalkRate == none)
		{
			anode_WalkRate = AnimNodeScalePlayRate(Mesh.Animations.FindAnimNode('WFwdSpeedCtrl'));
			if (anode_WalkRate == none)
			{
				;
				//return false;
			}
		}

		if (anode_speedBlend == none)
		{
			anode_speedBlend  = TPAnimBlendBySpeed(Mesh.Animations.FindAnimNode('IdleWalkSpeedBlend'));
			if (anode_speedBlend == none)
			{
				;
				//return false;
			}
		}
		if( skel_SpinePitch == None )
		{
			skel_SpinePitch  = TPSkelControlPlayerPitch(Mesh.FindSkelControl('SpinePitch'));
			if (skel_SpinePitch == none)
			{
				;
				//return false;
			}

			skel_SpinePitch.ControlStrength = 1.0;

			skel_SpinePitch.BlendInTime = 0.2;
			skel_SpinePitch.BlendOutTime = 0.2;

		}

		if( skel_SpineRoll == None )
		{
			skel_SpineRoll  = TPSkelControlPlayerRoll(Mesh.FindSkelControl('SpineRoll'));
			if (skel_SpineRoll == none)
			{
				;
				//return false;
			}

			skel_SpineRoll.ControlStrength = 1.0;

			skel_SpineRoll.BlendInTime = 0.2;
			skel_SpineRoll.BlendOutTime = 0.2;

		}
		if( anode_CrouchWeaponBlend == none)
		{
			anode_CrouchWeaponBlend = AnimNodeBlend(Mesh.Animations.FindAnimNode('CrouchWeaponBlend'));
			if(anode_CrouchWeaponBlend == none)
			{
			;
			//return false;
			}
		}

		if( anode_PostureBlend == none)
		{
			anode_PostureBlend = TPAnimNodeBlendList(Mesh.Animations.FindAnimNode('PostureBlend'));
			if(anode_PostureBlend == none)
			{
			;
			//return false;
			}
		}
		if (anode_HangBlend == none)
		{
			anode_HangBlend = AnimNodeBlend(Mesh.Animations.FindAnimNode('HangBlend'));
			if (anode_HangBlend == none)
			{
			;
			//return false;
			}

			anode_HangBlend.SetBlendTarget(0.0, 0.0);
		}
	}
}

simulated function WeaponAttachmentChanged()
{
	super.WeaponAttachmentChanged();
	if(bIsCrouched)
	{
		if (CurrentWeaponAttachmentClass == none)
			anode_CrouchWeaponBlend.SetBlendTarget(1.0, 0.2);
		else
			anode_CrouchWeaponBlend.SetBlendTarget(0.0, 0.2);
	}
	else
	{
		if (CurrentWeaponAttachmentClass == none)
			anode_WeaponBlend.SetBlendTarget(1.0, 0.0);
		else
			anode_WeaponBlend.SetBlendTarget(0.0, 0.0);
	}
}

event ComboButton(ComboButtonInfo info)
{
	TPPlayerController(Controller).ComboButton(info);
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().PlayerMoveData );
	//Create the bare hands weapon here so it's always available
	//CreateInventory(class'Hands');

	if (WorldInfo.NetMode == NM_Standalone)
	{
		MaxPlayerHealth = default.MaxPlayerHealth * TPGameInfo(WorldInfo.Game).CurrPlayerHealthMultiplier;
		//`log("PlayerPawn spawned with MaxPlayerHealth of"@MaxPlayerHealth);
	}

    Health = MaxPlayerHealth;
	JumpZ=NormalJumpZ;

	//Kelly set this because super.PostBeginPlay is setting it to 1.0 - this fixes playersonly movement
	Mesh.SetPhysicsWeight(0.0);

	ShellShockAudio.SoundCue = ShellShockSound;
	AttachComponent(ShellShockAudio);

	GoggleEffectAudio.SoundCue = GoggleLoopSound;
	AttachComponent(GoggleEffectAudio);

	GoggleStartDur = GoggleStartSound.GetCueDuration() - 0.3f;

    StartRegenHealth();	
}

simulated event ShellShockResetVolumes()
{
	local int i;
	for (i = 0; i < ShellShockSoundLevels.Length; i++)
	{
		PlayerController(Controller).SetAudioGroupVolume(ShellShockSoundLevels[i].Group, ShellShockSoundLevels[i].DefaultVolume);
	}
}

simulated event ShellShockSetStartVolumeDeltas()
{
	local int i;
	for (i = 0; i < ShellShockSoundLevels.Length; i++)
	{
		if (ShellShockSoundLevels[i].Group == 'MASTER_SFX')
			ShellShockSoundLevels[i].DefaultVolume = TPPlayerController(Controller).ProfileSettings.GetSFXVol();
		else if (ShellShockSoundLevels[i].Group == 'MASTER_Music')
			ShellShockSoundLevels[i].DefaultVolume = TPPlayerController(Controller).ProfileSettings.GetMusicVol();
		else if (ShellShockSoundLevels[i].Group == 'MASTER_Dialog')
			ShellShockSoundLevels[i].DefaultVolume = TPPlayerController(Controller).ProfileSettings.GetDialogVol();

		ShellShockSoundLevels[i].ShellShockVolume *= ShellShockSoundLevels[i].DefaultVolume;
		ShellShockSoundLevels[i].ChangePerSecond = ShellShockSoundLevels[i].DefaultVolume - ShellShockSoundLevels[i].ShellShockVolume;
		ShellShockSoundLevels[i].ChangePerSecond *= -1.0f;
		if (ShellShockSoundLevels[i].StartTime != 0)
			ShellShockSoundLevels[i].ChangePerSecond /= ShellShockSoundLevels[i].StartTime;
		ShellShockSoundLevels[i].CurrentVolume = ShellShockSoundLevels[i].DefaultVolume;
		//`log("ChangePerSecond for"@ShellShockSoundLevels[i].Group@"is"@ShellShockSoundLevels[i].ChangePerSecond);
		//`log("Curr volume is"@ShellShockSoundLevels[i].CurrentVolume);
	}
}

simulated event ShellShockKillPlayer()
{
	WorldInfo.Game.SetGameSpeed(1.0);
	LocalPlayer(TPPlayerController(Controller).Player).ClearPostProcessSettingsOverride();

	if (DamagePostMIC != None)
		DamagePostMIC.SetScalarParameterValue('DamagePercent', 1.0f);

	ShellShockAudio.Stop();
	ShellShockResetVolumes();
	//PlayerController(Controller).SetAudioGroupVolume('MASTER_SFX', 1.0);
	//PlayerController(Controller).SetAudioGroupVolume('MASTER_Dialog', 1.0);
	Died(PlayerKiller, PlayerKillerDamageType, Location);
}

simulated event ShellShockFinished()
{
    if (bShellShockActive)
	{
		if (bShellShockKillPlayer)
		{
			//show the corpse on the ground a little bit longer and then kill the player
			SetTimer(3.0f, false, 'ShellShockKillPlayer');
		}
		else
		{
			bShellShockActive = false;
			WorldInfo.Game.SetGameSpeed(1.0);
			//`log("Shell shock finished...");
			LocalPlayer(TPPlayerController(Controller).Player).ClearPostProcessSettingsOverride();
			ShellShockAudio.FadeOut(ShellShockSoundFadeOutTime, 0.0);
			//ShellShockAudio.Stop();
			ShellShockResetVolumes();
			//PlayerController(Controller).SetAudioGroupVolume('MASTER_SFX', 1.0);
			//PlayerController(Controller).SetAudioGroupVolume('MASTER_Dialog', 1.0);
		}
	}
}

event Landed(vector HitNormal, actor FloorActor)
{
	if (LastJumpLandTime + 0.75f < WorldInfo.TimeSeconds)
	{
        LastJumpLandTime = WorldInfo.TimeSeconds;

	    PlayJumpLandSound();
		Super.Landed(HitNormal, FloorActor);
	}
}

simulated event StartShellShock( int Damage, optional float Duration = 6.0f, optional bool bKillOff = false, optional bool bImpulse = true, optional bool bUseOtherPost = false, optional PostProcessSettings ShellPostOverride)
{
	local float TimeToUse;
    local TPPlayerController tppController;

    tppController = TPPlayerController(Controller);

	if (!bShellShockActive)
	{
		bShellShockActive = true;

		if (bKillOff)
		{
			if (DamagePostMIC != None)
				DamagePostMIC.SetScalarParameterValue('DamagePercent', 1.0f);

			Mesh.SetBlockRigidBody(true);
			SetCollision(false,true);
			InitRagdoll();
            //tppController.DisableAimDownSight();
            //tppController.SetDesiredFOV (tppController.DefaultFOV);

            InvManager.DiscardInventory();

			// Commented out by Ryan and Sanjay to make our heads rest easier :)  It might need to be commented back in, but we are applying an inpulse to the mesh in State Dying
			/*if (bImpulse)
			{
				Mesh.AddImpulse(vect(0.0f, -2000.0f, 7000.0f));
			}*/
			tppController.CameraMode('freecam');
			tppController.ClearPostMaterials();
			bShellShockKillPlayer = true;
            ClearTimer('RegenHealth');
			Mesh.SetRBCollidesWithChannel(RBCC_Default, true);
			ShellShockAudio.SoundCue = ShellShockDeathSound;
		}
		else
		{
			ShellShockAudio.SoundCue = ShellShockSound;
		}

		TimeToUse = Duration;

		if (WorldInfo.NetMode == NM_Standalone)
			WorldInfo.Game.SetGameSpeed(ShellShockGameSpeed);

		SetTimer(TimeToUse * ShellShockGameSpeed, false, 'ShellShockFinished');

		ShellShockTimeLeft = Duration;

		if (!bUseOtherPost)
		{
			if (!bKillOff)
				LocalPlayer(tppController.Player).OverridePostProcessSettings(ShellShockPostSettings, 0.5);
			else
				LocalPlayer(tppController.Player).OverridePostProcessSettings(ShellShockDeathPostSettings, 0.5);
		}
		else
			LocalPlayer(tppController.Player).OverridePostProcessSettings(ShellPostOverride, 0.5);
		//ShellShockAudio.FadeIn(0.5, 1.0);
		//PlayerController(Controller).SetAudioGroupVolume('MASTER_SFX', 0.2);
		//PlayerController(Controller).SetAudioGroupVolume('MASTER_Dialog', 0.2);
		ShellShockSetStartVolumeDeltas();
		ShellShockAudio.Play();
	}
}

function OnStartShellShock(SeqAct_StartShellShock action)
{
	local TPPawn.ShakeInfo myCameraShake;

	StartShellShock(100, action.Duration, action.bKillPlayer, true, true, action.PostSettings);

	if (action.bShakeCamera)
	{
		myCameraShake.RotMag.Z = CameraShake.RotMag.Z * 3;
		myCameraShake.OffsetMag.Z = CameraShake.OffsetMag.Z;
		myCameraShake.RotTime = action.Duration + 1;
		myCameraShake.OffsetTime = action.Duration + 1;

		TPPlayerController(Controller).ShakeView(myCameraShake);
	}
}

function int GetDamageShakeParamIndex(class<DamageType> damageType)
{
    local int i, offset;

    for (i = 0; i < DamageShakeParams.Length; i++)
    {
        offset = InStr(string(damageType.name),DamageShakeParams[i].DamageTypeString);
        if (offset != -1)
            return i;
    }

    return -1;
}

reliable client function DoDamageEffects(int Damage, Controller instigatedBy, vector inRotation, vector Momentum, vector FromLocation, class<DamageType> damageType)
{
	local int index; //CameraShakeDamage;
	//local TPPlayerController.ShakeInfo myCameraShake;
	local bool bShellShockKill;
	local bool bLethalExplosion;
	local TPPlayerController MyController;

	MyController = TPPlayerController(Controller);

	// If we don't have a controller, then that is probably because we're driving something...
	// Try grabbing its controller
	if (MyController == None && DrivenVehicle != None)
	{
		MyController = TPPlayerController(DrivenVehicle.Controller);
	}

	if (MyController != None)
	{
		// Update HUD Effects
		if (damageType != class'DmgType_Fell' && damageType != class'TPDamageTypeFall')
		{
			TpHUD(MyController.myHUD).DamageIndicationUpdate(momentum);
		}
		//else
		//{
		//	TpHUD(MyController.myHUD).ShowFallDamageIndication();
		//}

		//also do the damage particle effect (if it's not already up)
		if (damageType != class'TPDamageTypeGrapple')
			MyController.SpawnCameraEffect(class'Emit_CameraEffect');
	}

	//`log("Damage type is"@damageType);

	//we were hit by a grenade
	if (damageType == class'TPDamageTypeImpactGrenade' || damageType == class'TPDamageTypeImpactTankShell' || damageType == class'TPDamageTypeImpactMortarShell' || damageType == class'TPDamageTypeImpactPanzer')
	{
		//if (Damage < 90)
		//	CameraShakeDamage = 90;
		//else
		//	CameraShakeDamage = min(100.0f, Damage);

		//myCameraShake = CameraShake;

		if (Health - Damage <= 0)
			bLethalExplosion = true;
		else
			bLethalExplosion = false;

		if (Damage >= ShellShockDamageThreshold && !bLethalExplosion)
		{
			//myCameraShake.RotMag.Z = CameraShake.RotMag.Z * (CameraShakeDamage / 100.0f) * 2.5;
			//myCameraShake.RotRate.Z = CameraShake.RotRate.Z / (CameraShakeDamage / 100.0f);
			//myCameraShake.OffsetMag.Z = 0;//CameraShake.OffsetMag.Z * CameraShakeDamage / 100.0f;
			//myCameraShake.OffsetRate.Z = 0;//CameraShake.OffsetRate.Z / (CameraShakeDamage / 50.0f);
			//myCameraShake.RotTime = ShellShockTime + 0.50;
			//myCameraShake.OffsetTime = 0;//ShellShockTime;// + 1;


			if (WorldInfo.NetMode == NM_Standalone)
			{
// 				if (bLethalExplosion && !InGodMode())
// 				{
// 					//don't kill him just yet, have the shell shock take him out
// 					Damage = 0;
// 					Health = 1;
// 					bShellShockKill = true;
// 					PlayerKiller = instigatedBy;
// 					PlayerKillerDamageType = damageType;
// 				}
// 				else
// 				{
					bShellShockKill = false;
//				}

                StartShellShock(Damage, ShellShockTime, bShellShockKill);
			}
			else
			{				
				StartShellShock(Damage, ShellShockTime, bShellShockKill);
				TpHUD(MyController.myHUD).ReticleIndicationUpdate();
			}
		}
		//else
		//{
		//	myCameraShake.RotMag.Z = CameraShake.RotMag.Z * CameraShakeDamage / 100.0f;
		//	myCameraShake.OffsetMag.Z = CameraShake.OffsetMag.Z * CameraShakeDamage / 100.0f;
		//}

		//if (!bShellShockKill && MyController != None)
		//{
		//	MyController.ShakeView(myCameraShake);
		//}
	}
// 	else if (WorldInfo.NetMode == NM_Standalone && Health - Damage <= 0 && !InGodMode())
// 	{
// 		Damage = 0;
// 		Health = 1;
// 		bShellShockKill = true;
// 		StartShellShock(Damage, 0.5f, true, false);
// 		PlayerKiller = instigatedBy;
// 		PlayerKillerDamageType = damageType;
// 	}
	else if (WorldInfo.NetMode == NM_Standalone && damageType == class'TPDamageTypeGrapple')
	{
// BEGIN SPARK CHANGE
		if (!Class'WorldInfo'.Static.IsPS3Build())
// END SPARK CHANGE
			DoMeleeHitEffect();
		index = GetDamageShakeParamIndex(damageType);
        if (index >= 0 && MyController != None)
            MyController.ShakeView(DamageShakeParams[index].ShakeInfo);
	}
    else
    {
        index = GetDamageShakeParamIndex(damageType);
        if (index >= 0 && MyController != None)
            MyController.ShakeView(DamageShakeParams[index].ShakeInfo);
    }
}

exec function DoMeleeHitEffect()
{
	local MaterialEffect MeleeHitEffect;
	local LocalPlayer LP;

	if (MeleeHitPostMIC == None)
	{
		LP = LocalPlayer(PlayerController(Controller).Player);
		MeleeHitEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('HitFX'));
		MeleeHitPostMIC = MaterialInstanceConstant(MeleeHitEffect.Material);
	}

	if (MeleeHitPostMIC != None)
	{
		;
		ClearTimer('UpdateMeleeHitEffect');
		MeleeHitPostMIC.SetScalarParameterValue('hitFX_switcher', 1.0f);
		MeleeHitCurrentTime = 0.0f;
		SetTimer(0.1f, true, 'UpdateMeleeHitEffect');
	}
}

function UpdateMeleeHitEffect()
{
	if (MeleeHitPostMIC != None)
	{
		MeleeHitCurrentTime += 0.1f;
		if (MeleeHitCurrentTime >= MeleeHitTotalTime)
		{
			ClearMeleeHitEffect();
		}
		else
		{
			MeleeHitPostMIC.SetScalarParameterValue('hitFX_switcher', 1.0f - MeleeHitCurrentTime / MeleeHitTotalTime);
		}
	}
}

function ClearMeleeHitEffect()
{
	if (MeleeHitPostMIC != None)
	{
		MeleeHitPostMIC.SetScalarParameterValue('hitFX_switcher', 0.0f);
		ClearTimer('UpdateMeleeHitEffect');
	}
	//ClearTimer('UpdateMeleeHitEffect');
}

// Multiplayer function allowing just in time setting of the instigator for when we assign a new pawn's inventory.
reliable client function ClientSetInstigator()
{
	local Inventory Inv;

	if ( InvManager != None )
	{
		InvManager.Instigator = self;

		for (Inv = InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
		{
			Inv.Instigator = self;
		}
	}
}

function UpdateSprintingRate(float CurrStamina, const float MaxStamina)
{
    local float Percent, Threshold, Func;

    Threshold = 0.4f;
    Percent   = CurrStamina/MaxStamina;
    if (Percent > Threshold)
    {
        anode_WeaponSprinting.Rate = 1.0f;
    }
    else
    {
        Func = 0.3f * (1.0f - (Percent/Threshold));
        anode_WeaponSprinting.Rate = 1.0f - Func;
    }
}


// Note: We are not calling Super(), take into consideration if we ever do anything wacky with non player pawn default inventory.
function AddDefaultInventory()
{
	ClientSetInstigator();
}

function TakeFallingDamage()
{
    if (LastStandingLocation.Z - Location.Z > MinDamageHeight*0.75f && LandSound != None)
        PlaySound(LandSound);

    Super.TakeFallingDamage();
}

function PlaySprintSound()
{
    if (VSize(Velocity) > 1.f && SprintSound != None)
        PlaySound(SprintSound);
}

function PlaySprintSoundTimer(bool Play)
{
    if (Play)
    {
        if (!IsTimerActive('PlaySprintSound'))
            SetTimer(0.5f,true,'PlaySprintSound');
    }
    else
        ClearTimer('PlaySprintSound');
}

function bool DoJump(bool bUpdating)
{
    local bool Jumped;
    // Jump sound done here and not as an AnimNotify since the jump
    // animation used when falling in general
    Jumped = Super.DoJump(bUpdating);

    if (Jumped && JumpSound != None)
        PlaySound(JumpSound);

    // In case player goes from crouch to jump and tries to mantle
    // before standing anim finishes
    if (ToStandInProgress()) // ToStand
	{
        ToStandDone(0);
	}

    return Jumped;
}

reliable client function UpdateDamagePostEffect()
{
	local float DamagePct;
	local MaterialEffect myDamagePost;
	local LocalPlayer LP;
	local PlayerController PC;
	local Bool IsLocal;

	// If the player is on a turret, then he won't have a controller.
	// His vehicle, however, should have the original player controller
	if (Controller == None)
	{
		if (DrivenVehicle != None)
		{
			PC = PlayerController(DrivenVehicle.Controller);
			if (PC != None)
			{
				LP = LocalPlayer(PC.Player);
			}
			IsLocal = DrivenVehicle.IsLocallyControlled();
		}
	}
	else
	{
	    LP = LocalPlayer(PlayerController(Controller).Player);
		IsLocal = IsLocallyControlled();
	}

	if (LP != None && IsLocal)
	{
		if (DamagePostMIC == None)
		{
			myDamagePost = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('DamagePost'));
			DamagePostMIC = MaterialInstanceConstant(myDamagePost.Material);
		}

		//calc the level the post process effect should be at
		DamagePct = Health - 10;
		DamagePct /= (MaxPlayerHealth - 10);
		if (DamagePct < 0.0f)
			DamagePct = 0.0f;

        DamagePostMIC.SetScalarParameterValue('DamagePercent', DamagePct);
	}
}

function bool TakeShieldDamage(int Damage, Controller instigatedBy, Vector hitlocation,
						Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local TPPlayerController tppController;
    local bool bShieldDeath;

    tppController = TPPlayerController(Controller);

    if (vector(Rotation) dot -Normal(momentum) > 0 && tppController.eGrappleAction != GA_ShieldDied)
    {
        Damage *= ShieldDamageMultiplier;

        bShieldDeath = (Damage >= tppController.GrappleOpponent.Health);

        if (bShieldDeath)
        {
            tppController.GrapInt_v2.ShieldHasDied();
        }
        else
        {
            tppController.GrappleOpponent.Health -= Damage;
            tppController.GrapInt_v2.ShieldShotReaction();
        }

        return true;
    }

    return false;
}

event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation,
						Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local vector FromLocation;

	if ( damageType != class'DmgType_Fell' && damageType != class'TPDamageTypeFall' ) // suck it up if you're falling
	{
		// We might be without a controller, but in this case we aren't using a human shield anyway.
		if (Controller != None && Controller.IsInState('PlayerShielding'))
			if (TakeShieldDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser))
				return;

		if (Controller.IsInState('PlayerGrappling_v2'))
			Damage *= GrappleDamageMultiplier;
	}

    // If we are about to die, leave the vehicle
	if (Health - Damage <= 0 && DrivenVehicle != None)
	{
		DrivenVehicle.DriverLeave(false);
	}

	if (instigatedBy != None && instigatedBy.Pawn != None)
        FromLocation = instigatedBy.Pawn.Location;
    else if (DamageCauser != None)
        FromLocation = DamageCauser.Location;

	//we are already dying from the shell shock, so no more damage
	if (bShellShockKillPlayer)
		return;


	// Call the Client Function to do damage effects
	DoDamageEffects(Damage, instigatedBy, Normal(vector(Rotation)), Normal(momentum), FromLocation, damageType);

    if (WorldInfo.TimeSeconds - LastDamageTime > 1.5f)
    {
			
		if (DamageType ==  class'TPDamageTypeGrapple')
		{
			if (MeleeDamageSound != None)
			{
				//`log("PLAY THE MELEE SOUND!!!");
				PlaySound(MeleeDamageSound);
			}
		}
		else if (DamageType == class'TPDamageTypeFire')
		{
			if (FireDamageSound != None)
			{
				//`log("PLAY THE FIRE SOUND!!!");
				PlaySound(FireDamageSound);
			}
		}
		else if (DamageType == class'TPDamageTypeFall')
		{
			if (FallDamageSound != None)
			{
				//`log("PLAY THE FALL SOUND!!!");
				PlaySound(FallDamageSound);
			}
		}
		else if (DamageType == class'DmgType_Fell')
		{
			if (FallDamageSound != None)
			{
				//`log("PLAY THE FELL SOUND!!!");
				PlaySound(FallDamageSound);
			}
		}
		else
		{
			if( DamageSound != None )
			{
				//`log("PLAY THE BULLET SOUND!!!");
				PlaySound(DamageSound);
			}
		}
        LastDamageTime = WorldInfo.TimeSeconds;
    }

 	// do this so slomo death isn't overridden
 	if (WorldInfo.NetMode == NM_Standalone && Health - Damage <= 0 && !InGodMode())
 	{
		//`log(" ChadAI - PLayer Pawn: " @ Self @ "  Is Dying *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

 		Damage = 0;
		bIgnoreForces = true;

		// set the momentum to zero to keep the body from flying around
		momentum.X = 0.0f;
		momentum.Y = 0.0f;
		momentum.Z = 0.0f;

		Mesh.SetBlockRigidBody(true);
		SetCollision(false,true);
		InitRagdoll();
        InvManager.DiscardInventory();
        TPPlayerController(Controller).IgnoreLookInput(true);
		TPPlayerController(Controller).ClearPostMaterials();
		ClearTimer('RegenHealth');
		Mesh.SetRBCollidesWithChannel(RBCC_Default, true);
		Mesh.SetHidden(true);
		
		bShellShockKillPlayer = true;
		PlayerKiller = instigatedBy;
		PlayerKillerDamageType = damageType;
		
		LocalPlayer(TPPlayerController(Controller).Player).ClearPostProcessSettingsOverride();

		WorldInfo.Game.SetGameSpeed(m_FactorToSlowSimTimeWhenPlayerDying);
		PlaySound(DeathSound);
		//SetTimer(0.5f, false, 'DelayedKillPlayer');
		SetTimer(m_HowLongToWaitToPlayDyingEffect, false, 'DelayedKillPlayer');

	    if (DamagePostMIC != None)
		    DamagePostMIC.SetScalarParameterValue('DamagePercent', 0.0f);
 	}


    Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser);

    if ( Health > 0 )
	{
		ClearTimer('StartRegenHealth');
		ClearTimer('RegenHealth');
		SetTimer(HealthRegenIdleTime,, 'StartRegenHealth');
	}


	if (!bShellShockKillPlayer)
		UpdateDamagePostEffect();
}

simulated function DelayedKillPlayer()
{
	//`log(" ChadAI - PLayer Pawn: " @ Self @ "  DelayedKillPlayer *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	WorldInfo.Game.SetGameSpeed(1.0);
	if (DamagePostMIC != None)
		DamagePostMIC.SetScalarParameterValue('DamagePercent', 1.0f);
	Died(PlayerKiller, PlayerKillerDamageType, Location);
}

simulated function UpdateMeshBoneControllers( float DeltaTime )
{
	local TPPlayerController TPC;
	local vector	CamLoc;
	local rotator	CamRot;
	local float fDot;

	local vector vCamDir,vPawnDir;

	if (TPPlayerController(Controller) != None)
	{
		TPC = TPPlayerController(Controller);

		if (TPC.PlayerCamera != none)
		{
			TPC.PlayerCamera.GetCameraViewPoint(CamLoc,CamRot);
			CamRot += TPPlayerCamera(TPC.PlayerCamera).OffsetRotation;

			vPawnDir = vector(Rotation);
			vCamDir = vector(CamRot);

			// Move player into noweapon state
			if(TPC.bIsThirdPerson)
			{
				if(bIsCrouched)
				{
					anode_CrouchWeaponBlend.SetBlendTarget(1.0, 0.2);
				}
				else
				{
					anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
				}
			}
			else
			{
				if(bIsCrouched)
				{
					if (Weapon == none)
						anode_CrouchWeaponBlend.SetBlendTarget(1.0, 0.2);
					else
						anode_CrouchWeaponBlend.SetBlendTarget(0.0, 0.2);
				}
				else
				{
					if (Weapon == none || Controller.IsInState('PlayerClimbing'))
						anode_WeaponBlend.SetBlendTarget(1.0, 0.0);
					else
						anode_WeaponBlend.SetBlendTarget(0.0, 0.0);
				}
			}


			// Crouching Anim Blend
			if(anode_PostureBlend != none)
			{
				// To crouch or not to crouch
				if(bIsCrouched)
				{
					//anode_PostureBlend.SetBlendTarget(1.0, TPC.CrouchBlendTime);
                    //anode_PostureBlend.SetActiveChild(2, TPC.CrouchBlendTime);
				}
				else
					//anode_PostureBlend.SetBlendTarget(0, TPC.CrouchBlendTime);
                    //anode_PostureBlend.SetActiveChild(0, TPC.CrouchBlendTime);

			}


			//if (PlayerCamera.CameraStyle == 'Freecam')
			if (TPC.PlayerCamera.CameraStyle == 'FreeCam' || TPC.PlayerCamera.CameraStyle == 'ThirdPerson')
			{
				//aim node
				AimOffset.X = 0;
				AimOffset.Y = 0;

			//			Pawn.AimOffset.X = vPawnDir.X * vCamDir.Y - vPawnDir.Y * vCamDir.X;
			//			Pawn.AimOffset.Y =  vCamDir.Z;

				// head tracking

				if (!TPC.IsInState('PlayerClimbing') && !TPC.IsInState('PlayerHanging') && Physics != PHYS_Flying)
				{
					fDot = vPawnDir dot vCamDir;
					if (fDot<-0.5)
					{
						skel_HeadTrack.ControlStrength = 1+ (fDot+0.5)*2;
					}
					else
						skel_HeadTrack.ControlStrength = 1;

					skel_HeadTrack.StrengthTarget = skel_HeadTrack.ControlStrength;
					skel_HeadTrack.TargetLocation=CamLoc+1000*vCamDir;
				}
				else
				{
					skel_HeadTrack.StrengthTarget  = 0;
					skel_HeadTrack.ControlStrength = 0;
				}


				skel_SpinePitch.BoneRotation.Pitch = 0;
			}
			else if (TPC.PlayerCamera.CameraStyle == 'FirstPerson')
			{
				// [PETAR] Temporarily commented for L8
			//			anode_AIM_FPS.Aim.Y =  vCamDir.Z;
			//			anode_AIM_FPS.Aim.X =  0;


				//skel_HeadTrack.ControlStrength = 0;
				skel_HeadTrack.StrengthTarget = skel_HeadTrack.ControlStrength;
				skel_HeadTrack.TargetLocation=CamLoc+1000*vCamDir;

				AimOffset.X = 0;
				AimOffset.Y = 0;

				skel_SpinePitch.BoneRotation.Pitch = 0;
				skel_SpineRoll.BoneRotation.Roll   = 0;

				if (!TPC.bDontUseAimOffset)
				{
					if (TPC.Rotation.Pitch <= ViewPitchMax)
						AimOffset.Y = TPC.Rotation.Pitch / ViewPitchMax;
					else
						AimOffset.Y = (65535.0f-TPC.Rotation.Pitch)/ViewPitchMin;
				}

				CamRot.Pitch = 0;
				CamRot.Roll = 0;
			}
            else if (TPC.PlayerCamera.CameraStyle == 'Grapple')
            {
                AimOffset.X = 0;
				AimOffset.Y = 0;

				if (!TPC.bDontUseAimOffset)
				{
					if (TPC.Rotation.Pitch <= ViewPitchMax)
						AimOffset.Y = TPC.Rotation.Pitch / ViewPitchMax;
					else
						AimOffset.Y = (65535.0f-TPC.Rotation.Pitch)/ViewPitchMin;
				}
            }
		}
	}
}

function StartRegenHealth()
{
    RegenHealth();
    SetTimer(HealthRegenTime, true, 'RegenHealth');
}

function RegenHealth()
{
	local	TPPlayerController	theController;
	if( Health <= 0 )
	{
		return;
	}

    Health+=HealthRegenAmount;

	theController = TPPlayerController(Controller);

	if ( (theController != None) && (theController.IsBonusActive(BONUS_DOUBLE_HEALTH_REGEN_RATE) == true) )
	    Health+=HealthRegenAmount;

	if(Health > MaxPlayerHealth)
		Health = MaxPlayerHealth;

	if(!bShellShockKillPlayer)
    {
		UpdateDamagePostEffect();
    }
}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	UpdateMeshBoneControllers(DeltaTime);

	if (bHaveNotResetPost)
	{
		bHaveNotResetPost = false;
		UpdateDamagePostEffect();
	}

	if (bShellShockActive)
	{
		if (ShellShockGameSpeed != 0)
			ShellShockUpdateVolumes(DeltaTime / ShellShockGameSpeed);
	}
}

simulated function ShellShockUpdateVolumes(float DeltaTime)
{
	local int i;

	for (i = 0; i < ShellShockSoundLevels.Length; i++)
	{
		// this means we have a calculated delta we're applying
		if (ShellShockSoundLevels[i].ChangePerSecond < 0.0f)
		{
			ShellShockSoundLevels[i].CurrentVolume += ShellShockSoundLevels[i].ChangePerSecond * DeltaTime;
			PlayerController(Controller).SetAudioGroupVolume(ShellShockSoundLevels[i].Group, ShellShockSoundLevels[i].CurrentVolume);

			// if we're close to the final volume, just go with it and set CPS to 0
			if (abs(ShellShockSoundLevels[i].CurrentVolume - ShellShockSoundLevels[i].ShellShockVolume) < 0.03)
			{
				ShellShockSoundLevels[i].ChangePerSecond = 0;
				PlayerController(Controller).SetAudioGroupVolume(ShellShockSoundLevels[i].Group, ShellShockSoundLevels[i].ShellShockVolume);
				//`log("Setting CPS to 0 for "@ShellShockSoundLevels[i].Group);
			}

			//`log("CurrVolume for "@ShellShockSoundLevels[i].Group@"is"@ShellShockSoundLevels[i].CurrentVolume);
		}
		else if (ShellShockSoundLevels[i].ChangePerSecond > 0.0f)
		{
			ShellShockSoundLevels[i].CurrentVolume += ShellShockSoundLevels[i].ChangePerSecond * DeltaTime;
			PlayerController(Controller).SetAudioGroupVolume(ShellShockSoundLevels[i].Group, ShellShockSoundLevels[i].CurrentVolume);

			//`log("CurrVolume for "@ShellShockSoundLevels[i].Group@"is"@ShellShockSoundLevels[i].CurrentVolume);
		}
		else if (abs(ShellShockTimeLeft - ShellShockSoundLevels[i].EndTime) < 0.05)
		{
			ShellShockSoundLevels[i].ChangePerSecond = ShellShockSoundLevels[i].DefaultVolume - ShellShockSoundLevels[i].ShellShockVolume;
			if (ShellShockSoundLevels[i].EndTime != 0)
				ShellShockSoundLevels[i].ChangePerSecond /= ShellShockSoundLevels[i].EndTime;

			//`log("ChangePerSecond for"@ShellShockSoundLevels[i].Group@"is"@ShellShockSoundLevels[i].ChangePerSecond);
			//`log("Curr volume is"@ShellShockSoundLevels[i].CurrentVolume);
		}
	}

	ShellShockTimeLeft -= DeltaTime;
}

simulated function EnableDistortionEffect(bool enable)
{
    local float ar;
    local vector2d vec;

    LocalPlayer(TPPlayerController(Controller).Player).ViewportClient.GetViewportSize(vec);

    ar = vec.x/vec.y;

    if (ar < 1.5)
    {
        if (DistortionEffect != None)
        {
            DistortionEffect.bShowInGame = enable;
        }
    }
    else
    {
        if (DistortionEffectWide != None)
        {
            DistortionEffectWide.bShowInGame = enable;
        }
    }
}

function SetDistortionEffect()
{
    local LocalPlayer LP;

    LP = LocalPlayer(PlayerController(Controller).Player);

    if (LP != None)
    {
        DistortionEffectWide = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('SniperDistortionWide'));
        DistortionEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('SniperDistortion'));
    }
}

function SetDOFEffect()
{
    local LocalPlayer LP;

    LP = LocalPlayer(PlayerController(Controller).Player);

    if (LP != None)
    {
        Effect = DOFEffect(LP.PlayerPostProcess.FindPostProcessEffect('WeaponDOF'));
    }

    if (Effect != None)
    {
        EffectInfo.FocusInnerRadius  = Effect.FocusInnerRadius;
        EffectInfo.FocusDistance     = Effect.FocusDistance;
        EffectInfo.FalloffExponent   = Effect.FalloffExponent;
        EffectInfo.BlurKernelSize    = Effect.BlurKernelSize;
        EffectInfo.MaxNearBlurAmount = Effect.MaxNearBlurAmount;
        EffectInfo.MaxFarBlurAmount  = Effect.MaxFarBlurAmount;
    }
    else
    {
        ;
    }
}

function SetDOFParameters(bool Set, float AimDownFocusInnerRadius, float AimDownFalloffExponent,
                         float AimDownBlurKernelSize)
{
    if (Effect != None)
    {
        if (Set)
        {
            Effect.FocusInnerRadius  = AimDownFocusInnerRadius;
            Effect.FalloffExponent   = AimDownFalloffExponent;
            Effect.BlurKernelSize    = AimDownBlurKernelSize;
            Effect.MaxNearBlurAmount = 0.0;
            Effect.MaxFarBlurAmount  = 1.0;
            Effect.bShowInGame       = true;
            bDofFocus                = true;  // Force initial focus
        }
        else
        {
            Effect.FocusInnerRadius  = EffectInfo.FocusInnerRadius;
            Effect.FocusDistance     = EffectInfo.FocusDistance;
            Effect.FalloffExponent   = EffectInfo.FalloffExponent;
            Effect.BlurKernelSize    = EffectInfo.BlurKernelSize;
            Effect.MaxNearBlurAmount = EffectInfo.MaxNearBlurAmount;
            Effect.MaxFarBlurAmount  = EffectInfo.MaxFarBlurAmount;
            Effect.bShowInGame       = false;
            bDofFocus                = false;
        }
    }
}

function WeaponDOFTick(float DeltaTime)
{
    //local PlayerPawn   Player;
    local vector       Dummy, Pos;
    local rotator      Rot;
    local float        Percent, DistanceLeft;

    if (Effect != None)
    {
        DofTimer      += DeltaTime;
        DofDebugTimer += DeltaTime;

        if (DofTimer > 0.1f)
        {
            DofTimer = 0;
            TPPlayerController(Controller).GetPlayerViewPoint(Pos,Rot);

            //@optimization This exact same thing is done in C++ in ATPHUD::GetCrosshairIFF
            Trace(Effect.FocusPosition, Dummy, Pos + 100000.0*vector(Rot), Pos,,,,TRACEFLAG_Pawns);

            DofTotalTime      = 0;
            DofCurrDistance   = Effect.FocusDistance;
            DofTargetDistance = VSize(Effect.FocusPosition - Pos);
            bDofFocus         = false;

            if (TPGameReplicationInfo(WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWDOFINFO) &&
                DofDebugTimer > 1.0f)
            {
                ;
                //`log ("-<> HitActor             " @ HitActor);
                ;
                ;
                ;

                DofDebugTimer = 0;
            }
        }

        DistanceLeft = DofTargetDistance - DofCurrDistance;

        DofTotalTime += DeltaTime;
        Percent = DofTotalTime/0.2f;
        Percent = FClamp(Percent, 0.0, 1.0);

        Effect.FocusDistance = DofCurrDistance + Percent*DistanceLeft;
    }
}

simulated function ResetUnequipAnimRate()
{
    if (anode_WeaponUnequipStand != None)
        anode_WeaponUnequipStand.Rate = DefaultUnequipStandRate;

    if (anode_WeaponUnequipCrouch != None)
        anode_WeaponUnequipCrouch.Rate = DefaultUnequipCrouchRate;
}

simulated function SetUnequipAnimRate(float RateMultiplier)
{
    if (anode_WeaponUnequipStand != None)
        anode_WeaponUnequipStand.Rate *= RateMultiplier;

    if (anode_WeaponUnequipCrouch != None)
        anode_WeaponUnequipCrouch.Rate *= RateMultiplier;
}

event bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	//`log(" ChadAI - PLayer Pawn: " @ Self @ "  Died *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

    EnableDistortionEffect(false);
    EnableDistortionEffect(false);
    SetDOFParameters(false, 0, 0, 0);
    TpHUD(TPPlayerController(Controller).myHUD).bDrawSniperView=false;
	LocalPlayer(TPPlayerController(Controller).Player).ClearPostProcessSettingsOverride();
	TPPlayerController(Controller).ClearPostMaterials();

    if (TPWeapon(Weapon) != None && TPWeapon(Weapon).IsAimDownSight()) //SPLITSCRIPTS_TODO
    {
        TPWeapon(Weapon).ToggleAimDownSight(TPPlayerController(Controller));
    }

    return Super.Died (Killer, damageType, HitLocation);
}

// Over-writes the default PlayDying, eliminating the call to start falling which causes a levitating t-pose.
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	//`log(" ChadAI - PLayer Pawn: " @ Self @ "  PlayDying WorldInfo.NetMode: " @ WorldInfo.NetMode @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	if (WorldInfo.NetMode == NM_Standalone)
	{
		GotoState('Dying');
		bReplicateMovement = false;
		bTearOff = true;
		Velocity += TearOffMomentum;
		bPlayedDeath = true;
	}
	else
	{
		EnableDistortionEffect(false);

		super.PlayDying(DamageType, HitLoc);
	}
}

State Dying
{

	//SPMIRROR - overriding BeginState to eliminate destroy timer, just destroy right away.
	function BeginState(Name PreviousStateName)
	{
		local int i;
		local TPPlayerController tPC;
		//`log(" ChadAI - PLayer Pawn: " @ Self @ "  State Dying BeginState *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		tPC = TPPlayerController(Controller);

		if ( Controller != None )
		{
			tPC.StopViewShaking();

			if ( WorldInfo.NetMode != NM_Standalone )
			{
				// Toss all weapons
				while ( Weapon != None && InvManager != None )
					TossWeapon(Weapon);

				// Set up death cam.
				tPC.ClientSetCameraMode('DeathCam');
				tPC.InitDeathCam();

			}

			if (WorldInfo.NetMode == NM_Standalone)
			{
				// Fire up the lose screen
				tPC.GotoLoseScreen();
			}
			else
			{
				if ( tPC.bIsPlayer )
				{
					tPC.PawnDied(self);
					CopyCoverInfo();
					DetachFromController();
				}
				else
				{
					tPC.Destroy();
				}
			}
			for (i = 0; i < Attached.length; i++)
				if (Attached[i] != None)
					Attached[i].PawnBaseDied();
		}

	}

Begin:

	//`log(" ChadAI - PLayer Pawn: " @ Self @ "  State Dying: Begin *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

    if(FreezeTime > 0)
    {
        Sleep(FreezeTime);

        Mesh.bUpdateKinematicBonesFromAnimation=false;
	    Mesh.bUpdateJointsFromAnimation=false;

        SetPhysics(PHYS_None);
    }

    Sleep(DestroyTime - FreezeTime);

}

simulated function WeaponFired( bool bViaReplication, optional vector HitLocation )
{
//	if( TPPlayerController(Controller).PlayerCamera.CameraStyle == 'FirstPerson' )
//	{
//		WeaponBlend_FPS.AnimFire( '', false); //this is just setting the firenode into "Firing" state
//	}
//	else
//	{
//		WeaponBlend.AnimFire( '', false); //this is just setting the firenode into "Firing" state
//	}

	super.WeaponFired(bViaReplication, HitLocation);

	if (CurrentWeaponAttachment != None)
	{
		if ( !IsFirstPerson() )
			CurrentWeaponAttachment.WeaponFireEffects(HitLocation);

		if ( HitLocation != Vect(0,0,0) && bViaReplication )
		{
			CurrentWeaponAttachment.SpawnHitEffects(HitLocation);
		}
	}
	//CurrentWeaponAttachment.PendingFire(0);
}

simulated function WeaponStoppedFiring( bool bViaReplication )
{
    super.WeaponStoppedFiring(bViaReplication);

	if (CurrentWeaponAttachment != None)
	{
		CurrentWeaponAttachment.StopFireEffects();
	}
}

simulated function ToCrouchDone()
{
	PostureIndex = 3;
	anode_PostureBlend.SetActiveChild(3, 0.2);
    if (Weapon != None)
        TPWeapon(Weapon).ChangePostureDone();

    //TPPlayerController(Controller).DefaultFOV = TPPlayerController(Controller).CrouchFOV;
}

simulated function ToStandDone(optional float BlendTime = 0.2)
{
	PostureIndex = 0;
    anode_PostureBlend.SetActiveChild(0, BlendTime);
    if (Weapon != None)
        TPWeapon(Weapon).ChangePostureDone();

    //TPPlayerController(Controller).DefaultFOV = TPPlayerController(Controller).default.DefaultFOV;
}

simulated function bool ToStandInProgress()
{
    return anode_PostureBlend.ActiveChildIndex == 2;
}

exec function ChangePosture()
{
    local TPPlayerController tppController;

    tppController = TPPlayerController(Controller);

    if (tppController.IsInState('PlayerWalking') && !tppController.IsMoveInputIgnored() &&
        !tppController.bSprint && !bInPostureVolume)
    {
		tppController.FadeInHUD();
		ChangePostureInternal();
    }
}

simulated function ChangePostureInternal()
{
    Super(TPPawn).ChangePosture();
}

function bool PrePokeActor(vector PokeDir)
{
    // Do nothing for player
    return false;
}

function SetUniform( eUniform newUniform )
{

























}

//simulated function TossWeapon(Vector TossVel)
simulated function TossWeapon(Weapon Weap, optional vector TossVel)
{
	//Bypass the tppawn version, which sets up random ammo in the weapon
	super(Pawn).TossWeapon(Weap, TossVel);
}



function OnPlaySceneAnimation(SeqAct_PlaySceneAnimation action)
{
	super.OnPlaySceneAnimation(action);

	TPPlayerController(Controller).WaitForSceneFinish();
}

function OnEndSceneAnimation(SeqAct_EndSceneAnimation action)
{
	super.OnEndSceneAnimation(action);

	TPPlayerController(Controller).SceneFinished();
}

native function TemporarilyBlindPlayer(float Angle);
// {
// 	if (!bPlayerBlinded)
// 	{
// 		//`log("BLINDING PLAYER!");
// 		bPlayerBlinded = true;
// 		BlindAngle = Angle;
// 		if (TPPlayerController(Controller).bGogglesEnabled)
// 		{
// 			ApplyBlindEffect();
// 		}
// 		SetTimer(2.0f, false, 'FinishBlind');
// 	}
// }

native function ApplyBlindEffect();
// {
// 	LocalPlayer(TPPlayerController(Controller).Player).OverridePostProcessSettings(BlindPostSettings, 1.0f);
// }

event FinishBlind()
{
	//`log("BLIND FINISHED!");
	bPlayerBlinded = false;
	LocalPlayer(TPPlayerController(Controller).Player).ClearPostProcessSettingsOverride();
}

simulated function StartGoggleSound()
{
	if (!GoggleEffectAudio.bWasPlaying)
		GoggleEffectAudio.Play();
}

event TPPawn GetEnemyToPlayFFXOn()
{
	local	float			radius;
	local	vector			PlayerToEnemy;
	local	float			currDist;
	local	float			bestDist;
    local	WehrmachtPawn	currPawn;
    local	WehrmachtPawn	bestPawn;

	radius = 10000;

	bestDist	= radius;
	bestPawn	= None;

	ForEach VisibleActors( class'WehrmachtPawn', currPawn, radius )
    {
		// Ensure that the pawn isn't without a controller (e.g. when manning a turret)
		if ( currPawn.Controller == None )
			continue;

		if ( currPawn.Health <= 0 )
			continue;

		PlayerToEnemy = currPawn.Location - Location;

		currDist = VSize(PlayerToEnemy);

		if ( currDist < bestDist )
		{
			bestDist	= currDist;
			bestPawn	= currPawn;
		}
	}

	return ( bestPawn );
}

