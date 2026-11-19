//=============================================================================
// Parent class of all weapons.
// FIXME - should bReplicateInstigator be true???
//=============================================================================
class Weapon extends Inventory
	abstract
	native
	nativereplication;

#exec Texture Import File=Textures\Weapon.dds Name=S_Weapon Mips=Off MASKED=1

//-----------------------------------------------------------------------------
// Weapon ammo information:
var		class<ammunition> AmmoName;     // Type of ammo used.
var		int     PickupAmmoCount;		// Amount of ammo initially in pick-up item.
var		travel ammunition	AmmoType;	// Inventory Ammo being used.
var		byte    ReloadCount;			// Amount of ammo depletion before reloading. 0 if no reloading is done.

//-----------------------------------------------------------------------------
// Weapon firing/state information:

var		bool	  bPointing;		// Indicates weapon is being pointed
var		bool	  bWeaponUp;		// Used in Active State
var		bool	  bChangeWeapon;	// Used in Active State
var		bool	  bCanThrow;		// if true, player can toss this weapon out
var		bool	  bForceReload;
var		bool	  bAmmoAdded;		// if true, means ammo has been added during current reload
var		bool	  bGoInactiveAfterDown; //if true, downweapon doesn't automatically bring up a new weapon

var		float	StopFiringTime;	// bots use this.
var		bool	bWantToFire;  // MAT 8/30/04

var		int		AutoSwitchPriority;
var     vector	FireOffset;			// Offset from first person eye position for projectile/trace start

var(DebugShake) 	float	ShakeMag;
var(DebugShake) 	float	ShakeTime;
var(DebugShake) 	vector  ShakeVert;
var(DebugShake)		vector  ShakeSpeed;

var		texture	CrossHair;
var		Powerups Affector;			// powerup chain currently affecting this weapon

var()		float	TraceAccuracy;
var()		float	BotTraceAccuracy;

//-----------------------------------------------------------------------------
// Damage information
//var (Damage) const float DamageModifier;		// constant applied to base damage amount specified in ammunition
var (Damage) float DamageAmount;		// base damage amount done by weapon
var (Damage) float MPDamageAmount;		// base damage amount done by weapon in multiplayer


//-----------------------------------------------------------------------------
// AI information
var		bool	bPlayerOwned;	// MAT 9/28/04
var		bool	bMeleeWeapon;   // Weapon is only a melee weapon
var		bool	bSniping;		// weapon useful for sniping
var		float	AimError;		// Aim Error for bots (note this value doubled if instant hit weapon)
var		float	AIRating;
var		float	CurrentRating;
var		float	TraceDist;		// how far instant hit trace fires go
var		float   MaxRange;		// max range of weapon for non-trace hit attacks
var		Rotator AdjustedAim;

//-----------------------------------------------------------------------------
// Sound Assignments
var() sound 	FireSound;
var() sound 	SelectSound;

// messages
var() Localized string MessageNoAmmo;
var   Localized string WeaponDescription;
var   Color NameColor;	// used when drawing name on HUD

var		bool	bSteadyToggle;
var		bool bForceFire, bForceAltFire;

var string	LeftHandedMesh;	// string of name of left-handed view mesh (if different)
var float DisplayFOV;		// FOV for drawing the weapon in first person view

//-----------------------------------------------------------------------------
// first person Muzzle Flash
// weapon is responsible for setting and clearing bMuzzleFlash whenever it wants the
// MFTexture drawn on the canvas (see RenderOverlays() )

var					float	FlashTime;			// time when muzzleflash will be cleared (set in RenderOverlays())
var(MuzzleFlash)	float	MuzzleScale;		// scaling of muzzleflash
var(MuzzleFlash)	float	FlashOffsetY;		// flash center offset from centered Y (as pct. of Canvas Y size) 
var(MuzzleFlash)	float	FlashOffsetX;		// flash center offset from centered X (as pct. of Canvas X size) 
var(MuzzleFlash)	float	FlashLength;		// How long muzzle flash should be displayed in seconds
var(MuzzleFlash)	float	MuzzleFlashSize;	// size of (square) texture
//Zombie
var(MuzzleFlash)	bool	bUse2DMuzzleFlash;	//Wether or not to use the 2D MuzzleFlash (MFTexture)
//Zombie
var					texture MFTexture;			// first-person muzzle flash sprite
var					byte	FlashCount;			// when incremented, draw muzzle flash for current frame
var					bool	bAutoFire;			// when changed, draw muzzle flash for current frame
var					bool	bMuzzleFlash;		// if !=0 show first-person muzzle flash
var					bool	bSetFlashTime;		// reset FlashTime clock when false
var					bool	bDrawMuzzleFlash;	// enable first-person muzzle flash

//-----------------------------------------------------------------------------
// third person muzzleflash

var		bool		bMuzzleFlashParticles;
var		staticmesh	MuzzleFlashMesh;
var		float		MuzzleFlashScale;
var	ERenderStyle	MuzzleFlashStyle;
var		texture		MuzzleFlashTexture;

var float FireAdjust;

//var(RapidFire) float WeaponFireInterval, WeaponStopFireTime; 	// Auto fire interval   
var() float WeaponFireInterval; 	// Fire interval   
var bool SwitchOnEmpty;	//Whether or not the weapon should auto-switch when it runs out of ammo

var float CrouchBobLateralFactor;
var float CrouchBobVerticalFactor;

// Network replication
//
replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && bNetDirty && (Role==ROLE_Authority) )
		AmmoType, Affector; //, ReloadCount;

	// Functions called by server on client
	reliable if( Role==ROLE_Authority )
		ClientWeaponEvent, ClientWeaponSet, ClientForceReload,Zoom, ClientUpdateReloadCountGuarded, ClientUpdateReloadCount;

	// functions called by client on server
	reliable if( Role<ROLE_Authority )
		ServerForceReload, ServerFire, ServerAltFire, ServerRapidFire, ServerStopFiring, ServerReleaseFire, // ShouldRespondToPressingFire,
		ServerPutDown;
}

// AI Functions
function float RangedAttackTime()
{
	return 0;
}

function bool RecommendRangedAttack()
{ 
	return false;
}

function bool SplashDamage()
{
	return AmmoType.bSplashDamage;
}

function float GetDamageRadius()
{
	return AmmoType.GetDamageRadius();
}

function bool FocusOnLeader(bool bLeaderFiring)
{
	return false;
}
function float RefireRate()
{
	return AmmoType.RefireRate;
}

function bool RecommendSplashDamage()
{
	return AmmoType.bRecommendSplashDamage;
}

function FireHack(byte Mode);

// fixme - make IsFiring() weapon state based
event bool IsFiring()
{
	return ((Instigator != None) && (Instigator.Controller != None)
		&& ((Instigator.Controller.bFire !=0) || (Instigator.Controller.bAltFire != 0)));
}

/* IncrementFlashCount()
Tell WeaponAttachment to cause client side weapon firing effects
*/
simulated function IncrementFlashCount()
{
	FlashCount++;
	if ( WeaponAttachment(ThirdPersonActor) != None )
	{
		WeaponAttachment(ThirdPersonActor).FlashCount = FlashCount;
	//	log("Inc Flash Count: " $ Owner @ ThirdPersonActor);
		WeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
	}
}

simulated static function PrecacheAssets(LevelInfo xLevel);
simulated static function PrecacheSecondaryStaticMeshes(LevelInfo xLevel);

simulated event PostNetBeginPlay()
{
	if ( Role == ROLE_Authority )
		return;
	if ( (Instigator == None) || (Instigator.Controller == None) )
		SetHand(0);
	else
		SetHand(Instigator.Controller.Handedness);
}

/* Force reloading even though clip isn't empty.  Called by player controller exec function,
and implemented in idle state */
simulated function ForceReload();

function ServerForceReload()
{
	bForceReload = true;
}

simulated function ClientForceReload()
{
	bForceReload = true;
	GotoState('Reloading');
}

simulated function bool ShouldAutoReload()
{
	return true;
}

/* DisplayDebug()
list important controller attributes on canvas
*/
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string T;
	local name Anim;
	local float frame,rate;

//	Canvas.TextHeight = 12;
//	Canvas.TextWidth = 12;

	Canvas.SetDrawColor(0,255,0);
	Canvas.DrawText("WEAPON "$GetItemName(string(self)));
	YPos += YL;
	Canvas.SetPos(4,YPos);

	T = "     STATE: "$GetStateName()$" Timer: "$TimerCounter;

	if ( GetDefaultReloadCount() > 0 )
		T = T$" Reload Count: "$GetReloadCount() $" (max:"$ GetDefaultReloadCount() $")";

	Canvas.DrawText(T, false);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	
	if ( DrawType == DT_StaticMesh )		
		Canvas.DrawText("     StaticMesh "$StaticMesh$" AmbientSound "$AmbientSound, false);
	else 
		Canvas.DrawText("     Mesh "$Mesh$" AmbientSound "$AmbientSound, false);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	if ( Mesh != None )
	{
		// mesh animation
		GetAnimParams(0,Anim,frame,rate);
		T = "     AnimSequence "$Anim$" Frame "$frame$" Rate "$rate;
		if ( bAnimByOwner )
			T= T$" Anim by Owner";
		
		Canvas.DrawText(T, false);
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}

	if ( AmmoType == None )
	{
		Canvas.DrawText("ERROR - NO AMMUNITION");
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}
	else
		AmmoType.DisplayDebug(Canvas,YL,YPos);

}

//=============================================================================
// Inventory travelling across servers.

event TravelPostAccept()
{
	Super.TravelPostAccept();
	if ( Pawn(Owner) == None )
		return;
	if ( AmmoName != None )
	{
		AmmoType = Ammunition(Pawn(Owner).FindInventoryType(AmmoName));
		if ( AmmoType == None )
		{		
			AmmoType = Spawn(AmmoName);	// Create ammo type required		
			Pawn(Owner).AddInventory(AmmoType);		// and add to player's inventory
			AmmoType.AmmoAmount = PickUpAmmoCount; 
			AmmoType.GotoState('');
		}
	}
	if ( self == Pawn(Owner).Weapon )
		BringUp();
	else GotoState('');
}

function SetAITarget(Actor T);

function Destroyed()
{
	Super.Destroyed();
	if( (Pawn(Owner)!=None) && (Pawn(Owner).Weapon == self) )
		Pawn(Owner).Weapon = None;
}

// If this is single player, and owner is a human player, returns true (MAT 9/28/04)
function bool isSPHumanPlayer(Pawn Other)
{
	if( PlayerController(Other.controller) != None && Level.NetMode == NM_Standalone )
		return true;
	else
		return false;
}

function GiveTo(Pawn Other)
{
	Super.GiveTo(Other);
	bTossedOut = false;
	Instigator = Other;
	GiveAmmo(Other);
	ClientWeaponSet(true);

	if( isSPHumanPlayer(Other) )
		bPlayerOwned=true;
	else
		bPlayerOwned=false;
}



//=============================================================================
// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	local rotator NewRot;
	local bool bPlayerOwner;
	local int Hand;
	local  PlayerController PlayerOwner;
	local float ScaledFlash;

	DrawCrosshair(Canvas);

	if ( Instigator == None )
		return;

	PlayerOwner = PlayerController(Instigator.Controller);

	if ( PlayerOwner != None )
	{
		bPlayerOwner = true;
		Hand = PlayerOwner.Handedness;
		if (  Hand == 2 )
			return;
	}

	if (bUse2DMuzzleFlash)
	{
		if ( bMuzzleFlash && bDrawMuzzleFlash && (MFTexture != None) )
		{
			if ( !bSetFlashTime )
			{
				bSetFlashTime = true;
				FlashTime = Level.TimeSeconds + FlashLength;
			}
			else if ( FlashTime < Level.TimeSeconds )
			{
				bMuzzleFlash = false;
			}
			if ( bMuzzleFlash )
			{
				ScaledFlash = 0.5 * MuzzleFlashSize * MuzzleScale * Canvas.ClipX/640.0;
				Canvas.SetPos(0.5*Canvas.ClipX - ScaledFlash + Canvas.ClipX * Hand * FlashOffsetX, 0.5*Canvas.ClipY - ScaledFlash + Canvas.ClipY * FlashOffsetY);
				DrawMuzzleFlash(Canvas);
			}
		}
		else
		{
		//	log(self$"::RenderMuzzleFlash,setting flashtime false (weapon)");
			bSetFlashTime = false;
		}
	}

	SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
	NewRot = Instigator.GetViewRotation();

	if ( Hand == 0 )
		newRot.Roll = 2 * Default.Rotation.Roll;
	else
		newRot.Roll = Default.Rotation.Roll * Hand;

	setRotation(newRot);
	Canvas.DrawActor(self, false, true, DisplayFOV);
}


simulated event PostRender( canvas Canvas )
{
	if (Pawn(Owner)!= None && PlayerController(Pawn(Owner).Controller) != None)
	{
		if ( !PlayerController(Pawn(Owner).Controller).bBehindView )
			RenderOverlays(Canvas);
	}
}

simulated event DrawCrosshair( canvas Canvas)
{
	local float XLength;

	if ( CrossHair == None )
		return;
	XLength = 32.0;
	Canvas.bNoSmooth = False;
	Canvas.SetPos(0.503 * (Canvas.ClipX - XLength), 0.504 * (Canvas.ClipY - XLength));
	Canvas.Style = ERenderStyle.STY_Translucent;
	Canvas.SetDrawColor(255,255,255);
	Canvas.DrawTile(CrossHair, XLength, XLength, 0, 0, 32, 32);
	Canvas.bNoSmooth = True;
	Canvas.Style = Style;
}

/* DrawMuzzleFlash()
Default implementation assumes that flash texture can be drawn inverted in X and/or Y direction to increase apparent
number of flash variations
*/
simulated function DrawMuzzleFlash(Canvas Canvas)
{
	local float Scale, ULength, VLength, UStart, VStart;

	Scale = MuzzleScale * Canvas.ClipX/640.0;
	Canvas.Style = ERenderStyle.STY_Translucent;
	ULength = MFTexture.USize;
	if ( FRand() < 0.5 )
	{
		UStart = ULength;
		ULength = -1 * ULength;
	}
	VLength = MFTexture.VSize;
	if ( FRand() < 0.5 )
	{
		VStart = VLength;
		VLength = -1 * VLength;
	}

	Canvas.DrawTile(MFTexture, Scale * MFTexture.USize, Scale * MFTexture.VSize, UStart, VStart, ULength, VLength);
	Canvas.Style = ERenderStyle.STY_Normal;
}

//-------------------------------------------------------
// AI related functions

/* CanAttack()
return true if other is in range of this weapon
*/
function bool CanAttack(Actor Other)
{
	local float MaxDist, CheckDist;
	local vector HitLocation, HitNormal,X,Y,Z, projStart;
	local actor HitActor;

	if ( (Instigator == None) || (Instigator.Controller == None) )
		return false;

	// check that target is within range
	MaxDist = MaxRange;
	if ( AmmoType.bInstantHit )
		MaxDist = TraceDist;
	if ( VSize(Instigator.Location - Other.Location) > MaxDist )
		return false;

	// check that can see target
	if ( !Instigator.Controller.LineOfSightTo(Other) )
		return false;

	// check that would hit target, and not a friendly
	GetAxes(Instigator.Controller.Rotation,X,Y,Z);
	projStart = GetFireStart(X,Y,Z);
	if ( AmmoType.bInstantHit )
		HitActor = Trace(HitLocation, HitNormal, Other.Location + Other.CollisionHeight * vect(0,0,0.7), projStart, true);
	else
	{
		// for non-instant hit, only check partial path (since others may move out of the way)
		CheckDist = FClamp(AmmoType.ProjectileClass.Default.Speed,600, VSize(Other.Location - Location));
		HitActor = Trace(HitLocation, HitNormal, 
				projStart + CheckDist * Normal(Other.Location + Other.CollisionHeight * vect(0,0,0.7) - Location), 
				projStart, true);
	}

	if ( (HitActor == None) || (HitActor == Other) ||
		((Pawn(HitActor) != None) && !Instigator.Controller.SameTeamAs(Pawn(HitActor).Controller)) )
		return true;

	return false;
}

/* AmmoStatus()
return percent of full ammo (0 to 1 range)
*/
function float AmmoStatus()
{
	return float(AmmoType.AmmoAmount)/AmmoType.MaxAmmo;
}

//
// Make sure that ammo type has ammo and weapon has any left 
// in a reload count
//
simulated function bool HasAmmo()
{
	if( AmmoType != None )
		return ((AmmoType.HasAmmo()) || (GetReloadCount() != 0 )) ;
	else
		return false;

}

function bool SplashJump()
{
	return false;
}

/* GetRating()
returns rating of weapon based on its current configuration (no configuration change)
*/
function float GetRating()
{
	return RateSelf(); // don't do this if RateSelf() changes weapon configuration
}

simulated function float RateSelf()
{
    if ( !HasAmmo() )
        CurrentRating = -2;
	else if ( Instigator.Controller == None )
		return 0;
	else
		CurrentRating = Instigator.Controller.RateWeapon(self);
	return CurrentRating;
}

function float GetAIRating()
{
	return AIRating;
}

// return delta to combat style
function float SuggestAttackStyle()
{
// FIXME - implement
//	if ( VSize(Instigator.Target.Location - Instigator.Location) > MaxRange )
//		return 1.0;
	return 0.0;
}

function float SuggestDefenseStyle()
{
	return 0.0;
}

//-------------------------------------------------------

function ClientWeaponEvent(name EventType);

/* HandlePickupQuery()
If picking up another weapon of the same class, add its ammo.
If ammo count was at zero, check if should auto-switch to this weapon.
*/
function bool HandlePickupQuery( Pickup Item )
{
	local int OldAmmo, NewAmmo;
	local Pawn P;

	if (Item.InventoryType == Class)
	{
		if ( WeaponPickup(item).bWeaponStay && ((item.inventory == None) || item.inventory.bTossedOut) )
			return true;
		P = Pawn(Owner);
		if ( AmmoType != None )
		{
			OldAmmo = AmmoType.AmmoAmount;
			if ( Item.Inventory != None )
				NewAmmo = Weapon(Item.Inventory).PickupAmmoCount;
			else
				NewAmmo = class<Weapon>(Item.InventoryType).Default.PickupAmmoCount;
			if ( AmmoType.AddAmmo(NewAmmo) && (OldAmmo == 0) 
				&& (P.Weapon.class != item.InventoryType) )
					ClientWeaponSet(true);
		}
		Item.AnnouncePickup(Pawn(Owner));
		return true;
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// set which hand is holding weapon
simulated function setHand(float Hand)
{
	// If we're deferring loading of player view mesh (e.g. mesh is none until we find out that this 
	// weapon is in fact being used by a player), then don't allow setting of handedness
	if( default.Mesh == None )
		return;

	if ( Hand == 2 )
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		return;
	}

	LinkMesh(Default.Mesh);
	if ( Hand == 0 )
	{
		PlayerViewOffset.X = Default.PlayerViewOffset.X * 0.88;
		PlayerViewOffset.Y = -0.2 * Default.PlayerViewOffset.Y;
		PlayerViewOffset.Z = Default.PlayerViewOffset.Z * 1.12;
	}
	else
	{
		PlayerViewOffset.X = Default.PlayerViewOffset.X;
		PlayerViewOffset.Y = Default.PlayerViewOffset.Y * Hand;
		PlayerViewOffset.Z = Default.PlayerViewOffset.Z;
		if ( (Hand == -1) && (LeftHandedMesh != "") )
		{
			// load left handed mesh
			LinkMesh(mesh(DynamicLoadObject(LeftHandedMesh, class'Mesh')));
		}
	}
	FireOffset.Y = Default.FireOffset.Y * Hand;
}

//
// Change weapon to that specificed by F matching inventory weapon's Inventory Group.
simulated function Weapon WeaponChange( byte F )
{	
	local Weapon newWeapon;
	 
	if ( InventoryGroup == F )
	{
		if (SwitchOnEmpty && !HasAmmo() )
		{
			if ( Inventory == None )
				newWeapon = None;
			else
				newWeapon = Inventory.WeaponChange(F);
			if ( (newWeapon == None) && Instigator.IsHumanControlled() )
				Instigator.ClientMessage( ItemName$MessageNoAmmo );		
			return newWeapon;
		}		
		else 
			return self;
	}
	else if ( Inventory == None )
		return None;
	else
		return Inventory.WeaponChange(F);
}

// Find the previous weapon (using the Inventory group)
simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if ( !SwitchOnEmpty || HasAmmo() )
	{
		if ( (CurrentChoice == None) )
		{
			if ( CurrentWeapon != self )
				CurrentChoice = self;
		}
		else if ( InventoryGroup == CurrentChoice.InventoryGroup )
		{
			if ( InventoryGroup == CurrentWeapon.InventoryGroup )
			{
				if ( (GroupOffset < CurrentWeapon.GroupOffset)
					&& (GroupOffset > CurrentChoice.GroupOffset) )
					CurrentChoice = self;
			}
			else if ( GroupOffset > CurrentChoice.GroupOffset )
				CurrentChoice = self;
		}
		else if ( InventoryGroup > CurrentChoice.InventoryGroup )
		{
			if ( (InventoryGroup < CurrentWeapon.InventoryGroup)
				|| (CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup) )
				CurrentChoice = self;
		}
		else if ( (CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup)
				&& (InventoryGroup < CurrentWeapon.InventoryGroup) )
			CurrentChoice = self;
	}
	if ( Inventory == None )
		return CurrentChoice;
	else
		return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if ( !SwitchOnEmpty || HasAmmo() )
	{
		if ( (CurrentChoice == None) )
		{
			if ( CurrentWeapon != self )
				CurrentChoice = self;
		}
		else if ( InventoryGroup == CurrentChoice.InventoryGroup )
		{
			if ( InventoryGroup == CurrentWeapon.InventoryGroup )
			{
				if ( (GroupOffset > CurrentWeapon.GroupOffset)
					&& (GroupOffset < CurrentChoice.GroupOffset) )
					CurrentChoice = self;
			}
			else if ( GroupOffset < CurrentChoice.GroupOffset )
				CurrentChoice = self;
		}

		else if ( InventoryGroup < CurrentChoice.InventoryGroup )
		{
			if ( (InventoryGroup > CurrentWeapon.InventoryGroup)
				|| (CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup) )
				CurrentChoice = self;
		}
		else if ( (CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup)
				&& (InventoryGroup > CurrentWeapon.InventoryGroup) )
			CurrentChoice = self;
	}
	if ( Inventory == None )
		return CurrentChoice;
	else
		return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);
}

simulated function AnimEnd(int Channel)
{
	if ( Level.NetMode == NM_Client )
		PlayIdleAnim();
}

function GiveAmmo( Pawn Other )
{
	if ( AmmoName == None )
		return;
	AmmoType = Ammunition(Other.FindInventoryType(AmmoName));
	if ( AmmoType != None )
		AmmoType.AddAmmo(PickUpAmmoCount);
	else
	{
		AmmoType = Spawn(AmmoName);	// Create ammo type required		
		Other.AddInventory(AmmoType);		// and add to player's inventory
		AmmoType.AmmoAmount = PickUpAmmoCount; 
	}
}	

// Return the switch priority of the weapon (normally AutoSwitchPriority, but may be
// modified by environment (or by other factors for bots)
simulated function float SwitchPriority() 
{
	if ( !Instigator.IsHumanControlled() )
		return RateSelf();
	else if ( !HasAmmo() )
	{
		if ( Pawn(Owner).Weapon == self )
			return -0.5;
		else
			return -1;
	}
	else 
		return default.AutoSwitchPriority;
}

// Compare self to current weapon.  If better than current weapon, then switch
simulated function ClientWeaponSet(bool bOptionalSet)
{
	local weapon W;

	Instigator = Pawn(Owner); //weapon's instigator isn't replicated to client
	if ( Instigator == None )
	{
		GotoState('PendingClientWeaponSet');
		return;
	}
	else if ( IsInState('PendingClientWeaponSet') )
		GotoState('');
	if ( Instigator.Weapon == self )
		return;

	if ( Instigator.Weapon == None )
	{
		Instigator.PendingWeapon = self;
		Instigator.ChangedWeapon();
		return;	
	}
	if ( bOptionalSet && (Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup) )
		return;
	if ( Instigator.Weapon.SwitchPriority() < SwitchPriority() ) 
	{
		W = Instigator.PendingWeapon;
		Instigator.PendingWeapon = self;
		GotoState('');

		if ( !Instigator.Weapon.PutDown() )
			Instigator.PendingWeapon = W;
		return;
	}
	GotoState('');
}

simulated function Weapon RecommendWeapon( out float rating )
{
	local Weapon Recommended;
	local float oldRating;

	if ( Instigator.IsHumanControlled() )
		rating = SwitchPriority();
	else
	{
		rating = RateSelf();
		if ( (self == Instigator.Weapon) && (Instigator.Controller.Enemy != None) 
			&& HasAmmo() )
			rating += 0.21; // tend to stick with same weapon
			rating += Instigator.Controller.WeaponPreference(self);
	}
	if ( inventory != None )
	{
		Recommended = inventory.RecommendWeapon(oldRating);
		if ( (Recommended != None) && (oldRating > rating) )
		{
			rating = oldRating;
			return Recommended;
		}
	}
	return self;
}

// Toss this weapon out
function Pickup DropFrom(vector StartLocation)
{
	AIRating = Default.AIRating;
	bMuzzleFlash = false;
	if ( AmmoType != None )
	{
		PickupAmmoCount = AmmoType.AmmoAmount;
		AmmoType.AmmoAmount = 0;
	}
	bPlayerOwned=false;
	return Super.DropFrom(StartLocation);
}

//**************************************************************************************
//
// Firing functions and states
//

function ServerStopFiring()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ServerStopFiring    self:"$self.class );
//	StopFiringTime = Level.TimeSeconds;
	bWantToFire=false;  // MAT 8/30/04
}

function ServerRapidFire()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ServerRapidFire    self:"$self.class );
	ServerFire();
	// MAT 8/30/04
//	if ( IsInState('NormalFire') )
//		StopFiringTime = Level.TimeSeconds + WeaponFireInterval;
}
	
function ServerFire()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ServerFire    self:"$self.class );
	if ( AmmoType == None )
	{
		// ammocheck
		log("WARNING "$self$" HAS NO AMMO!!!");
		GiveAmmo(Pawn(Owner));
	}
	if ( HasAmmo() && ReloadCount > 0 )
	{
		GotoState('NormalFire');
	//	ReloadCount--;
		
		if ( AmmoType.bInstantHit )
			TraceFire(TraceAccuracy,0,0);
		else
			ProjectileFire();
		LocalFire();
	}
}

simulated function ReleaseFire(optional float F)
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ReleaseFire    self:"$self.class );
//	log(self$"::ReleaseFire, in weapon");
	bWantToFire=false;  // MAT 8/30/04
	ServerReleaseFire();
}

function ServerReleaseFire()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ServerReleaseFire    self:"$self.class );
//	log(self$"::ServerReleaseFire, in weapon");
	bWantToFire=false;  // MAT 8/30/04
}

simulated function Fire( float Value )
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.Fire    self:"$self.class $"   StopFiringTime:"$StopFiringTime $"  WeaponStopFireTime:"$WeaponStopFireTime $"   WeaponFireInterval:"$WeaponFireInterval );
	if ( !HasAmmo() )
		return;

	ServerFire();  // MAT 8/30/04

	if ( Role < ROLE_Authority )
	{
	//	ReloadCount--;
		LocalFire();
		GotoState('ClientFiring');
	}
}

// Server uses this to force an update of the client's ReloadCount.
simulated function ClientUpdateReloadCount( byte newReloadCount )
{
	ReloadCount = newReloadCount;
}

// Server uses this to force an update of the client's ReloadCount, but only if
// the server amount is less than the client amount.
// This is good for decrementing ammo as shots are fired in a lagged network game.
//  For example, bullets 30, 29 and 28 are fired.  Client has been decrementing its
//  ReloadCount, so it is at 27.  If updates sent by the server are delayed, then
//  the server's "decrement to 29" may be received when the client is already at 27.
//  In that case, this function will leave the client at 27.
simulated function ClientUpdateReloadCountGuarded( byte newReloadCount )
{
	if( newReloadCount < ReloadCount )
		ReloadCount = newReloadCount;
}

simulated function LocalFire()
{
	local PlayerController P;

//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.LocalFire    self:"$self.class );
	ReloadCount--;
	if( Role == ROLE_Authority )
		ClientUpdateReloadCountGuarded(ReloadCount);

	bPointing = true;

	bWantToFire=true;  // MAT 8/30/04

	if ( (Instigator != None) && Instigator.IsLocallyControlled() )
	{
		P = PlayerController(Instigator.Controller);
		if (P!=None)
			P.ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, 1);
	}
	if ( Affector != None )
		Affector.FireEffect();
	PlayFiring();
}

function ServerAltFire()
{
	if ( !IsInState('Idle') )
		GotoState('Idle');
}

/* AltFire()
Weapon mode change.
*/
simulated function AltFire( float Value )
{
	if ( !IsInState('Idle') )
		GotoState('Idle');
	ServerAltFire();
}

simulated function PlayFiring()
{
	//Play firing animation and sound
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
	return (Instigator.Location + Instigator.EyePosition() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z); 
}

function ProjectileFire()
{
	local Vector Start, X,Y,Z;

	Owner.MakeNoise(1.0);
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	Start = GetFireStart(X,Y,Z); 
	AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError);	
	AmmoType.SpawnProjectile(Start,AdjustedAim);	
}

function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Material HitMaterial; 

	Owner.MakeNoise(1.0);
	
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	StartTrace = GetFireStart(X,Y,Z); 
	
	// apply pawn specific aim modification 
	AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 2*AimError);	
	
	// Adjust endpoint of trace (for horizontal and vertical offset and inaccuracy).
	// Essentially, if the YOffset and ZOffset are 0, then converting from Accuracy 
	// factor to a max scatter angle (i.e. weapon could be betweeen +0.5*angle and 
	// -0.5*angle) is as folows:
	//
	//    Max scatter angle = 2 * arctangent( accuracy * 0.5 * 1000 / TraceDistance ) 
	//        where: TraceDist's default is often 10,000 (or 100,000 for sniper rifles).
	//
	// If you don't feel like doing trig (i.e. if you're a normal person):
	//	For TraceDist = 10,000 (and no YOffset or ZOffset):	
	//		Accuracy=0.1 means shot will be within 0.573 deg (or: +/-0.286 deg about aim point)
	//		Accuracy=1.0 means shot will be within 5.72 deg (or: +/-2.86 deg about aim point)
	//	For TraceDist = 10,000 (and no YOffset or ZOffset):	
	//		Accuracy=0.1 means shot will be within 0.0573 deg (or: +/-0.0286 deg about aim point)
	//		Accuracy=1.0 means shot will be within 0.573 deg (or: +/-2.86 deg about aim point)
	//
	// Other notes / more details:
	// * (FRand() - 0.5) returns something between -0.5 and +0.5
	// * The scaling factor of 1000 on each component is not the TraceDist, but usually
	//   more like 1/10th or 1/100th of the TraceDist.  It appears to be a magic number 
	//   chosen because it made things look ok.
	// * If using YOffset or ZOffset, remember that they will be scaled up by 1000.
	EndTrace = StartTrace + (YOffset + Accuracy * (FRand() - 0.5 ) ) * Y * 1000
		+ (ZOffset + Accuracy * (FRand() - 0.5 )) * Z * 1000;

	X = vector(AdjustedAim);
	EndTrace += (TraceDist * X); 
	Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial);
	
	AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z,HitMaterial);
}

//
// need to reaload when 
//		a)	Player hit realod (bForceReload set to true)
//	or	b)  reload count is larger the 0 and 0	
//	and c)	the weapon is not fully loaded
//
simulated function bool NeedsToReload()
{
	return ( (bForceReload || (GetDefaultReloadCount() > 0) && (GetReloadCount() == 0)) /*&& ReloadCount != Default.ReloadCount*/ );
}

/* BotFire()
called by NPC firing weapon.  Weapon chooses appropriate firing mode to use (typically no change)
bFinished should only be true if called from the Finished() function
FiringMode can be passed in to specify a firing mode (used by scripted sequences)
*/
event bool BotFire(bool bFinished, optional float BotAccuracy, optional name FiringMode)
{
	if ( !bFinished && !IsIdle() )
		return false;
	
	// set bot accuracy
	BotTraceAccuracy = BotAccuracy;

	Instigator.Controller.bFire = 1;
	Instigator.Controller.bAltFire = 0;

	Global.ServerFire();

	return true;
}

function bool IsIdle()
{
	return false;
}

// Finish a sequence
function Finish()
{
	local bool bForce, bForceAlt;
	local float RefireRate;

//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.Finish    self:"$self.class $"   StopFiringTime:"$StopFiringTime $"  WeaponStopFireTime:"$WeaponStopFireTime $"   WeaponFireInterval:"$WeaponFireInterval $"  bForce:"$bForce );
	if ( NeedsToReload() && HasAmmo() && ShouldAutoReload() )
	{
		GotoState('Reloading');
		return;
	}

	bForce = bForceFire;
	bForceAlt = bForceAltFire;
	bForceFire = false;
	bForceAltFire = false;

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}

	if ( (Instigator == None) || (Instigator.Controller == None) )
	{
		GotoState('');
		return;
	}

	if ( !Instigator.IsHumanControlled() )
	{
		if ( !HasAmmo() )
		{
			Instigator.Controller.SwitchToBestWeapon();
			if ( bChangeWeapon )
				GotoState('DownWeapon');
			else
				GotoState('Idle');
			return;
		}
		if ( AIController(Instigator.Controller) != None )
		{
			RefireRate = 0.1;
			if ( AmmoType != None )
				RefireRate = AmmoType.RefireRate;

			if ( !AIController(Instigator.Controller).WeaponFireAgain(RefireRate,true) )
			{
				if ( bChangeWeapon )
					GotoState('DownWeapon');
				else
					GotoState('Idle');
			}
			return;
		}
	}
	if ( !HasAmmo() && Instigator.IsLocallyControlled() )
	{
		if (SwitchOnEmpty)
		{
			SwitchToWeaponWithAmmo();
		}
		else
		{
			GotoState('Idle');
		}
		return;
	}
	if ( Instigator.Weapon != self )
	{
		GotoState('Idle');
	}
	//else if ( (/*StopFiringTime > Level.TimeSeconds*/ bWantToFire && ShouldRespondToPressingFire() ) || bForce ) // || (Instigator.PressingFire() && ShouldRespondToPressingFire()) )
	//{
	//	Global.ServerFire();
	//}
	//else if ( bForceAlt ) // || (Instigator.PressingAltFire() && ShouldRespondToPressingFire()) )
	//{
	//	CauseAltFire();
	//}
	else 
	{
		GotoState('Idle');
	}
//	Log("");
}

function SwitchToWeaponWithAmmo()
	{
	// if local player, switch weapon
	Instigator.Controller.SwitchToBestWeapon();
	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}
	else
		GotoState('Idle');
}

function CauseAltFire()
{
	Global.ServerAltFire();
}

simulated function ClientFinish()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ClientFinish    self:"$self.class $"   StopFiringTime:"$StopFiringTime $"  WeaponStopFireTime:"$WeaponStopFireTime $"   WeaponFireInterval:"$WeaponFireInterval );

	if ( (Instigator == None) || (Instigator.Controller == None) )
	{
		GotoState('');
		return;
	}
	if ( NeedsToReload() && HasAmmo() )
	{
		if( ShouldAutoReload() )
		{
		//	Log("  Weapon.ClientFinish    self:"$self.class $"   Needs to reload and has ammo: going to state reloading");
			GotoState('Reloading');
			return;
		}
		else
		{
			// MAT 4/29/04
			PlayIdleAnim();
			GotoState('Idle');
			return;
		}
	}
	if ( !HasAmmo() )
	{
		//Tag:NoAmmo
		if (SwitchOnEmpty)
		{
			Instigator.Controller.SwitchToBestWeapon();
			if ( !bChangeWeapon )
			{
				PlayIdleAnim();
				GotoState('Idle');
				return;
			}
		}
		else
		{
			PlayIdleAnim();
			GotoState('Idle');
			return;
		}
	}
	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
	}
	//else if ( Instigator.PressingFire() && ShouldRespondToPressingFire() )
	//{
	//	Global.Fire(0);
	//}
	else
	{
		//if ( Instigator.PressingAltFire() && ShouldRespondToPressingFire() )
		//	Global.AltFire(0);
		//else
		//{
			PlayIdleAnim();
			GotoState('Idle');
		//}
	}
}

function CheckAnimating();

function bool ShouldRespondToPressingFire()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ShouldRespondToPressingFire   ");
	return true;
}

simulated function bool ClientShouldRespondToPressingFire()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.ClientShouldRespondToPressingFire   ");
	return true;
}

///////////////////////////////////////////////////////
state NormalFire
{
	function CheckAnimating()
	{
		if ( !IsAnimating() )
			warn(self$" stuck in NormalFire and not animating!");
	}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	function Fire(float F) {}
	function AltFire(float F) {} 

	function AnimEnd(int Channel)
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.NormalFire.AnimEnd   Channel:"$Channel );

		// This acts as a backup mechanism for stopping the weapon's firing, 
		// just in case ReleaseFire is broken (i.e. its key binding goes missing).
		if( AIController( Pawn( Owner ).Controller ) != None || (Pawn(Owner).IsLocallyControlled() && Pawn(Owner).controller != None && Pawn(Owner).Controller.bFire==0) )
		{
		//	if( bWantToFire )
		//		Log("    Weapon.NormalFire.AnimEnd is stopping firing!  ----------");
			bWantToFire = false;
		}

		Finish();
		CheckAnimating();
	}

	function Finish()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $"."$ Level.Millisecond $"    Weapon.NormalFire.Finish   RC:"$ ReloadCount ); 

		if( NeedsToReload() || !HasAmmo() || !bWantToFire || !ShouldRespondToPressingFire() )
			Global.Finish();
		else
			Global.ServerFire();
	}

	function EndState()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.NormalFire.EndState    YAAAAAAAAAAA!!!!!!");
	//	StopFiringTime = Level.TimeSeconds;
		bWantToFire = false;
	}

Begin:
	Sleep(0.0);
}

/*
Weapon is up and ready to fire, but not firing.
*/
state Idle
{
	function bool IsIdle()
	{
		return true;
	}

	simulated function ForceReload()
	{
		ServerForceReload();
	}

	function ServerForceReload()
	{
		if ( HasAmmo() )
			GotoState('Reloading');
	}	
	
	simulated function AnimEnd(int Channel)
	{
		PlayIdleAnim();
	}

	simulated event bool PutDown()
	{
		GotoState('DownWeapon');
		return True;
	}

	simulated function LocalFire()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.Idle.LocalFire");
		if( GetReloadCount() != 0 )
			Global.LocalFire();
	}

Begin:
	bPointing=False;
	if ( NeedsToReload() && HasAmmo() && ShouldAutoReload() )
		GotoState('Reloading');
	if (SwitchOnEmpty)
	{
		if ( !HasAmmo() ) 
		{
			Instigator.Controller.SwitchToBestWeapon();  //Goto Weapon that has Ammo
		}
	}
	if( ShouldRespondToPressingFire() )
	{
		if ( Instigator.PressingFire() ) Fire(0.0);
		if ( Instigator.PressingAltFire() ) AltFire(0.0);	
	}
	PlayIdleAnim();
}

// 
// reload manipulation helpers, use these insead of just using variable 
// so derived classes can overload them if neccessary
// TODO: Since HUD insists on doing everything, we need some sort of a string interface 
//		 to retreave this variables.  Weapon should control what it displays in the ammo count
//		 panel.
// 
simulated function int GetReloadCount() { return ReloadCount; }
simulated function int GetDefaultReloadCount() { /*log("a"@Default.ReloadCount);*/ return Default.ReloadCount; }
simulated function int GetAmmoAmount() { if (AmmoType!=None) return AmmoType.AmmoAmount; else return 0;} 

state Reloading
{
	function ServerForceReload() {}
	function ClientForceReload() {}
	function Fire( float Value ) {}
	function AltFire( float Value ) {}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event bool PutDown()
	{
		GotoState('DownWeapon');
		return True;
	}

	simulated function BeginState()
	{
		if ( !bForceReload )
		{
			if ( Role < ROLE_Authority )
				ServerForceReload();
			else
				ClientForceReload();
		}
		bForceReload = false;
		bAmmoAdded = false;
		PlayReloading();
	}

	simulated function AnimEnd(int Channel)
	{
		// If ammo hasn't been added to the weapon by this time, then do it
		if( !bAmmoAdded )
			AddAmmo();
			
		if ( Role < ROLE_Authority )
			ClientFinish();
		else
			Finish();
		CheckAnimating();
	}

	simulated function AddAmmo()
	{
		//
		// Different behavior based on difficulty 
		// (e.g. in hard dump the entire clip) has 
		// been moved to a child class.
		// 

		ReloadCount += AmmoType.RequestReloadAmmo(GetDefaultReloadCount() - GetReloadCount());
		if( Role == ROLE_Authority )
			ClientUpdateReloadCount( ReloadCount );

		bAmmoAdded = true;
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
			warn(self$" stuck in Reloading and not animating!");
	}

	function bool ShouldRespondToPressingFire()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.Reloading.ShouldRespondToPressingFire   ");
		return false;
	}
	simulated function bool ClientShouldRespondToPressingFire()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  Weapon.Reloading.ClientShouldRespondToPressingFire   ");
		return false;
	}
}

/* Active
Bring newly active weapon up.
The weapon will remain in this state while its selection animation is being played (as well as any postselect animation).
While in this state, the weapon cannot be fired.
*/
state Active
{
	function Fire( float Value ) {}
	function AltFire( float Value ) {}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event bool PutDown()
	{
		local name anim;
		local float frame,rate;
		GetAnimParams(0,anim,frame,rate);
		if ( bWeaponUp || (frame < 0.75) )
			GotoState('DownWeapon');
		else
			bChangeWeapon = true;
		return True;
	}

	simulated function BeginState()
	{
//SysLinkSPAM		log("BeginState Active");
	
		Instigator = Pawn(Owner);
		bForceFire = false;
		bForceAltFire = false;
		bWeaponUp = false;
		bChangeWeapon = false;
	}

	simulated function EndState()
	{
		bForceFire = false;
		bForceAltFire = false;
	}

	simulated function AnimEnd(int Channel)
	{
		if ( bChangeWeapon )
			GotoState('DownWeapon');
		if ( Owner == None )
		{
		//	log(self$" no owner");
			Global.AnimEnd(0);
			GotoState('');
		}
		else if ( bWeaponUp )
		{
			if ( Role == ROLE_Authority )
				Finish();
			else
				ClientFinish();
		}
		else
		{
			PlayPostSelect();
			bWeaponUp = true;
		}
		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
			warn(self$" stuck in Active and not animating!");
	}
}

/* DownWeapon
Putting down weapon in favor of a new one.  No firing in this state
*/
State DownWeapon
{
	function Fire( float Value ) {}
	function AltFire( float Value ) {}

	function ServerFire() {}
	function ServerAltFire() {}

	simulated event bool PutDown()
	{
		return true; //just keep putting it down
	}

	simulated function AnimEnd(int Channel)
	{
		if (bGoInactiveAfterDown)
			GotoState('DownAndInactive');
		else
			Pawn(Owner).ChangedWeapon();
	}

	simulated function BeginState()
	{
		bChangeWeapon = false;
		bMuzzleFlash = false;
		TweenDown();
		ServerPutDown();
	}
}

/* 
Fire on the client side. This state is only entered on the network client of the player that is firing this weapon. 
*/
state ClientFiring
{
	function Fire( float Value ) {}
	function AltFire( float Value ) {}

	simulated function AnimEnd(int Channel)
	{
		// This acts as a backup mechanism for stopping the weapon's firing, 
		// just in case ReleaseFire is broken (i.e. its key binding goes missing).
		if( Pawn(Owner).IsLocallyControlled() && Pawn(Owner).controller != None && Pawn(Owner).Controller.bFire==0 )
		{
		//	if( bWantToFire )
		//		Log("    WeapM249MachineGun.ClientFiring.AnimEnd is stopping firing!  ----------");
			bWantToFire = false;
			ServerStopFiring();
		}

		ClientFinish();
		CheckAnimating();
	}

	simulated function ClientFinish()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"   Weapon.ClientFiring.ClientFinish");

		if( NeedsToReload() || !HasAmmo() || !bWantToFire || !ShouldRespondToPressingFire() )
			Global.ClientFinish();
		else
			LocalFire();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
			warn(self$" stuck in ClientFiring and not animating!");
	}

	simulated function EndState()
	{
		AmbientSound = None;

		// MAT 8/30/04
		bWantToFire=false;
		ServerStopFiring();
	}
}

/* PendingClientWeaponSet
Weapon on network client side may be set here by the replicated function ClientWeaponSet(), to wait,
if needed properties have not yet been replicated.  ClientWeaponSet() is called by the server to 
tell the client about potential weapon changes after the player runs over a weapon (the client 
decides whether to actually switch weapons or not.
*/
State PendingClientWeaponSet
{
	simulated function Timer()
	{
		if ( Pawn(Owner) != None )
			ClientWeaponSet(false);
	}

	simulated function BeginState()
	{
		SetTimer(0.05, true);
	}

	simulated function EndState()
	{
		SetTimer(0.0, false);
	}
}

simulated function BringUp()
{
	if ( Instigator.IsHumanControlled() )
	{
//SysLinkSPAM		log("BringUp: human");
	
		SetHand(PlayerController(Instigator.Controller).Handedness);
		PlayerController(Instigator.Controller).EndZoom();
	}	
	bWeaponUp = false;
	PlaySelect();
	
//SysLinkSPAM	log("BringUp: GotoState('Active')");
	
	GotoState('Active');
}

function ServerPutDown()
{
	GotoState('DownWeapon');
}

simulated event bool PutDown()
{
	bChangeWeapon = true;
	return true; 
}

simulated function TweenDown()
{
	local name Anim;
	local float frame,rate;

	if ( IsAnimating() && AnimIsInGroup(0,'Select') )
	{
		GetAnimParams(0,Anim,frame,rate);

	//	log("TweenDown: Tween " $ Anim);

		TweenAnim( Anim, frame * 0.4 );
	}
	else
	{
	//	log("TweenDown: PlayAnim'Down'");
		PlayAnim('Down', 1.0, 0.05);
	}
}

simulated function PlayReloading()
{
	AnimEnd(0);
}

simulated function PlaySelect()
{
	bForceFire = false;
	bForceAltFire = false;
	if ( !IsAnimating() || !AnimIsInGroup(0,'Select') )
		PlayAnim('Select',1.0,0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, 1.0);	
}

simulated function PlayPostSelect()
{
	GotoState('Idle');
	AnimEnd(0);
}

simulated function PlayIdleAnim(optional bool bForceSubtle)
{
}

simulated function zoom();

simulated event bool IsFullyZoomed() { return false; }
simulated event bool IsZooming() { return false; }

state DownAndInactive
{
	function Fire( float Value ) {}
	function AltFire( float Value ) {}

	function ServerFire() {}
	function ServerAltFire() {}

	simulated event bool PutDown()
	{
		return true; //just keep putting it down
	}

	event BeginState()
	{
	}
	event EndState()
	{
		bGoInactiveAfterDown=false;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    bCanThrow=true
    AutoSwitchPriority=1
    ShakeMag=300.0000000
    shaketime=0.1000000
    ShakeVert=(X=0.0000000,Y=0.0000000,Z=5.0000000)
    ShakeSpeed=(X=100.0000000,Y=100.0000000,Z=100.0000000)
    DamageAmount=10.0000000
    aimerror=550.0000000
    AIRating=0.5000000
    CurrentRating=0.5000000
    TraceDist=10000.0000000
    MaxRange=8000.0000000
    MessageNoAmmo=" has no ammo."
    NameColor=(R=255,G=255,B=255,A=255)
    DisplayFOV=85.0000000
    MuzzleScale=1.0000000
    FlashLength=0.1000000
    bUse2DMuzzleFlash=true
    FireAdjust=1.0000000
    CrouchBobLateralFactor=3.0000000
    CrouchBobVerticalFactor=2.0000000
    InventoryGroup=1
    PlayerViewOffset=(X=30.0000000,Y=0.0000000,Z=-5.0000000)
    AttachmentClass=Class'WeaponAttachment'
    Icon=Texture'S_Weapon'
    ItemName="Weapon"
    DrawType=2
    bReplicateInstigator=true
}