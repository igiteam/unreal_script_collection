//===============================================================================
//  [Colt M4 Carbine ]  
//===============================================================================

class WeapM4 extends ZombieWeapon
	ignoredigitwarning;


#exec ANIM IMPORT ANIM=M4Anims ANIMFILE=..\Animations\PSA\pv_m4_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M4Anims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=M4Anims SEQ=shoot FRAME=1.0 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=M4Anims SEQ=reload FRAME=15.0 FUNCTION=AddAmmo

#exec ANIM IMPORT ANIM=M4WeapAnims ANIMFILE=..\Animations\PSA\pv_m4_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=M4WeapAnims USERAWINFO VERBOSE

// Campaign-specific playerview weapon reskinning
//var string JungleTextureName;
//var string BlackTextureName;

static simulated function PreCacheWeapAssets()
{
	DynamicLoadObject ( "CBA_PV_Weapons.PV_M4", class'Mesh' );
	DynamicLoadObject ( "Weapons.M4WeapAnims", class'MeshAnimation' );
	DynamicLoadObject ( "Weapons.M4Anims", class'MeshAnimation' );
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

function string GetCampaignWeapSkin(int index)
{
	//if( index == 2 )   // Bosnia (Chechnya)
	//	return BlackTextureName;
	//else if( index == 5 )  // Philippines (Congo)
	//	return JungleTextureName;
	//else
	//	return "";
	return "";
}


// Decompiled with UE Explorer.
defaultproperties
{
    PVMeshName="CBA_PV_Weapons.PV_HANDS"
    WeaponSpread[0]=0.0670000
    WeaponSpread[1]=0.1010000
    WeaponSpread[2]=0.1340000
    WeaponSpread[3]=0.1340000
    MaxScatterFactorZoomed=0.7000000
    ZoomPlayerViewOffset=(X=3.5000000,Y=-4.0000000,Z=0.7000000)
    ZoomRotationOffset=(Pitch=0,Yaw=1000,Roll=300)
    ZoomLeanPVYCorr=0.0000000
    ZoomLeanPVZCorr=0.4200000
    ZoomLeanPitchCorr=0.0800000
    LeanPVYCorr=0.0000000
    LeanPVZCorr=1.2000000
    LeanPitchCorr=0.2000000
    LeanPlayerViewOffset=(X=3.0000000,Y=-13.0000000,Z=-3.0000000)
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
    ViewKickRate=(X=24.0000000,Y=0.0000000,Z=600.0000000)
    ViewKickMax=(X=24.0000000,Y=0.0000000,Z=11520.0000000)
    fViewRestoreTime=0.1750000
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
    fNoiseFactor=2.0000000
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
    FireSounds[0]=Sound'CBW_DYN_weapons.M4.M4_FireIndoor1'
    FireSounds[1]=Sound'CBW_DYN_weapons.M4.M4_FireOutdoor1'
    ReloadSound=Sound'CBW_DYN_weapons.M4.Reload_M4'
    // Reference: RumbleSawtooth'WeapM4.WeapRumbleM4A'
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
    TraceAccuracy=0.1010000
    DamageAmount=25.0000000
    TraceDist=8000.0000000
    FlashOffsetY=-143.0000000
    FlashOffsetX=-138.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=52
    PickupClass=Class'PickupM4'
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.HH_M4'
    ThirdPersonScale=1.0000000
    ThirdPersonRelativeLocation=(X=12.0000000,Y=-2.0000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=1000,Yaw=0,Roll=-16384)
    AttachmentClass=Class'M4Attach'
    ItemName="M4"
    DrawScale=1.0000000
}