//===============================================================================
//  [H&K MP5]  
//===============================================================================

class WeapMP5 extends ZombieWeapon
	ignoredigitwarning;


#exec ANIM IMPORT ANIM=MP5Anims ANIMFILE=..\Animations\PSA\pv_mp5_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=MP5Anims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=MP5Anims SEQ=shoot FRAME=1.0 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=MP5Anims SEQ=reload FRAME=24.0 FUNCTION=AddAmmo

#exec ANIM IMPORT ANIM=MP5WeapAnims ANIMFILE=..\Animations\PSA\pv_mp5_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=MP5WeapAnims USERAWINFO VERBOSE

static simulated function PreCacheWeapAssets()
{
	DynamicLoadObject ( "CBA_PV_Weapons.PV_MP5", class'Mesh' );
	DynamicLoadObject ( "Weapons.MP5WeapAnims", class'MeshAnimation' );
	DynamicLoadObject ( "Weapons.MP5Anims", class'MeshAnimation' );
}

//simulated state Zooming
//{
//	simulated function BeginState()
//	{
//		local PlayerController PC;
//		PC = PlayerController(Instigator.Controller);
//			
//		if ( PC == None )
//			return; 
//
//		if ( bZoomed )
//		{
//		//	BasicHud(PC.myHUD).ShowHud();
//			BasicHud(PC.myHUD).SetScopeMode(false, class'ZombieGame.M4Scope');
//		}
//		else
//		{
//		//	BasicHud(PC.myHUD).HideHud();
//			BasicHud(PC.myHUD).SetScopeMode(true, class'ZombieGame.M4Scope');
//		}
//		Super.BeginState();
//	}
//	
//	
//}
//
//simulated function EndZoom()
//{
//	local PlayerController PC;
//	PC = PlayerController(Instigator.Controller);
//		
//	Super.EndZoom();
//	
////	BasicHud(PC.myHUD).ShowHud();
//	BasicHud(PC.myHUD).SetScopeMode(false, class'ZombieGame.M4Scope');
//}


//simulated event RenderOverlays( canvas Canvas )
//{
//	local  PlayerController P;
//
//	if ( Instigator == None )
//		return;
//
//	P = PlayerController(Pawn(Owner).Controller);
//	
//	if ( (P != None) && (bZoomed) && CurrentWeaponMode == 0) 
//	{
//		class'ZombieGame.M4Scope'.static.DrawCrosshair(canvas, BasicHUD(P.myHUD));
//	}
//	else
//		Super.RenderOverlays(Canvas);		
//}


// Decompiled with UE Explorer.
defaultproperties
{
    PVMeshName="CBA_PV_Weapons.PV_HANDS"
    WeaponSpread[0]=0.0440000
    WeaponSpread[1]=0.0650000
    WeaponSpread[2]=0.0870000
    WeaponSpread[3]=0.0870000
    ScatterFullRestoreTime=0.2300000
    MaxScatterFactorZoomed=0.7000000
    ZoomPlayerViewOffset=(X=2.0000000,Y=-4.5000000,Z=2.0000000)
    ZoomRotationOffset=(Pitch=0,Yaw=1340,Roll=1100)
    LeanPlayerViewOffset=(X=0.0000000,Y=-13.0000000,Z=-2.0000000)
    LeanRotationOffset=(Pitch=0,Yaw=1340,Roll=0)
    ZoomLeanPlayerViewOffset=(X=1.5000000,Y=-5.6500000,Z=1.3000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=1340,Roll=900)
    BotFireRate=0.8000000
    BotBulletInterval=0.0800000
    bFireTracer=true
    vMuzzleFlashLocalOffset=(X=-200.0000000,Y=-100.0000000,Z=0.0000000)
    BrassStartVelocityRange=(X=(Min=-110.0000000,Max=-100.0000000),Y=(Min=-90.0000000,Max=-80.0000000),Z=(Min=220.0000000,Max=240.0000000))
    BrassRight=(X=0.0000000,Y=-1.0000000,Z=0.0000000)
    MinShotDistBrass=32000.0000000
    ViewKickRate=(X=24.0000000,Y=0.0000000,Z=500.0000000)
    ViewKickMax=(X=24.0000000,Y=0.0000000,Z=10000.0000000)
    fViewRestoreTime=0.1400000
    bIsSilenced=true
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
    fNoiseFactor=0.1000000
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.PV_MP5"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    WABrassBone="gun_brass"
    UseAttachAnims=true
    AttachReloadAnim="Reload"
    WeapAnimSet="Weapons.MP5Anims"
    WeapAttachAnimSet="Weapons.MP5WeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.mp5.pv_mp5"
    CrosshairIndex=7
    WeaponIconIndex=22
    hudProps=(WeaponIconIdx=33,AmmoIconIdx=85,ItemsPerTex=5)
    FireSounds[0]=Sound'CBW_DYN_weapons.MP5SD.MP5SD_FireIndoor1'
    FireSounds[1]=Sound'CBW_DYN_weapons.MP5SD.MP5SD_FireOutdoor1'
    ReloadSound=Sound'CBW_DYN_weapons.MP5SD.Reload_MP5'
    // Reference: RumbleSawtooth'WeapMP5.WeapRumbleMP5'
    begin object name=WeapRumbleMP5 class=Class'ZombieGame.RumbleSawtooth'
        Frequency=0.1500000
        MaxStrength=0.5000000
        Duration=0.1500000
        UseRightMotor=false
    end object
    RumbleDes=WeapRumbleMP5
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleLocation=(X=90.0000000,Y=8.0000000,Z=-5.5000000)
    PVMuzzleFlashScale=0.0500000
    PVMuzzleLocationZoomed=(X=90.0000000,Y=17.5000000,Z=-13.0000000)
    PVMuzzleLocationLean=(X=90.0000000,Y=16.0000000,Z=-6.0000000)
    PVMuzzleLocationZoomLean=(X=90.0000000,Y=16.5000000,Z=-13.0000000)
    AmmoName=Class'AssaultRifleAmmo'
    PickupAmmoCount=120
    ReloadCount=30
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    TraceAccuracy=0.0650000
    DamageAmount=20.0000000
    TraceDist=6500.0000000
    FlashOffsetY=-143.0000000
    FlashOffsetX=-138.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=53
    PickupClass=Class'PickupMP5'
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_mp5'
    ThirdPersonScale=0.9000000
    ThirdPersonRelativeLocation=(X=12.0000000,Y=-3.5000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=300,Yaw=300,Roll=-16384)
    AttachmentClass=Class'MP5Attach'
    ItemName="MP5"
    DrawScale=1.0000000
}