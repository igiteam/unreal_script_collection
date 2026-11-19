/**
 * Base class for COG character AI in the Campaign
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_COGGear extends GearAI_Cover
	native(AI);

/** GoW global macros */

/** Player that will act as a default tether */
var GearPC Player;

var float CurBumpVal;
var() float BumpThreshold;
var() float BumpDecayRate;
var() float BumpGrowthRate;

var bool    bBumpedThisFrame;

var GearPawn LastBumper;


function class<AICommand> GetDefaultCommand()
{
	if( GearPawn_LocustMomCorpserBase(Enemy) != None )
	{
		return class'AICmd_Base_CoverAI_vsMomCorpser';
	}
	else if( GearPawn_LocustBerserkerBase(Enemy) != None )
	{
		return class'AICmd_Base_CoverAI_vsBerserker';
	}
	else if ( GearPawn_LocustTempestBase(Enemy) != None )
	{
		return class'AICmd_Base_CoverAI_vsTempest';
	}

	return Super.GetDefaultCommand();
}


function ReceiveChargeTargetWarning(Pawn Shooter)
{
	// if we're looking in that direction and skilled enough, try to evade
	if ((Enemy == Shooter || vector(Pawn.Rotation) dot Normal(Shooter.Location - Pawn.Location) > 0.7) && CanEvade(true))
	{
		DoEvade(GetBestEvadeDir(Shooter.Location, Shooter), true);
	}
}

function bool CanTeleportToFriendlyOnPathFailure()
{
	return true;
}

function CachePlayer()
{
	foreach WorldInfo.AllControllers(class'GearPC', Player)
	{
		break;
	}
}

function bool WantsInfiniteAmmoFor(GearWeapon Wpn)
{
	// only for assault rifles, but regenerate ammo for others when out of combat
	return (Wpn.IsA('GearWeap_AssaultRifle') || Wpn.IsA('GearWeap_LocustAssaultRifle') || Wpn.IsA('GearWeap_RetroLancer'));
}

function SetIsInCombat()
{
	local bool bWasInCombat;
	local GearWeapon W;

	if (MyGearPawn != None)
	{
		bWasInCombat = MyGearPawn.bIsInCombat;
		Super.SetIsInCombat();
		if (bWasInCombat && !MyGearPawn.bIsInCombat)
		{
			// restore ammo when exiting combat since AI don't take ammo boxes
			foreach MyGearPawn.InvManager.InventoryActors(class'GearWeapon', W)
			{
				W.SpareAmmoCount = W.InitialMagazines * W.WeaponMagSize;
				W.AmmoUsedCount = 0;
			}
		}
	}
}

function bool AttemptToTeleportToFriendly()
{
	local bool bTeleported;
	local Vector ResPos;
	local NavigationPoint ResNav;

	`AILog(GetFuncname());

	//ScriptTrace();
	Pawn.SetAnchor(None);
	// first try to teleport to squad
	if( Squad != None )
	{
		ResPos = GetSquadPosition();
		if( !IsZero(ResPos) )
		{
			bTeleported = TeleportToLocation(ResPos,Pawn.Rotation);
		}
	}
	// attempt to teleport to the player if we failed to join squad
	if (!bTeleported)
	{
		CachePlayer();
		if (Player != None && (Squad == None || GetSquadLeader() == Player))
		{
			if (!Player.FindAvailableTeleportSpot(Pawn))
			{
				ResNav = class'NavigationPoint'.static.GetNearestNavToActor(Player.Pawn,,,256.f);
				if(ResNav != none)
				{
					bTeleported = TeleportToLocation(ResNav.Location,Pawn.Rotation);
				}
			}
			else
			{
				bTeleported = TRUE;
			}
			if (bTeleported)
			{
				WorldInfo.Game.Broadcast(self,self@"was stuck off the path network, teleported to player:"@Player);
			}
		}
	}
	return bTeleported || Super.AttemptToTeleportToFriendly();
}

event CurrentLevelUnloaded()
{
	`AILog("Current level unloaded");
	if (HasValidBase())
	{
		`AILog(" - not destroying because we found a valid base");
	}
	else
	{
		CachePlayer();
		if (Player != None && Pawn != None)
		{
			`Warn(self@"teleporting to player because level was unloaded");
			UnClaimCover();
			if (!Player.FindAvailableTeleportSpot(Pawn))
			{
				Pawn.SetLocation(class'NavigationPoint'.static.GetNearestNavToActor(Player.Pawn,,,256.f).Location);
			}
			Pawn.SetAnchor(None);
//			TransitionTo(None);
		}
		else
		{
			`Warn(self@"no friendly player?");
			Super.CurrentLevelUnloaded();
		}
	}
}

function OnDriveBrumak(SeqAct_DriveBrumak InAction)
{
	local GearPawn_LocustBrumakBase Brumak;
	local Pawn OldPawn;

	NotifyDidSomethingInteresting();
	Brumak = GearPawn_LocustBrumakBase(InAction.BrumakPawn);
	if (MyGearPawn != None && Brumak != None)
	{
		if (InAction.InputLinks[0].bHasImpulse)
		{
			Brumak.SetGunner(MyGearPawn, 0);
			DefaultCommand = class'AICmd_Base_DomAsBrumakGunner';
		}
		else if (InAction.InputLinks[1].bHasImpulse)
		{
			OldPawn = Brumak.LeftGunPawn;
			Brumak.SetGunner( None, 0 );

			if (InAction.DismountDest.length > 0 && InAction.DismountDest[0] != None)
			{
				OldPawn.SetLocation(InAction.DismountDest[0].Location);
			}
			OldPawn.DropToGround();
			OldPawn.SetCollision(true, true, false);
		}
	}
}

// returns true if the pawn bumping into us would even have space to go somewhere if we weren't here
native function bool BumperSomewhereToGo();

simulated function Tick(FLOAT DeltaTime)
{
	local float delta;
	Super.Tick(DeltaTime);


	if(Role == ROLE_Authority)
	{
		//decay bump val
		if(bBumpedThisFrame)
		{
			delta = fMax(0.1,abs(BumpThreshold - CurBumpVal));
			CurBumpVal = FInterpTo(CurBumpVal,BumpThreshold*1.01f,DeltaTime,BumpGrowthRate/delta);
			if(CurBumpVal > BumpThreshold)
			{
				// if the bumping pawn has somewhere to go if we are not here, then disable our collision and let him pass
				if(BumperSomewhereToGo())
				{
					//MessagePlayer(GetFuncname()@"HIT THRESHOLD! TURNING OFF COLLISION ZOMG");
					DisableCollision();
				}
				else // otherwise reset counter
				{
					CurBumpVal /= 2.0f;
				}
			}
		}
		else
		{
			if(CurBumpVal > 0.01)
			{
				CurBumpVal = FInterpTo(CurBumpVal,0.f,DeltaTime,BumpDecayRate/fMax(CurBumpVal,0.1));
			}
			else
			{
				RestoreCollision();
			}

		}
		bBumpedThisFrame=false;
	}

}

function DisableCollision()
{
	if(MyGearPawn != None)
	{
		MyGearPawn.SetCollision(,FALSE);
	}
}
function RestoreCollision()
{
	if(MyGearPawn != None)
	{
		MyGearPawn.SetCollision(,TRUE);
	}
}

function bool NotifyBump( Actor Other, vector HitNormal )
{
	local GearPawn GP;

	GP = GearPawn(other);
	if(GP != none && GP.IsHumanControlled() && !IsZero(GP.Acceleration) && InterpActor_GearBasePlatform(GP.Base) == none)
	{
		bBumpedThisFrame=true;
		LastBumper = GP;
		//MessagePlayer(GetFuncname()@"BUMP! -"@CurBumpVal);
	}

	return Super.NotifyBump(Other,HitNormal);
}

function float GetBaseEnemyRating(Pawn EnemyP, float Distance)
{
	local GearPC PC;
	local float Result;

	Result = Super.GetBaseEnemyRating(EnemyP, Distance);

	// prioritize targets our human allies are shooting at for more focus fire
	PC = GearPC(GetSquadLeader());
	if ( (PC != None && (PC.Enemy == EnemyP || PC.ShotTarget == EnemyP)) ||
		(PlayerController(EnemyP.LastHitBy) != None && WorldInfo.GRI.OnSameTeam(EnemyP.LastHitBy, self)) )
	{
		Result += 1.0;
	}

	return Result;
}

function float AboutToFireFromOpen()
{
	local float Result;

	Result = Super.AboutToFireFromOpen();
	// friendly AI in campaign wait less when throwing grenades
	if (MyGearPawn != None && GearWeap_GrenadeBase(MyGearPawn.MyGearWeapon) != None)
	{
		Result *= 0.5;
	}
	return Result;
}

defaultproperties
{
	// Gears can shoot at anyone they'd like
	bUseFireTickets=FALSE

	DefaultReactConditionClasses.Add(class'AIReactCond_EnemyAttack')

	// friendlies don't ditch cover from damage
	DefaultReactConditionClasses.Remove(class'AIReactCond_DmgLeaveCover')


	BumpThreshold=10.f
	BumpDecayRate=2.0f
	BumpGrowthRate=3.0f
}
