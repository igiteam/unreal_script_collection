//===============================================================================
//  [M82A1 Sniper Rifle]  
//===============================================================================

class WeapM82A1 extends ABSTRACT_WeapSniperRifle
	ignoredigitwarning;


#exec ANIM IMPORT ANIM=M82A1Anims ANIMFILE=..\Animations\PSA\pv_m82a1_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M82A1Anims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=M82A1Anims SEQ=shoot FRAME=1.0 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=M82A1Anims SEQ=reload FRAME=14.0 FUNCTION=AddAmmo

#exec ANIM IMPORT ANIM=M82A1WeapAnims ANIMFILE=..\Animations\PSA\pv_m82a1_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M82A1WeapAnims USERAWINFO VERBOSE

static simulated function PreCacheWeapAssets()
{
	DynamicLoadObject ( "CBA_PV_Weapons.PV_m82a1", class'Mesh' );
	DynamicLoadObject ( "Weapons.M82A1WeapAnims", class'MeshAnimation' );
	DynamicLoadObject ( "Weapons.M82A1Anims", class'MeshAnimation' );
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
    WeaponSpread[0]=12.2330000
    WeaponSpread[1]=16.4430000
    WeaponSpread[2]=19.0820000
    WeaponSpread[3]=21.3740000
    ScatterKick=1.4000000
    MinScatterFactor=1.0000000
    MinScatterFactorZoomed=0.0010000
    MaxScatterFactorZoomed=0.0010000
    BurstLength=1
    bHasScope=true
    ZoomPlayerViewOffset=(X=-14.0000000,Y=-15.0000000,Z=6.2000000)
    ZoomRotationOffset=(Pitch=0,Yaw=600,Roll=0)
    LeanPlayerViewOffset=(X=1.0000000,Y=-14.0000000,Z=-2.0000000)
    LeanRotationOffset=(Pitch=0,Yaw=600,Roll=0)
    ZoomLeanPlayerViewOffset=(X=-14.0000000,Y=-14.9000000,Z=6.2000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=600,Roll=0)
    ZoomMagnificationInSound=Sound'CBW_DYN_interface.HUD.zoom_in_high'
    BotFireRate=0.8000000
    BotBulletInterval=0.0800000
    bFireTracer=true
    vMuzzleFlashLocalOffset=(X=-200.0000000,Y=-100.0000000,Z=0.0000000)
    BrassStartVelocityRange=(X=(Min=-110.0000000,Max=-100.0000000),Y=(Min=-90.0000000,Max=-80.0000000),Z=(Min=220.0000000,Max=240.0000000))
    BrassRight=(X=0.0000000,Y=-1.0000000,Z=0.0000000)
    MinShotDistBrass=32000.0000000
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
    fNoiseFactor=2.5000000
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.PV_M82A1"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    WABrassBone="gun_brass"
    UseAttachAnims=true
    AttachReloadAnim="Reload"
    WeapAnimSet="Weapons.M82A1Anims"
    WeapAttachAnimSet="Weapons.M82A1WeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.m82a1.pv_m82a1"
    WeaponIconIndex=152
    hudProps=(WeaponIconIdx=24,AmmoIconIdx=85,ItemsPerTex=5)
    FireSounds[0]=Sound'CBW_DYN_weapons.Sniper.Sniper_FireIndoor1'
    FireSounds[1]=Sound'CBW_DYN_weapons.Sniper.Sniper_FireOutdoor1'
    ReloadSound=Sound'CBW_DYN_weapons.Sniper.Reload_sniper'
    // Reference: RumbleSawtooth'WeapM82A1.WeapRumbleM82A1'
    begin object name=WeapRumbleM82A1 class=Class'ZombieGame.RumbleSawtooth'
        Frequency=0.2000000
        MaxStrength=0.9000000
        Duration=0.2000000
        UseRightMotor=false
    end object
    RumbleDes=WeapRumbleM82A1
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleLocation=(X=90.0000000,Y=8.0000000,Z=-5.5000000)
    PVMuzzleFlashScale=0.1000000
    PVMuzzleLocationZoomed=(X=90.0000000,Y=8.0000000,Z=-5.5000000)
    PVMuzzleLocationLean=(X=90.0000000,Y=16.5000000,Z=-5.5000000)
    PVMuzzleLocationZoomLean=(X=90.0000000,Y=16.5000000,Z=-5.5000000)
    AmmoName=Class'SniperRifleAmmo'
    ReloadCount=6
    TraceAccuracy=12.2330000
    DamageAmount=70.0000000
    TraceDist=100000.0000000
    MaxRange=95000.0000000
    FlashOffsetY=-143.0000000
    FlashOffsetX=-138.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=61
    PickupClass=Class'PickupM82A1'
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_m81a1'
    ThirdPersonScale=0.8000000
    ThirdPersonRelativeLocation=(X=12.0000000,Y=-4.0000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=700,Yaw=-600,Roll=-16384)
    AttachmentClass=Class'M82A1Attach'
    ItemName="M82A1"
    DrawScale=1.0000000
}