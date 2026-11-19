//===============================================================================
//  [WeapC4]  
//===============================================================================

#exec ANIM IMPORT ANIM=c4Anims ANIMFILE=..\Animations\PSA\pv_c4_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=c4Anims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=c4Anims SEQ=shoot_pull FRAME=7.0 FUNCTION=PlayArmingSound
#exec ANIM NOTIFY ANIM=c4Anims SEQ=shoot_pull FRAME=18.0 FUNCTION=PlayArmedSound
#exec ANIM NOTIFY ANIM=c4Anims SEQ=shoot_pull FRAME=17.0 FUNCTION=ArmLCD

#exec ANIM NOTIFY ANIM=c4Anims SEQ=shoot_throw FRAME=3.0 FUNCTION=SpawnProjectile

//#exec ANIM IMPORT ANIM=c4WeapAnims ANIMFILE=..\Animations\PSA\pv_c4_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
//#exec ANIM DIGEST ANIM=c4WeapAnims USERAWINFO VERBOSE

class WeapC4 extends ABSTRACT_WeapGrenade
	ignoredigitwarning;

var() sound ArmingSound;
var() sound ArmedSound;

var() texture LCDReady;
var() texture LCDArmed;


//state CookingOff
//{
//	ignores Fire;
//
//	simulated function AnimEnd(int Channel)
//	{
//		PlaySound( ArmedSound,, 1.0,,100.0, ,true ); 
//		Super.AnimEnd( Channel );
//	}
//}

simulated function ReadyLCD()
{
	WeapAttachment.Skins[0] = WeapAttTex;
	WeapAttachment.Skins[1] = LCDReady;
}

simulated function ArmLCD()
{
	WeapAttachment.Skins[0] = WeapAttTex;
	WeapAttachment.Skins[1] = LCDArmed;
}

simulated function PlayArmingSound()
{
	Instigator.PlaySound( ArmingSound,, 1.0,,50.0, ,true );
}

simulated function PlayArmedSound()
{
//	Log("########### PlayArmedSound ############# ");
	Instigator.PlaySound( ArmedSound,, 1.0,,50.0, ,true );
}

function ServerSpawnProjectile( bool bCookoffExpired )
{
	local vector X, Y, Z, Start;
	local rotator AdjustedAim;
	local float SpeedModifier;
	local Projectile P;
	local float GrenadeLifespan;

//C4SPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WC4.ServerSpawnProjectile   bCookoffExpired:"$ bCookoffExpired $"  RC:"$ ReloadCount );
	// Prevent weird loops where you get stuck throwing infinite grenades
	if( ReloadCount == 0 )
		return;

	if( Level.TimeSeconds < TimeOfLastProjectile + MinProjectileInterval )
		return;
	else
		TimeOfLastProjectile = Level.TimeSeconds;

	// Get start point
	Owner.MakeNoise(fNoiseFactor);
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	Start = GetFireStart(X,Y,Z); 
	//Log(" WeapC4.SpawnGrenadeProjectile   Start: "$Start $"   ### ");

	// Set launch direction
	AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError, true);	
	AdjustedAim.Pitch += 1820;

	if( bCookoffExpired )
	{
		SpeedModifier = 0.02;
	}
	else
	{
		// If walking and aiming (looking) forward, add a little more speed
		if( X dot Instigator.Velocity > 180 )
			SpeedModifier = 2.00;
		else
			SpeedModifier = 1.00;
	}

	// If looking up enough (could be trying to put charge on a low ceiling)
	// give a little extra speed
	if( AdjustedAim.Pitch < 21844 ) // < 120 deg
	{
		if( AdjustedAim.Pitch > 12742 ) // > 70 deg
		{
			SpeedModifier *= 2.4;
		}
		else if( AdjustedAim.Pitch > 7281 ) // > 40 deg
		{
			SpeedModifier *= 1.7;
		}
	}
//	Log("AdjustedAim.Pitch:"$ AdjustedAim.Pitch $"  SpeedModifier:"$ SpeedModifier $"  oooooooooooo");

	// Figure out how much time the C4 charge has left
	if( bCookoffInHand && bCookoffExpired )
	{
		GrenadeLifespan = 0.1;
	}
	else if( bCookoffInHand && bCookingOff )
	{
		GrenadeLifespan  = CookoffDuration - (Level.TimeSeconds-CookoffStartTime);
	}
	else
	{
		GrenadeLifespan  = CookoffDuration;
	}

	P = SFRMAmmunition(AmmoType).SpawnProjectileEx(Start,AdjustedAim, SpeedModifier, Level.TimeSeconds);

	HideThirdPersonActor();

	// Set projectile lifespan on server.
	// Client-side projectile will grab lifespan when able.
	P.LifeSpan = GrenadeLifespan;
	C4Projectile(P).bGotLifeSpan = true;
	C4Projectile(P).DPLifespan = GrenadeLifespan;

//	Log("           P:"$ P $"  P loc:"$ P.Location $"  dloc:"$ P.Location - Location $"  P.Velocity:"$ P.Velocity );
//	Log("           SM:"$ SpeedModifier $"  CookoffDuration:"$ CookoffDuration $"  Level.TimeSeconds:"$ Level.TimeSeconds $"  CookoffStartTime:"$ CookoffStartTime $"  L.TS-CST:"$ (Level.TimeSeconds-CookoffStartTime) $"  P.Ls:"$ P.LifeSpan );

	LocalEndCookoff();

	// Decrement ReloadCount
	ReloadCount = 0;

	if( Level.bMPWeapLogs )
		Log( Level.TimeSeconds $" MPLog: #### C4 projectile thrown by "$ instigator.PlayerReplicationInfo.PlayerName $"  weap:"$ self.class $"  lifespan remaining:"$ GrenadeLifespan );
}

simulated function PlaySelect()
{
	ReadyLCD();
	Super.PlaySelect();
}


// Decompiled with UE Explorer.
defaultproperties
{
    ArmingSound=Sound'CBW_DYN_weapons.C4.C4_beep_arming'
    ArmedSound=Sound'CBW_DYN_weapons.C4.C4_beep_armed'
    LCDReady=Texture'CBT_DYN_Weapons.C4.pv_c4_lcd_ready'
    LCDArmed=Texture'CBT_DYN_Weapons.C4.pv_c4_lcd_armed'
    xSingleFireThrow="shoot_throw"
    CookoffDuration=30.0000000
    ThrowSound=Sound'CBW_DYN_weapons.Grenade.grenade_fire'
    xNoHandsAnim="nohands_pose"
    PVMeshName="CBA_PV_Weapons.pv_hands"
    bIsSingleShot=true
    HandsSkinIndex=1
    xSubtleIdle="Idle"
    xNonSubtleIdle="Idle"
    xSingleFire="shoot_pull"
    xReloadAnim="Reload"
    xSelectAnim="load"
    DEBUG_WeapAttachment=true
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.pv_c4"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    UseAttachAnims=true
    AttachFireAnim="shoot_pull"
    AttachReloadAnim="load"
    WeapAnimSet="Weapons.C4Anims"
    WeapAttTexName="CBT_DYN_Weapons.c4.pv_c4"
    hudProps=(WeaponIconIdx=26,AmmoIconIdx=86,ItemsPerTex=4)
    AmmoName=Class'C4Ammo'
    PickupAmmoCount=1
    FireOffset=(X=20.0000000,Y=1.0000000,Z=0.0000000)
    InventoryGroup=140
    PickupClass=Class'PickupC4'
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_c4'
    ThirdPersonScale=0.6500000
    ThirdPersonRelativeLocation=(X=14.0000000,Y=7.0000000,Z=-13.0000000)
    ThirdPersonRelativeRotation=(Pitch=-11000,Yaw=1500,Roll=36000)
    AttachmentClass=Class'C4Attach'
    ItemName="C4 charge"
}