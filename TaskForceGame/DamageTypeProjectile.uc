
class DamageTypeProjectile extends SFRMDamageType abstract;
	
var() float DamageThreshholdShake;
var() float fShakeTimeMin;

// Overriding base class function so shake can be scaled based on damage amount
static function ShakeView(Controller C, optional float Damage, optional bool bMP )
{
	local float DamageFactor;

	DamageFactor = FMin(Damage+5,30)/30.0;

	if(default.bShakeView && Damage >= default.DamageThreshholdShake)
	{
		// -ShakeTime scales up with Damage
		//   -Floor is set by fShakeTimeMin.
		//   -For this calc, Damage is capped so that it will achieve a 
		//    duration of fShakeTime at a Damage of 45 or above.
		// -Max shake offset scales up with Damage (also hits max at 45).
	//	PlayerController(C).SetupShake ( FMax(default.fShakeTimeMin, default.fShakeTime*FMin(Damage+5,50)/50.0 ), default.vMaxShakeOffset*(FMin(Damage+5,50)/50.0), 
	//									default.fShakeUpdateRate, default.ShakeBlur, default.ShakeBlurAlpha);
		if( bMP )
		{
			PlayerController(C).SetupShake ( FMax(default.fShakeTimeMin, default.fShakeTime*DamageFactor )*0.8, default.vMaxShakeOffset*DamageFactor, 
											default.fShakeUpdateRate, false, 0);
		}
		else
		{
			PlayerController(C).SetupShake ( FMax(default.fShakeTimeMin, default.fShakeTime*DamageFactor ), default.vMaxShakeOffset*DamageFactor, 
											default.fShakeUpdateRate, default.ShakeBlur, default.ShakeBlurAlpha);
		}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    fShakeTimeMin=1.1000000
    bNoSpecificLocation=true
    FlashScale=0.2500000
    FlashFog=(X=0.3500000,Y=0.1000000,Z=0.0000000)
    DamageDesc=16
    bShakeView=true
    fShakeTime=1.6000000
    vMaxShakeOffset=(X=16.0000000,Y=16.0000000,Z=12.0000000)
    fShakeUpdateRate=0.0100000
    ShakeBlur=true
    ShakeBlurAlpha=128
}