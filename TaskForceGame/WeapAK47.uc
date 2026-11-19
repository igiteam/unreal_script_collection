//===============================================================================
//  [Kalashnikov AK-47]  
//
//  This weapon is intended to be used by NPC's, not players.
//  It uses M4 PV anims, but will have a seperate ZombieWeaponAttachment
//  so that AI will look like they're holding AK's.
//===============================================================================

class WeapAK47 extends ZombieWeapon
	ignoredigitwarning;

#exec ANIM IMPORT ANIM=M4Anims ANIMFILE=..\Animations\PSA\pv_m4_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M4Anims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=M4Anims SEQ=shoot FRAME=1.0 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=M4Anims SEQ=reload FRAME=15.0 FUNCTION=AddAmmo

#exec ANIM IMPORT ANIM=M4WeapAnims ANIMFILE=..\Animations\PSA\pv_m4_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M4WeapAnims USERAWINFO VERBOSE



// Decompiled with UE Explorer.
defaultproperties
{
    PVMeshName="CBA_PV_Weapons.PV_HANDS"
    WeaponSpread[0]=0.0980000
    WeaponSpread[1]=0.1470000
    WeaponSpread[2]=0.1960000
    WeaponSpread[3]=0.1960000
    MinScatterFactor=0.3000000
    MinScatterFactorZoomed=0.1000000
    MaxScatterFactorZoomed=0.9000000
    ZoomPlayerViewOffset=(X=3.5000000,Y=-4.0000000,Z=0.7000000)
    ZoomRotationOffset=(Pitch=0,Yaw=1000,Roll=300)
    LeanPlayerViewOffset=(X=-3.0000000,Y=-13.0000000,Z=-1.0000000)
    LeanRotationOffset=(Pitch=0,Yaw=1200,Roll=0)
    ZoomLeanPlayerViewOffset=(X=3.0000000,Y=-5.6500000,Z=0.3000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=1200,Roll=300)
    BotFireRate=0.8000000
    BotBulletInterval=0.0800000
    bFireTracer=true
    vMuzzleFlashLocalOffset=(X=-200.0000000,Y=-100.0000000,Z=0.0000000)
    BrassStartVelocityRange=(X=(Min=-110.0000000,Max=-100.0000000),Y=(Min=-90.0000000,Max=-80.0000000),Z=(Min=220.0000000,Max=240.0000000))
    BrassRight=(X=0.0000000,Y=-1.0000000,Z=0.0000000)
    MinShotDistBrass=32000.0000000
    ViewKickRate=(X=24.0000000,Y=0.0000000,Z=640.0000000)
    ViewKickMax=(X=24.0000000,Y=0.0000000,Z=11520.0000000)
    fViewRestoreTime=0.2500000
    bSetBurstWeapon=true
    SpeedClass=0
    MinSwayRotClamp=(Pitch=-1820,Yaw=-1092,Roll=0)
    MaxSwayRotClamp=(Pitch=1092,Yaw=1092,Roll=0)
    xSubtleIdle="Idle"
    xNonSubtleIdle="Idle"
    xSingleFire="shoot"
    xReloadAnim="Reload"
    xHolsterAnim="holster"
    xSelectAnim="load"
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.PV_M4"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    WABrassBone="gun_brass"
    UseAttachAnims=true
    AttachReloadAnim="Reload"
    WeapAnimSet="Weapons.M4Anims"
    WeapAttachAnimSet="Weapons.M4WeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.M4.pv_m4"
    WeaponIconIndex=22
    hudProps=(WeaponIconIdx=22,AmmoIconIdx=85,ItemsPerTex=5)
    FireSounds[0]=Sound'CBW_DYN_weapons.AK47.AK47_FireIndoor1'
    FireSounds[1]=Sound'CBW_DYN_weapons.AK47.AK47_FireOutdoor1'
    ReloadSound=Sound'CBW_DYN_weapons.M4.Reload_M4'
    // Reference: RumbleSawtooth'WeapAK47.WeapRumbleM4A'
    begin object name=WeapRumbleM4A class=Class'ZombieGame.RumbleSawtooth'
        Frequency=0.1500000
        MaxStrength=0.7000000
        Duration=0.1500000
        UseRightMotor=false
    end object
    RumbleDes=WeapRumbleM4A
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleLocation=(X=90.0000000,Y=7.0000000,Z=-5.0000000)
    PVMuzzleFlashScale=0.0800000
    PVMuzzleLocationZoomed=(X=90.0000000,Y=15.0000000,Z=-7.0000000)
    PVMuzzleLocationLean=(X=90.0000000,Y=17.0000000,Z=-5.5000000)
    PVMuzzleLocationZoomLean=(X=90.0000000,Y=17.0000000,Z=-7.0000000)
    AmmoName=Class'AssaultRifleAmmo'
    PickupAmmoCount=120
    ReloadCount=30
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    TraceAccuracy=0.1470000
    DamageAmount=25.0000000
    TraceDist=9000.0000000
    FlashOffsetY=-143.0000000
    FlashOffsetX=-138.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=52
    PickupClass=Class'PickupAK47'
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_ak74'
    ThirdPersonScale=1.3000000
    ThirdPersonRelativeLocation=(X=12.0000000,Y=-2.5000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=800,Yaw=-1000,Roll=-16384)
    AttachmentClass=Class'AK47Attach'
    ItemName="AK47"
    DrawScale=1.0000000
}