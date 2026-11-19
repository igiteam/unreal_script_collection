//===============================================================================
//  [USP Pistol]  
//===============================================================================

class WeapUSP extends ZombieWeapon;

#exec ANIM IMPORT ANIM=USPAnims ANIMFILE=..\Animations\PSA\pv_usp_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=USPAnims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=USPAnims SEQ=shoot FRAME=1.0 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=USPAnims SEQ=reload FRAME=21.0 FUNCTION=AddAmmo

#exec ANIM IMPORT ANIM=USPWeapAnims ANIMFILE=..\Animations\PSA\pv_usp_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=USPWeapAnims USERAWINFO VERBOSE


// Decompiled with UE Explorer.
defaultproperties
{
    PVMeshName="CBA_PV_Weapons.pv_hands"
    ReticleRangeFactor=0.5200000
    WeaponSpread[0]=0.0660000
    WeaponSpread[1]=0.0990000
    WeaponSpread[2]=0.1320000
    WeaponSpread[3]=0.1320000
    ScatterKick=1.0500000
    ScatterFullRestoreTime=0.5000000
    MinScatterFactor=0.2000000
    MinScatterFactorZoomed=0.0500000
    BurstLength=1
    ZoomPlayerViewOffset=(X=5.0000000,Y=-3.5000000,Z=1.8000000)
    ZoomRotationOffset=(Pitch=0,Yaw=300,Roll=0)
    ZoomLeanPVYCorr=0.1600000
    LeanPlayerViewOffset=(X=-1.0000000,Y=-13.1000000,Z=2.5000000)
    LeanRotationOffset=(Pitch=0,Yaw=1300,Roll=500)
    ZoomLeanPlayerViewOffset=(X=5.0000000,Y=-6.7000000,Z=2.5000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=1300,Roll=500)
    BotFireRate=1.0000000
    BotBulletInterval=0.2500000
    WeaponAnims=1
    BrassStartVelocityRange=(X=(Min=-60.0000000,Max=-50.0000000),Y=(Min=-50.0000000,Max=-40.0000000),Z=(Min=180.0000000,Max=190.0000000))
    BrassRight=(X=0.0000000,Y=-1.0000000,Z=0.0000000)
    MinShotDistBrass=32000.0000000
    BotBurstSize=3
    BotTimeBetweenBursts=1.5000000
    SpeedClass=1
    TakeOutAnim[0]="aim_pistol_select"
    TakeOutAnim[1]="aim_pistol_select"
    PutAwayAnim[0]="aim_pistol_deselect"
    PutAwayAnim[1]="aim_pistol_deselect"
    PoseAnim[0]="idle_pistol_pose"
    PoseAnim[1]="aim_pistol_pose"
    PawnReloadAnim="aim_pistol_reload"
    YawSwayFactor=1.2000000
    PitchSwayFactor=1.3000000
    TransSwayFactors=(X=1.8000000,Y=1.4000000,Z=1.6000000)
    YawTransSwayFactors=(X=1.0000000,Y=-2.4000000,Z=0.0000000)
    PitchTransSwayFactors=(X=1.0000000,Y=0.0000000,Z=-2.4000000)
    MinSwayClamp=(X=-3.0000000,Y=-3.4000000,Z=-2.2000000)
    MaxSwayClamp=(X=3.0000000,Y=3.4000000,Z=2.2000000)
    MinSwayRotClamp=(Pitch=-1820,Yaw=-900,Roll=0)
    MaxSwayRotClamp=(Pitch=1092,Yaw=900,Roll=0)
    xSubtleIdle="Idle"
    xNonSubtleIdle="Idle"
    xSingleFire="shoot"
    xReloadAnim="Reload"
    xHolsterAnim="holster"
    xSelectAnim="load"
    fNoiseFactor=1.6000000
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.pv_usp"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    WABrassBone="gun_brass"
    UseAttachAnims=true
    AttachReloadAnim="Reload"
    WeapAnimSet="Weapons.USPAnims"
    WeapAttachAnimSet="Weapons.USPWeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.usp.pv_usp"
    CrosshairIndex=4
    WeaponIconIndex=38
    hudProps=(WeaponIconIdx=23,AmmoIconIdx=85,ItemsPerTex=5)
    FireSounds[0]=Sound'CBW_DYN_weapons.USP45.USP45_FireIndoor1'
    FireSounds[1]=Sound'CBW_DYN_weapons.USP45.USP45_FireOutdoor1'
    ReloadSound=Sound'CBW_DYN_weapons.USP45.Reload_USP'
    // Reference: RumbleSawtooth'WeapUSP.WeapRumbleSS'
    begin object name=WeapRumbleSS class=Class'ZombieGame.RumbleSawtooth'
        Frequency=0.1500000
        MaxStrength=0.6000000
        Duration=0.1500000
        UseRightMotor=false
    end object
    RumbleDes=WeapRumbleSS
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleLocation=(X=60.0000000,Y=11.5000000,Z=-6.5000000)
    PVMuzzleFlashScale=0.0550000
    PVMuzzleLocationZoomed=(X=60.0000000,Y=13.0000000,Z=-6.5000000)
    PVMuzzleLocationLean=(X=60.0000000,Y=19.5000000,Z=-10.5000000)
    PVMuzzleLocationZoomLean=(X=60.0000000,Y=19.5000000,Z=-10.5000000)
    AmmoName=Class'PistolAmmo'
    PickupAmmoCount=60
    ReloadCount=12
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    TraceAccuracy=0.0990000
    DamageAmount=35.0000000
    AIRating=0.4100000
    TraceDist=3400.0000000
    DisplayFOV=60.0000000
    FlashOffsetY=-116.0000000
    FlashOffsetX=-170.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=11
    PickupClass=Class'PickupUSP'
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_usp'
    ThirdPersonScale=0.9000000
    ThirdPersonRelativeLocation=(X=10.0000000,Y=-4.0000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=0,Yaw=0,Roll=-16384)
    AttachmentClass=Class'USPAttach'
    ItemName="USP"
    DrawScale=1.0000000
}