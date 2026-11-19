class MP5Attach extends ZombieWeaponAttachment;

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
    MuzzleOffset=(X=55.0000000,Y=-8.0000000,Z=0.0000000)
    MuzzleOffsetPoint=(X=55.0000000,Y=-20.0000000,Z=5.0000000)
    MuzzleRotationOffset=(Pitch=0,Yaw=16384,Roll=0)
    EffectLocationOffset=(X=60.0000000,Y=0.0000000,Z=5.0000000)
    BrassEffectClass=Class'ZombieEffects.brassEjection'
    BrassThirdPersonOffset=(X=13.0000000,Y=0.0000000,Z=7.0000000)
    ThirdPersonSound[0]=Sound'CBW_DYN_weapons.MP5SD.MP5SD_FireIndoor_3rd1'
    ThirdPersonSound[1]=Sound'CBW_DYN_weapons.MP5SD.MP5SD_FireOutdoor_3rd1'
    DrawScale=0.9000000
}