//===============================================================================
//  [Knife]  
//===============================================================================

class WeapKnife extends ZombieWeapon;

#exec ANIM IMPORT ANIM=KnifeAnims ANIMFILE=..\Animations\PSA\pv_knife_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=KnifeAnims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=KnifeAnims SEQ=shoot FRAME=1.3 FUNCTION=DoTraceFire
#exec ANIM NOTIFY ANIM=KnifeAnims SEQ=shoot2 FRAME=1.3 FUNCTION=DoTraceFire

#exec ANIM NOTIFY ANIM=KnifeAnims SEQ=shoot FRAME=0.2 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=KnifeAnims SEQ=shoot2 FRAME=0.2 FUNCTION=PlayFireSound


replication
{
	unreliable if( Role == ROLE_Authority )
		ClientInstigatorEffects;
}

var(WeapHandAnimations) name xSingleFire2;

var(Knife) vector BackupTraceOffset;

var float MPBotTraceDist;
var float SPBotTraceDist;

//
// Ensure ammo can't be given to this weapon
//
function GiveAmmo( Pawn Other ) {}
static function bool StaticGiveAmmo( Pawn Other ) { return false; }
function GiveWeaponAmmo(optional int AmmoCount)  {}

// Ensure that weapon always has ammo
simulated function int GetAmmoAmount() { return 1; } 
simulated function bool HasAmmo() { return true; }


//*********************************************************************
//
// "Firing" functions and states
//

simulated function Fire( float Value )
{
//	Log("t="$Level.TimeSeconds $"  Weapon.Fire    self:"$self.class $"   StopFiringTime:"$StopFiringTime $"  WeaponStopFireTime:"$WeaponStopFireTime $"   WeaponFireInterval:"$WeaponFireInterval );
	bReleasedFireSinceLastShot=false;

	ServerFire();  // MAT 8/30/04

	if ( Role < ROLE_Authority )
	{
		LocalFire();
		GotoState('ClientFiring');
	}
}

simulated function PlayFiring()
{
	local int FireNum; // -1 or 1

	// Choose which fire anim to play
	if( KickDirX != 0 )
		FireNum = KickDirX;
	else
		FireNum = 2*FRand() - 1;

	// Play selected fire anim
	if( FireNum > 0 )
	{
	//	Log("FireAnim 1");
		PlayAnim(xSingleFire, 1.0f, 0.02f);
	}
	else
	{
	//	Log("FireAnim 2");
		PlayAnim(xSingleFire2, 1.0f, 0.02f);
	}

	IncrementFlashCount();
	
	if (UseAttachAnims && UseWeapAttachment && (AttachFireAnim != ''))
	{
		WeapAttachment.PlayAnim(AttachFireAnim, 1.0f, 0.02f);
	}
}

simulated function LocalFire()
{
	local PlayerController P;

	TimeOfLastShot=Level.TimeSeconds;

	bJustSelected=false;
	BurstCounter++;

	bPointing = true;

	bWantToFire=true;

	if ( (Instigator != None) && Instigator.IsLocallyControlled() )
	{
		P = PlayerController(Instigator.Controller);
		if (P!=None)
			P.ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, 1);
	}
	if ( Affector != None )
		Affector.FireEffect();
	PlayFiring();

	ApplyKick();
}

function ServerFire()
{
	GotoState('NormalFire');

	// Not calling TraceFire here because it's being fired by an anim notify
//	TraceFire(TraceAccuracy,0.0,0.0);

	LocalFire();
}

// Anim notify function that causes TraceFire to happen
simulated function DoTraceFire()
{
	if( Role == ROLE_Authority )
		TraceFire(TraceAccuracy,0.0,0.0);
}

function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
	local float AdjustedTraceDist, PitchAdj;
	local vector HitLocation, HitNormal, HitLocation2, HitNormal2;
	local vector StartTrace, EndTrace, X,Y,Z;
	local actor Victim, Victim2;
	local Material HitMaterial; 

//	if( Pawn(Owner) != None && SFRMPlayerController(Pawn(Owner).Controller) != None )
//	{
//		SFRMPlayerController(Pawn(Owner).Controller).StatMgr.ShotFired();
//	}

	// For bots, use a different trace distance
	// (Just in case GetFireStart calc works differently for bots).
	if( bPlayerOwned )
		AdjustedTraceDist = TraceDist;
	else
	{
		if( bUseMPDiffHack )
			AdjustedTraceDist = MPBotTraceDist;
		else
			AdjustedTraceDist = SPBotTraceDist;
	}
//	Log("//// TraceDist:"$ TraceDist $"  AdjustedTraceDist:"$ AdjustedTraceDist $"  bPlayerOwned:"$ bPlayerOwned );

	// Adjust trace distance if view pitched down (to help player kill crouching pawns)
	PitchAdj = Instigator.GetViewRotation().Pitch;  
	if( PitchAdj > 49151 )   // > 270 deg
	{
		// Use pitch only as far down as -45 deg = 315 deg = 57344 unreal angle units
		PitchAdj = max( PitchAdj, 57344 );  
		AdjustedTraceDist = AdjustedTraceDist / cos( PitchAdj/10430.06 ); // radians / unreal angle units = 10430.06
	}
	else
		AdjustedTraceDist = TraceDist;

//	Log("//// TraceDist:"$ TraceDist $"  AdjustedTraceDist:"$ AdjustedTraceDist $"  bPlayerOwned:"$ bPlayerOwned );

	Owner.MakeNoise(fNoiseFactor);
	
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	StartTrace = GetFireStart(X,Y,Z); 
//	Log("  StartTrace - Loc:"$ StartTrace - instigator.Location $"    "$ VSize(StartTrace - instigator.Location) );

	// Adjust endpoint of trace (for horizontal and vertical offset and inaccuracy).
	//    Max scatter angle = 2 * arctangent( accuracy * 0.5 * 1000 / TraceDistance ) 
	EndTrace = StartTrace + Y * YOffset * 1000 + Z * ZOffset * 1000;
	EndTrace += (AdjustedTraceDist * X);

	// Try to find a victim down the middle (where the crosshair would be)
	Victim = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial,true);
//	if( Victim != None )
//		Spawn(class'ZombieGame.BulletHole',,,HitLocation,);  // DEBUG

	if( Level.bMPWeapLogs )
	{
		if( Pawn(Victim) != None )
		{
			Log( Level.TimeSeconds $" MPLog: #### Knife jab by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit player named "$ Pawn(Victim).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(Victim).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(Victim).PlayerReplicationInfo.bTerrorist $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
		}
		else if( Victim != None )
		{
			Log( Level.TimeSeconds $" MPLog: #### Knife jab by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit a(n) "$ Victim.class $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
		}
		else
		{
			Log( Level.TimeSeconds $" MPLog: #### Knife jab by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit nothing.");
		}
	}

	// If no victim was found or victim is not a pawn, do backup trace
	if( Pawn(Victim) == None )
	{
		EndTrace = StartTrace + (BackupTraceOffset.Y) * Y  + (BackupTraceOffset.Z) * Z;
		StartTrace = StartTrace + (BackupTraceOffset.Y*0.5) * Y + (BackupTraceOffset.Z*0.5) * Z;

		EndTrace += ( (AdjustedTraceDist+BackupTraceOffset.X) * X);
		Victim2 = Trace(HitLocation2,HitNormal2,EndTrace,StartTrace,
						True,,HitMaterial,true);
	//	if( Victim2 != None )
	//		Spawn(class'ZombieGame.BulletHole',,,HitLocation2,);  // DEBUG

		if( Level.bMPWeapLogs )
		{
			if( Pawn(Victim2) != None )
			{
				Log( Level.TimeSeconds $" MPLog: #### Knife jab backup trace by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit player named "$ Pawn(Victim2).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(Victim2).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(Victim2).PlayerReplicationInfo.bTerrorist $"  using this instead of first trace.  dist:"$ VSize(HitLocation2-StartTrace) $" ("$ VSize(HitLocation2-StartTrace)/24 $"ft)" );
			}
			else if( Victim2 != None )
			{
				Log( Level.TimeSeconds $" MPLog: #### Knife jab backup trace by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit a(n) "$ Victim2.class $" sticking with first trace.  dist:"$ VSize(HitLocation2-StartTrace) $" ("$ VSize(HitLocation2-StartTrace)/24 $"ft)" );
			}
			else
			{
				Log( Level.TimeSeconds $" MPLog: #### Knife jab backup trace by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit no pawns: definitely sticking with first trace.");
			}
		}

		// If this trace had beter luck, (found a pawn, or found something
		// while the other trace found nothing) then use this victim
		if( Pawn(Victim2) != None || (Victim == None && Victim2 != None) )
		{
			Victim = Victim2;
			HitLocation = HitLocation2;
		}
	}

	if( Victim != None && VSize(HitLocation-StartTrace) <= AdjustedTraceDist )
	{
		ClientInstigatorEffects();
		Victim.TakeDamage(DamageAmount, Instigator, HitLocation, X*2.0, class'ZombieGame.DamageTypeMelee');
	//	Spawn(class'ZombieGame.BulletHole',,,HitLocation,);  // DEBUG
	}
}

simulated function ClientInstigatorEffects()
{
	if ( Instigator == None || PlayerController ( Instigator.Controller ) == None ) return;

	// Shake client's view
	Instigator.controller.SetupShake ( 0.15f, vect ( 1, 1, 1.5 ), 0.002f, false, 0 );

	// Rumble the client's controller
	if (RumbleDes != none)
	{
		PlayerController(Instigator.controller).PlayRumble(RumbleDes);
	}
}

simulated event PlayFireSound()
{
//	log("PlayFireSound");
//	TimeOfLastShot=Level.TimeSeconds;

	if( Instigator.IsLocallyControlled() )
		PlayFireSoundForZone();
}

// ----------------------------



// Decompiled with UE Explorer.
defaultproperties
{
    xSingleFire2="shoot2"
    BackupTraceOffset=(X=0.0000000,Y=16.0000000,Z=-36.0000000)
    MPBotTraceDist=65.0000000
    SPBotTraceDist=60.0000000
    PVMeshName="CBA_PV_Weapons.pv_hands"
    ReticleRangeFactor=0.5200000
    BurstLength=1
    bCanZoom=false
    ZoomPlayerViewOffset=(X=9.0000000,Y=0.0000000,Z=1.0000000)
    ZoomRotationOffset=(Pitch=0,Yaw=0,Roll=0)
    ZoomLeanPVYCorr=0.1600000
    ZoomLeanPVZCorr=0.3000000
    LeanPlayerViewOffset=(X=0.0000000,Y=-4.0000000,Z=-0.5000000)
    LeanRotationOffset=(Pitch=0,Yaw=100,Roll=0)
    ZoomLeanPlayerViewOffset=(X=9.0000000,Y=-3.0000000,Z=-0.2000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=100,Roll=0)
    BotFireRate=1.0000000
    BotBulletInterval=0.2500000
    WeaponAnims=1
    ViewKickRate=(X=32.0000000,Y=64.0000000,Z=0.0000000)
    ViewKickMax=(X=32.0000000,Y=64.0000000,Z=0.0000000)
    fViewRestoreTime=0.1500000
    BotBurstSize=1
    BotTimeBetweenBursts=0.2500000
    SpeedClass=1
    TakeOutAnim[0]="aim_knife_select"
    TakeOutAnim[1]="aim_knife_select"
    PutAwayAnim[0]="aim_knife_deselect"
    PutAwayAnim[1]="aim_knife_deselect"
    PoseAnim[0]="aim_knife_pose"
    PoseAnim[1]="aim_knife_pose"
    PawnFireAnim="aim_knife_shoot"
    YawSwayFactor=1.1000000
    PitchSwayFactor=1.2000000
    TransSwayFactors=(X=1.7000000,Y=1.3000000,Z=1.6000000)
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
    fNoiseFactor=0.0500000
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.PV_KNIFE"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    UseAttachAnims=true
    AttachReloadAnim="Reload"
    WeapAnimSet="Weapons.KnifeAnims"
    WeapAttTexName="CBT_DYN_Weapons.knife.pv_knife"
    CrosshairIndex=-1
    WeaponIconIndex=38
    hudProps=(WeaponIconIdx=27,AmmoIconIdx=255,ItemsPerTex=0)
    FireSounds[0]=Sound'CBW_DYN_weapons.Knife.Knife_Fire1'
    FireSounds[1]=Sound'CBW_DYN_weapons.Knife.Knife_Fire1'
    // Reference: RumbleConst'WeapKnife.WeapRumbleSS'
    begin object name=WeapRumbleSS class=Class'ZombieGame.RumbleConst'
        MaxStrength=0.2500000
        Duration=0.2500000
        UseLeftMotor=false
    end object
    RumbleDes=WeapRumbleSS
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleFlashScale=0.0700000
    bWeapHasMuzzleFlash=false
    PickupAmmoCount=60
    ReloadCount=1
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    DamageAmount=150.0000000
    AIRating=0.4100000
    TraceDist=95.0000000
    DisplayFOV=60.0000000
    FlashOffsetY=-116.0000000
    FlashOffsetX=-170.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=150
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_knife'
    ThirdPersonScale=1.0000000
    ThirdPersonRelativeLocation=(X=10.0000000,Y=-2.0000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=0,Yaw=0,Roll=-16384)
    AttachmentClass=Class'KnifeAttach'
    ItemName="Knife"
    DrawScale=1.0000000
}