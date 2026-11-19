
class ShotgunAmmo extends SFRMAmmunition;

var int pelletCounter;
var int HitSoundCounter;
var int FriendlyFireSoundCounter;

function FinishTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z, optional Material MaterialHit)
{
	local byte byteType;
	local Actor ImpactActor; 
	local ZombiePlayerPawn P;
	local ZombieWeapon ZWeap; 
	local float FalloffModifier, Dist;

	ZWeap = ZombieWeapon(W);

	// Calculate modifier to reduce damage at long range
	Dist = VSize( W.Location - HitLocation );
	FalloffModifier = 1.0;
	if( W.TraceDist > 0 )
	{
		if( Dist > W.TraceDist * 0.10 )  // Full damage out to 10% max distance
			FalloffModifier = 1.0-0.90*(Dist-W.TraceDist*0.10)/(W.TraceDist*0.90);  // Falls off to 0.10 at max range
	}
//	Log(" dist:"$ dist/24 $" ft  FalloffModifier:"$ FalloffModifier $"  sp dmg:"$ ZWeap.default.DamageAmount*FalloffModifier $"  mp dmg:"$ ZWeap.default.MPDamageAmount*FalloffModifier );
	
	// Apply weapon specific damage modifier
	Other.TakeDamage(W.DamageAmount * FalloffModifier, W.Instigator, HitLocation, MomentumTransfer*X, MyDamageType);

	// Bullet hole
	if( Level.Game.bShowBulletHoles  
	 &&	Other.bShowBulletHoles 
	 && MaterialHit != None   // MAT 2/17/05
	 && MaterialHit.MaterialType != EMATERIALTYPE_WATER 
	 && MaterialHit.MaterialType != EMATERIALTYPE_SKY )
	{
	//	 ZombiePlayerPawn(instigator).BulletHoleMgr.NewBulletHole( HitLocation, HitNormal );
	//	Level.NewBulletHole( HitLocation, HitNormal );
		if( Level.NetMode == NM_Standalone )
			Level.NewBulletHole( HitLocation, HitNormal );
		else
			ClientNewBulletHole( HitLocation.X, HitLocation.Y, HitLocation.Z, (HitNormal*1000) );  // PC: bullet holes in multiplayer too
	}

	// Impact effect (e.g. dust kicked up)
	if (ZWeap != None && ZWeap.bOverwriteBulletImpact)
		ZWeap.SpawnImpactEffect(Other, Self, HitLocation, HitNormal, byteType);
		
	if(ZombiePlayerPawn(W.Instigator) == None)
	{
		//Don't do this if it can't be seen by a player.
		ForEach RadiusActors(class'ZombiePlayerPawn', P, 600,HitLocation)
		{
			break;		
		}

		if(P == None)
		{
			return;
		}
	}
	
	if( MaterialHit != None )
		byteType = MaterialHit.MaterialType; 
	else
		byteType = 0;

	// Limit the number of impact effects that get spawned
	if( PelletCounter < 5 || PelletCounter % 2 == 0 )
		ImpactActor = class'BulletImpactEffects'.Static.SpawnImpactEffect(Other, Self, HitLocation, HitNormal, byteType); 
	
	if ( HitSoundCounter == 0 && (Other != None && Other.bWorldGeometry || (Mover(Other) != None)) && ImpactActor != None )
	{
		ImpactActor.PlaySound(RandomBulletImpactSounds[byteType],, 1,,30, ,true);
		HitSoundCounter++;
	}

	PelletCounter++;
	if( PelletCounter >= 10 || (Level.NetMode != NM_Standalone && PelletCounter >= 4) )
	{
		PelletCounter = 0;
		HitSoundCounter = 0;
		FriendlyFireSoundCounter = 0;
	}
}

function Projectile SpawnProjectileEx(vector Start, rotator Dir, float SpeedMod, float TimeDelta)
{
	SpawnProjectile(Start, Dir); 
	return None; 
}


// Decompiled with UE Explorer.
defaultproperties
{
    MaxAmmo=300
    AmmoAmount=30
    bInstantHit=true
    MyDamageType=Class'ZombieGame.DamageTypeShotgun'
    MomentumTransfer=3000.0000000
    PickupClass=Class'AmmoPickupShotgun'
    ItemName="Shotgun Ammo"
}