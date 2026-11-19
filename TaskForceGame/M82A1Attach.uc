class M82A1Attach extends ZombieWeaponAttachment;

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
    MuzzleClass=Class'ZombieGame.M4MuzzleFlash'
    MuzzleOffset=(X=80.0000000,Y=-12.5000000,Z=2.0000000)
    MuzzleOffsetPoint=(X=60.0000000,Y=-25.0000000,Z=15.0000000)
    MuzzleRotationOffset=(Pitch=0,Yaw=16384,Roll=0)
    EffectLocationOffset=(X=60.0000000,Y=0.0000000,Z=5.0000000)
    BrassEffectClass=Class'ZombieEffects.brassEjection'
    BrassThirdPersonOffset=(X=13.0000000,Y=0.0000000,Z=7.0000000)
    ThirdPersonSound[0]=Sound'CBW_DYN_weapons.Sniper.Sniper_FireIndoor_3rd1'
    ThirdPersonSound[1]=Sound'CBW_DYN_weapons.Sniper.Sniper_FireOutdoor_3rd1'
    DrawScale=0.9000000
}