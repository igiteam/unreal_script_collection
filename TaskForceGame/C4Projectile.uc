class C4Projectile extends DelayedProjectile;

var(ImpactEffect) class<Actor>			ImpactEffectSnow;
var(ImpactEffect) class<Actor>			ImpactEffectMP;
var float Elasticity;

var float DPLifespan;
var bool bGotLifespan;
var bool bEarlyDetonation;

var float EarlyDetonationDelay;
var sound DetonationWarnSound;

var Material ProjectileSkin;
var Material LCDArmTex;

var() float PostLandingCollisionRadius;
var() float PostLandingCollisionHeight;

var RadiusWatcher ProxFuseWatcher;
var float ProxFuseCollisionRadius;
var float ProxFuseCollisionHeight;
var float TimeOfLastProxFuseRescan;
var float ProxFuseArmTime;

var RadiusWatcher ContactWatcher;  // If attached to a door, used to see if the door has been moved

var float LandingTime;
var Actor LandedOn;

//var float MinGlassBreakSpeed;  // min speed at which grenade itself (not the explosion) will inflict damage to destructible (e.g. glass window)
//var int   ImpactDamage;        // damage that grenade itself (not explosion) will do to destructible (e.g. glass)

replication
{
	reliable if( Role == ROLE_Authority )//&& bNetDirty )
		DPLifespan, SetClientLandingLocation;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  C4P.PostBeginPlay   ##");

	Skins[0] = ProjectileSkin;
	Skins[1] = LCDArmTex;
}

simulated function SetClientLandingLocation( vector newLocation, rotator newRotation )
{
//	Log("############## SetClientLandingLocation ################## delta loc:"$ newLocation-Location );
//	if( VSize(newLocation-Location) > 6 )
//		Log("  ######################## client location is more than 6 away from server ################"); 
	SetRotation( newRotation );
	SetLocation( newLocation );
	Velocity=vect(0,0,0);
	SetPhysics(PHYS_None);
	if( LandingTime < 0 )
		LandingTime = Level.TimeSeconds;
}

simulated event Destroyed()
{
//	Log("##### Destroyed ");

	// special FAISON hack for your pleasure, ported by MAT from GrenadeProjectile
	if ( Level.NetMode == NM_Client )
	{
		PlaySound(DPExplosionSound,, 1,,5000.0, 0.5+FRand(),true);
	}

	// Make sure radius watchers are cleaned up
	if( ProxFuseWatcher != None )
		ProxFuseWatcher.Destroy();
	if( ContactWatcher != None )
		ContactWatcher.Destroy();

	Super.Destroyed();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
//	Log("####----- ProcessTouch  state:"$ GetStateName() $"  Other:"$ Other );
//	Log(" **## RemoteRole:"$ RemoteRole $"  Role:"$ Role $"  ##**");

	HitWall( Normal(HitLocation), Other );
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	local vector		TraceHitLocationOut;	// output for Trace
	local vector		TraceHitNormalOut;		// output for Trace
	local vector		TraceEnd;	// Furthest point the trace should go to
	local material		mHitting;   // Surface the grenade hit
	local byte			byteType; 	// Material type
	local actor			BounceVictim;
	local float			V_dot_HitNorm;
	local rotator		PostBounceRotation;

	//log ("hit"@hitwall);
//	Log("####----- HitWall  state:"$ GetStateName() $"  HitWall:"$ HitWall );
	if ( HitWall == Instigator)
		return; 

	if( ZombieBipedPawn(HitWall) != None || BlockingVolume(HitWall) != None )
	{
		AvoidSticking( HitNormal );
		return;
	}

	// Find the surface the grenade hit
	// (32.0 factor applied to HitNormal is just over 1 foot distance--just in case there
	// is a delay that causes this function to be called when the grenade is already 
	// slightly away from the wall).
	TraceEnd = Location - 32.0*HitNormal;
	BounceVictim = Trace( TraceHitLocationOut, TraceHitNormalOut, TraceEnd,,,, mHitting );

	// Find out what material we hit
	if( mHitting != None )
	{
		// If surface can be determined, find material type 
		byteType = mHitting.MaterialType;
	}
	else
	{
		// If cannot find what surface was hit, use default material type
		byteType = EMATERIALTYPE_NONE;
	}

	// Handle impact with destructible (may need to break the destructible and keep going)
	if( DestructibleMesh(BounceVictim) != None
	 && DestructibleMesh(BounceVictim).bProjectileBounceCanDamage 
	 && VSize(Velocity) > MinDestructibleBreakSpeed )
	{
		BounceVictim.TakeDamage( ImpactDamage, instigator, TraceHitLocationOut, vect(0,0,0), class'DamageTypeProjectile' );

		// If victim is being destroyed by the impact, then don't bounce 
		// (just slightly dampen velocity and let grenade pass through).
		if( DestructibleMesh(BounceVictim).HitPoints <= 0
		 && !DestructibleMesh(BounceVictim).bRemainSolidWhenDestroyed )
		{
			Velocity *= VelocityImpactCoeff;
			return;
		}
	}

	// Play sound if not hitting sky (material type none is considered sky)
	// PlaySound args: Sound, Slot, Volume, bNoOverride, Radius, Pitch, Attenuate
	if( byteType != EMATERIALTYPE_SKY && !bSilentlyDestroyingNow )
		PlaySound( ProjectileBounceSounds[int(byteType)],, 0.8,,200.0, ,true ); 

	// Handle hitting a skybox
	Speed = VSize(Velocity);
	V_dot_HitNorm = Velocity dot HitNormal;
	if( byteType == EMATERIALTYPE_SKY )  
	{
		// We're hitting sky
		BounceSkybox(V_dot_HitNorm, HitNormal );
		return;
	}

	// If we've gotten here, we've hit something to which we want to stick

	// Set rotation (align with wall if steep enough, or just level it if shallow)
	if( HitNormal.Z > 0.940 ) // 20 deg or shallower slope
	{
		PostBounceRotation.Pitch = 0;
		PostBounceRotation.Yaw = Rotation.Yaw;
		PostBounceRotation.Roll = 0;
	}
	else
	{
		PostBounceRotation = rotator(HitNormal);
		PostBounceRotation.Pitch = (PostBounceRotation.Pitch-16353) % 65535;
	}
	SetRotation( PostBounceRotation );

	LandingTime = Level.TimeSeconds;

	LandedOn = HitWall;

	// Ensure multiplayer client projectile doesn't fall through terrain
	if( Role == ROLE_Authority && Level.NetMode != NM_Standalone )
		SetClientLandingLocation( Location+(0.5*HitNormal), PostBounceRotation );

	// Spawn radius watchers (for prox fuse, etc.)
	InitRadiusWatchers(HitNormal);

	// Increase collision size slightly to make it slightly easier to shoot
	// (Will increase it to its full size in about a second, after we've given the
	// client-side projectile a chance to be positioned in the right place).
	SetCollisionSize( CollisionRadius+4, CollisionHeight+4 );

	bBounce = False;
	SetPhysics(PHYS_None);
	WarnBots();
}

// Changes speed after bouncing off skybox
simulated function BounceSkybox(float V_dot_HitNorm, vector HitNormal )
{
	local vector NewLocation;
	// We're hitting sky
//	Log(" Hit sky!  HitNormal:"$HitNormal );
	if( Normal(HitNormal).Z > -0.5 )  // If skybox wall is within 30 degrees of vertical (Z between 0.5 and -0.5) or faces upward (+Z)
	{
		// Hitting a near-vertical skybox wall or an upward facing skybox surface (e.g. floor)
		// Make the grenade disappear (make it look like the skybox swallowed the grenade)
		if( HitNormal.Z <= 0.0 )
		{
			// if wall is vertical or facing down, give it a small drop velocity
			// (since a further away object will cover same linear distance over a
			// smaller angular distance as seen by viewer)
			Velocity = vect(0,0,-1.5);
		}
		else
		{
			// if wall is facing up, try to keep grenade from sinking into surface instantly
			NewLocation = Location;
			NewLocation.Z = NewLocation.Z + 0.5;
			SetLocation( NewLocation );
			Velocity = vect(0,0,2.0);   
		}
		SetDrawScale( DrawScale * 0.8 );
		bSilentlyDestroyingNow=true;
	}
	else
	{
		// Hitting a skybox ceiling
		// (Produce no bounce in HitNormal direction--just cancel out velocity in HitNormal direction,
		// and damp whatever velocity remains after that to help mitigate the suddden change in
		// direction.  Not perfect, just makes it slightly less jarring).
		Velocity = 0.4*(( V_dot_HitNorm ) * HitNormal * (-1.00) + Velocity);
	}
}

function DebugMarkProxFuseCircle( vector centerLoc, vector HitNormal )
{
	local actor a;
	local int inx, numDots;
	local float angle;

	numDots = 15;

	a = Spawn(class'BulletHole', ,, centerLoc );
	a.Lifespan = Lifespan+10;

	for( inx = 0 ; inx < numDots ; inx++ )
	{
		angle += (360/numDots)*(3.14159/180);
		Log("angle:"$ angle );
		a = Spawn(class'BulletHole', ,, centerLoc + (vect(1,0,0)*cos(angle)+vect(0,1,0)*sin(angle))*ProxFuseCollisionRadius );
		a.Lifespan = Lifespan+5+(float(inx)/4);
	}
}

function InitRadiusWatchers( vector HitNormal )
{
	local RadiusWatcher rw;

//	DebugMarkProxFuseCircle( Location+(ProxFuseCollisionRadius*HitNormal), HitNormal );
//	DebugMarkProxFuseCircle( Location+(ProxFuseCollisionRadius+5)*HitNormal+(vect(0,0,1)*ProxFuseCollisionHeight), HitNormal );
//	DebugMarkProxFuseCircle( Location+(ProxFuseCollisionRadius+5)*HitNormal+(vect(0,0,-1)*ProxFuseCollisionHeight), HitNormal );

	rw = Spawn(class'RadiusWatcher',self,,Location+(ProxFuseCollisionRadius+8)*HitNormal );
	rw.SetCollisionSize(ProxFuseCollisionRadius,ProxFuseCollisionHeight);
	rw.OnRadiusEnter = OnActorEnteredProxFuseRadius;
	rw.OnRadiusLeave = OnActorLeftProxFuseRadius;

	ProxFuseWatcher=rw;

	rw = Spawn(class'RadiusWatcher',self,,Location );
	rw.SetCollisionSize(CollisionRadius+0.5,CollisionHeight+2);
	rw.OnRadiusEnter = OnActorEnteredContactRadius;
	rw.OnRadiusLeave = OnActorLeftContactRadius;

	ContactWatcher=rw;
}

function OnActorEnteredProxFuseRadius( Actor other )
{
//	Log(">>>o OnActorEnteredProxFuseRadius   REST IN PIECES?   other:"$ other $" self:"$ self $"  Owner:"$ Owner );
	if( Level.TimeSeconds > LandingTime+ProxFuseArmTime )
		DetonateIfDetected( other );
}

function OnActorLeftProxFuseRadius( Actor other )
{
//	Log("<<<o OnActorLeftProxFuseRadius   you can run, but you'll just die tired.  other:"$ other $" self:"$ self $"  Owner:"$ Owner );
	if( Level.TimeSeconds > LandingTime+ProxFuseArmTime+0.25 )
		DetonateIfDetected( other );
}

function OnActorEnteredContactRadius ( Actor other )
{
	//Log("  >o OnActorEnteredContactRadius       other:"$ other $" self:"$ self $"  Owner:"$ Owner );
	//Log("   #   other:"$ other );
	if( ZombieDoor(other) != None )
	{
		//Log("  ######## OnActorEnteredContactRadius: [] going to state InducedExplosion!!! #####");
		bEarlyDetonation=true;
		EarlyDetonationDelay=0.08;
		PlaySound( DetonationWarnSound,, 1.0,,200.0, ,true ); 
		GotoState('InducedExplosion');
	}
}

function OnActorLeftContactRadius ( Actor other )
{
//	Log("  <o OnActorLeftContactRadius       other:"$ other $" self:"$ self $"  Owner:"$ Owner );
//	Log("       Mover(other):             "$ Mover(other) );
//	Log("       JitteryStaticMesh(other): "$ JitteryStaticMesh(other) );
	if( ZombieDoor(other) != None 
	 && ( LandedOn == other || VSize(Location-other.Location)<1.4*other.CollisionRadius ) )
	{
		//Log("  ######## OnActorLeftContactRadius: going to state InducedExplosion!!! #####");
		//Log("   #   other:"$ other );
		//Log("   #   dist < 1.4 CR :"$ VSize(Location-other.Location) < 1.4*other.CollisionRadius );
		//Log("   #   (dist / CR :"$ VSize(Location-other.Location) / other.CollisionRadius $")" );
		//Log("   #   LandedOn == other :"$ LandedOn == other );
		bEarlyDetonation=true;
		EarlyDetonationDelay=0.08;
		PlaySound( DetonationWarnSound,, 1.0,,200.0, ,true ); 
		GotoState('InducedExplosion');
	}
}

function DetonateIfDetected( Actor other )
{
	local ZombieBipedPawn ZBP;

	ZBP = ZombieBipedPawn(Other);
	if( ZBP != None && ZBP.Health > 0  // if this is a player or enemy human pawn
	 && !bEarlyDetonation )  // and we're not already doing an early detonation
	{
	//	Log("DetonateIfDetected: Obstruction check: ");
	//	Log("  C4 loc to other loc:    "$ FastTrace( Location, Other.location ) );
	//	Log("  C4 loc to other eye loc:"$ FastTrace( Location, Other.Location + Pawn(Other).EyePosition() ) );
	//	Log("  C4 loc to other low loc:"$ FastTrace( Location, Other.Location - (vect(0,0,1)*Other.CollisionHeight) ) );
	//	Log("    C4 loc:"$ Location $"  other low loc:"$ Other.Location - (vect(0,0,1)*Other.CollisionHeight) );

		if( FastTrace( Location, Other.location )   // Trace to pawn location
		 || FastTrace( Location, Other.Location + ZBP.EyePosition() )  // Trace to pawn eye position
		 || FastTrace( Location, Other.Location - (vect(0,0,1)*Other.CollisionHeight) ) )  // Trace to low point on pawn
		{
			PlaySound( DetonationWarnSound,, 1.0,,200.0, ,true ); 
		//	Log("   #----- DetonateIfDetected  state:"$ GetStateName() $"  about to GotoState InducedExplosion");
			if( Level.bMPWeapLogs )
			{
				if( Pawn(other) != None )
					Log( Level.TimeSeconds $" MPLog: #### C4 going to explode:  someone set off proximity fuse  victim name:"$ Pawn(Other).PlayerReplicationInfo.PlayerName $"  instigator:"$ InstigatorController.PlayerReplicationInfo.PlayerName );
				else
					Log( Level.TimeSeconds $" MPLog: #### C4 going to explode:  something set off proximity fuse   "$ other.class $"      instigator:"$ InstigatorController.PlayerReplicationInfo.PlayerName );
			}
			GotoState('InducedExplosion');
		}
	}
}

// Changes speed after bouncing off a pawn or something else it shouldn't stick to
simulated function AvoidSticking( vector HitNormal )
{
	Velocity = -70.0*Normal(Velocity);
	SetRotation( rotator(HitNormal) );
}

simulated event Tick( float TimeDelta )
{
	if( bSilentlyDestroyingNow )
	{
		SetDrawScale( DrawScale*(0.996-TimeDelta) );
		if( Velocity.Z < 0 )
			Velocity.Z *= 0.6;
		if( DrawScale < 0.15 )
			Destroy();
	}

	if( ProxFuseWatcher != None )
	{
		if( Level.TimeSeconds > TimeOfLastProxFuseRescan + 0.25
		 && Level.TimeSeconds > LandingTime + ProxFuseArmTime + 0.25 )
		{
		//	Log( Level.TimeSeconds $" Rescan");
			ProxFuseWatcher.Rescan();
			TimeOfLastProxFuseRescan = Level.TimeSeconds;
		}
	}

	Super.Tick( TimeDelta );
}

simulated function Landed( vector HitNormal )
{
//	log("Grenade Landed");
	HitWall(HitNormal, none);
}

// have to overload this state because we don't want the LifeSpan getting set
// to Zero in a base class.  cookoff will set the lifespan on the projectile
auto State Flying
{
	simulated event Tick( float TimeDelta )
	{
	//	Log("DPLifespan:"$ DPLifespan );
		if( !bGotLifespan )
		{
			Lifespan = DPLifespan;
			bGotLifespan = true;
		//	Log("##### C4P.Flying.Tick  "$ FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"   new Lifespan:"$ Lifespan $"  Skins[0]:"$ Skins[0] );
		//	Log(" **## RemoteRole:"$ RemoteRole $"  Role:"$ Role $"  ##**");
		}

		// If enough time has passed after landing so that the client projectile has probably
		// received the SetClientLandingLocation sent by the server...
		if( (CollisionRadius < PostLandingCollisionRadius || CollisionHeight < PostLandingCollisionHeight )
			&& (Physics==PHYS_None) && (Level.TimeSeconds > LandingTime + 0.9) && ROLE==Role_Authority )
		{
			// Increase collision size to make it easier to shoot the C4
			SetCollisionSize( PostLandingCollisionRadius, PostLandingCollisionHeight );
		}

		Global.Tick( TimeDelta );
	}
Begin:
//	log("Adding Impulse of: " $ Velocity);
//	log("Setting Speed to: " $ Speed);
	Velocity = Speed * vector(Rotation);
	Speed = VSize(Velocity);
//	Log("Velocity:"$Velocity);
	bBounce = True;
//	Log("####### C4P.Flying.Begin  about to sleep for Lifespan-0.1.  Lifespan:"$ Lifespan $" #####################");
	Sleep(Lifespan-2.1);
	PlaySound( DetonationWarnSound,, 1.0,,220.0, ,true ); 
	Sleep(2.0);
//	Log("    ### C4P.Flying.Begin  done sleeping, about to call Explode?");
	if( Level.Game != None && !Level.Game.bGameEnded )
	{
		if( Level.bMPWeapLogs )
			Log( Level.TimeSeconds $" MPLog: #### C4 exploding:  timer ran out.  instigator:"$ InstigatorController.PlayerReplicationInfo.PlayerName );
		Explode(Location,Normal(-Velocity));
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitLocation, Vector momentum, class<DamageType> damageType, optional Controller KillerController )
{
//	Log("############# C4Projectile.TakeDamage    Damage:"$ Damage $"  state:"$ GetStateName() $"  self:"$ self );
//	Log(" #### hitLocation:"$ hitLocation $"  Location:"$ Location $"  delta:"$ VSize(hitLocation-Location) $"  ####");
//	Log(" **## RemoteRole:"$ RemoteRole $"  Role:"$ Role $"  ##**");

	// If enough damage is being done (regardless of whether or not there's something
	// in the way), or any damage is being inflicted that's not through a wall,
	// then detonate the C4
	// (Through-the-wall damage could occur if the collision cylinder is poking
	// through a wall and someone shoots the collision cylinder from the other
	// side of the wall).
	if( Damage > 55 || (Damage > 0 && FastTrace( Location, hitLocation )) )
	{
		bEarlyDetonation=true;
	//	ClientDetonateEarly();
		DPLifespan = 0.5;

		// Set delay time before explosion occurs.
		//  Want more delay for explosive damage (as opposed to bullet hit) so that 
		//  C4's triggering each other will
		//   a. detonate in a rapid sequence (and not all at once), and
		//   b. be less likely to play their explosion sounds at once
		if( ClassIsChildOf( damageType, class'DamageTypeGrenade') )
			EarlyDetonationDelay=0.25;
		else
		{
			if( instigatedBy.isLocallyControlled() )
				EarlyDetonationDelay=0.10;  // For player on server
			else
				EarlyDetonationDelay=0.08;  // For player on client, slightly shorter delay
		}

		// The kill should be credited to the player who shot the C4
		if( instigatedBy != None )
			instigator = instigatedBy;
		if( KillerController != None )
			InstigatorController = KillerController;

		if( Level.bMPWeapLogs )
			Log( Level.TimeSeconds $" MPLog: #### C4 going to explode:  took damage from someone or something  instigator:"$ InstigatorController.PlayerReplicationInfo.PlayerName $"  damageType:"$ damageType ); 
		GotoState('InducedExplosion');
	}
}

simulated state InducedExplosion
{
	ignores Touch;

Begin:
//	Log("#### C4P.InducedExplostion Begin:   EarlyDetonationDelay:"$ EarlyDetonationDelay );
//	Log(" ### Setting 	bEarlyDetonation=true");
//	Log(" **## RemoteRole:"$ RemoteRole $"  Role:"$ Role $"  ##**");
	bEarlyDetonation=true;
	Sleep(EarlyDetonationDelay);
	if( Level.Game != None && !Level.Game.bGameEnded )
		Explode(Location,Normal(-Velocity));
}


// Decompiled with UE Explorer.
defaultproperties
{
    ImpactEffectSnow=Class'ZombieEffects.explosion_grenade'
    ImpactEffectMP=Class'ZombieEffects.explosion_grenade'
    Elasticity=0.1000000
    EarlyDetonationDelay=0.2500000
    DetonationWarnSound=Sound'CBW_DYN_weapons.C4.C4_beep_alarm'
    ProjectileSkin=Texture'CBT_DYN_Weapons.C4.pv_c4'
    LCDArmTex=Texture'CBT_DYN_Weapons.C4.pv_c4_lcd_armed'
    PostLandingCollisionRadius=24.0000000
    PostLandingCollisionHeight=14.0000000
    ProxFuseCollisionRadius=240.0000000
    ProxFuseCollisionHeight=230.0000000
    ProxFuseArmTime=2.0000000
    LandingTime=-999.0000000
    DPExplosionSound=Sound'CBW_DYN_weapons.explosions.C4_explosion1'
    ProjectileBounceSounds[0]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[1]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[2]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[3]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[4]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[5]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[6]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[7]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[8]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[9]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[10]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    ProjectileBounceSounds[11]=Sound'CBW_DYN_weapons.C4.C4_Fire1'
    VelocityImpactCoeff=0.7500000
    LifespanAfterPHYSNone=30.0000000
    MinDestructibleBreakSpeed=800.0000000
    ImpactDamage=10
    Speed=180.0000000
    MaxSpeed=900.0000000
    Damage=150.0000000
    DamageRadius=600.0000000
    InnerDamageRadius=192.0000000
    FringeDamageRadius=615.0000000
    MomentumTransfer=45000.0000000
    MyDamageType=Class'ZombieGame.DamageTypeHEGrenade'
    DrawType=2
    StaticMesh=none
    bNetTemporary=false
    bAlwaysRelevant=true
    LifeSpan=30.0000000
    Mesh=SkeletalMesh'CBA_PV_Weapons.pv_c4'
    AmbientGlow=20
    bUnlit=false
    CollisionRadius=1.5000000
    CollisionHeight=2.0000000
    bProjTarget=true
}