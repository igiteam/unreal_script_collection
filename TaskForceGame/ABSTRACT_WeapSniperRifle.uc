
//
// WeapSniperRifle
//
// new functionality:  
//			- playing zoom in and out sounds
//			- draw scope overlay when zoomed
//			

class ABSTRACT_WeapSniperRifle extends ZombieWeapon abstract; 

const MP_SNIPER_SWAY_DIFF_HACK = 1;

var(WeapSniperRifle) sound ZoomInSound;
var(WeapSniperRifle) sound ZoomOutSound;
var float TimeOfNextZoomInSound;
var float TimeOfNextZoomOutSound;
var float ZoomInSoundLength;
var float ZoomOutSoundLength;

var(WeapSniperRifle) Texture Reticle;
var(WeapSniperRifle) Texture Darken;

// Related to sniper rifle aim sway when zoomed
//var(WeapSniperRifle) float WaveSpeed, WaveTime;
var(WeapSniperRifle) float WaveYawAmplitudeMax, WavePitchAmplitudeMax;	// Max size of sway when zoomed (very hard level)
var(WeapSniperRifle) float WaveYawAmplitudeMin, WavePitchAmplitudeMin;	// Min size of sway when zoomed (very hard level)
var(WeapSniperRifle) float WaveYawPeriod,    WavePitchPeriod;		// Time for a complete cycle, in seconds
//var(WeapSniperRifle) float ZoomStartTime;     // The level time (in seconds) at which the current zoom started
var(WeapSniperRifle) float WaveStartTime;     // The level time (in seconds) at which the current zoom wave motion started
var(WeapSniperRifle) float WaveDampingTime;         // Time (in seconds) for sway to reach minimum amplitude
var(WeapSniperRifle) float WaveDampingTimeCrouched; // Time (in seconds) when crouched for sway to reach minimum amplitude
var(WeapSniperRifle) rotator AppliedWave;
var(WeapSniperRifle) vector  AppliedTranslationWave;  // Portion of tilt turned into translation (to avoid resolution problem)
var(WeapSniperRifle) float YawDirection;
var(WeapSniperRifle) float DampExp;
var bool bZoomNudged;
var bool bFlashSwayIndicator;
var float SwayAmount;

//var class<CrosshairRenderInfo> SniperScope;

var Actor  LastClientVictim;
var vector LastClientHitLoc;
var vector LastClientVictimPos;

replication
{
	// Called by client on server
	reliable if( Role < ROLE_Authority)
		ServerUpdateLastHit;
	reliable if( Role == ROLE_Authority )
		ClientTraceFireCheck;

	// DEBUG FUNCTIONS!
	// Called by server on client
//	reliable if( Role == ROLE_Authority )
//		ClientSpawnLaserDot;
}


simulated function Fire( float Value )
{
	LastClientVictim=None;
	if( Role < ROLE_Authority )
		ClientTraceFireCheck();

	Super.Fire(Value);
}

//state NormalFire
//{
//	function BeginState()
//	{
//		// Make HUD indicate that weapon is not ready to fire yet
//		bIndicateNotReady = true;
//		Super.BeginState();
//	}
//
//	function EndState()
//	{
//		// Make HUD indicate that weapon ready to fire again
//		bIndicateNotReady = false;
//		Super.EndState();
//	}
//}
//
//state ClientFiring
//{
//	simulated function BeginState()
//	{
//		// Make HUD indicate that weapon is not ready to fire yet
//		bIndicateNotReady = true;
//		Super.BeginState();
//	}
//
//	simulated function EndState()
//	{
//		// Make HUD indicate that weapon ready to fire again
//		bIndicateNotReady = false;
//		Super.EndState();
//	}
//}

simulated function float AdjustShotScatter(float Accuracy)
{
	local float ScatterFactor;

	// When zoomed, inaccuracy will actually come from scope sway,
	// so just handle additional inaccuracy for non-zoomed firing
	if( bZoomed )
	{
		ScatterFactor = 1.00;
	}
	else
	{
		ScatterFactor = 1.00;

		// Increase scatter if walking
		if( VSize(Instigator.Velocity) > 10 )
			ScatterFactor *= 1.5;

		// Increase scatter if rotating
		if( SFRMPlayerController(Instigator.Controller) != None 
		 && (abs(SFRMPlayerController(Instigator.Controller).aTurnAccum) > 50 
		  || abs(SFRMPlayerController(Instigator.Controller).aLookUpAccum) > 30) )
			ScatterFactor *= 1.2;

		// Limit scatter factor
		ScatterFactor = FMin( ScatterFactor, 2.0 );
	}

	return ( Super.AdjustShotScatter(Accuracy) * ScatterFactor );
}

simulated state Zooming
{
	simulated function BeginState()
	{
		local PlayerController PC;
		PC = PlayerController(Instigator.Controller);

		if ( PC == None )
			return; 

		if ( bZoomed )
		{
		//	BasicHud(PC.myHUD).ShowHud();
	//		BasicHud(PC.myHUD).SetScopeMode(false, SniperScope, true);
	//		BasicHud(PC.myHUD).SetScopeMode(false);
		//	PC.PlaySound(ZoomOutSound, SLOT_Interface,,,5000);
			GotoState('LoweringScope');	// play lowering anim and reset weapon
		}
		else
		{
		//	BasicHud(PC.myHUD).HideHud();
	//		BasicHud(PC.myHUD).SetScopeMode(true, SniperScope, true);
	//		BasicHud(PC.myHUD).SetScopeMode(true);
		//	PC.PlaySound(ZoomInSound, SLOT_Interface,,,5000);
			fFOVChange=fFOVChangeMin;
		}

//		ZoomStartTime = Level.TimeSeconds;
		ResetZoomTiltBob();
		Super.BeginState();
	}
	
	
}

simulated function PlayZoomInSound()
{
	if( Level.TimeSeconds >= TimeOfNextZoomInSound )
	{
		if( ZombiePlayerPawn(Instigator) != None )
			Instigator.PlaySound(ZoomInSound,SLOT_Interface);
		else
			PlaySound(ZoomInSound,SLOT_Interface);
		TimeOfNextZoomInSound = Level.TimeSeconds + ZoomInSoundLength;
	}
}

simulated function PlayZoomOutSound()
{
	if( Level.TimeSeconds >= TimeOfNextZoomInSound )
	{
		if( ZombiePlayerPawn(Instigator) != None )
			Instigator.PlaySound(ZoomOutSound,SLOT_Interface);
		else
			PlaySound(ZoomInSound,SLOT_Interface);
		TimeOfNextZoomInSound = Level.TimeSeconds + ZoomOutSoundLength;
	}
}

simulated function EndZoom()
{
	local PlayerController PC;
	PC = PlayerController(Instigator.Controller);
		
	Super.EndZoom();
	
//	BasicHud(PC.myHUD).ShowHud();
//	BasicHud(PC.myHUD).SetScopeMode(false, SniperScope, false);
	BasicHud(PC.myHUD).SetScopeMode(false);
//	PC.PlaySound(ZoomOutSound, SLOT_Interface,,,5000);
}

simulated function AdjustZoomIn()
{
	PlayZoomInSound();
	Super.AdjustZoomIn();
}

simulated function AdjustZoomOut()
{
	PlayZoomOutSound();
	Super.AdjustZoomOut();
}

state AdjustingZoom
{
	simulated function Tick(float TimeDelta)
	{
		Super.Tick( TimeDelta );

	//	Log("t:"$Level.TimeSeconds $"  ZoomDelta:"$ZoomDelta );
		if( ZoomDelta < 0 )
			PlayZoomInSound();
		else if( ZoomDelta > 0 )
			PlayZoomOutSound();
	}
}

simulated function StepZoomIn()
{
	PlayZoomInSound();
	Super.StepZoomIn();
}

simulated function StepZoomOut()
{
	PlayZoomOutSound();
	Super.StepZoomOut();
}

state SteppingZoom
{
	simulated function Tick(float TimeDelta)
	{
		Super.Tick( TimeDelta );

	//	Log("t:"$Level.TimeSeconds $"  ZoomDelta:"$ZoomDelta );
		if( ZoomDelta < 0 )
			PlayZoomInSound();
		else if( ZoomDelta > 0 )
			PlayZoomOutSound();
	}
}

simulated state Reloading
{
	simulated function Zoom()
	{
		ResetZoomTiltBob();
		Super.Zoom();
	}
}


simulated event RenderOverlays( canvas Canvas )
{
	local  PlayerController P;

	if ( Instigator == None )
		return;

	P = PlayerController(Pawn(Owner).Controller);
	
	if ( (P != None) && (bZoomed) ) 
	{
		//class'ZombieGame.DragunovSniperScope'.static.DrawCrosshair(canvas, none);
//		SniperScope.static.DrawCrosshair(canvas, none);
	}
	else
		Super.RenderOverlays(Canvas);		
}

function ServerUpdateLastHit( Actor Other, vector OtherPos, vector HitLocation )
{
	LastClientVictim = Other;
	LastClientVictimPos = OtherPos;
	LastClientHitLoc = HitLocation;
}
/*
simulated function ClientSpawnLaserDot(vector HitLocation, optional float DotLifeSpan, optional bool bNoLog )
{
	local LaserDot DotActor; // DEBUG

	if( !bNoLog )
	{
		Log("WeapSniperRifle.ClientSpawnLaserDot  HitLocation:"$HitLocation );
	}

	DotActor = Spawn(class'ZombieGame.LaserDot',,,HitLocation,);  // DEBUG
	if( DotLifeSpan == 0 )
		DotActor.LifeSpan = 240;  // DEBUG
	else
		DotActor.LifeSpan = DotLifeSpan;
}
*/

// Used by TraceFire to check if client thinks it can hit a target.
// Server will sanity check this to try to prevent cheating.
simulated function ClientTraceFireCheck()
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Material HitMaterial; 
	local bool OverrideAutoAim;
//	local LaserDot DotActor; // DEBUG

//	Log("WeapSniperRifle.ClientTraceFireCheck  t:"$Level.TimeSeconds $"  self:"$self.class $"  Owner:"$Owner $"  Instigator:"$Instigator );
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	StartTrace = GetFireStart(X,Y,Z); 

	OverrideAutoAim = true;

//	Log("## ClientTraceFireCheck  X:"$ X $"                                   view rot:"$ Instigator.GetViewRotation() );

	// If zoomed, don't have scatter.  If not zoomed, increase scatter.
	if( bZoomed )
		EndTrace = StartTrace;
	else
		EndTrace = StartTrace + (FRand()-0.5)*TraceAccuracy * Y * 3000 + (FRand()-0.5)*TraceAccuracy * Z * 3000;

	EndTrace += (TraceDist * X);

	Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial,true);

	// If not zoomed, only give help up to a very short distance away (3 ft)
	if( !bZoomed && VSize(Other.Location - Location) > 72 )
		Other = None;

//	DotActor = Spawn(class'ZombieGame.LaserDot',,,HitLocation,);  // DEBUG
//	DotActor.LifeSpan = 40;  // DEBUG
//	DotActor.SetDrawScale( DotActor.default.DrawScale*2.5 );  // DEBUG

	if( Other == None )
		ServerUpdateLastHit( Other, vect(0,0,0), HitLocation );
	else
		ServerUpdateLastHit( Other, Other.Location, HitLocation );
}

function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other, Other2;
	local Material HitMaterial; 
	local vector TracerStart; 
	local rotator TraceRotation; 
	local bool OverrideAutoAim;
	local vector MPVictimPosError;
//	local LaserDot DotActor; // DEBUG

//	Log("WeapSniperRifle.TraceFire  t:"$Level.TimeSeconds $"  self:"$self.class $"  Owner:"$Owner $"  Instigator:"$Instigator );
//	Log("  WeapSR.TF   Accuracy:"$Accuracy $"  YOffset:"$YOffset $"  ZOffset:"$ZOffset $"  AmmoType:"$AmmoType.class );

	// Compute scatter caused by jolting of previous shot
	Accuracy = AdjustShotScatter(Accuracy);
//	Log("   Accuracy after shot scatter adj: "$Accuracy );

	OverrideAutoAim = false;

	if (!AutoAimOnZoom && bZoomed)
	{
		OverrideAutoAim = true;
//		log("No auto aim");
	}
//	else
//	{
//		log("Auto aim");
//	}

	if( Pawn(Owner) != None && SFRMPlayerController(Pawn(Owner).Controller) != None && SFRMPlayerController(Pawn(Owner).Controller).StatMgr != None )
	{
		SFRMPlayerController(Pawn(Owner).Controller).StatMgr.ShotFired();
	}

	Owner.MakeNoise(fNoiseFactor);
	
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	StartTrace = GetFireStart(X,Y,Z); 

	AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 2*AimError, OverrideAutoAim);
	
	// Adjust endpoint of trace (for horizontal and vertical offset and inaccuracy).
	// Essentially, if the YOffset and ZOffset are 0, then converting from Accuracy 
	// factor to a max scatter angle (i.e. weapon could be betweeen +0.5*angle and 
	// -0.5*angle) is as folows:
	//
	//    Max scatter angle = 2 * arctangent( accuracy * 0.5 * 1000 / TraceDistance ) 
	//        where: TraceDist's default is often 10,000 (or 100,000 for sniper rifles).
	//
	// If you don't feel like doing trig (i.e. if you're a normal person):
	//	For TraceDist = 10,000 (and no YOffset or ZOffset):	
	//		Accuracy=0.1 means shot will be within 0.573 deg (or: +/-0.286 deg about aim point)
	//		Accuracy=1.0 means shot will be within 5.72 deg (or: +/-2.86 deg about aim point)
	//	For TraceDist = 10,000 (and no YOffset or ZOffset):	
	//		Accuracy=0.1 means shot will be within 0.0573 deg (or: +/-0.0286 deg about aim point)
	//		Accuracy=1.0 means shot will be within 0.573 deg (or: +/-2.86 deg about aim point)
	//
	// Other notes / more details:
	// * (FRand() - 0.5) returns something between -0.5 and +0.5
	// * The scaling factor of 1000 on each component is not the TraceDist, but usually
	//   more like 1/10th or 1/100th of the TraceDist.  It appears to be a magic number 
	//   chosen because it made things look ok.
	// * If using YOffset or ZOffset, remember that they will be scaled up by 1000.	
	EndTrace = StartTrace + (YOffset + Accuracy * (FRand() - 0.5 ) ) * Y * 1000
		+ (ZOffset + Accuracy * (FRand() - 0.5 )) * Z * 1000;

//	Log("## TraceFire             X:"$ X $"  vector(AdjustedAim):"$ vector(AdjustedAim) $"  view rot:"$ Instigator.GetViewRotation() );
	X = vector(AdjustedAim);
	EndTrace += (TraceDist * X);
	Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial,true);

	if( Level.bMPWeapLogs )
	{
		if( Pawn(Other) != None )
		{
			Log( Level.TimeSeconds $" MPLog: #### Shot fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  (1) weap:"$ self.class $"  hit player named "$ Pawn(other).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(other).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(other).PlayerReplicationInfo.bTerrorist $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
		}
		else if( Other != None )
		{
			Log( Level.TimeSeconds $" MPLog: #### Shot fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  (1) weap:"$ self.class $"  hit a(n) "$ other.class $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
		}
		else
		{
			Log( Level.TimeSeconds $" MPLog: #### Shot fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  (1) weap:"$ self.class $"  hit nothing." );
		}
	}

//	if( LastClientVictim != None )
//		Log("TraceFire client-side check would say pos err is "$ VSize(LastClientVictimPos - LastClientVictim.Location) $" LCVP:"$ LastClientVictimPos $" LCV.L:"$ LastClientVictim.Location );
	if( Pawn(Other) == None && bUseMPDiffHack && Pawn(LastClientVictim) != None ) // || Projectile(LastClientVictim) != None) )
	{
	//	Log("TraceFire using client-side check!!!!  Pos err:"$ VSize(LastClientVictimPos - LastClientVictim.Location) );
		// Trace missed: see if client-side trace had better luck (but on the server
		// make sure the client's reported hit location is reasonable).
		MPVictimPosError = LastClientVictimPos - LastClientVictim.Location;
		if( VSize(MPVictimPosError) < 90 )
		{
			// Compensating for client-server position mismatch:
			//   Set to the victim found by client
			Other = LastClientVictim;
			//   Move hit location to equivalent location on server
			//   (const*X moves the hit location into the target slightly, just in case a
			//   discrepancy in rotation causes the equivalent hit location on the server
			//   to be further back than on the client
			HitLocation = LastClientHitLoc - MPVictimPosError + 2.0*X;
		}

		if( Level.bMPWeapLogs )
		{
			if( Pawn(Other) != None )
			{
				Log( Level.TimeSeconds $" MPLog:   ## Client backup trace by "$ instigator.PlayerReplicationInfo.PlayerName $"  (1b) weap:"$ self.class $"  hit player named "$ Pawn(other).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(other).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(other).PlayerReplicationInfo.bTerrorist $"  using this instead.   dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
			}
			else if( Other != None )
			{
				Log( Level.TimeSeconds $" MPLog:   ## Client backup trace by "$ instigator.PlayerReplicationInfo.PlayerName $"  (1b) weap:"$ self.class $"  hit a(n) "$ other.class $"  not switching victim to this.  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
			}
			else
			{
				Log( Level.TimeSeconds $" MPLog:   ## Client backup trace by "$ instigator.PlayerReplicationInfo.PlayerName $"  (1b) weap:"$ self.class $"  hit nothing, not switching victim to this." );
			}
		}
	}

	LastShotDist = VSize(HitLocation - Location);

	if ( bFireTracer != False && PlayerController(Instigator.Controller) == None)
	{
		if( ShotsUntilNextTracer <= 1 )
		{
			ZombieWeaponAttachment(ThirdPersonActor).GetEffectStart(TracerStart,TraceRotation);
			Spawn(class'Tracer', self, ,TracerStart, AdjustedAim); 
			ShotsUntilNextTracer=ShotsPerTracer;
		}
		else
		{
			ShotsUntilNextTracer--;
		}	
	}

//	DotActor = Spawn(class'ZombieGame.LaserDot',,,HitLocation,);  // DEBUG
//	DotActor.LifeSpan = 240;  // DEBUG
//	ClientSpawnLaserDot(HitLocation);  // DEBUG
	AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z, HitMaterial);

	// Continue trace behind Other if Other is permeable to sniper bullets
//	Log("Other:"$Other $"   StartTrace:"$StartTrace $"  HitLocation:"$HitLocation $"  EndTrace:"$EndTrace );
	if( Other != None && Other.bPermeableToSniperBullets )
	{
		StartTrace = HitLocation + (2.2*Other.CollisionRadius * X);
		Other2 = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial,true);
	//	Log("     Other.ColR:"$Other.CollisionRadius );
	//	Log("Other2:"$Other2 $"  StartTrace:"$StartTrace $"  HitLocation:"$HitLocation $"  EndTrace:"$EndTrace $"  ColR:"$Other.CollisionRadius );
		if( Other2 != None && Other2 != Other )
			AmmoType.ProcessTraceHit(self, Other2, HitLocation, HitNormal, X,Y,Z, HitMaterial);

		if( Level.bMPWeapLogs )
		{
			if( Pawn(Other) != None )
			{
				Log( Level.TimeSeconds $" MPLog:   ## Continued trace (after exiting first victim shot by "$ instigator.PlayerReplicationInfo.PlayerName $"). (2)  weap:"$ self.class $"  hit player named "$ Pawn(other).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(other).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(other).PlayerReplicationInfo.bTerrorist );
			}
			else if( Other != None )
			{
				Log( Level.TimeSeconds $" MPLog:   ## Continued trace (after exiting first victim shot by "$ instigator.PlayerReplicationInfo.PlayerName $"). (2)  weap:"$ self.class $"  hit a(n) "$ other.class );
			}
			else
			{
				Log( Level.TimeSeconds $" MPLog:   ## Continued trace (after exiting first victim shot by "$ instigator.PlayerReplicationInfo.PlayerName $"). (2)  weap:"$ self.class $"  hit nothing.");
			}
		}

	}
}


// Forces sway back to the beginning 
simulated function ResetZoomTiltBob( optional bool bCausedByNudge )
{
//	ZoomStartTime = Level.TimeSeconds;
	WaveStartTime = Level.TimeSeconds;
	bFlashSwayIndicator=true;
	if( FRand() < 0.5 )
		YawDirection = -1.0;
	else
		YawDirection = 1.0;

	if( bCausedByNudge && (Level.TimeSeconds - fZoomStartTime) > WaveDampingTimeCrouched*0.6 )
		bZoomNudged = true;
	else
		bZoomNudged = false;
//	if( bCausedByNudge )
//		Log("CausedbyNudge   t:"$Level.TimeSeconds $"  fZST:"$fZoomStartTime $"  zoom time:"$(Level.TimeSeconds - fZoomStartTime) $"  WDTC:"$WaveDampingTimeCrouched $"  nudge:"$bZoomNudged );
}

simulated function rotator ZoomTiltBob() 
{ 
	local float YawAmplitude, PitchAmplitude, WaveTime, DampingTime;
	local float CalcYaw, CalcPitch;
//	local float HeartBeatAmplitude, HeartBeat;
	local float RampInTime;
	local float AmpFactor;
	local float YawAmpMaxMod, PitchAmpMaxMod;
	local int LevelOfDifficulty;

	// Hack: makes sure this bool is set correctly on client
	// (On client, it's this simple.
	// On server, gotta check Level.Game to make sure it's MP and !CoOp).
	if( Level.NetMode != NM_Standalone )
		bUseMPDiffHack = true;

//	Log("bUseMPDiffHack:"$bUseMPDiffHack );
	if( bUseMPDiffHack )
		LevelOfDifficulty = MP_SNIPER_SWAY_DIFF_HACK;
	else
		LevelOfDifficulty = Level.Game.GameDifficulty;

	WaveTime = Level.TimeSeconds - WaveStartTime;

	// Choose damping time based on whether user is crouched or standing
	if( Instigator.bIsCrouched )
	{
		DampingTime = WaveDampingTimeCrouched;
	//	HeartBeatAmplitude = 5.0;
	}
	else
	{
		DampingTime = WaveDampingtime;
	//	HeartBeatAmplitude = 10.0;
	}

	// Scale down damping time based on game difficulty (unscaled value is for hardest level)
	if( LevelOfDifficulty < 2 )
	{
		DampingTime *= 0.8;
	}

	if( bUseMPDiffHack )
	{
	// Scale down damping time if in a non-CoOp multiplayer game
		DampingTime *= 0.8;
	}

	// Adjust amplitude damping based on how long have been zoomed
	RampInTime = 0.3;  // Ideally should be less than shortest period / 8
	if( bZoomNudged )
	{
		DampingTime *= 0.5;
		YawAmpMaxMod   = Max(WaveYawAmplitudeMax   * 0.4, WaveYawAmplitudeMin);
		PitchAmpMaxMod = Max(WavePitchAmplitudeMax * 0.4, WavePitchAmplitudeMin);
	}
	else
	{
		YawAmpMaxMod   = WaveYawAmplitudeMax;
		PitchAmpMaxMod = WavePitchAmplitudeMax;
	}
	if( WaveTime < DampingTime )
	{
		if( WaveTime < RampInTime )  // For the first part, ramp up the oscillation
		{
			// Ramping factor starts at 0.2, ramps up to 1.0
			YawAmplitude =   ( 0.2 + 0.8*(WaveTime/RampInTime) )*(YawAmpMaxMod);
			PitchAmplitude = ( 0.2 + 0.8*(WaveTime/RampInTime) )*(PitchAmpMaxMod);
		}
		else
		{
			// Otherwise, ramp down oscillation as time goes by.  
			// Ramp down factor of (WaveTime-RampInTime)/(DampingTime-RampInTime) goes 
			// from 1.0 (when WaveTime equals RampInTime) down to 0.0 (when WaveTime equals DampingTime).
			AmpFactor = (WaveTime-RampInTime)/(DampingTime-RampInTime);
			if( AmpFactor < 0 )
				AmpFactor = 1.0;
			YawAmplitude   = YawAmpMaxMod   - (AmpFactor ** DampExp)*(YawAmpMaxMod-WaveYawAmplitudeMin);
			PitchAmplitude = PitchAmpMaxMod - (AmpFactor ** DampExp)*(PitchAmpMaxMod-WavePitchAmplitudeMin);
		}
	}
	else
	{
		if( bZoomNudged && WaveTime > DampingTime/0.6 )  // If it has settled to min amplitude for long enough
			bZoomNudged = false;
		YawAmplitude = WaveYawAmplitudeMin;
		PitchAmplitude = WavePitchAmplitudeMin;
	}
	//Log(" Y: "$ YawAmplitude $"   Z: "$PitchAmplitude $"   DampingTime: "$DampingTime  $"  WaveTime: "$WaveTime);
	
	// Scale down amplitudes based on game difficulty (unscaled values are for hardest level)
	if( LevelOfDifficulty == 0 )  // Easy (0)
	{
		PitchAmplitude *= 0.12;
		YawAmplitude *= 0.10;
	//	HeartBeatAmplitude = 0;	
	}
	else if( LevelOfDifficulty == 1 )  // Normal (1)
	{
		PitchAmplitude *= 0.60;
		YawAmplitude *= 0.60;
	//	HeartBeatAmplitude = 0;	
	}

	if( bUseMPDiffHack )
	{
		PitchAmplitude *= 0.8;
		YawAmplitude *= 0.8;
	}

	// Apply basic sway 
	// ( 6.283185 below is conversion factor convert time/period to radians.  
	//   In other words, 1 full cycle = 2 Pi radians = 6.283185 )
	CalcYaw   = YawAmplitude   * sin(WaveTime * 6.283185/WaveYawPeriod) * YawDirection;
	CalcPitch = PitchAmplitude * sin(WaveTime * 6.283185/WavePitchPeriod);

	// Apply additional vertical jitter due to heartbeat
	// (60 beats per minute = period of 1.0 sec.  6.283185 / 1.0 is about 6.283 )
//	CalcYaw   += HeartBeatAmplitude * sin(WaveTime * 6.283 );
//	CalcPitch += 1.2 * HeartBeatAmplitude * sin(WaveTime * 3.1415 );

	SwayAmount = YawAmplitude;

	// Put answer in rotator (preceding calcs were done with floats because rotators have a resolution limit)
	if( YawAmplitude != 0 )
		AppliedWave.Yaw   = CalcYaw  *  FMax((YawAmplitude-20.0)/YawAmplitude, 0.0);  // Subtract some angle units from rotation (to reduce rotation at low amplitudes)
	if( PitchAmplitude != 0 )
		AppliedWave.Pitch = CalcPitch * FMax((PitchAmplitude-20.0)/PitchAmplitude, 0.0);  // Subtract some angle units from rotation (to reduce rotation at low amplitudes)

	// Calculate amount of translational sway.
	//  Since translation has finer resolution than rotation in Unreal, then this helps mitigate
	//  jerkiness at low amplitudes due to rotation resolution
	if( YawAmplitude != 0 )
		AppliedTranslationWave.Y = FMin(YawAmplitude*0.20, 3.0)   * CalcYaw   / YawAmplitude;
	if( PitchAmplitude != 0 )
		AppliedTranslationWave.Z = FMin(PitchAmplitude*0.20, 3.0) * CalcPitch / PitchAmplitude;

	return AppliedWave;
}

// Translational sway
simulated function vector ZoomTiltTranslationBob()
{
	local vector X,Y,Z;
	GetAxes(Rotation,X,Y,Z);

	return (AppliedTranslationWave.Y * Y + AppliedTranslationWave.Z * Z);
} 

simulated function float GetZoomSwayFraction()
{
	if( bFlashSwayIndicator )
	{
		bFlashSwayIndicator=false;

		// Hack: makes sure this bool is set correctly on client
		// (On client, it's this simple.
		// On server, gotta check Level.Game to make sure it's MP and !CoOp).
		if( Level.NetMode != NM_Standalone )
			bUseMPDiffHack = true;

		if( bUseMPDiffHack )
			return (0.2+MP_DIFFICULTY_HACK*0.10);
		else
			return (0.2+Level.Game.GameDifficulty*0.12);
	}
	else
		return FMin(SwayAmount / 140.0, 1.0);
}


//// Reduce kick when zoomed
//simulated function CalcWeaponKick(out vector InViewKickAdjustment, vector Kick)
//{
//	if( bZoomed )
//		Super.CalcWeaponKick(InViewKickAdjustment, Kick*( 0.06 + 1.38/FMax(1.0,GetZoomPower()) ) );
//	else
//		Super.CalcWeaponKick(InViewKickAdjustment, Kick);
//}
//
//simulated function RestoreWeaponKick(float Delta, out vector InViewKickAdjustment)
//{
//	local vector LerpInterval;
//	
//	if( bZoomed )
//		LerpInterval = ViewKickRate / fViewRestoreTime / ( 0.8 + 0.3*FMax(1.0,GetZoomPower()) );
//	else
//		LerpInterval = ViewKickRate / fViewRestoreTime; 
//	InViewKickAdjustment.X = MoveToZero(LerpInterval.X * Delta, InViewKickAdjustment.X);		
//	InViewKickAdjustment.Y = MoveToZero(LerpInterval.Y * Delta, InViewKickAdjustment.Y);		
//	InViewKickAdjustment.Z = MoveToZero(LerpInterval.Z * Delta, InViewKickAdjustment.Z);
//}



// Decompiled with UE Explorer.
defaultproperties
{
    WaveYawAmplitudeMax=180.0000000
    WavePitchAmplitudeMax=130.0000000
    WaveYawPeriod=5.0000000
    WavePitchPeriod=8.0000000
    WaveDampingTime=12.0000000
    WaveDampingTimeCrouched=3.6000000
    DampExp=0.7000000
    fScopeRaiseDuration=0.4000000
    fZoomInDuration=0.2500000
    fZoomOutDuration=0.2500000
    fFOVChange=65.0000000
    fFOVChangeMax=80.0000000
    fFOVChangeMin=65.0000000
    AutoAimOnZoom=false
    BotFireRate=2.0000000
    BotBulletInterval=0.2000000
    ViewKickRate=(X=24.0000000,Y=0.0000000,Z=700.0000000)
    ViewKickMax=(X=64.0000000,Y=0.0000000,Z=16000.0000000)
    fViewRestoreTime=0.8000000
    fZoomViewKickFactor=0.7000000
    bIsSingleShot=true
    SpeedClass=1
    CrosshairIndex=6
    PickupAmmoCount=10
    ReloadCount=10
    FireOffset=(X=20.0000000,Y=0.0000000,Z=0.0000000)
    ShakeSpeed=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    InventoryGroup=60
    BobDamping=0.9750000
    ThirdPersonScale=1.0000000
    ThirdPersonRelativeLocation=(X=10.0000000,Y=-2.0000000,Z=-2.0000000)
    ThirdPersonRelativeRotation=(Pitch=0,Yaw=0,Roll=-16384)
    ItemName="Sniper Rifle"
}