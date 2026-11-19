//===============================================================================
//  [M203 Grenade launcher ]  
//===============================================================================

class WeapM203 extends ZombieWeapon
	ignoredigitwarning;


#exec ANIM IMPORT ANIM=M203Anims ANIMFILE=..\Animations\PSA\pv_m203_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M203Anims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=M203Anims SEQ=shoot FRAME=0.2 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=M203Anims SEQ=reload FRAME=23.0 FUNCTION=AddAmmo

#exec ANIM IMPORT ANIM=M203WeapAnims ANIMFILE=..\Animations\PSA\pv_m203_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M203WeapAnims USERAWINFO VERBOSE


// Decompiled with UE Explorer.
defaultproperties
{
    PVMeshName="CBA_PV_Weapons.PV_HANDS"
    bUseCanFireAgainPostReload=true
    BurstLength=1
    ZoomPlayerViewOffset=(X=7.0000000,Y=-3.8000000,Z=0.5000000)
    ZoomRotationOffset=(Pitch=0,Yaw=1100,Roll=0)
    ZoomLeanPVYCorr=0.0000000
    ZoomLeanPVZCorr=0.4200000
    ZoomLeanPitchCorr=0.0800000
    LeanPVYCorr=0.0000000
    LeanPVZCorr=1.2000000
    LeanPitchCorr=0.2000000
    LeanPlayerViewOffset=(X=1.0000000,Y=-14.5000000,Z=-3.0000000)
    LeanRotationOffset=(Pitch=0,Yaw=1450,Roll=0)
    ZoomLeanPlayerViewOffset=(X=4.5000000,Y=-6.4000000,Z=-0.3000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=1450,Roll=0)
    BotFireRate=0.8000000
    BotBulletInterval=0.0800000
    bFireTracer=true
    vMuzzleFlashLocalOffset=(X=-200.0000000,Y=-100.0000000,Z=0.0000000)
    BrassEjectBone="None"
    ViewKickRate=(X=0.0000000,Y=0.0000000,Z=1000.0000000)
    ViewKickMax=(X=0.0000000,Y=0.0000000,Z=8000.0000000)
    fViewRestoreTime=0.4000000
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
    fNoiseFactor=0.8000000
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.PV_M4"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    UseAttachAnims=true
    AttachReloadAnim="Reload"
    WeapAnimSet="Weapons.M203Anims"
    WeapAttachAnimSet="Weapons.M203WeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.M4.pv_m4"
    CrosshairIndex=40
    WeaponIconIndex=22
    hudProps=(WeaponIconIdx=28,AmmoIconIdx=86,ItemsPerTex=4)
    FireSounds[0]=Sound'CBW_DYN_weapons.M203.M203_Fire1'
    FireSounds[1]=Sound'CBW_DYN_weapons.M203.M203_Fire1'
    ReloadSound=Sound'CBW_DYN_weapons.M203.Reload_M203'
    // Reference: RumbleSawtooth'WeapM203.WeapRumbleM203A'
    begin object name=WeapRumbleM203A class=Class'ZombieGame.RumbleSawtooth'
        Frequency=0.1500000
        MaxStrength=0.7000000
        Duration=0.1500000
        UseRightMotor=false
    end object
    RumbleDes=WeapRumbleM203A
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleLocation=(X=90.0000000,Y=9.5000000,Z=-11.5000000)
    PVMuzzleFlashScale=0.0500000
    PVMuzzleLocationZoomed=(X=90.0000000,Y=17.0000000,Z=-10.0000000)
    PVMuzzleLocationLean=(X=90.0000000,Y=18.0000000,Z=-11.5000000)
    PVMuzzleLocationZoomLean=(X=90.0000000,Y=18.0000000,Z=-9.0000000)
    AmmoName=Class'GrenadeLauncherAmmo'
    PickupAmmoCount=120
    ReloadCount=1
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    FlashOffsetY=-143.0000000
    FlashOffsetX=-138.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=110
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.HH_M4'
    ThirdPersonScale=1.0000000
    ThirdPersonRelativeLocation=(X=12.0000000,Y=-2.0000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=1000,Yaw=0,Roll=-16384)
    AttachmentClass=Class'M203Attach'
    ItemName="M203"
    DrawScale=1.0000000
}