//-----------------------------------------------------------
//  ??Pawn???
//-----------------------------------------------------------
class HDBasePawn extends GamePawn
	config(TGPawn)
	native;

/** Cached bIsInCombat flag set by the server via GearPC.IsInCombat() */
var bool bIsInCombat;

var() config array<Name> HeadBoneNames;

/** Actor we are forced to be based on unless teleported. This is a hack to keep the Pawn on certain movers (e.g. Derrick)
 * that the physics will occasionally insist we should detach from.
 */
var Actor ClampedBase;

// FIRE TICKET VARIABLES
/** Number of fire tickets allowed for this pawn -- -1 == Infinite */
/** CALL SetNumberOfFireTickets TO CHANGE */
var config int		NumFireTickets;
/** Claimed fire tickets for this pawn */
var array<Controller> FireTickets;

//Health
var bool bHealthIsRecharging;
/** Configurable health setting */
var() config int DefaultHealth;
/** Float value of health to handle deltatime being too small for insane difficulty settings */
var transient float RechargingHealthAmount;
/** Delay before health starts recharging */
var() config float HealthRechargeDelay;
/** Amount of recharge per second */
var() config float HealthRechargePercentPerSecond;

replication
{
	if( Role == Role_Authority )
		bIsInCombat, DefaultHealth;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Initial setup of fire tickets
	SetNumberOfFireTickets( NumFireTickets );
}

function bool ConfineToClampedBase()
{
	local InterpActor_GearBasePlatform PlatBase;

	// If no longer on our clamped base
	if( ClampedBase != None && Base != ClampedBase )
	{
		PlatBase = InterpActor_GearBasePlatform(Base);

// 		`DLog("Base:" @ Base @ "ClampedBase:" @ ClampedBase @ "Base.Base:" @ Base.Base @ "ClampedBase.Base:" @ ClampedBase.Base @ "PlatBase:" @ PlatBase);

		// If not moving onto another platform OR
		// If not moving onto a platform that is our current platforms base or shares a base (used for torture barges)
		if( PlatBase == None ||
			PlatBase.bAlwaysConfineToClampedBase ||
			( PlatBase.Base != None &&
			  PlatBase.Base != ClampedBase &&
			  PlatBase.Base != ClampedBase.Base ) )
		{
			// Confine the pawn to our original clamped platform
			return TRUE;
		}
	}
	return FALSE;
}

function OnChangeCollisionSize(HDSeqAct_ChangeCollisionSize Action)
{
    local float CollisionRadius, CollisionHeight;

    CollisionRadius = (Action.CollisionRadius >= 1.f) ? Action.CollisionRadius : CylinderComponent.default.CollisionRadius;
    CollisionHeight = (Action.CollisionHeight >= 1.f) ? Action.CollisionHeight : CylinderComponent.default.CollisionHeight;

    SetCollisionSize(CollisionRadius, CollisionHeight);
}

/** Ask for a fire ticket for the target */
final function bool ClaimFireTicket( Controller inClaimer, optional bool bClaimAll, optional bool bTest )
{
	local int Idx, Num;
	local bool bResult;

	if(NumFireTickets < 0)
	{
		return TRUE;
	}

	// If not claiming all
	if( !bClaimAll )
	{
		// Check to see if we already have a ticket
		Idx = FireTickets.Find( inClaimer );
		if( Idx >= 0 )
		{
			return TRUE;
		}
	}

	Num = FireTickets.Length;
	for( Idx = 0; Idx < Num; Idx++ )
	{
		if( bClaimAll ||
			FireTickets[Idx] == None || FireTickets[Idx].bDeleteMe || FireTickets[Idx].IsInState('Dead') )
		{
			if( !bTest )
			{
				FireTickets[Idx] = inClaimer;
			}

			bResult = TRUE;

			if( !bClaimAll )
			{
				break;
			}
		}
	}

	return bResult;
}

/** Release all of ticket claims for given controller */
final function bool ReleaseFireTicket( Controller inReleaser )
{
	local int Idx, Num;
	local bool bResult;

	Num = FireTickets.Length;
	for( Idx = 0; Idx < Num; Idx++ )
	{
		if( FireTickets[Idx] == inReleaser )
		{
			FireTickets[Idx] = None;
			bResult = TRUE;
		}
	}

	return bResult;
}

/** Updates the number of available fire tickets */
final function SetNumberOfFireTickets( int inNum )
{
	NumFireTickets = inNum;
	FireTickets.Length = Max(0,NumFireTickets);
}

function OnGiveAmmo(HDSeqAct_GiveAmmo Action)
{
   local Weapon W;
   local HDWeapon HW;
   local HDWeapon_AirAttack AAW;

   W = Weapon( FindInventoryType(Action.WeaponType) );
   if(W != none)
   {
		W.AddAmmo(Action.Ammo);

		HW = HDWeapon(W);
		if(HW != none)
		{
		    if( Action.Clips != -1 )
			    HW.ClipBulletCount[0] = Action.Clips;

			AAW = HDWeapon_AirAttack(W);
			if(AAW != none)
			    AAW.DelayTime = Action.AirAttackDelayTime;
        }
   }
}

simulated event PlayCrouchedFootStepSound( int FootDown )
{
//	local float Loudness;
	local PlayerController PC;

//	if( Role == ROLE_Authority )
//	{
//		// Noise loudness based on movement speed
//		Loudness = (VSize(Velocity) / GroundSpeed);
//		MakeNoise( Loudness*Loudness*Loudness, 'NOISETYPE_FootStep' );
//	}

	// for each local player we want to see if they are relevant for hearing footsteps and seeing particle effects
	foreach LocalPlayerControllers( class'PlayerController', PC )
	{
		// 300.0f is from the SoundCue DiststanceCrossFade/Attenuation node
		if( (PC.ViewTarget != None) && (VSize(PC.ViewTarget.Location - Location) < 1000.0f) )
		{
			//`log( (VSize(PC.ViewTarget.Location - Location) ));
			ActuallyPlayFootstepSound( FootDown );
			break; // only place this once please :)
		}
	}
}

simulated event PlayFootStepSound( int FootDown )
{
	local float Loudness;
	local PlayerController PC;

	if( Role == ROLE_Authority )
	{
		// Noise loudness based on movement speed
		Loudness = (VSize(Velocity) / GroundSpeed);
		MakeNoise( Loudness*Loudness*Loudness, 'NOISETYPE_FootStep' );
	}

	// for each local player we want to see if they are relevant for hearing footsteps and seeing particle effects
	foreach LocalPlayerControllers( class'PlayerController', PC )
	{
		// 300.0f is from the SoundCue DiststanceCrossFade/Attenuation node
		if( (PC.ViewTarget != None) && (VSize(PC.ViewTarget.Location - Location) < 1000.0f) )
		{
			//`log("actuallyPlayFootStepSound");
			ActuallyPlayFootstepSound( FootDown );
			break; // only place this once please :)
		}
	}
}

simulated function ActuallyPlayFootstepSound( int FootDown );

function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
   	local HDMapInfo HDMap;

 	HDMap = HDMapInfo(WorldInfo.GetMapInfo());
 	if(HDMap != none)
 	{
 	    HDMap.TeamPawn.RemoveItem(self);  //if any
	}

    return Super.Died(Killer, damageType, HitLocation);
}

final function OnModifyHealthRC(HDSeqAct_ModifyHealthRC Action)
{
    if(Action.DefaultHealth > 0)
    {
        DefaultHealth = Action.DefaultHealth;
        Health = DefaultHealth;
    }

    if(Action.HealthMax != HealthMax && Action.HealthMax > 0 && Action.HealthMax >= Action.DefaultHealth)
    {
        HealthMax = Action.HealthMax;
        if(Health > HealthMax)
            Health = HealthMax;
    }

    if(Action.HealthRechargePercentPerSecond >= 0.0)
        HealthRechargePercentPerSecond = Action.HealthRechargePercentPerSecond;

    if(Action.HealthRechargeDelay >= 0.0)
        HealthRechargeDelay = Action.HealthRechargeDelay;
}

/** Stops any current recharge and resets the timer */
final function ResetHealthRecharge()
{
	bHealthIsRecharging = FALSE;
	SetTimer( HealthRechargeDelay,FALSE,nameof(EnableHealthRecharge) );
}

/** Allows health recharging to kick in */
final function EnableHealthRecharge()
{
	if ( !IsInState('Dying') && Health > 0 )
	{
		bHealthIsRecharging = TRUE;
		RechargingHealthAmount = Health;
	}
}

/**
 * Returns location to use when testing if this pawn was hit by a melee attack.  Useful to override, e.g., for
 * small creatures close to the ground.
 */
simulated function vector GetMeleeHitTestLocation()
{
	return Location;
}

simulated function vector GetMeleePos()
{
	return GetPawnViewLocation();
}

