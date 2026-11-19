
class DamageTypeBullet extends SFRMDamageType abstract;

var float MPHeadshotDamageModifier;
var float MPLegshotDamageModifier;

static function float GetMPHitLocDamageModifier( EHitLocation HumanHitLoc )
{
	local float MPDamageFactor;
	MPDamageFactor = 1.0;
	switch ( HumanHitLoc )
	{
		// head
		case HITLOC_Head:
			MPDamageFactor = default.MPHeadshotDamageModifier;
			break;
		// legs
		case HITLOC_UpperRightLeg:
		case HITLOC_LowerRightLeg:
		case HITLOC_UpperLeftLeg:
		case HITLOC_LowerLeftLeg:
			MPDamageFactor = default.MPLegshotDamageModifier;
			break;
	}
	return MPDamageFactor;
}


// Decompiled with UE Explorer.
defaultproperties
{
    MPHeadshotDamageModifier=1.0000000
    MPLegshotDamageModifier=1.0000000
    FlashScale=0.3000000
    FlashFog=(X=0.3500000,Y=0.0000000,Z=0.0000000)
    DamageDesc=2
    KDamageImpulse=15000.0000000
    bShakeView=true
    fShakeTime=0.0500000
    vMaxShakeOffset=(X=5.0000000,Y=5.0000000,Z=6.5000000)
    fShakeUpdateRate=0.0050000
}