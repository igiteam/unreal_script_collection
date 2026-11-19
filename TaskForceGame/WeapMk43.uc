//===============================================================================
//  [Mk43 SAW]  
//===============================================================================

class WeapMk43 extends ZombieWeapon
	ignoredigitwarning;


#exec ANIM IMPORT ANIM=Mk43Anims ANIMFILE=..\Animations\PSA\pv_Mk43_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=Mk43Anims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=Mk43Anims SEQ=shoot FRAME=1.0 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=Mk43Anims SEQ=reload FRAME=30.0 FUNCTION=AddAmmo

#exec ANIM IMPORT ANIM=Mk43WeapAnims ANIMFILE=..\Animations\PSA\pv_Mk43_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=Mk43WeapAnims USERAWINFO VERBOSE

static simulated function PreCacheWeapAssets()
{
	DynamicLoadObject ( "CBA_PV_Weapons.PV_mk43", class'Mesh' );
	DynamicLoadObject ( "Weapons.Mk43WeapAnims", class'MeshAnimation' );
	DynamicLoadObject ( "Weapons.Mk43Anims", class'MeshAnimation' );
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
//			BasicHud(PC.myHUD).SetScopeMode(false, class'ZombieGame.Mk43Scope');
//		}
//		else
//		{
//		//	BasicHud(PC.myHUD).HideHud();
//			BasicHud(PC.myHUD).SetScopeMode(true, class'ZombieGame.Mk43Scope');
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
//	BasicHud(PC.myHUD).SetScopeMode(false, class'ZombieGame.Mk43Scope');
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
//		class'ZombieGame.Mk43Scope'.static.DrawCrosshair(canvas, BasicHUD(P.myHUD));
//	}
//	else
//		Super.RenderOverlays(Canvas);		
//}


// Decompiled with UE Explorer.
defaultproperties
{
    PVMeshName="CBA_PV_Weapons.PV_HANDS"
    WeaponSpread[0]=0.1670000
    WeaponSpread[1]=0.2510000
    WeaponSpread[2]=0.3350000
    WeaponSpread[3]=0.3350000
    MinScatterFactor=0.5000000
    MinScatterFactorZoomed=0.3000000
    MaxScatterFactorZoomed=0.7000000
    ZoomPlayerViewOffset=(X=3.0000000,Y=-5.5000000,Z=1.9000000)
    ZoomRotationOffset=(Pitch=0,Yaw=1400,Roll=900)
    LeanPlayerViewOffset=(X=3.0000000,Y=-15.5000000,Z=0.0000000)
    LeanRotationOffset=(Pitch=0,Yaw=1500,Roll=500)
    ZoomLeanPlayerViewOffset=(X=3.0000000,Y=-6.8000000,Z=1.4000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=1500,Roll=900)
    BotFireRate=0.8000000
    BotBulletInterval=0.0800000
    bFireTracer=true
    vMuzzleFlashLocalOffset=(X=-200.0000000,Y=-100.0000000,Z=0.0000000)
    BrassStartVelocityRange=(X=(Min=-110.0000000,Max=-100.0000000),Y=(Min=-90.0000000,Max=-80.0000000),Z=(Min=220.0000000,Max=240.0000000))
    BrassRight=(X=0.0000000,Y=-1.0000000,Z=0.0000000)
    MinShotDistBrass=32000.0000000
    ViewKickRate=(X=120.0000000,Y=0.0000000,Z=700.0000000)
    ViewKickMax=(X=120.0000000,Y=0.0000000,Z=30000.0000000)
    fViewRestoreTime=0.1500000
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
    fNoiseFactor=2.3000000
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.PV_Mk43"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    WABrassBone="gun_brass"
    UseAttachAnims=true
    AttachFireAnim="shoot"
    AttachReloadAnim="Reload"
    AttachSelectAnim="load"
    WeapAnimSet="Weapons.Mk43Anims"
    WeapAttachAnimSet="Weapons.Mk43WeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.Mk43.pv_Mk43"
    CrosshairIndex=30
    WeaponIconIndex=25
    hudProps=(WeaponIconIdx=32,AmmoIconIdx=85,ItemsPerTex=5)
    FireSounds[0]=Sound'CBW_DYN_weapons.MK43.MK43_FireIndoor1'
    FireSounds[1]=Sound'CBW_DYN_weapons.MK43.MK43_FireOutdoor1'
    ReloadSound=Sound'CBW_DYN_weapons.MK43.Reload_MK43'
    // Reference: RumbleSawtooth'WeapMk43.WeapRumbleMk43A'
    begin object name=WeapRumbleMk43A class=Class'ZombieGame.RumbleSawtooth'
        Frequency=0.1500000
        MaxStrength=0.8000000
        Duration=0.1500000
        UseRightMotor=false
    end object
    RumbleDes=WeapRumbleMk43A
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleLocation=(X=90.0000000,Y=7.5000000,Z=-5.5000000)
    PVMuzzleFlashScale=0.0800000
    PVMuzzleLocationZoomed=(X=90.0000000,Y=19.0000000,Z=-14.0000000)
    PVMuzzleLocationLean=(X=90.0000000,Y=20.0000000,Z=-11.0000000)
    PVMuzzleLocationZoomLean=(X=90.0000000,Y=20.0000000,Z=-14.0000000)
    AmmoName=Class'AssaultRifleAmmo'
    PickupAmmoCount=120
    ReloadCount=100
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    TraceAccuracy=0.2510000
    DamageAmount=20.0000000
    TraceDist=9600.0000000
    FlashOffsetY=-143.0000000
    FlashOffsetX=-138.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=70
    PickupClass=Class'PickupMk43'
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_mk43'
    ThirdPersonScale=0.8500000
    ThirdPersonRelativeLocation=(X=11.0000000,Y=-4.0000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=600,Yaw=-600,Roll=-16384)
    AttachmentClass=Class'Mk43Attach'
    ItemName="Mk43"
    DrawScale=1.0000000
}