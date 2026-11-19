
class SFRMDamageType extends DamageType	abstract;

//var bool bIgnoreFriendlyFire;	//If set, this damage type ignores friendly fire rules and always does full damage

var()	array<Sound>	HeavyPawnDamageSounds;

var()	float			PlayerHeadDamageFactor;
var()	float			PlayerTorsoDamageFactor;
var()	float			PlayerArmDamageFactor;
var()	float			PlayerLegDamageFactor;

var()	float			HeadDamageFactorArr[4];
var()	float			TorsoDamageFactorArr[4];
var()	float			ArmDamageFactorArr[4];
var()	float			LegDamageFactorArr[4];

static function Sound GetPawnDamageSound(Pawn P)
{
	if( P.Health > 20 )
	{
		return Default.PawnDamageSounds[Rand(Default.PawnDamageSounds.Length)];
	}
	else
	{
		return Default.HeavyPawnDamageSounds[Rand(Default.HeavyPawnDamageSounds.Length)];
	}
}

static function ShakeView(Controller C, optional float Damage, optional bool bMP )
{
	if(default.bShakeView)
	{
		if( bMP )
		{
			// Shake offset gets scaled up at smaller FOV (force MP version)
			PlayerController(C).SetupShake (default.fShakeTime*0.75, 
				default.vMaxShakeOffset*( 1.0 - (PlayerController(C).FOVAngle-70.0)/110.0 ), 
				default.fShakeUpdateRate, 
				false, 0);
		}
		else
		{
			// Shake offset gets scaled up at smaller FOV (normal version)
			PlayerController(C).SetupShake (default.fShakeTime, 
				default.vMaxShakeOffset*( 1.0 - (PlayerController(C).FOVAngle-70.0)/110.0 ), 
				default.fShakeUpdateRate, 
				default.ShakeBlur, default.ShakeBlurAlpha);
		}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    HeavyPawnDamageSounds[0]=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_flesh1'
    PawnDamageSounds=/* Array type was not detected. */
    bCausesImpactSound=true
}