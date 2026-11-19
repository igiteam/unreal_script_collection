//=============================================================================
// Ammunition: the base class of weapon ammunition
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================

class Ammunition extends Inventory
	abstract
	native
	nativereplication;

var travel int MaxAmmo;						// Max amount of ammo
var travel int AmmoAmount;					// Amount of Ammo current available
var travel int PickupAmmo;					// Amount of Ammo to give when this is picked up for the first time	

// Used by Bot AI

var		bool	bRecommendSplashDamage;
var		bool	bTossed;
var		bool	bTrySplash;
var		bool	bLeadTarget;
var		bool	bInstantHit;
var		bool	bSplashDamage;	


// Damage and Projectile information

var class<Projectile> ProjectileClass;
var class<DamageType> MyDamageType;
var float WarnTargetPct;
var float RefireRate;

var	float	DamageAmount;		// How much damage is done.
var float	MomentumTransfer;	// Momentum magnitude imparted by impact


var Sound FireSound;

var float MaxAutoAimRange; 

// Network replication
//

replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && bNetDirty && (Role==ROLE_Authority) )
		AmmoAmount;
}


simulated function bool HasAmmo()
{
	if(instigator!=None && instigator.controller!=None && instigator.controller.bInfiniteAmmo )
		return true;
	else
		return ( AmmoAmount > 0 );
}

function float RateSelf(Pawn Shooter, out name RecommendedFiringMode)
{
	return 0.5;
}

function WarnTarget(Actor Target,Pawn P ,vector FireDir)
{
	if ( bInstantHit )
		return;
	if ( (FRand() < WarnTargetPct) && (Pawn(Target) != None) && (Pawn(Target).Controller != None) ) 
		Pawn(Target).Controller.ReceiveWarning(P, ProjectileClass.Default.Speed, FireDir); 
}

function SpawnProjectile(vector Start, rotator Dir)
{
	Spawn(ProjectileClass,,, Start,Dir);	
}

function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z,optional Material MaterialHit)
{
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	Canvas.DrawText("Ammunition "$GetItemName(string(self))$" amount "$AmmoAmount$" Max "$MaxAmmo);
	YPos += YL;
	Canvas.SetPos(4,YPos);
}
	
function bool HandlePickupQuery( pickup Item )
{
	if ( class == item.InventoryType ) 
	{
		if (AmmoAmount==MaxAmmo) 
			return true;
		item.AnnouncePickup(Pawn(Owner));
		AddAmmo(Ammo(item).AmmoAmount);
        item.SetRespawn(); 
		return true;				
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// If we can, add ammo and return true.  
// If we are at max ammo, return false
//
function bool AddAmmo(int AmmoToAdd)
{
	AmmoAmount = Min(MaxAmmo, AmmoAmount+AmmoToAdd);
	return true;
}

function float GetDamageRadius()
{
	if ( ProjectileClass != None )
		return ProjectileClass.Default.DamageRadius;

	return 0;
}

//
// check to see if we have enough ammo to handle reload count, 
// and if not, return the remainder and adjust total ammo count 
// accordingly 
//

function float RequestReloadAmmo(float RequestedReloadCount )
{
	local int AvailableAmmoCount; 
	
	if (RequestedReloadCount == 0) return 0; 
	
	// figure out how much ammo is left and if the reqest can be covered
	AvailableAmmoCount = Min(RequestedReloadCount, AmmoAmount); 
	
	// adjust total ammo count
//	Log("Ammunition.RequestReloadAmmo   instigator:"$instigator );
	if( instigator.controller != None && instigator.controller.bInfiniteAmmo )
	{
		if( AvailableAmmoCount == 0 )
			AvailableAmmoCount = RequestedReloadCount;
	}
	else
		AmmoAmount -= AvailableAmmoCount;

	return 	AvailableAmmoCount; 
}

function Sound GetRandomBulletImpactSound(byte byteType);

// Decompiled with UE Explorer.
defaultproperties
{
    MyDamageType=Class'DamageType'
    WarnTargetPct=0.5000000
    RefireRate=0.5000000
    MaxAutoAimRange=5000.0000000
}