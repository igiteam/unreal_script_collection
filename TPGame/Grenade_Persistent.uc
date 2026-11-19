
class Grenade_Persistent extends TPWeapon
	hidedropdown
	native;

var PhysicsGrenade PhyGrenade;
var bool bOverHandThrown;					// If it is overhand thrown or not
var bool bHoldingFire;						// Are we holding fire still?
var bool bThrewGrenade;						// Did we throw grenade?
var float ButtonHeldTime;					// Time we held the button

var config float CookTime;					// How much time before the grenade blows up
var config vector TossForce;				// How much force to apply to grenade when it is tossed
var config vector ThrowForce;				// How much force to apply to grenade when it is thrown overhandded.
var config vector CrouchTossForce;			// how much force to apply when crouched
var config float ImpulseForce;				// How much force to apply to nearby objects
var config float AffectedRadius;			// What radius the zone effects
var config float DamageCaused;				// How much damage does this do.
var config float DamageCaused_AI;   		// How much damage does this do if an AI tosses it.
var config bool bExplodeOnImpact;			// Should this grenade explode upon rigid body collision?
var config float TransitionRateMultiplier;

var bool bPawnWasCrouched;					// Was I crouched before I threw.

var config float TossTimer;					// How much time before changing to overhand 

var float ActualCookTime;

struct native sClientGrenadeInfo
{
	var  vector grenadeLocation;
	var rotator grenadeRotation;
	var bool isCrouched;
};

var sClientGrenadeInfo clientGrenadeInfo;

//var vector clientLocation;

simulated function float GetSpread()
{
	return 0.0;
}

// Dont Use AIMDownSight
simulated function ToggleAimDownSight(TPPlayerController TPController)
{
}

// Dont Update Recoil
simulated function UpdateRecoil (float DeltaTime)
{
}

simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	if( PlayerPawn( Owner ) != None)
	{
		//Weapon is held by a player.
		//Note this may not be the correct way to determine this in multiplayer!
		bIsNPCWeapon = false;

		bInfiniteAmmo = false;

	}
	else
	{
		bIsNPCWeapon = true;

		bInfiniteAmmo = true;
	}

	MeshCpnt.AttachComponentToSocket(Mesh, 'Grenade');

	AttachMuzzleFlash();

	 // Spawn the 3rd Person Attachment
	if (Role==ROLE_Authority && TPPawn(Instigator) != None)
	{
		TPPawn(Instigator).CurrentWeaponAttachmentClass = AttachmentClass;
		if ( Instigator.IsLocallyControlled() || WorldInfo.NetMode == NM_ListenServer )
		{
			TPPawn(Instigator).WeaponAttachmentChanged();
		}
	}
}

reliable client function OutofAmmo()
{
	// Do Nothing
}

simulated event PlayReload(optional bool bFinished = false)
{
    // Do nothing
}

/*********************************************************************************************
 * State Active
 * This state means the weapon is equipped and about to be fired.
 * For grenades, in most cases the active state will be extremely brief, as once the grenade
 * has been fired, it will be switched to the inactive state and swapped out with another weapon.
 *********************************************************************************************/

simulated state Active
{
	simulated function BeginState( Name PreviousStateName )
	{
		//We need to set this mesh to visible, because in the grenade throw
		//behavior, we hide the mesh. If we don't set it visible here, the explosion
		//for this grenade will never go off.
		Mesh.SetHidden(false);
		super.BeginState(PreviousStateName);
		//`log("Active Begin Called");
	}
	simulated function StartFire( byte FireModeNum )
	{
		//`log("Calling StartFire setting ActualCookTime to"@ActualCookTime);
		SetActualCookTime(ActualCookTime);
		//`log("Active Start Fire Called");
		Super.StartFire(FireModeNum);
	}
}

/*********************************************************************************************
 * State Inactive
 * Default state for a weapon. It is not active, cannot fire and resides in player inventory.
 *********************************************************************************************/

auto state Inactive
{
	/**
	 * Clear out the PendingFires
	 */

	simulated function BeginState( Name PreviousStateName )
	{
		local TPPlayerController TPC;
		
		// Make sure all pending fires are cleared
		ForceEndFire();

		if (Owner != none)
		{
			TPC = TPPlayerController(Pawn(Owner).Controller);
			
			if (TPC != None )
			{
				// Switch to the previous weapon we held before firing our grenade.
				if (TPC.PrevWeaponOnGrenade != none)
				{
					Instigator.InvManager.SetCurrentWeapon(TPC.PrevWeaponOnGrenade);
				}
				// If there wasn't one, then just pick SOME weapon...
				else
					Instigator.InvManager.SwitchToBestWeapon();

				// Clear our PrevWeaponOnGrenade, since we have now set our current weapon to it.
				TPPlayerController(Instigator.Controller).PrevWeaponOnGrenade = none;

				// If we have no ammo.
				if ( Empty() )
				{
					// Remove ourselves from the inventory
					Instigator.InvManager.RemoveFromInventory(self);
				}
			
			}
		}
	}

	simulated function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
	}

	reliable server function ServerStartFire( byte FireModeNum )
	{

		;
		;

		if (Instigator != none && Instigator.Weapon == self)	// We haven't received the activate yet so pass it along
		{
			;
			GotoState('Active');
			Global.ServerStartFire(FireModeNum);
		}
		else if (InvManager != none && InvManager.PendingWeapon == self)
		{
			;
			;
			;
			InvManager.ChangedWeapon();
			SetPendingFire(FireModeNum);
		}
		else
		{
			;

			// Have the client switch to the current weapon

			InvManager.ClientSyncWeapon(Instigator.Weapon);
		}
	}

	reliable server function ServerStopFire( byte FireModeNum )
	{
		ClearPendingFire(FireModeNum);
	}

	/** do not allow firing in the inactive state */
	simulated function StartFire( byte FireModeNum )
	{
		;
	}

	/** can't put down an inactive weapon */
	simulated function bool TryPutDown()
	{
		return FALSE;
	}
}

simulated state Reloading
{
	simulated function BeginState( Name PreviousStateName )
	{
		local int AmountToReload;

		if(AmmoCount > 0)
		{
			//`log("Starting reload animation!");
			TimeWeaponReload();

			// Find how much ammo is needed if there is still ammo in the magazine

			AmountToReload = MagazineSize - AmmoInMagazine;

            if (AmountToReload <= AmmoCount)
            {
                AmmoInMagazine += AmountToReload;

                if( !bInfiniteAmmo )
					AmmoCount -= AmountToReload;
            }
            else
            {
                AmmoInMagazine += AmmoCount;

				if( !bInfiniteAmmo )
					AmmoCount = 0;
            }
			PutDownWeapon();


		}
		else
		{
			//when would this happpen?
			GotoState('Inactive');
		}
	}

	simulated function EndState(Name NextStateName)
	{
		//if (bPawnWasCrouched)
		//	Pawn(Owner).ShouldCrouch(true);
		//Mesh.SetHidden(false);
		ClearTimer('WeaponReloaded');
	}

	simulated function WeaponReloaded()
	{
		local Weapon weap;

		weap = TPPlayerController(Pawn(Owner).Controller).PrevWeaponOnGrenade;
		if ( weap != none && weap != self)
		{
			//`log("WeaponReloaded() - Valid weapon on grenade -" @ weap);
			GotoState('Inactive');
		}
		else
		{
			//`log("WeaponReloaded() - !!!Invalid weapon on grenade -" @ weap);
			weap = none;
			GotoState('Inactive');
			// KMSK - Why would we wan to go to active, we are not firing...
			//GotoState('Active');
		}
	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		//animation has ended
		WeaponReloaded();
	}

}

simulated event GrenadeFire(optional bool AccurateFire)
{
	;
}

reliable server function ServerPlayWeaponFire(optional bool AccurateFire)
{
	;
}

reliable server function FireClientGrenade( vector grenadeLocation, rotator grenadeRotation, bool isCrouched )
{
	clientGrenadeInfo.grenadeLocation	= grenadeLocation;
	clientGrenadeInfo.grenadeRotation	= grenadeRotation;
	clientGrenadeInfo.isCrouched		= isCrouched;
	GotoState('GrenadeThrow');

	PlayWeaponFire(true);
}

simulated state GrenadeThrow
{
	simulated function BeginState( Name PreviousStateName )
	{
		super.BeginState( PreviousStateName );
		PlayFiringAnimation();
		bHoldingFire = true;
		//bOverHandThrown = false;
		bThrewGrenade = false;
		ButtonHeldTime = 0.0;
		IncrementFlashCount();
	}
	simulated function EndState(Name NextStateName)
	{
		ClearFlashCount();
		ButtonHeldTime = 0.0;
		if (Instigator != none && AIController(Instigator.Controller) != None)
		{
			AIController(Instigator.Controller).NotifyWeaponFinishedFiring(self,CurrentFireMode);
		}
	}
	simulated function BeginFire(Byte FireModeNum)
	{
		super.BeginFire(FireModeNum);
		bHoldingFire = true;
	}
	//simulated function Tick(float dt)
	//{
		//if (bHoldingFire)
        //   ButtonHeldTime += dt;

		/*if (Pawn(Owner).Controller.bFire == 0)
			StopFire(0);*/

		//if (ButtonHeldTime > TossTimer)
		//{
		//	bOverHandThrown = true;
		//	bHoldingFire = false;
		//}
	//}
	simulated event bool IsFiring()
	{
		return true;//!bHoldingFire;
	}
	simulated function StopFire( byte FireModeNum )
	{
		super.StopFire(FireModeNum);

		bHoldingFire = false;

		ButtonHeldTime = 0.0;
	}
	simulated event GrenadeFire(optional bool AccurateFire)
	{
		//`log("GrenadeFire()");
		ServerPlayWeaponFire(AccurateFire);
		PlayWeaponFire(AccurateFire);
	}
	reliable server function ServerPlayWeaponFire(optional bool AccurateFire)
	{
		//`log("ServerPlayWeaponFire()");
		PlayWeaponFire(AccurateFire);
	}
	simulated event PlayWeaponFire(optional bool AccurateFire)
	{
		//local vector gren_pos;

		local vector grenade_location;
		local rotator grenade_rotation;
		local bool	 isCrouched;

		if ( WorldInfo.NetMode != NM_Standalone && Role == ROLE_AUTHORITY && !AccurateFire && !Pawn(Owner).IsLocallyControlled())
		{
			/*`log("========================================================");
			`log("Server must wait for client to be ready to throw grenade... Aborting");
			`log("========================================================");
			*/
			return;
		}

		// If we are a client, and we threw this grenade, then inform the server to call this function with our local parameters to ensure lag-free throwing
		if ( WorldInfo.NetMode != NM_Standalone && Role < ROLE_AUTHORITY && Pawn(Owner).IsLocallyControlled() )
		{
			Pawn(Owner).mesh.GetSocketWorldLocationAndRotation('Grenade', grenade_location, grenade_rotation);

			// The player's hand goes outside of the player's collision box during the grenade throw animation
			// In the event there is a wall, or any collision between hand and player, we must move the grenade back to safe distance (player's location)
			if ( false == TPPlayerController(Pawn(Owner).Controller).GrenadeHandCollisionNoHit(Pawn(Owner).Location, grenade_location ) )
			{
				// There is a collision between the hand and the player mesh, so spawn the grenade at the player's location safely
				grenade_location = Pawn(Owner).Location;
				;
				;
			}

			FireClientGrenade( grenade_location,grenade_rotation, PlayerPawn(Owner).bIsCrouched);	// Controller rot not pawn rot, investigate if this causes problems
		}

		if (Mesh.HiddenGame)
			return;

		// Hide the WeaponMesh
		Mesh.SetHidden(true);

		// Kking - Maybe I need to stop sending StartFire messages from the client ONLY for grenades.  I need a 1 way upwards message
		// from the client where I send a state agnostic message to trigger a ServerStartFire() (locally on server) with the correct info (client).
		if (Role == Role_Authority)
		{

			// Misuse of the variable.  When AccurateFire = true, the client bypassed StartFire() in order to send us his grenade's pos and rot
			//if ( AccurateFire )
			if ( !Pawn(Owner).IsLocallyControlled() )	// AccurateFire is same as !Pawn(Owner).IsLocallyControlled()  in this case.
			{
				grenade_location	= clientGrenadeInfo.grenadeLocation;
				grenade_rotation	= clientGrenadeInfo.grenadeRotation;
				isCrouched			= clientGrenadeInfo.isCrouched;
			}
			else
			{
				Pawn(Owner).mesh.GetSocketWorldLocationAndRotation('Grenade', grenade_location, grenade_rotation);
				//grenade_location	= Mesh.GetPosition();	// Need to get socket location instead.
				isCrouched			= Pawn(Owner).bIsCrouched;

				if ( isCrouched )
					grenade_rotation= Mesh.Rotation;
				else
					grenade_rotation= Owner.Rotation;

			// The player's hand goes outside of the player's collision box during the grenade throw animation
			// In the event there is a wall, or any collision between hand and player, we must move the grenade back to safe distance (player's location)
				if ( false == TPPlayerController(Pawn(Owner).Controller).GrenadeHandCollisionNoHit(Pawn(Owner).Location, grenade_location ) )
				{
					// There is a collision between the hand and the player mesh, so spawn the grenade at the player's location safely
					;
					;
					grenade_location = Pawn(Owner).Location;
				}
			}

			PhyGrenade = Spawn(class'PhysicsGrenade',Owner,,grenade_location, grenade_rotation);
			PhyGrenade.controllerOwner = TPPlayerController(Pawn(Owner).Controller);

			//`log("ActualCookTime is"@ActualCookTime);
			// Activate the Physics Grenade
			PhyGrenade.Activate(ActualCookTime, ImpulseForce, AffectedRadius, DamageCaused, bExplodeOnImpact);

			// Change force type by the type of throw
			if (bOverHandThrown)
			{
				PhyGrenade.SkeletalMeshComponent.SetRBRotation(Mesh.Rotation);
				PhyGrenade.SkeletalMeshComponent.SetRBLinearVelocity(ThrowForce >> TPPawn(Owner).Controller.Rotation, true);
				PhyGrenade.SkeletalMeshComponent.SetRBAngularVelocity(vect(0,20,5) >> TPPawn(Owner).Controller.Rotation, true);
			}

			// Decrement the Ammo Count
			FireAmmunition();

			// Because we have grenades and not a grenade launcher, the act of shooting a grenade can reset values.  Storing unlimted
			// grenade mode on the client due to losing this property on weaponequip is necessary to resync the weapon.
			if ( WorldInfo.NetMode == NM_Standalone && TPPlayerController(Pawn(Owner).Controller).bUnlimitedGrenadeMode )
			{
				bInfiniteAmmo = true;
			}
				


			

		}
		bThrewGrenade = true;
	}
	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
        if (PlayerPawn(Owner) != None)
        {
            PlayerPawn(Owner).ResetUnequipAnimRate();
        }

		if (!bThrewGrenade)
		{
			// `log("xxxxxxxxxx Can't end anim without grenade being thrown yet?");
			return;
		}


		// If we have more ammo then reload
		if (AmmoCount > 0)
		{
			// Reload if we need to
			if(!HasAmmo( CurrentFireMode ))
			{
				if( CanReload() && !MagazineFull() )
				{
					GotoState( 'Reloading' );
					return;
				}
			}
		}

		GotoState('InActive');
	}
}

simulated state WeaponPuttingDown
{
	simulated function BeginState(Name PreviousStateName)
	{
		super.BeginState( PreviousStateName );
	}

	simulated function WeaponIsDown()
		{
		bWeaponEquipped=false;
		super.WeaponIsDown();
		TPPlayerController(Pawn(Owner).Controller).PrevWeaponOnGrenade = none;
		}
	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
        WeaponIsDown();
	}

}

static function float GetDefaultImpulseForce()
{
    return default.ImpulseForce;
}
static function float GetDefaultAffectedRadius()
{
	return default.AffectedRadius;
}
static function float GetDefaultDamageCaused()
{
	return default.DamageCaused;
}
static function float GetDefaultDamageCaused_AI()
{
	return default.DamageCaused_AI;
}


reliable server function SetActualCookTime(float myActualCookTime)
{
	;
	ActualCookTime = myActualCookTime;
}

simulated event Destroyed()
{
	if( Instigator != None && Instigator.Controller != None && TPPlayerController(Instigator.Controller).PrevWeaponOnGrenade != None )
	{
		TPPlayerController(Instigator.Controller).PrevWeaponOnGrenade = none;
	}
}

