class USPAttach extends ZombieWeaponAttachment;

var bool bSnipe;
var vector HitLoc;

replication
{
	// Things the server should send to the client.
	unreliable if( bNetDirty && !bNetOwner && (Role==ROLE_Authority) )
		bSnipe, HitLoc;
}


// Decompiled with UE Explorer.
defaultproperties
{
    MuzzleClass=Class'ZombieGame.SOCOMMuzzleFlash'
    MuzzleOffset=(X=26.0000000,Y=-6.0000000,Z=0.0000000)
    MuzzleOffsetPoint=(X=30.0000000,Y=-5.0000000,Z=0.0000000)
    MuzzleRotationOffset=(Pitch=0,Yaw=16384,Roll=0)
    EffectLocationOffset=(X=22.0000000,Y=2.0000000,Z=4.0000000)
    BrassEffectClass=Class'ZombieEffects.brassEjection'
    BrassThirdPersonOffset=(X=9.0000000,Y=0.0000000,Z=7.0000000)
    ThirdPersonSound[0]=Sound'CBW_DYN_weapons.USP45.USP45_FireIndoor_3rd1'
    ThirdPersonSound[1]=Sound'CBW_DYN_weapons.USP45.USP45_FireOutdoor_3rd1'
    RelativeLocation=(X=0.0000000,Y=1.0000000,Z=0.0000000)
    DrawScale=0.1000000
}