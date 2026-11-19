//=============================================================================
// DamageType, the base class of all damagetypes.
// this and its subclasses are never spawned, just used as information holders
//=============================================================================
class DamageType extends Actor
	native
	abstract;

// Description of a type of damage.
var() localized string     DeathString;	 					// string to describe death by this type of damage
var() localized string		FemaleSuicide, MaleSuicide;	
var() float                ViewFlash;    					// View flash to play.
var() vector               ViewFog;      					// View fog to play.
var() class<effects>       DamageEffect; 					// Special effect.
var() string			   DamageWeaponName; 				// weapon that caused this damage
var() bool					bArmorStops;					// does regular armor provide protection against this damage
var() bool					bInstantHit;					// done by trace hit weapon
var() bool					bFastInstantHit;				// done by fast repeating trace hit weapon
var() bool                  bAlwaysGibs;
var() bool                  bNoSpecificLocation;
var() bool                  bSkeletize;         // swap model to skeleton
var() bool					bCausesBlood;
var() bool					bKUseOwnDeathVel;	// For ragdoll death. Rather than using default - use death velocity specified in this damage type.

var() float					GibModifier;

// these effects should be none if should use the pawn's blood effects
var() class<Effects>		PawnDamageEffect;	// effect to spawn when pawns are damaged by this damagetype
var() class<Emitter>		PawnDamageEmitter;	// effect to spawn when pawns are damaged by this damagetype
var() array<Sound>			PawnDamageSounds;	// Sound Effect to Play when Damage occurs	

var() class<Effects>		LowGoreDamageEffect; 	// effect to spawn when low gore
var() class<Emitter>		LowGoreDamageEmitter;	// Emitter to use when it's low gore
var() array<Sound>			LowGoreDamageSounds;	// Sound Effects to play with Damage occurs with low gore 	

var() class<Effects>		LowDetailEffect;		// Low Detail effect
var() class<Emitter>		LowDetailEmitter;		// Low Detail emitter	

var() float					FlashScale;		//for flashing victim's screen
var() vector				FlashFog;

var() int					DamageDesc;			// Describes the damage
var() int					DamageThreshold;	// How much damage much occur before playing effects
var() vector				DamageKick;	

var(Karma)	float			KDamageImpulse;		// magnitude of impulse applied to KActor due to this damage type.
var(Karma)  float			KDeathVel;			// How fast ragdoll moves upon death
var(Karma)  float			KDeathUpKick;		// Amount of upwards kick ragdolls get when they die

struct native ImpactEffect
{
	var() class <Emitter>	EmitterClass; 
	var() bool				bInverseRotation;
};

var() export array< ImpactEffect >	HitEffectList;	// emitter list that should be spawn when a hit effect occurs

var() range		PlayerDamageModifier[4];				// modifier applied to the player
const MP_DAMAGE_DIFF = 2;

var() bool		bShakeView;
var() float		fShakeTime;
var() vector	vMaxShakeOffset;
var() float		fShakeUpdateRate;
var() bool		ShakeBlur;
var() int		ShakeBlurAlpha;

var() bool		bPlayRumble;

var() bool		bCausesImpactSound;

var bool bIgnoreFriendlyFire;	//If set, this damage type ignores friendly fire rules and always does full damage

static function IncrementKills(Controller Killer);

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
	return Default.DeathString;
}

static function string SuicideMessage(PlayerReplicationInfo Victim)
{
	if ( Victim.bIsFemale )
		return Default.FemaleSuicide;
	else
		return Default.MaleSuicide;
}

static function SpawnGettingHitEffects( vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail )
{
	local int index; 
	local vector BloodOffset, Mo, HitNormal;
	
	// early breakout
	if (Default.HitEffectList.Length == 0) return; 
	
	HitNormal		= Normal(HitLocation - Victim.Location);
	BloodOffset		= 0.2 *  HitNormal;
	BloodOffset.Z	= BloodOffset.Z * 0.5;

	Mo = Momentum;
	if ( Mo.Z > 0 )
		Mo.Z *= 0.5;
		
	if ( class'GameInfo'.static.UseLowGore() )
	{
	}
	else if ( bLowDetail )
	{
		Victim.Spawn(Default.HitEffectList[index].EmitterClass,Victim,,HitLocation + BloodOffset,rotator(Mo));
	}
	else
	{
		for ( index = 0; index < Default.HitEffectList.Length; index++ )
		{
			if (Default.HitEffectList[index].bInverseRotation)
				Victim.Spawn(Default.HitEffectList[index].EmitterClass,Victim,,HitLocation + BloodOffset,rotator(-Mo));
			else
				Victim.Spawn(Default.HitEffectList[index].EmitterClass,Victim,,HitLocation + BloodOffset,rotator(Mo));
		}
	}
}


static function Sound GetPawnDamageSound(optional Pawn P)
{
	if ( class'GameInfo'.static.UseLowGore() )
	{
		if (Default.LowGoreDamageSounds.Length>0)
			return Default.LowGoreDamageSounds[Rand(Default.LowGoreDamageSounds.Length)];
		else
			return none;
	}
	else
	{
		if (Default.PawnDamageSounds.Length>0)
			return Default.PawnDamageSounds[Rand(Default.PawnDamageSounds.Length)];
		else
			return none;
	}
}

static function bool IsOfType(int Description)
{
	local int result;
	
	result = Description & Default.DamageDesc;
	return (result == Description);
} 

static function string GetWeaponClass()
{
	return "";
}

static event range GetPlayerDamageModifier(LevelInfo theLevel)
{
	return default.PlayerDamageModifier[0];
}

static function FlashClient(Controller C, optional Vector momentum)
{
	if ( PlayerController ( C ) != None )
	{
		PlayerController(C).ClientFlash(default.FlashScale, default.FlashFog);
		PlayerController(C).ViewFlash(0.1f);
	}
}

static function ShakeView(Controller C, optional float Damage, optional bool bMP )
{
	if(default.bShakeView)
	{
		if( bMP )
			PlayerController(C).SetupShake (default.fShakeTime, default.vMaxShakeOffset, default.fShakeUpdateRate, false, 0 );
		else
			PlayerController(C).SetupShake (default.fShakeTime, default.vMaxShakeOffset, default.fShakeUpdateRate, default.ShakeBlur, default.ShakeBlurAlpha);
	}
}

static function class<Effects> GetPawnDamageEffect( vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail )
{
	return Default.PawnDamageEffect;
}

static function float GetMPHitLocDamageModifier( EHitLocation HumanHitLoc );


// Decompiled with UE Explorer.
defaultproperties
{
    DeathString="%o was killed by %k."
    FemaleSuicide="%o killed herself."
    MaleSuicide="%o killed himself."
    ViewFlash=0.1000000
    bArmorStops=true
    GibModifier=1.0000000
    FlashScale=1.0000000
    DamageDesc=1
    DamageThreshold=5000
    KDamageImpulse=8000.0000000
    PlayerDamageModifier[0]=(Min=1.0000000,Max=1.0000000)
    PlayerDamageModifier[1]=(Min=1.0000000,Max=1.0000000)
    PlayerDamageModifier[2]=(Min=1.0000000,Max=1.0000000)
    PlayerDamageModifier[3]=(Min=1.0000000,Max=1.0000000)
    bPlayRumble=true
}