class M4Attach extends ZombieWeaponAttachment;

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
    MuzzleOffset=(X=60.0000000,Y=-8.5000000,Z=0.0000000)
    MuzzleOffsetPoint=(X=60.0000000,Y=-20.0000000,Z=5.0000000)
    MuzzleRotationOffset=(Pitch=0,Yaw=16384,Roll=0)
    EffectLocationOffset=(X=60.0000000,Y=0.0000000,Z=5.0000000)
    BrassEffectClass=Class'ZombieEffects.brassEjection'
    BrassThirdPersonOffset=(X=13.0000000,Y=0.0000000,Z=7.0000000)
    DrawScale=0.9000000
}