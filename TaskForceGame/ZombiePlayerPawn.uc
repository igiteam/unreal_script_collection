class ZombiePlayerPawn extends ZombieBipedPawn
	native;

const MP_DAMAGE_DIFF_HACK = 2;

var eDoubleClickDir			CurrentDir;

var bool					bStarted;	// set to true when pawn is started
var bool					bStartedWithWeap;	// set to true if player has a weapon during a call to ClientRestart

// (Sniper Rifle) Zoom Sway
var (ZoomSway) rotator		NeutralZoomViewRotation;
var (ZoomSway) rotator		PrevNeutralZoomViewRotation;
var (ZoomSway) rotator		ZoomSway;
var (ZoomSway) vector		ZoomTiltTranslation;
var (ZoomSway) float		postMoveGracePeriod;
var (ZoomSway) float		timeOfLastMove;

// Weather effects
var() editinline array<Emitter>	WeatherEmitters; 

var	Sound	UnderWaterAmbience;
var Controller OldController;

replication
{
	reliable if (Role == ROLE_Authority)
		ClientHitEffects, ClientGotAmmo;

	unreliable if (Role == ROLE_Authority)
		ClientHearBulletImpactVictim;

	reliable if (Role < ROLE_Authority)
		ShouldDoWhatWithAmmoPickup, RechargeExistingAmmo, GetWeaponThatUsesThisAmmo;
}

// return true if was controlled by a Player (AI or human)
simulated function bool WasPlayerPawn()
{
	return ( (OldController != None) && OldController.bIsPlayer );
}

function TeamInfo GetTeam()
{
	if ( PlayerReplicationInfo != None )
		return PlayerReplicationInfo.Team;
	if ( (OldController != None) && (OldController.PlayerReplicationInfo != None) )
		return OldController.PlayerReplicationInfo.Team;
	return None;
}

function PossessedBy(Controller C)
{
	Super.PossessedBy(C);
	if ( Controller != None )
		OldController = Controller;
}

event BeginPlay()
{
	Super.BeginPlay();

	if( Level.Game != none && ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMSinglePlayer') )
	{
		Tag = 'Hayden';
	}
	else
	{
		// TODO - Use mesh based on MP Player Class
		LinkMesh ( class'ZombieBipedPawn'.default.Mesh, true );
	}
}

simulated function bool ShouldTossWeapon()
{
	if ((Level.Game == none) || (ClassIsChildOf(level.Game.Class, class'ZombieGame.SFRMMultiplayer')))
	{
		return false;
	}
	
	return super.ShouldTossWeapon();
}

event PostBeginPlay()
{
	TimeOfLastWeaponEquip = -3;

	Super.PostBeginPlay();
}

simulated event ProcessNewPlayerReplicationInfo()
{
	if (!bTearOff && Health>0)
	{
		//log (self@"_____________PNPRI!!!!!"PlayerReplicationInfo.ClassIdx@PlayerReplicationInfo.bTerrorist);
		UpdateMPPawnClass();
		PlayerReplicationInfo.bWasTerrorist = PlayerReplicationInfo.bTerrorist;
		PlayerReplicationInfo.OldClassIdx = PlayerReplicationInfo.ClassIdx;
	}
}

// In case the player pawn bumps a karma actor
// apply the correct kimpulse to that actor.
event Bump( Actor Other )
{
	if( Other.IsA('KActor') && !KActor(Other).bIgnorePlayerImpulse )
	{
		Other.KAddImpulse( velocity*50/Other.KGetMass(), Other.location );
	}
}

event EndCrouch(float HeightAdjust)
{
	local ZombieWeapon ZWeapon;
//	Log("t="$Level.TimeSeconds $"  SFPlayerPawn.EndCrouch   self:"$self.class $"  weap:"$Weapon.class $" weap Loc:"$Weapon.Location $" ####4CRASHBUG####");
	EyeHeight -= HeightAdjust;
	OldZ += HeightAdjust;
	BaseEyeHeight = Default.BaseEyeHeight;
	ZWeapon = ZombieWeapon ( Weapon );
	if( ZWeapon != None && ZWeapon.bZoomed )
	{
		ZWeapon.ResetZoomTiltBob();
	}
}

event StartCrouch(float HeightAdjust)
{
	local ZombieWeapon ZWeapon;
//	Log("t="$Level.TimeSeconds $"  SFPlayerPawn.EndCrouch   self:"$self.class $"  weap:"$Weapon.class $" weap Loc:"$Weapon.Location $" ####4CRASHBUG####");
	EyeHeight += HeightAdjust;
	OldZ -= HeightAdjust;
	BaseEyeHeight = FMin(0.8 * CrouchHeight, CrouchHeight - 10);
	ZWeapon = ZombieWeapon ( Weapon );
	if( ZWeapon != None && ZWeapon.bZoomed )
	{
		ZWeapon.ResetZoomTiltBob();
	}
}

event UpdateEyeHeight( float DeltaTime )
{
	local vector HeadLoc, horizVel;

	Super.UpdateEyeHeight( DeltaTime );

	if( bWantsToCrouch )
	{
		if( EyeHeight > BaseEyeHeight + 20.0 )
		{
			if( SFRMPlayerController(Controller) != None )
				SFRMPlayerController(Controller).PVWeapNudgeCrouch(DeltaTime);
		}

		if( (EyeHeight > BaseEyeHeight + 0.05) && (Velocity.X != 0 || Velocity.Y != 0) )
		{
		//	Log("Headbump protection!!!    EyeHeight:"$EyeHeight $"   BaseEyeHeight:"$BaseEyeHeight );
			HeadLoc = Location + (EyeHeight)*vect(0,0,1);
			horizVel = Velocity;
			horizVel.Z = 0;
			if( !FastTrace( HeadLoc + Normal(horizVel)*(CollisionRadius+6.0), HeadLoc) )
			{
				Velocity.X = 0.0;
				Velocity.Y = 0.0;
			}
		}
	}
	else if( EyeHeight < BaseEyeHeight - 20.0 )  // For uncrouching and going up very steep stairs
	{
		if( SFRMPlayerController(Controller) != None )
			SFRMPlayerController(Controller).PVWeapNudgeUnCrouch(DeltaTime);
	}
}

exec function DropPickup(class<Pickup> PickupClass)
{
	if( PickupClass!= None)
	{
		Spawn(PickupClass,,,Location, Rotation); 
	}
}

function UpdateGrenadeInfo()
{
/*
		// Ensure grenade info is updated accordingly
		PC = SFRMPlayerController(Controller);
		if( PC != None && ABSTRACT_WeapGrenade(weap) != None )
			PC.ForceGrenadeInfoRefresh();
*/
}

exec function AddWeapon(string WeaponClassName)
{
	local class<Weapon> WeaponClass; 
	local Weapon newWeapon; 

	WeaponClass = class<Weapon>( DynamicLoadObject(WeaponClassName, class'Class') ); 
	
	if (WeaponClass==None)
	{
		if( FindInventoryType(WeaponClass) != None )
		{
			Log("Unable to create weaponclass from '"$WeaponClass$"'");
			return; 
		}
	} 
	
	newWeapon = Spawn(WeaponClass, self);  
	
	if ( newWeapon != None || ZombieWeapon(newWeapon) == None) 	
	{
		ZombieWeapon(newWeapon).GiveTo(self);
		ZombieWeapon(newWeapon).GiveWeaponAmmo();
	}
	
	UpdateGrenadeInfo();
}

function ClientReStart()
{
	local SFRMPlayerController SFRMPC;
	local rotator CurrRotation;
//	Log("t="$ Level.TimeSeconds $" ZombiePlayerPawn.ClientRestart   bStarted:"$ bStarted $" Weapon:"$Weapon 
//		$"  bStartedWithWeap:"$ bStartedWithWeap $"  StartingWeapSlot:"$ StartingWeapSlot );
//	Log("   **ZPP.ClientReStart  self:"$ self $"  Role<ROLE_Authority:"$ Role<ROLE_Authority );
	Super.ClientReStart();

	if ( Controller != None )
		OldController = Controller;

	// Ensure that player doesn't start out with a roll (was a problem with Congo 2)
	CurrRotation = Rotation;
	CurrRotation.Roll = 0;
	SetRotation( CurrRotation );

	if( Controller != None )
		Controller.StopFiring();

	SFRMPC = SFRMPlayerController(Controller);
	if( SFRMPC != None )
	{
		// Make sure player does not get stuck
		if( SFRMPC.IsMP() )
		{
			ShouldCrouch(false);
			BaseEyeHeight = Default.BaseEyeHeight;
			SFRMPlayerController(Controller).SetLean(false);
			BasicHud(PlayerController(Controller).myHUD).SetScopeMode(false);
		}

		// Reset PV weapon sway accum parameters (just in case the player fell out
		// of the world when they died in multiplayer and respawned, for example).
		SFRMPC.aTurnAccum=0.0;
		SFRMPC.aLookUpAccum=0.0;
		SFRMPC.VXAccum=0.0;
		SFRMPC.VYAccum=0.0;
		SFRMPC.VZAccum=0.0;

		SFRMPC.LastGrenadeWeapon=None; //very important.  
	}

	if( !bStarted )  // Only do following logic when pawn first starts
	{
		if (Level.NetMode == NM_Standalone)
		{
//SysLinkSPAM			log("ClientReStart RestartPlayer");
			Level.DefaultMapInfo.RestartPlayer(self);	// notify level info about incoming client
		}

		bStarted = true;	// after first start, this signifies it's a restart
	}

	//don't allow them to start with grenades as the current slot.  (for quick-grenade)
//	if (StartingWeapSlot == 2) StartingWeapSlot = 1;
	
	if( !bStartedWithWeap ) // Only do the following logic the first time pawn restarts with a weapon
	{
		bStartedWithWeap = PickAndSetStartingWeapon();
	}

	// Regardless of whether a starting weapon needed to be selected, 
	// if there is a weapon now, then set the appropriate reticle
	if ( Weapon != None && (PlayerController(Controller)!=none) && (BasicHud(PlayerController(Controller).myHUD)!=none) )
	{
		BasicHud(PlayerController(Controller).myHUD).SetCHIndex(ZombieWeapon(Weapon).GetCrosshairIndex(),
																ZombieWeapon(Weapon).WeaponIconIndex);
	}

	// Make sure player doesn't start with grenade icon on HUD on respawn (after dying while grenading)
	BasicHud(PlayerController(Controller).myHUD).bGrenadingNow = false;
}

function bool PickAndSetStartingWeapon()
{
	local int inx;
	local Weapon ChosenWeapon;
	local bool bIgnorePause;

	bIgnorePause = true;

	if( StartingWeapSlot >= 0 && StartingWeapSlot <= 4 && Weapons[StartingWeapSlot] != None )  // if starting weapon is valid
	{
	//	Log("  **SFPP.PickAndSetStartingWeapon    starting weap slot is valid   StartingWeapSlot:"$StartingWeapSlot );
		if( Weapon != Weapons[StartingWeapSlot] ) 	// if starting weapon isn't already selected
		{
			EquipWeapon( StartingWeapSlot, bIgnorePause ); 		// set starting weapon
			ChosenWeapon = Weapons[StartingWeapSlot];
		}
	}
	else
	{
	//	Log("  **SFPP.PickAndSetStartingWeapon    no valid weapon in specified slot (so try rifle, then other slots)   StartingWeapSlot:"$StartingWeapSlot );
		// Otherwise, try rifle slot and then other slots
		if( StartingWeapSlot != 1 && Weapon != Weapons[1] && Weapons[1] != None )
		{
			EquipWeapon(1, bIgnorePause);							// set rifle
			ChosenWeapon = Weapons[StartingWeapSlot];
		//	Log("   **SFPP.PickAndSetStartingWeapon    set rifle ");
		}
		else
		{
			for( inx = 0 ; inx < 4 ; inx++ )
			{
				//don't allow them to start with grenades as the current slot.
				if (Weapons[inx] == None || inx==2) continue;

				EquipWeapon(inx, bIgnorePause);	// set a (non hand-grenade) weapon
				ChosenWeapon = Weapons[inx];
			//	Log("   **SFPP.PickAndSetStartingWeapon    set slot "$ inx );
				break;  // MAT 03/07/04: If we found a weapon, stop looking
			}
		}
	}

	// Hack! Fix for host starting with pistol, and host not being able to
	// zoom until they change weapon froim pistol. (4/16/04)
	if( Role==ROLE_Authority )
		ChangedWeapon();

//	Log("  **SFPP.PickAndSetStartingWeapon    check:  ChosenWeapon != None:"$ ChosenWeapon != None $"  Weapon != ChosenWeapon:"$ Weapon != ChosenWeapon $"   state:"$GetStateName() );
	// Return success/failure indication
	if( ChosenWeapon != None )
		return true;
	else
		return false;
}

function GiveWeapon ( string aClassName )
{
	AddWeapon ( aClassName ); 
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
/*	local vector X,Y,Z;
	local rotator ViewRotation;
	ViewRotation = Rotation;

	if ( bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) )
		return false;

	if (DoubleClickMove == DCLICK_Forward)
	{
		//Velocity = 1.5*GroundSpeed*X + (Velocity Dot Y)*Y;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		if (ViewRotation.Pitch > 32768)
			ViewRotation.Pitch -= 65536;

		ViewRotation.Pitch = 0;

		PlayerController(Controller).SetRotation(ViewRotation);
		PlayerController(Controller).UpdateRotation(DeltaTime, 1);
	}
	else if (DoubleClickMove == DCLICK_Back)
	{
		Velocity = -1.5*GroundSpeed*X + (Velocity Dot Y)*Y; 
	}
	else if (DoubleClickMove == DCLICK_Left)
	{
		GetAxes(Rotation,X,Y,Z);
		Velocity = 1.5*GroundSpeed*Y + (Velocity Dot X)*X; 
		Velocity.Z = 210;
		CurrentDir = DoubleClickMove;
		SetPhysics(PHYS_Falling);
	}
	else if (DoubleClickMove == DCLICK_Right)
	{
		GetAxes(Rotation,X,Y,Z);
		Velocity = -1.5*GroundSpeed*Y + (Velocity Dot X)*X; 
		Velocity.Z = 210;
		CurrentDir = DoubleClickMove;
		SetPhysics(PHYS_Falling);
	}*/

	//return true;
	return false;
}

function bool Dodge2(eDoubleClickDir DoubleClickMove)
{
	local float DodgeVel;

	local vector X,Y,Z;
	local rotator ViewRotation;
	ViewRotation = Rotation;

	DodgeVel = 4.0;

	if ( bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) )
		return false;

	
	if (DoubleClickMove == DCLICK_Left)
	{
		GetAxes(Rotation,X,Y,Z);
		Velocity = -DodgeVel*GroundSpeed*Y + (Velocity Dot X)*X; 
		Velocity.Z = 210;
		CurrentDir = DoubleClickMove;
		SetPhysics(PHYS_Falling);
	}
	else if (DoubleClickMove == DCLICK_Right)
	{
		GetAxes(Rotation,X,Y,Z);
		Velocity = DodgeVel*GroundSpeed*Y + (Velocity Dot X)*X; 
		Velocity.Z = 210;
		CurrentDir = DoubleClickMove;
		SetPhysics(PHYS_Falling);
	}

	return true;
}

simulated function vector CalcDrawOffset(inventory Inv)
{
	local vector DrawOffset;

	DrawOffset = super.CalcDrawOffset(Inv);

	if ((PlayerController(Controller) != none) && (PlayerController(Controller).bLeanView))
	{
		DrawOffset += (PlayerController(Controller).LeanFirePosition - Location);
		DrawOffset.Z -= EyeHeight;
		DrawOffset -= WeaponBob(Inv.BobDamping);
	}
	
	return DrawOffset;
}

function BasicHUD GetHUD()
{
	if ((PlayerController(Controller)!=none))
	{
		return BasicHud(PlayerController(Controller).myHUD);
	}

	return none;
}

exec function LogAllWeapons()
{
	local ZombiePlayerPawn sfpp;
	
	log("LogAllWeapons:");
	
	foreach DynamicActors (class'ZombieGame.ZombiePlayerPawn', sfpp)
	{
		sfpp.LogWeapons();
	}
}

exec function LogWeapons()
{
	local inventory I;
	log("Weapons for " $ self $ ": " $ weapons[0] @ weapons[1] @ weapons[2] @ weapons[3]);
	I = Inventory;
	while ( I != none)
	{
		log("Inventory is: " $ I);
		
		I = I.Inventory;
	}
}

function Controller GetKillerController()
{
	if ( Controller != None )
		return Controller;
	if ( OldController != None )
		return OldController;
	return None;
}

// Shake view and flash view on client side
simulated function ClientHitEffects( class<DamageType> damageType, int Damage, Vector momentum )
{
	if( Level.Game == None || Level.NetMode != NM_Standalone 
	 || (ClassIsChildOf( Level.Game.Class, class'ZombieGame.SFRMMultiPlayer' ) ) )
		damageType.Static.ShakeView(Controller,Damage,true);  // Force it to not use blur in multiplayer!
	else
		damageType.Static.ShakeView(Controller,Damage);
	damageType.Static.FlashClient(Controller,momentum);

	ClientHearSelfTakeHit( damageType );
}

// overloaded to not modify damage values for player in single player
function int GetLocationalDamage ( int Damage, vector HitLocation )
{
	return Damage;
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType, optional Controller KillerController)
{
	local range					PlayerMod;

	//log( "ZombiePlayerPawn.uc Take Damage" );
	//log( "Controller: "@Controller );
	//log( "(PlayerController(Controller).bGodMode)"@(PlayerController(Controller).bGodMode) );
	//log( "DamageType"@DamageType );

	if( (Controller == None) ||
	    (PlayerController(Controller).bGodMode) ||
	    DamageType == None ||
	    Controller.IsInState('PlayerFrozen') )
	{
		return;
	}

	PlayerMod = damageType.Static.GetPlayerDamageModifier(Level);
	Damage *= PlayerMod.Min;

	// Hack to nerf Bot damage on Player in SinglePlayer - RAF 10/1/04 (Moved from SFRMDamageType and changed a few of the checks)
	// MAT 11/12/04: Moved this to ZombieBipedPawn
	//if ( ZombieBot ( instigatedBy.Controller ) != None && Level.Game != None && !Level.Game.bIsMultiplayer )
	//{
	//	Damage *= LODDamageFactor[Level.Game.GameDifficulty];
	//}

	Damage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);

	if (Damage <= 0)
		return;

	if ( SFRMPlayerController ( Controller ) != None && SFRMPlayerController ( Controller ).StatMgr != None )
	{
		SFRMPlayerController(Controller).StatMgr.PlayerHit(Damage);
	}
		
	// Ow!  See red and view shake when taking a hit.  And maybe hear a sound too.
	ClientHitEffects( damageType, Damage, momentum );

	// Ow!  Hear myself take a hit
//	PlaySound(damageType.Static.GetPawnDamageSound(self),SLOT_Interface);
//	PlaySound(damageType.Static.GetPawnDamageSound(self),SLOT_Misc,0.8,,15);
//	ClientHearSelfTakeHit(damageType);

	if (!damageType.default.bNoSpecificLocation)
	{
		SFRMPlayerController(Controller).OwnerHit(momentum, damageType.default.bPlayRumble);
	}

//	if (HitRumbleDes != none && damageType.default.bPlayRumble)
//	{
//		PlayerController(Controller).PlayRumble(HitRumbleDes);
//	}

	Super.TakeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, KillerController);
	
	lastDamage = Damage;

	if ( Health <= 0 )
	{
		TearOffMomentum = momentum;

	//	Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.TakeDamage  About to call MPPlayerDropPickup ");
	//	Log("     IsMP():"$ IsMP() $"  instigatedBy:"$instigatedBy $"  instigatedBy.Weapon:"$ instigatedBy.Weapon );
		//if( ZombiePlayerPawn(instigatedBy) != None &&  // Checking for instigatedBy.weapon fails for a grenade suicide
		// (Level.NetMode != NM_Standalone) || 
		// (Level.Game == none) || 
		// ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer') )  // IsMP in ZombieBipedPawn was broken for split-screen
		//	MPPlayerDropPickup( instigatedBy, damageType);
	}
}

simulated function ClientHearSelfTakeHit(class<DamageType> damageType)
{
// TODO: may want to get a different sound
//	PlaySound(damageType.Static.GetPawnDamageSound(self),SLOT_Interface,0.9,,12);
}

// Lets this player pawn get sound feedback from hitting other pawn
function HearBulletImpactVictim()
{
	ClientHearBulletImpactVictim();
}
simulated function ClientHearBulletImpactVictim()
{
	if( PlayerController(Controller) != None && IsLocallyControlled() )
	{
		PlaySound( 
			class'ZombieGame.SFRMAmmunition'.default.RandomBulletImpactSounds[EMaterialTypes.MATERIAL_Flesh], 
			SLOT_Interface, 1.0 );
	}
}

event Died ( Controller Killer, class<DamageType> damageType, vector HitLocation )
{
	local int Weap;
	log("DamageType" @damagetype);
	log("Controller" @controller);
	log("killer" @killer);
	//	Log("t="$Level.TimeSeconds $"  ZombiePlayerPawn.Died   self:"$self );
	if ( bDeleteMe )
		return; //already destroyed

	if( Controller != None )
		Controller.StopFiring();

	// weapon & mode cleanup
	for ( Weap = 0; Weap < 4; Weap++ )
	{
		if ( Weapons[Weap] != None )
		{
			Weapons[Weap].Destroy ( );
			Weapons[Weap] = None;
		}	
	}

	// Unzoom weapon
	if( ZombieWeapon(Weapon) != None && ZombieWeapon(Weapon).bZoomed )
		ZombieWeapon(Weapon).EndZoom();

	// Ensure that after the player respawns, its controller isn't referencing 
	// a grenade weapon that should no longer exist
	if( SFRMPlayerController(Controller) != None )
		SFRMPlayerController(Controller).LastGrenadeWeapon = None;

    Super.Died(Killer, damageType, HitLocation);
}


function MPPlayerDropPickup( Pawn instigatedBy, class<DamageType> damageType)
{
	local vector DropStartLoc, DropVelocity;
	local rotator AmmoRotation;
	local int slot;
	local Pickup P;

//	Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.MPPlayerDropPickup  Controller:"$ Controller $"  Level.NetMode!=NM_Standalone:"$ Level.NetMode!=NM_Standalone );
//	if( SFRMPlayerController(Controller) != None )
//		Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.MPPlayerDropPickup  SFRMPlayerController(Controller).IsMP():"$ SFRMPlayerController(Controller).IsMP() );

	// Base location of ammo on location of pawn
	DropStartLoc = Location;
	if( Physics == PHYS_KarmaRagDoll )
	{
		// With ragdoll, Location changes if lying down vs standing, 
		// so want to raise it slightly to make it less likely to spawn in the ground
		DropStartLoc.Z += 26;
	}
	else
	{
		// With a non-ragdoll death (death animation), Location usually stays the same,
		// so want to lower it so that pickup doesn't pop out of, say, pawn's head
		DropStartLoc.Z -= 72; // for timer 0.8 was 40;
	}

	// Further adjust ammo location and velocity
	AmmoRotation.Yaw = Rotation.Yaw;

	// Adjust velocity and location to put drop either on left or right side
	if( FRand() < 0.5 )
	{
		// Drop towards pawn's left side
		DropVelocity += (vect(0,-80,0) >> AmmoRotation);
		DropStartLoc += (vect(0,-32,0) >> AmmoRotation);
	}
	else
	{
		// Drop towards pawn's right side
		DropVelocity += (vect(0,80,0) >> AmmoRotation);
		DropStartLoc += (vect(0,32,0) >> AmmoRotation);
	}

	// Spawn the ammo
	if( ClassIsChildOf(damageType, Class'ZombieGame.DamageTypeProjectile') )
	{
		// If this was a grenade death, definitely drop grenade ammo
		P = spawn( ZombieBipedPawn(instigatedBy).Weapons[slot].AmmoName.default.PickupClass,,,DropStartLoc,AmmoRotation);
	}
	else
	{
		if( FRand() < 0.75 )
		{
			// Otherwise, it has a high probability of dropping the ammo for the
			// instigator's current weapon
			P = spawn( ZombieWeapon(instigatedBy.Weapon).AmmoName.default.PickupClass,,,DropStartLoc,AmmoRotation);
		}
		else
		{
			// It has a lesser probability of dropping the ammo for one of the
			// instigator's other weapons
			slot = int(FRand() * 3.999);  // 0.0-0.999 truncates to 0, ... 3.0 to 3.999 truncates to 3
            if( ZombieBipedPawn(instigatedBy) != None && ZombieBipedPawn(instigatedBy).Weapons[slot] != None )
			{
				P = spawn( ZombieBipedPawn(instigatedBy).Weapons[slot].AmmoName.default.PickupClass,,,DropStartLoc,AmmoRotation);
			}
			else
			{
				// If the random choice was an empty slot, then just pick 
				// the instigator's current weapon
				P = spawn( ZombieWeapon(instigatedBy.Weapon).AmmoName.default.PickupClass,,,DropStartLoc,AmmoRotation);
			}
		}
	}

//	if( P == None )
//		Log("###### SFPP.MPPlayerDropPickup   P: "$P $"( n/a )" );
//	else
//		Log("###### SFPP.MPPlayerDropPickup   P: "$P $"("$ P.class $")" );

	if( P != None )
	{
		P.InitDroppedPickupFor(None);
		if( AmmoPickup(P) != None )
		{
			P.Velocity = DropVelocity;
			AmmoPickup(P).LifeSpan=60.0;
		}
	}
}

simulated function ClientGotAmmo( ZombieWeapon zweap )
{
	BasicHud(PlayerController(Controller).MyHud).GotAmmo(zweap);
}

// Adjust ammo location if neeeded to avoid spawning in walls
function vector FindRagdollDropLocation ( vector currLoc, vector currDropStartLoc )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, OKDropStartLoc;
	local actor Other;
	local rotator currAngle;
	local int yaw;
	local bool foundOkLoc;
	
	foundOkLoc = false;

	StartTrace = currLoc;
	StartTrace.Z = currDropStartLoc.Z;

	for( yaw = 0; yaw < 16384; yaw += 5461 ) // 0 to 90 deg, steps of 30 deg 
	{
		currAngle.Yaw = yaw;
		EndTrace = currLoc + ((currDropStartLoc - currLoc) << currAngle);
		Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,,,);
	//	Log("   #### Yaw:"$Yaw $"("$ Yaw*360/65535 $")  Other:"$Other $"  EndTrace:"$EndTrace );
		if( Other == None )
		{
			foundOkLoc = true;
			OKDropStartLoc = EndTrace;
			break;
		}

		if( yaw == 0 )  // If yaw is 0, don't need to flip sign and try negative angle--answer will be same.
			continue;   // So for that case, skip the rest of the code in this loop

		currAngle.Yaw = -yaw;
		EndTrace = currLoc + ((currDropStartLoc - currLoc) << currAngle);
		Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,,,);
	//	Log("   #### Yaw:"$-Yaw $"("$ -Yaw*360/65535 $")  Other:"$Other $"  EndTrace:"$EndTrace );
		if( Other == None )
		{
			foundOkLoc = true;
			OKDropStartLoc = EndTrace;
			break;
		}
	}
	
	if( !foundOkLoc )
		OKDropStartLoc = currLoc;
	
	return OKDropStartLoc;
}

//-----------------------------------------------------------------------------
// Weather effects

function AttachWeatherEffect(class<Emitter> InEmitterClass, vector InOffset)
{
	local Emitter E; 
	local rotator R; 
	
	if (InEmitterClass == None)
		return; 

	R.Yaw = 16000;
	 
//	Log ( "Adding "$InEmitterClass$" to "$self ); 		
	E =  Spawn(InEmitterClass, self);  
	
	E.SetBase(self); 
	E.SetRelativeLocation(InOffset); 


	WeatherEmitters.Insert(WeatherEmitters.Length,1);
	WeatherEmitters[WeatherEmitters.Length-1] = E; 
}

function DetachWeatherEffects()
{
	local int i; 
	for ( i = 0; i < WeatherEmitters.Length; i++ ) 
	{
		DetachFromBone(WeatherEmitters[i]);
		WeatherEmitters[i].SetBase(None);
		WeatherEmitters[i].bHardAttach = false; 
		WeatherEmitters[i].Destroy(); 
	}
		
	WeatherEmitters.Remove(0, WeatherEmitters.Length); 
}


//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// New equipment system

function Inventory FindInventoryOfClassType( class ParentClass )
{
	local Inventory Inv;
	local int Count;

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )   
	{
		if ( ClassIsChildOf(Inv.class, ParentClass ) )
			return Inv;
		Count++;
		if ( Count > 1000 )
			return None;
	}
	return None;
} 


exec function EquipWeapon ( optional int SlotID, optional bool bIgnorePause )
{
//SysLinkSPAM		log("EquipWeapon1: " $ SlotID @ Weapons[SlotID] @ Weapons[SlotID].InventoryGroup);
	// valid slot num?
	if( SlotID < 0 || SlotID > 3 )
		return; 
	
	if( Weapons[SlotID] != None )
	{
		if( Weapons[SlotID] != Weapon )
		{
			// Handle switch to new weapon
//SysLinkSPAM		log("EquipWeapon2: " $ Weapons[SlotID] @ Weapons[SlotID].InventoryGroup);

			PlayerController(Controller).SwitchWeapon(Weapons[SlotID].InventoryGroup, bIgnorePause ); 

			//if we changed weapons let the client know so they can stop any weapon specific animations from playing
			if( bDidChangeWeapon )
			{
				bDidChangeWeapon = false;
				if( ROLE == ROLE_Authority )
				{
					bWeaponChanged = true;
					SetDirty();
				}
				else
					ServerWeaponChanged( );
			}

			TimeOfLastWeaponEquip = Level.TimeSeconds;

			MyWeapon = Weapons[SlotID];
		}
	}
}

// If equip will probably not result in a useful outcome, this will return false
// Note that this does not take into account timing issues (i.e. player is trying 
// to select weapon mode within 1 second of selecting weapon is not checked)
function bool EquipWillBeValid(int SlotID)
{
	if( Weapons[SlotID] == None )
	{
		return false;  // An Equip with this SlotID won't select a valid weapon: don't unzoom
	}
	else
	{
		if( Weapons[SlotID] != Weapon )
		{
			return true;  // An Equip with this SlotID will result in weapon switch: unzoom
		}
		else
			return false;
	}
}


function AddWeaponToSlot(int SlotID, class<ZombieWeapon> WeaponClass, optional bool forceReplace)
{
	local ZombieWeapon NewWeapon;
//	log(self$"::AddWeaponToSlot");	
//	log("t="$ Level.TimeSeconds $" ZombiePlayerPawn.AddWeaponToSlot");	
	
	//wrc changed 3/16/04 no more special behaviour for slot 3!
	if (Weapons[SlotID] == None || forceReplace)
	{
		NewWeapon = Spawn(WeaponClass, self);  
		if ( NewWeapon != None ) 	
		{
			AddExistingWeaponToSlot(SlotID, NewWeapon, forceReplace);
		//	log("t="$ Level.TimeSeconds $" ZombiePlayerPawn.AddWeaponToSlot  Added "$ NewWeapon $"  weap state:"$ NewWeapon.GetStateName() );
		}
		else
		{
			log("Failed to spawn weapon: " $ WeaponClass $ " for " $ self);
		}
	}
}

function AddExistingWeaponToSlot(int SlotID, ZombieWeapon weap, optional bool forceReplace)
{
	if (forceReplace || Weapons[SlotID] == None)
	{
		// when forceReplace == true, this can be true but may not be.
		if ( Weapons[SlotID] != None )
		{
			Weapons[SlotID].Destroy();
		}

		// Set ammo pickup
		if( SinglePlayerMI(Level.DefaultMapInfo) != None )
			SinglePlayerMI(Level.DefaultMapInfo).NewAmmoPickupForSlot(weap.class, SlotID);		

		weap.GiveTo(self);
		weap.GiveWeaponAmmo();
		Weapons[SlotID] = weap; 

		UpdateGrenadeInfo();
		return; 
	}
	
	//wrc 3/16/04 no more throwing weapons if we already have a weapon in a particular slot
}

function HandlePickup(Pickup pick)
{
	if ( pick.IsA ( 'SFRMPickup' ) )
	{
		//MakeNoise ( 0.2 );
		AddWeaponToSlot ( 3, class<ZombieWeapon>( pick.InventoryType ) );
	}
}

function ZombieWeapon GetWeaponThatUsesThisAmmo( class<Ammunition> AmmunitionClass, int AmmoAmount )
{
	local Inventory Inv;
	local ZombieWeapon FoundWeap, ClosestClipSizeWeap;
	local ZombieWeapon ZInv;

//	Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.GetWeaponThatUsesThisAmmo ");
	for( Inv=Inventory; Inv!=None ; Inv=Inv.Inventory )
	{ 
		ZInv = ZombieWeapon ( Inv );
		if ( ZInv != None )
		{
			if ( AmmunitionClass.name == ZInv.AmmoName.name )
			{
				FoundWeap = ZInv;
				if( ClosestClipSizeWeap == None )
					ClosestClipSizeWeap = FoundWeap;   // If this is first weapon found, it becomes our prime candidate
				else
				{
					// If this weapon's clip size is closer to the pickup's ammo count than our last match was, 
					// then we probably want to make this our new best choice
					if( abs(FoundWeap.default.ReloadCount-AmmoAmount) < abs(ClosestClipSizeWeap.default.ReloadCount-AmmoAmount) )
						ClosestClipSizeWeap = FoundWeap;
				}
			//	Log("   FoundWeap:"$FoundWeap $" rc:"$FoundWeap.default.ReloadCount $"  ClosestClipSizeWeap:"$ClosestClipSizeWeap $" rc:"$ClosestClipSizeWeap.default.ReloadCount );
			}
		}
	}
//	Log(" ClosestClipSizeWeap:"$ClosestClipSizeWeap $"    pickup's AmmoAmount:"$AmmoAmount );
//	Log("      curr reload count:"$ ClosestClipSizeWeap.ReloadCount );

	return ClosestClipSizeWeap;
}

function byte ShouldDoWhatWithAmmoPickup( class<Ammunition> AmmunitionClass )
{
	local Ammunition UsersExistingAmmo;

//	Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.ShouldDoWhatWithAmmoPickup  ");

	if( AmmunitionClass != None )
		UsersExistingAmmo = Ammunition( FindInventoryType( AmmunitionClass ) );

//	if( UsersExistingAmmo != None )
//		Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.ShouldDoWhatWithAmmoPickup      tried to get users existing ammo:"$ UsersExistingAmmo.class $"  ammo amt:"$ UsersExistingAmmo.AmmoAmount $" max ammo:"$ UsersExistingAmmo.MaxAmmo );
//	else
//		Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.ShouldDoWhatWithAmmoPickup      tried to get users existing ammo, but result is none");

	if( UsersExistingAmmo == None )
	{
//		Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.ShouldDoWhatWithAmmoPickup        return 2: doesn't have that type of ammo at all");
		return 2;
	}
	else if( UsersExistingAmmo.AmmoAmount < UsersExistingAmmo.MaxAmmo )
	{
//		Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.ShouldDoWhatWithAmmoPickup        return 1: can just recharge existing ammo   ammo amt:"$ UsersExistingAmmo.AmmoAmount $" max ammo:"$ UsersExistingAmmo.MaxAmmo );
		return 1;
	}
	else
	{
//		Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.ShouldDoWhatWithAmmoPickup        return 0: don't take this ammo!!!");
		return 0;
	}
}
// change ammoamount to an out var Brett
function bool RechargeExistingAmmo( class<Ammunition> AmmunitionClass, out int AmmoAmount )
{
	local Ammunition UsersExistingAmmo;
	local ZombieWeapon weap;

//	Log("t="$ Level.TimeSeconds $"  ZombiePlayerPawn.RechargeExistingAmmo  ");

	if( AmmunitionClass != None )
		UsersExistingAmmo = Ammunition( FindInventoryType( AmmunitionClass ) );

	// If current ammo amount is less than MaxAmmo limit
	if( (UsersExistingAmmo != None) && (UsersExistingAmmo.AmmoAmount < UsersExistingAmmo.MaxAmmo) )
	{
		// Add to the ammo amount, but only up to the MaxAmmo limit
		UsersExistingAmmo.AmmoAmount += AmmoAmount;
		//   If this is a hand grenade, use some ammo to "reload" the weapon
		if( GrenadeAmmo(UsersExistingAmmo) != None )
		{
			weap = GetWeaponThatUsesThisAmmo(AmmunitionClass,AmmoAmount);
			if( ABSTRACT_WeapGrenade(weap) != None && weap.ReloadCount == 0 )
			{	
				weap.ReloadCount = 1;
				UsersExistingAmmo.AmmoAmount--;
			}
		}
		//   Limit ammo amount in user's reserve to MaxAmmo limit
		if( UsersExistingAmmo.AmmoAmount > UsersExistingAmmo.MaxAmmo )
		{
			AmmoAmount -= (UsersExistingAmmo.AmmoAmount - UsersExistingAmmo.MaxAmmo);
			UsersExistingAmmo.AmmoAmount = UsersExistingAmmo.MaxAmmo;
		}
		//log("AmmoAmount from pawn"@AmmoAmount);
		return true;
	}
	else
	{
		// Otherwise, leave ammo alone
		return false;
	}
}

//
//-----------------------------------------------------------------------------

simulated function Zoom()
{
	local ZombieWeapon ZWeapon;

	ZWeapon = ZombieWeapon ( Weapon );
	if ( ZWeapon == None )
		return;

//	Log("ZPP.Zoom  1    About to call ZWeapon.Zoom()");
	ZWeapon.Zoom();
	NeutralZoomViewRotation = Controller.Rotation;

	// TODO - Do we need this anymore?
	// HACK.  Grenade gets screwed up by UnZoomFaster.  just end it here.
	if ( ZWeapon.IsA ( 'ABSTRACT_WeapGrenade' ) )
		return;

	if ( ZWeapon.bDoingZoom )
	{
	//	Log("SFPP.Zoom  1.1a Going to state PawnZoomed ");
		GotoState('PawnZoomed'); 
	}
	else
	{
	//	Log("ZPP.Zoom  1.1b  bDoingZoom:"$ZWeapon.bDoingZoom $"  Physics==PHYS_Falling:"$Physics==PHYS_Falling );
		if ( ZWeapon.bZoomed ) //&& Physics == PHYS_Falling )
		{
		//	Log("SFPP.Zoom  1.1.1b   Weapon was zoomed, and we're falling: Unzooming");
			ZWeapon.UnZoomFaster ( );
		//	SFRMPlayerController(Controller).setLean(false);
		}

	//	Log("ZPP.Zoom  1.2b  bDoingZoom:"$ZWeapon.bDoingZoom $"  Physics==PHYS_Falling:"$Physics==PHYS_Falling );
		GotoState ( '' );
	}
}

simulated state PawnZoomed
{
	function vector WeaponBob(float BobDamping)
	{
		return 0.25*Super.WeaponBob(BobDamping);
	}

	simulated function vector EyePosition()
	{
		local int pitchMove, yawMove;
		local ZombieWeapon weap;

		weap = ZombieWeapon(Weapon);
		
		if ( !weap.bDoingZoom )
		{
			GotoState ( '' );
			return EyeHeight * vect(0,0,1);
		}
		else if ( PlayerController ( Controller ) != None && PlayerController ( Controller ).ShowingFMV )
		{
			weap.UnZoomFaster ( );
			GotoState ( '' );
			return EyeHeight * vect ( 0, 0, 1 );
		}
		else
		{
			// If we're not fully-zoomed, then don't tilt yet.
			if( !weap.bZoomed )
				return EyeHeight * vect ( 0, 0, 1 );
			
			// Otherwise, we're fully zoomed-in: adjust eye position and view rotation

			// Find out how much pitch changed (and make it between -180/+180 deg--e.g. 330 becomes -30 deg)
			pitchMove = (Controller.Rotation.Pitch - NeutralZoomViewRotation.Pitch) - ZoomSway.Pitch;
			if( pitchMove < -32767 )
				pitchMove += 65535;
			else if( pitchMove > 32767 )
				pitchMove -= 65535;
				
			// Find out how much pitch changed (and make it between -180/+180 deg--e.g. 330 becomes -30 deg)
			yawMove =   (Controller.Rotation.Yaw   - NeutralZoomViewRotation.Yaw  ) - ZoomSway.Yaw;
			if( yawMove < -32767 )
				yawMove += 65535;
			else if( yawMove > 32767 )
				yawMove -= 65535;
			
			// If player view rotation moved, recompute neutral view rotation
			if( abs(pitchMove) > 1 || abs(yawMove) > 1 )
			{
				NeutralZoomViewRotation = Controller.Rotation;

			//	Log("Moved!    dp:"$pitchMove $"  dy:"$yawMove $"   sway: dp:"$ZoomSway.Pitch$ " dy:"$ZoomSway.Yaw
			//		$"   t:"$Level.TimeSeconds );

				weap.ResetZoomTiltBob(true);

				timeOfLastMove = Level.TimeSeconds;
			}

			if(	Level.TimeSeconds < timeOfLastMove + postMoveGracePeriod )
			{
				// User is moving view, or just after user moved view:
				// Wait before restarting oscillation (just in case user moves again)
				weap.ResetZoomTiltBob(true);
				ZoomSway *= 0.5;  // Blend out whatever sway there was before movement started
				ZoomTiltTranslation *= 0.5;
			//	Log("Reset bob  current time:"$Level.TimeSeconds$"  time of last move: "$timeOfLastMove $"  sway (being blended down):"$ ZoomSway );
			}
			else
			{
				// Otherwise, compute sway
				ZoomSway = weap.ZoomTiltBob();
				ZoomTiltTranslation = weap.ZoomTiltTranslationBob();
			}

			// Apply sway as rotation
		//	Log("ZombiePlayerPawn.PawnZoomed.EyePosition:  neutral: "$NeutralZoomViewRotation $"   sway: "$ZoomSway $"    result: "$(NeutralZoomViewRotation+ZoomSway) );
			Controller.SetRotation(NeutralZoomViewRotation+ZoomSway);
			
			return ( EyeHeight * vect(0,0,1)
						+ ZoomTiltTranslation );  // Apply some of sway as translation
		}
	}
}

function OnActorEnteredZone ( )
{
	Super.OnActorEnteredZone ( );
	
	PlaySound ( Region.Zone.StereoAmbience,SLOT_AmbientStereo );
}

event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
	Super.HeadVolumeChange(newHeadVolume);

	if ( (HeadVolume != none) && HeadVolume.bWaterVolume )
	{
		if (!newHeadVolume.bWaterVolume)
		{
			PlaySound(Region.Zone.StereoAmbience,SLOT_AmbientStereo);
		}
	}
	else if ( newHeadVolume.bWaterVolume )
	{
		PlaySound(UnderWaterAmbience,SLOT_AmbientStereo);
	}
}
//RDN

simulated function Tick(float DeltaTime)
{
	if ( Controller != None )
		OldController = Controller;
}


// Decompiled with UE Explorer.
defaultproperties
{
    postMoveGracePeriod=0.1400000
    LODDamageFactor[0]=0.1000000
    LODDamageFactor[1]=0.2000000
    LODDamageFactor[2]=0.5000000
    LODDamageFactor[3]=0.5000000
    StartingWeapSlot=1
    Faction=1
    bCanPickupInventory=true
    WalkingPct=0.5000000
    CrouchedPct=0.5000000
    BaseWalkingPct=0.8500000
    BaseCrouchedPct=0.5000000
    BaseEyeHeight=55.0000000
    ControllerClass=none
    LightEffect=13
    Mesh=SkeletalMesh'CBA_Characters.combat_soldier'
    Buoyancy=80.0000000
}