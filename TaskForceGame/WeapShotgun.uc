class WeapShotgun extends ZombieWeapon;

#exec ANIM IMPORT ANIM=ShotgunAnims ANIMFILE=..\Animations\PSA\pv_shotgun_hands.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=ShotgunAnims USERAWINFO VERBOSE

#exec ANIM NOTIFY ANIM=ShotgunAnims SEQ=shoot FRAME=0.5 FUNCTION=PlayFireSound
#exec ANIM NOTIFY ANIM=ShotgunAnims SEQ=shoot FRAME=4.5 FUNCTION=EjectBrass
#exec ANIM NOTIFY ANIM=ShotgunAnims SEQ=reload_repeat FRAME=8.0 FUNCTION=AddShell
#exec ANIM NOTIFY ANIM=ShotgunAnims SEQ=reload_last FRAME=6.0 FUNCTION=AddShell

#exec ANIM IMPORT ANIM=ShotgunWeapAnims ANIMFILE=..\Animations\PSA\pv_shotgun_weapon.psa COMPRESS=1.0 MAXKEYS=999999 IMPORTSEQS=1
#exec ANIM DIGEST ANIM=ShotgunWeapAnims USERAWINFO VERBOSE

var(Damage) int	CentralDamageAmount;
var(Damage) int	MPCentralDamageAmount;

var() int	TracesPerShot;		// how many traces should be projected when fired
var() int	MPTracesPerShot;	// how many traces should be projected when fired in multiplayer
var() int	MPPelletsPerShot;	// number of traces that actually cause hurt in multiplayer

var() float PatternY[5];  // Y locations for pre-set shot pattern of first few shots

var() sound ReloadStartSound;
var() sound ReloadLoopSound;
var() sound ReloadLastSound;

var(WeapHandAnimations) name xReloadStartAnim;
var(WeapHandAnimations) name xReloadLoopAnim;
var(WeapHandAnimations) name xReloadLastAnim;

var (AttachAnims)	name				AttachReloadStartAnim;
var (AttachAnims)	name				AttachReloadLoopAnim;
var (AttachAnims)	name				AttachReloadLastAnim;

var bool bShellAdded; // set to true if shell insertion has been counted during current reload anim


// Network replication
//
replication
{
	// Functions called by server on client
	reliable if( Role==ROLE_Authority )
		ClientGotoBeginReloading, ClientGotoSGReloading, ClientPlayReloadLoop, 
		ClientGotoSGEndReloading, ClientSGPutDown;

	unreliable if( Role==ROLE_Authority )
		ClientFakeHoles;

	// Functions called by client on server 
	reliable if( Role<ROLE_Authority )
		ServerSGPutDown, ServerCancelReload, ServerGotoBeginReloading;
}

static simulated function PreCacheWeapAssets()
{
	DynamicLoadObject ( "CBA_PV_Weapons.PV_shotgun", class'Mesh' );
	DynamicLoadObject ( "Weapons.ShotgunWeapAnims", class'MeshAnimation' );
	DynamicLoadObject ( "Weapons.ShotgunAnims", class'MeshAnimation' );
}

// -----------------------------
// #@&$ hack for muiltiplayer.
// If shotgun has reserve ammo and player empties magazine and immediately switches to 
// another weapon, there was a multiplayer bug where other weapon would go down and up
// repeatedly.
// Seems that it was trying to reload the shotgun, so the least risky hack at this late
// stage is to put one shell in the stupid thing when it's being put down so that it
// won't keep trying to reload.  Oh, and do it for both server and client.
// Use ServerSGPutDown instead of GotoState('DownWeapon') in PutDown function.

function ServerSGPutDown()
{
	if( Level.Game == None || (SFRMMultiPlayer(Level.Game) != None))
	{
		if( AmmoType.AmmoAmount > 0 && ReloadCount == 0 )
		{
			ReloadCount = 1;
			--AmmoType.AmmoAmount;
		}
	}
	GotoState('DownWeapon');
	ClientSGPutDown();
}

simulated function ClientSGPutDown()
{
	if( Level.Game == None || (SFRMMultiPlayer(Level.Game) != None))
	{
		if( AmmoType.AmmoAmount > 0 && ReloadCount == 0 )
		{
			ReloadCount = 1;
			--AmmoType.AmmoAmount;
		}
	}
	GotoState('DownWeapon');
}
// -----------------------------

state idle
{
	simulated function ClientGotoSGReloading() {}
	simulated function ClientPlayReloadLoop() {}
}

state ClientFiring
{
	simulated function ClientGotoSGReloading() {}
	simulated function ClientPlayReloadLoop() {}
}

//
// Overload Trace fire to compensate for multiple traced fired of 
// by a shotgun class weapon
//
function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Material HitMaterial; 
	local vector TracerStart; 
	local rotator TraceRotation; 
	local bool OverrideAutoAim, bInstigatorIsPlayer;
	local int ShotIndex;   // Counter for traces
	local int NumTraces;   // Number of traces to be done
	local int NumPellets;  // Number of traces that actually cause hurt
	local StatManager StatMgr;
	local float YRndF, ZRndF;
	local int CentralDamage, NormalDamage;

	if ( Pawn(Owner) != None && SFRMPlayerController(Pawn(Owner).Controller) != None )
	{
		StatMgr = SFRMPlayerController(Pawn(Owner).Controller).StatMgr;
	}

	OverrideAutoAim = true;

	if (!AutoAimOnZoom && bZoomed)
		OverrideAutoAim = true;

	if( Pawn(Owner) != None && SFRMPlayerController(Pawn(Owner).Controller) != None )
		bInstigatorIsPlayer = true;
	else
		bInstigatorIsPlayer = false;

	Owner.MakeNoise(fNoiseFactor);
	
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	StartTrace = GetFireStart(X,Y,Z); 

	AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 2*AimError, OverrideAutoAim);	

	X = vector(AdjustedAim);

	// Reduce number of pellets per shot for multiplayer
	//  In CoOp this works because headshot damage to AI is magnified (like in single player), and
	//  an upper-torso shot could land a pellet on the enemy's head.
	//  In non-CoOp MP this helps balance the shotgun against the other weapon classes.
	if( Level.Game == None || Level.NetMode != NM_Standalone 
	 || ClassIsChildOf( Level.Game.class, class'ZombieGame.SFRMMultiplayer') )
	{
		NumTraces = MPTracesPerShot;
		NumPellets = MPPelletsPerShot;
		NormalDamage = MPDamageAmount;
		CentralDamage = MPCentralDamageAmount;
	}
	else
	{
		NumTraces = TracesPerShot;
		NumPellets = TracesPerShot;
		NormalDamage = DamageAmount;
		CentralDamage = CentralDamageAmount;
	}

	if( Level.bMPWeapLogs )
		Log( Level.TimeSeconds $" MPLog: #### Shotgun blast fired by "$ instigator.PlayerReplicationInfo.PlayerName );

	for (ShotIndex = 0; ShotIndex < NumPellets; ShotIndex++ )
	{
		if( bInstigatorIsPlayer && StatMgr != None )
		{
			StatMgr.ShotFired();
		}

		if( ShotIndex < 5 )
		{
			// For first 5 shots, have them horizontally distributed 
			// in a fairly consistent pattern
		//	YRndF = (float(ShotIndex)*0.25)-0.375;
			YRndF = PatternY[ShotIndex];
			ZRndF = (FRand()-0.5)*0.25;
		}
		else
		{
			YRndF = (FRand() - 0.5);
			ZRndF = (FRand() - 0.5);

			// Try to keep traces from overlapping too much with the first
			// few traces (the ones that are in a controlled pattern).
			if( ZRndF > 0 && ZRndF < 0.1 )
				ZRndF += 0.20;
			else if( ZRndF < 0 && ZRndF > -0.1 )
				ZRndF -= 0.20;
		}
	//	Log("ShotIndex:"$ ShotIndex $"   Y:"$ YRndF @ (Accuracy * YRndF) $"  Z:"$ ZRndF @ (Accuracy * ZRndF) );

		EndTrace = StartTrace  +  (YOffset + Accuracy * YRndF ) * Y * 1000
			+  (ZOffset + Accuracy * ZRndF) * Z * 1000;

		EndTrace	+= (TraceDist * X);

		Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial,true);

		if( Level.bMPWeapLogs )
		{
			if( Pawn(Other) != None )
			{
				Log( Level.TimeSeconds $" MPLog:   ## Shotgun pellet "$ ShotIndex $" fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit player named "$ Pawn(other).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(other).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(other).PlayerReplicationInfo.bTerrorist $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)  (Y:"$ YRndF $" Z:"$ ZRndF $")" );
			}
			else if( Other != None )
			{
				Log( Level.TimeSeconds $" MPLog:   ## Shotgun pellet "$ ShotIndex $" fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit a(n) "$ other.class $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)  (Y:"$ YRndF $" Z:"$ ZRndF $")" );
			}
			else
			{
				Log( Level.TimeSeconds $" MPLog:   ## Shotgun pellet "$ ShotIndex $" fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  hit nothing.  (Y:"$ YRndF $" Z:"$ ZRndF $")" );
			}
		}

		if ( bFireTracer != False && !bInstigatorIsPlayer )
		{
			ZombieWeaponAttachment(ThirdPersonActor).GetEffectStart(TracerStart,TraceRotation);
			Spawn(class'Tracer', self, ,TracerStart, AdjustedAim); 
		}

		if( ShotIndex > 0 && ShotIndex < 4 )
			DamageAmount = CentralDamage;
		else
			DamageAmount = NormalDamage;

		// We're doing a real trace (causes hurt, spawns impact effect)
		AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z, HitMaterial);
	}

	// Add additional bullet holes (but without the impact effect or damage infliction)
	if( NumPellets < NumTraces )
		ClientFakeHoles( NumTraces-NumPellets, Instigator.GetViewRotation(), StartTrace );
}

simulated function ClientFakeHoles( int NumHoles, rotator ViewRotationIn, vector StartTraceIn )
{
	local int NoHurtTraceIndex;
	local vector HitLocation, HitNormal, EndTrace, X,Y,Z;
	local actor Other;
	local Material HitMaterial; 
	local float YRndF, ZRndF;

	GetAxes(ViewRotationIn,X,Y,Z);

	for( NoHurtTraceIndex = 0 ; NoHurtTraceIndex < NumHoles ; NoHurtTraceIndex++ )
	{
		YRndF = (FRand() - 0.5);
		ZRndF = (FRand() - 0.5);

		// Try to keep fake traces from overlapping too much with the real traces
		if( ZRndF > 0 && ZRndF < 0.1 )
			ZRndF += 0.20;
		else if( ZRndF < 0 && ZRndF > -0.1 )
			ZRndF -= 0.20;

		EndTrace = StartTraceIn  +  (TraceAccuracy * YRndF) * Y * 1000
			+  (TraceAccuracy * ZRndF) * Z * 1000;

		EndTrace	+= (TraceDist * X);

		Other = Trace(HitLocation,HitNormal,EndTrace,StartTraceIn,True,,HitMaterial,true);

		// This won't inflict damage and won't spawn impact effect -- 
		// just puts down a bullet hole)
		if( Other != None && Other.bShowBulletHoles 
		&& HitMaterial.MaterialType != EMATERIALTYPE_NONE 
		&& HitMaterial.MaterialType != EMATERIALTYPE_WATER 
		&& HitMaterial.MaterialType != EMATERIALTYPE_SKY )
		{
		//	Log("Client fake bullet hole "$ NoHurtTraceIndex );
		//	SFRMAmmunition(AmmoType).ClientNewBulletHole( HitLocation.X, HitLocation.Y, HitLocation.Z, (HitNormal*1000) );
			Level.NewBulletHole( HitLocation, HitNormal );
		}
	}
}

//
// Trigger event for animnotify_script to play fire sound
//  (Overriding PlayFireSound to not eject brass)
//
simulated event PlayFireSound()
{
//	log("PlayFireSound");
//	TimeOfLastShot=Level.TimeSeconds;

	if( Instigator.IsLocallyControlled() )
		PlayFireSoundForZone();
}

simulated function PlayReloadLoopSound()
{
	if( ReloadLoopSound != None )
		Instigator.PlaySound(ReloadLoopSound,SLOT_Misc,,,200.0);  // arg 2: slot, arg 5: radius
}

state Reloading
{
	function ServerForceReload() {}
	function ClientForceReload() {}
	function Fire( float Value ) {}
	function AltFire( float Value ) {}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event bool PutDown()
	{
	//	GotoState('DownWeapon');
		ServerSGPutDown();
		return True;
	}

	simulated function BeginState()
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.Reloading.BeginState   ");
		// Support for inifinite ammo cheat.  
		// (The idea is that the magical ammo pixie resupplies you one clip at a time).
		if(instigator!=None && instigator.controller!=None && instigator.controller.bInfiniteAmmo )
		{
			AmmoType.AmmoAmount = Max( default.ReloadCount, AmmoType.AmmoAmount );
		}

		if (bZoomed)		// zoom out if a weapon is zoomed in duing reload
			Unzoom(); 

		Instigator.PlaySound(ReloadSound,SLOT_Misc,,,200.0);  // arg 2: slot, arg 5: radius

		GotoState('ShotgunStartReloading');
		if( Level.NetMode != NM_Standalone )
		{
			if( Role == ROLE_Authority )
				ClientGotoBeginReloading();
			else
				ServerGotoBeginReloading();
		}
	}

	simulated function EndState() {}

	simulated function AnimEnd(int Channel)
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.Reloading.AnimEnd   ");
//		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
			warn(self$" stuck in Reloading and not animating!");
	}
}

state ShotgunReloadingBase
{
	function ServerForceReload() {}
	function ClientForceReload() {}
	simulated function Fire( float Value )
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShogtunReloadingBase.Fire   state:"$ GetStateName() );
	//	if( Role < ROLE_Authority && ReloadCount > 0 )
	//		ServerGotoState('Idle');
		if( Role < ROLE_Authority && ReloadCount > 0 )
			ServerCancelReload(ReloadCount);
		Global.Fire( Value );
	}

	function AltFire( float Value ) {}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event bool PutDown()
	{
	//	GotoState('DownWeapon');
		ServerSGPutDown();
		return True;
	}
	
	function CheckAnimating()
	{
		if ( !IsAnimating() )
			warn(self$" stuck in Reloading and not animating!");
	}

	simulated function Zoom()
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunReloadingBase.Zoom ");
		if( SFRMSinglePlayer(Level.Game) == None )
		{
			// In multiplayer game, try to guard against someone hitting zoom (or rapidly cycling
			// between zoom and unzoom) at the beginning of reload and causing client bug where
			// ammo counter briefly shows 255
			if( ReloadCount == 0 )
			{
				return;
			}
			else
			{
			//	Log("   calling ServerGotoState('Idle') ");
			//	ServerGotoState('Idle');
			//	Log("   calling ServerCancelReload  RC:"$ ReloadCount );
				ServerCancelReload(ReloadCount);

				// Get the client's playerview weapon back to a non-reloading position
				if( HasAnim(xSubtleIdle) )
					PlayAnim(xSubtleIdle, 2.5);
			}
		}

		Global.Zoom();
	}

}

function ServerGotoBeginReloading()
{
	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ServerGotoBeginReloading   ");
	GotoState('ShotgunStartReloading');
}

simulated function ClientGotoBeginReloading()
{
	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ClientGotoBeginReloading   ");
	GotoState('ShotgunStartReloading');
}

state ShotgunStartReloading extends ShotgunReloadingBase
{
	ignores ServerGotoBeginReloading, ClientGotoBeginReloading;

	simulated function AnimEnd(int Channel)
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunStartReloading.AnimEnd    RC:"$ ReloadCount );
		if( GetReloadCount() < GetDefaultReloadCount()-1 && AmmoType.AmmoAmount > 1 )
		{	
			if( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
				ClientGotoSGReloading();  // This is just in case the client hasn't changed state on its own
			GotoState('ShotgunReloading'); 
		}
		else
		{
			GotoState('ShotgunEndReloading');
		}	
		CheckAnimating();	
	}
	
	simulated function BeginState()
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunStartReloading.BeginState   ");
		if (GetReloadCount() != GetDefaultReloadCount())
		{ 
			if (HasAnim(xReloadStartAnim))
				PlayAnim(xReloadStartAnim, 1.0f, 0.02f);
			if (UseAttachAnims && UseWeapAttachment && (AttachReloadStartAnim != ''))
			{
				WeapAttachment.PlayAnim(AttachReloadStartAnim, 1.0f, 0.02f);
			}
		}
		else
		{
			bForceReload = false;
			if ( Role < ROLE_Authority )
				ClientFinish();
			else
				Finish();
		}
	}

//	simulated function bool canQuickGrenade()
//	{
	//	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"   WeapShotgun.ShotgunStartReloading.canQuickGrenade  state:"$ GetStateName() );
	//	Log("BLEAAAAAARGHHHHHHHH!!!!!!!");
//		return false;
//	}

}

//simulated function Zoom()
//{
//	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"   WeapShotgun.Zoom    ");
//	Super.Zoom();
//}

// If we're in a laggy network game where the client interrupts reload, but
// the ClientPlayReloadLoop gets sent by the server before the server finds
// out that reload is being cancelled, then versions of this function in 
// state ClientFiring and state idle should reduce the odds we'll get an
// unexpected shell-insertion anim.
simulated function ClientPlayReloadLoop()
{
	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ClientPlayReloadLoop    RC:"$ ReloadCount $"  state:"$ GetStateName() );
	PlayAnim(xReloadLoopAnim, 1.0f, 0.02f);
	if (UseAttachAnims && UseWeapAttachment && (AttachReloadLoopAnim != ''))
	{
		WeapAttachment.PlayAnim(AttachReloadLoopAnim, 1.0f, 0.02f);
	}
}

simulated function ClientGotoSGReloading()
{
	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"    WeapShotgun.ClientGotoSGReloading    RC:"$ ReloadCount $"  state:"$ GetStateName() );
	GotoState('ShotgunReloading');
}

function ServerCancelReload( int ClientReloadCount )
{
	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"    WeapShotgun.ServerCancelReload    RC:"$ ReloadCount $"  state:"$ GetStateName() );
	if( ClientReloadCount > 0 && ReloadCount > 0 && ClientReloadCount < ReloadCount )
	{
		// If a shell insertion happened on the server, but the client hasn't
		// played one yet (due to lag), this rolls it back by one.
		// Rollback is only limited to one to try to limit potential problems.
		ReloadCount--;
	}
	GotoState('Idle');
}

simulated function AddShell()
{
	ReloadCount += AmmoType.RequestReloadAmmo(1);
	if( Role==ROLE_Authority )
	{
		ClientUpdateReloadCount(ReloadCount);
	}
	bShellAdded=true;
}

state ShotgunReloading
{
	simulated function ClientGotoSGReloading() {}  // If we're already in the state, don't need to go to it.

	simulated function AnimEnd(int Channel)
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunReloading.AnimEnd    RC:"$ ReloadCount );

		// shotgun reloads one shell at a time
		if( !bShellAdded && Role==ROLE_Authority )
		{
			AddShell();
			//Log("   count shell:" $ ReloadCount );
		}

		// Keep looking until all ammo shells (except for last) are in
		// If only last shell remains to be loaded (or one shell left in ammo),
		// jump to ShotgunEndReloading state
		if (AmmoType.AmmoAmount == 1 || ReloadCount >= GetDefaultReloadCount()-1 ) 
		{
			//Log("   going to state ShotgunEndReloading");
			if( Level.NetMode != NM_Standalone && Role==ROLE_Authority )
				ClientGotoSGEndReloading();
			GotoState('ShotgunEndReloading'); 
		}
		else
		{
			if (HasAnim(xReloadLoopAnim))
			{
				bShellAdded=false;
				if( ROLE==Role_Authority )
				{
					PlayReloadLoopSound();

					if( Level.NetMode != NM_Standalone )
						ClientPlayReloadLoop();
					PlayAnim(xReloadLoopAnim, 1.0f, 0.02f);
					if (UseAttachAnims && UseWeapAttachment && (AttachReloadLoopAnim != ''))
					{
						WeapAttachment.PlayAnim(AttachReloadLoopAnim, 1.0f, 0.02f);
					}
				}
			}
		}		
		CheckAnimating();	
	}
	
	simulated function BeginState()
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunReloading.BeginState   ");
		//if ( ZombiePawn ( Owner ) != None )
		//{
		////	log ( "***ShotgunReloading - BeginState - Calling ServerShotgunShell***" );
		//	ZombiePawn ( Owner ).ServerShotgunShell ( );
		//}

		if (HasAnim(xReloadLoopAnim))
		{
			bShellAdded=false;
			if( ROLE==Role_Authority )
			{
				if( Level.NetMode != NM_Standalone )
					ClientPlayReloadLoop();
				PlayAnim(xReloadLoopAnim, 1.0f, 0.02f);
				if (UseAttachAnims && UseWeapAttachment && (AttachReloadLoopAnim != ''))
				{
					WeapAttachment.PlayAnim(AttachReloadLoopAnim, 1.0f, 0.02f);
				}
			}
		}
		else 
			GotoState('ShotgunEndReloading'); 
	}

	function ServerForceReload() {}
	function ClientForceReload() {}

	simulated function Fire( float Value )
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunReloading.Fire ");
	//	Log("WeapShotgun.ShotgunReloading.Fire   state:"$ GetStateName() );
		if( Role < ROLE_Authority && ReloadCount > 0 )
		{
		//	Log("   calling ServerGotoState('Idle') ");
		//	ServerGotoState('Idle');
		//	Log("   calling ServerCancelReload  RC:"$ ReloadCount );
			ServerCancelReload(ReloadCount);
		}
		Global.Fire( Value );
	}

	function ServerFire()
	{
	//	Log("WeapShotgun.ShotgunReloading.ServerFire   state:"$ GetStateName() );
		if (ReloadCount > 0)
			Global.ServerFire();
	}

	simulated function Zoom()
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunReloading.Zoom ");
		if( SFRMSinglePlayer(Level.Game) == None )
		{
			// In multiplayer game, try to guard against someone hitting zoom (or rapidly cycling
			// between zoom and unzoom) at the beginning of reload and causing client bug where
			// ammo counter briefly shows 255
			if( ReloadCount == 0 )
			{
				return;
			}
			else
			{
			//	Log("   calling ServerGotoState('Idle') ");
			//	ServerGotoState('Idle');
			//	Log("   calling ServerCancelReload  RC:"$ ReloadCount );
				ServerCancelReload(ReloadCount);

				// Get the client's playerview weapon back to a non-reloading position
				if( HasAnim(xSubtleIdle) )
					PlayAnim(xSubtleIdle, 2.5);
			}
		}

		Global.Zoom();
	}

	simulated event bool PutDown()
	{
	//	GotoState('DownWeapon');
		ServerSGPutDown();
		return True;
	}
	
	function CheckAnimating()
	{
		if ( !IsAnimating() )
			warn(self$" stuck in Reloading and not animating!");
	}
}

simulated function ClientGotoSGEndReloading()
{
	//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ClientGotoSGEndReloading   RC:"$ ReloadCount );
	GotoState('ShotgunEndReloading');
}

state ShotgunEndReloading extends ShotgunReloadingBase
{
	function ClientGotoSGEndReloading() { Log("   ClientGotoSGEndReloading: already in state"); } // don't need to go to this state if already in this state

	simulated function AnimEnd(int Channel)
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunEndReloading.AnimEnd   RC:"$ ReloadCount );

		// reload last shell
		if( !bShellAdded && Role==ROLE_Authority )
		{
			AddShell();
			Log("   count shell:" $ ReloadCount );
		}

		if ( Role < ROLE_Authority )
			ClientFinish();
		else
			Finish();
	}
	
	simulated function BeginState()
	{
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunEndReloading.BeginState   ");
		if (HasAnim(xReloadLastAnim))
		{
			bShellAdded=false;
			PlayAnim(xReloadLastAnim, 1.0f, 0.02f);
			if( ReloadLastSound != None )
				Instigator.PlaySound(ReloadLastSound,SLOT_Misc,,,200.0);  // arg 2: slot, arg 5: radius
		}
		if (UseAttachAnims && UseWeapAttachment && (AttachReloadLastAnim != ''))
		{
			WeapAttachment.PlayAnim(AttachReloadLastAnim, 1.0f, 0.02f);
		}

		//if ( ZombiePawn ( Owner ) != None )
		//{
		////	log ( "***ShotgunEndReloading - BeginState - Calling ServerShotgunReloaded***" );
		//	ZombiePawn ( Owner ).ServerShotgunReloaded ( );
		//}

		// reload last shell
		//if( !bShellAdded )
		//{
		//	ReloadCount += AmmoType.RequestReloadAmmo(1);
		//	ClientUpdateReloadCount(ReloadCount);
		//	bShellAdded=true;
		//}
	}

	simulated function EndState()
	{	
		//Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  WeapShotgun.ShotgunEndReloading.EndState   ");
		if( ZombiePlayerPawn(Instigator) != None )
		{
			ZombiePlayerPawn(Instigator).EndReloadAnim(); 		
		}
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    CentralDamageAmount=35
    MPCentralDamageAmount=35
    TracesPerShot=8
    MPTracesPerShot=8
    MPPelletsPerShot=5
    PatternY[0]=-0.4000000
    PatternY[1]=-0.1800000
    PatternY[3]=0.1800000
    PatternY[4]=0.4000000
    ReloadLoopSound=Sound'CBW_DYN_weapons.Shotgun.Reload_shotgun_shell'
    ReloadLastSound=Sound'CBW_DYN_weapons.Shotgun.Reload_shotgun_charge'
    xReloadStartAnim="reload_start"
    xReloadLoopAnim="reload_repeat"
    xReloadLastAnim="reload_last"
    AttachReloadStartAnim="reload_start"
    AttachReloadLoopAnim="reload_repeat"
    AttachReloadLastAnim="reload_last"
    PVMeshName="CBA_PV_Weapons.PV_HANDS"
    WeaponSpread[0]=0.4740000
    WeaponSpread[1]=0.4740000
    WeaponSpread[2]=0.4740000
    WeaponSpread[3]=0.4740000
    MinScatterFactor=1.0000000
    BurstLength=1
    ZoomPlayerViewOffset=(X=-0.3000000,Y=-4.5000000,Z=2.2000000)
    ZoomRotationOffset=(Pitch=0,Yaw=1150,Roll=700)
    ZoomLeanPVYCorr=0.2000000
    LeanPlayerViewOffset=(X=1.0000000,Y=-12.0000000,Z=-1.0000000)
    LeanRotationOffset=(Pitch=0,Yaw=1100,Roll=0)
    ZoomLeanPlayerViewOffset=(X=-0.6000000,Y=-5.3400000,Z=1.7000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=1100,Roll=600)
    WeaponAnims=3
    bFireTracer=true
    vMuzzleFlashLocalOffset=(X=-200.0000000,Y=-100.0000000,Z=0.0000000)
    BrassStartVelocityRange=(X=(Min=-120.0000000,Max=-130.0000000),Y=(Min=-90.0000000,Max=-80.0000000),Z=(Min=130.0000000,Max=140.0000000))
    BrassRight=(X=0.0000000,Y=-1.0000000,Z=0.0000000)
    MinShotDistBrass=32000.0000000
    ViewKickRate=(X=0.0000000,Y=0.0000000,Z=1024.0000000)
    ViewKickMax=(X=0.0000000,Y=0.0000000,Z=4096.0000000)
    fViewRestoreTime=0.5000000
    SpeedClass=1
    xSubtleIdle="Idle"
    xNonSubtleIdle="Idle"
    xSingleFire="shoot"
    xHolsterAnim="holster"
    xSelectAnim="load"
    fNoiseFactor=2.2000000
    UseWeapAttachment=true
    WeapAttachmentMeshName="CBA_PV_Weapons.PV_shotgun"
    WeapAttachmentBone="pv_gun"
    WeapAttachmentScale=1.0000000
    WABrassBone="gun_brass"
    UseAttachAnims=true
    AttachFireAnim="shoot"
    WeapAnimSet="Weapons.ShotgunAnims"
    WeapAttachAnimSet="Weapons.ShotgunWeapAnims"
    WeapAttTexName="CBT_DYN_Weapons.Shotgun.pv_shotgun"
    CrosshairIndex=5
    WeaponIconIndex=24
    hudProps=(WeaponIconIdx=37,AmmoIconIdx=34,ItemsPerTex=3)
    FireSounds[0]=Sound'CBW_DYN_weapons.Shotgun.shotgun_FireIndoor1'
    FireSounds[1]=Sound'CBW_DYN_weapons.Shotgun.shotgun_FireOutdoor1'
    ReloadSound=Sound'CBW_DYN_weapons.Shotgun.Reload_shotgun_release'
    // Reference: RumbleSawtooth'WeapShotgun.WeapRumbleShotgun'
    begin object name=WeapRumbleShotgun class=Class'ZombieGame.RumbleSawtooth'
        Frequency=0.1500000
        MaxStrength=0.8000000
        Duration=0.2500000
        UseRightMotor=false
    end object
    RumbleDes=WeapRumbleShotgun
    PVMuzzleStaticMeshClass=Class'ZombieGame.PlayerViewMuzzleFlashEffect'
    PVMuzzleLocation=(X=90.0000000,Y=7.0000000,Z=-5.5000000)
    PVMuzzleFlashScale=0.0800000
    PVMuzzleLocationZoomed=(X=90.0000000,Y=16.0000000,Z=-10.0000000)
    PVMuzzleLocationLean=(X=90.0000000,Y=15.5000000,Z=-5.5000000)
    PVMuzzleLocationZoomLean=(X=90.0000000,Y=15.5000000,Z=-10.0000000)
    AmmoName=Class'ShotgunAmmo'
    ReloadCount=8
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    TraceAccuracy=0.4740000
    DamageAmount=35.0000000
    MPDamageAmount=35.0000000
    AIRating=0.4100000
    TraceDist=1800.0000000
    FlashOffsetY=-143.0000000
    FlashOffsetX=-138.0000000
    FlashLength=0.0100000
    MuzzleFlashSize=32.0000000
    MFTexture=Texture'CBT_DYN_Weapons.MuzzleFlashes.generic_1st_mflash_tex'
    InventoryGroup=80
    PickupClass=Class'PickupShotgun'
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ThirdPersonStaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_shotgun'
    ThirdPersonScale=0.8000000
    ThirdPersonRelativeLocation=(X=11.5000000,Y=-2.5000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=700,Yaw=-900,Roll=-16384)
    AttachmentClass=Class'ShotgunAttach'
    ItemName="Shotgun"
    DrawScale=1.0000000
}