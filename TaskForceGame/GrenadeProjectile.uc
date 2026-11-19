class GrenadeProjectile extends DelayedProjectile;

var(ImpactEffect) class<Actor>			ImpactEffectSnow;
var(ImpactEffect) class<Actor>			ImpactEffectMP;
var float Elasticity;
var float RollBounceHorizCoeff;  // Elasticity in the horizontal direction
var Actor muffleActor;  //the actor (if any) lying on top of this grenade
var float ArmingTime;
var vector LastBounceLoc;

var class<MuzzleLight> GrenadeFlashClass;
var MuzzleLight grenadeFlash;

var bool bIsArmed;	 
var bool bRollingBounce;	// when set to true, grenade doesn't slow down as soon.  This does NOT model pure rolling--EVER!

var bool bGotLifespan;

var float DPLifespan;

var Material ProjectileSkin;

//var float MinGlassBreakSpeed;  // min speed at which grenade itself (not the explosion) will inflict damage to destructible (e.g. glass window)
//var int   ImpactDamage;        // damage that grenade itself (not explosion) will do to destructible (e.g. glass)

replication
{
	reliable if( Role == ROLE_Authority && bNetDirty )
		DPLifespan;
}

event bool isBeingHandled(){return bBeingHandled;}

function setBeingHandled(Actor a)
{
	bBeingHandled=true;
}

function muffleGrenade(Actor muffler)
{
	if (muffler!=None)
	{
		muffleActor=muffler;
		EffectScale/=5;
		bBeingHandled=true;
	}
	else
	{
		muffleActor=None;
		EffectScale=default.EffectScale;
		bBeingHandled=false;
	}
}
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  GP.PostBeginPlay   ##");
	//counteract the stupid code in SFRMProjectile::PostBeginPlay... but I dont' want to delete it up there in case something relies on it.
	//if ( Level.NetMode == NM_Client )
	//{
	//	LifeSpan = default.Lifespan; 
	//}

	armGrenade();
	if( isMP() )
	{
		DamageRadius *= 1.5;
		FringeDamageRadius *= 1.5;

		ImpactEffect=ImpactEffectMP;
	}

	Skins[0] = ProjectileSkin;
}

simulated function armGrenade()
{
	if (!bIsArmed)
	{
		//log ("arming "@self); 
		bIsArmed = true;
		ArmingTime = Level.TimeSeconds;
	}
	//else
	////	log(self@"already armed");
}
simulated function disarmGrenade()
{
	//log ("disarming "@self); 
	bIsArmed = false;
	ArmingTime = 2000000000;
}
simulated function AttachGrenadeToThrowersHand(Pawn p, name bonename)
{
	Instigator = p;
	//log ("attached "@self); 
	GotoState('');
	SetOwner(p);
	p.AttachToBone(self,bonename);
	SetRelativeLocation(vect(0,0,0));
}
simulated function letGrenadeFly(rotator r,optional float speedScale)
{
	Speed=default.speed;
	if (speedScale!=0) Speed*=speedScale;
	
	//log (self@"flying!"@Speed);
	if ( Pawn ( Owner ) != None )
	{
		Pawn ( Owner ).DetachFromBone(self);
	}

	//SetOwner(None);
	SetLocation(Location+vector(r)*80);
	SetRotation(r);
	SetPhysics(PHYS_Falling);
	GotoState('Flying');
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if( bIsArmed && Level.TimeSeconds > ArmingTime + 0.05 )
	{
		HitWall( Normal(HitLocation), Other );
	}
}

function doLightFlash()
{
	//wrc don't flash in MP, it gets all screwed up.
	//this is a quick hack fix when obviously a better fix would be to fix 
	//the flashes instead of removing them. 
	if (GrenadeFlashClass!=None && !isMP())
	{
		if (grenadeFlash==None)
			grenadeFlash = Spawn(GrenadeFlashClass);
		grenadeFlash.SetLocation(Location);
		if (muffleActor != None) grenadeFlash.LightRadius/=5;
		grenadeFlash.Flash();
		if (muffleActor == None) grenadeFlash.LightRadius/=5;
	}
}
simulated function BlowUp(vector HitLocation)
{
	doLightFlash();
	if (muffleActor!=None)
	{
		//total hack
		/*
		if (Damage>100)
		{
			SpecForcePawn(muffleActor).bCanRagdoll = true;	

			SpecForcePawn(muffleActor).DeathAnimation = '';
			//SpecForcePawn(muffleActor).GoRagdoll();
		}
		*/
		muffleActor.TakeDamage(Damage,Pawn(Owner),Location,MomentumTransfer/60*(10*vrand()+muffleActor.Location-Location),MyDamageType,InstigatorController);
	}
	else
	{
		Super.BlowUp(HitLocation);
	}
}

simulated event Destroyed()
{
	// special FAISON hack for your pleasure
	if ( Level.NetMode == NM_Client )
	{
		//log ( "GrenadeProjectile:Destroyed - Playing explosion sound" );
		PlaySound(DPExplosionSound,, 1,,5000.0, 0.5+FRand(),true);
	}

	Super.Destroyed();
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	local vector		TraceHitLocationOut;	// output for Trace
	local vector		TraceHitNormalOut;		// output for Trace
	local vector		TraceEnd;	// Furthest point the trace should go to
	local material		mHitting;   // Surface the grenade hit
	local byte			byteType; 	// Material type
//	local float			horizVSquared, vertVSquared;
//	local vector		RollingBounceAdjustment, HitNormComponent;
	local actor			BounceVictim;
	local float			V_dot_HitNorm;

	//log ("hit"@hitwall);
	if ( HitWall == Instigator)
		return; 

	// Find the surface the grenade hit
	// (32.0 factor applied to HitNormal is just over 1 foot distance--just in case there
	// is a delay that causes this function to be called when the grenade is already 
	// slightly away from the wall).
	TraceEnd = Location - 32.0*HitNormal;
	BounceVictim = Trace( TraceHitLocationOut, TraceHitNormalOut, TraceEnd,,,, mHitting );
	
	// Play appropriate bounce sound
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
		BounceVictim.TakeDamage( ImpactDamage, instigator, TraceHitLocationOut, vect(0,0,0), class'DamageTypeProjectile', InstigatorController );

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
		PlaySound( ProjectileBounceSounds[int(byteType)],, 1.3,,500.0, 0.5+FRand(),true ); 

	// Reflect off Wall w/damping (less bounce if we're hitting a skybox)
	Speed = VSize(Velocity);
	V_dot_HitNorm = Velocity dot HitNormal;
	if( byteType == EMATERIALTYPE_SKY )  
	{
		// We're hitting sky
		BounceSkybox(V_dot_HitNorm, HitNormal );
		return;
	}
	else
	{
		// Normal case
		Bounce(V_dot_HitNorm, HitNormal );
	}

	// If on a slope, discourage it from sticking (give it a slight downhill psuedo-rolling)
	if( Speed < 360 
	 && HitNormal.Z < 0.9659 && HitNormal.Z > 0   // If HitNormal is 15 to 90 deg from vertical (for HitNormal length of 1, Z of 0.9659 means it's about 15 deg from vertical)
	 && Velocity.Z < 3.0 )
	{
		// If hitting a horizontal floor, the correction would cancel out to nothing
		// If hitting a vertical wall, the correction would be about 45 deg away from wall (downward)
		// (The goal is to get "close enough" to the goal of not getting stuck on steep surfaces, while using a cheap computation).
		if( HitNormal.Z < 0.777 ) // If more than 39 degrees 
			Velocity += (HitNormal + vect(0,0,-1))*60.0;
		else if( VSize(Velocity) > 50 )  // For other angles (and if velocity is high enough)
			Velocity += (HitNormal + vect(0,0,-1))*10.0;
	}

	
	RandSpin(30000);
	Speed = VSize(Velocity);
	

//	Log("Bounce.  Speed: "$Speed );
	if ( Velocity.Z > 600 )		// Limit vertical velocity
	{
		Velocity.Z = 0.5 * (600 + Velocity.Z);
	}
	else if ( Speed < 45 )  // If speed gets too low, stop bouncing
	{
		// Last ditch effort to keep it from sticking to a steep surface
		if( HitNormal.Z < 0.5 ) // 60 degree or steeper wall
		{
		//	Log("GP.HW  Speed:"$ Speed $"  HN:"$ HitNormal $"  steep surface stick last-ditch protection");
			Velocity += HitNormal*12.0;
			return;
		}

		bBounce = False;
		SetPhysics(PHYS_None);
		WarnBots();
	}
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

// Changes speed after bouncing off a non-skybox surface
simulated function Bounce(float V_dot_HitNorm, vector HitNormal )
{
	local float CurrElasticity;

	// Elasticity varies as a function of impact angle
	if( VSize(Velocity) > 0 )
	{
		if( bRollingBounce )
			CurrElasticity = ( RollBounceHorizCoeff*1.25 - (RollBounceHorizCoeff*1.25-Elasticity)*abs(V_dot_HitNorm)/Vsize(Velocity) );
		else
			CurrElasticity = ( RollBounceHorizCoeff - (RollBounceHorizCoeff-Elasticity)*abs(V_dot_HitNorm)/Vsize(Velocity) );
	}
	else
		CurrElasticity = Elasticity;

	// Adjust elasticity at high and low impact speeds
	if( Speed > 1100 )
	{
		CurrElasticity *= 0.85;
	}
	else if( Speed > 900 )
	{
		CurrElasticity *= 0.95;
	}
	else if( Speed > 95 && Speed < 320 )
	{
		if( bRollingBounce )
			CurrElasticity *= 1.63;
		else
			CurrElasticity *= 1.60;
	}
	CurrElasticity = FClamp( CurrElasticity, 0.0, 0.9999 );
//	Log("t:"$Level.TimeSeconds $"   V:"$Vsize(Velocity) $"  E:"$CurrElasticity );

	Velocity = CurrElasticity*(( V_dot_HitNorm ) * HitNormal * (-2.0) + Velocity);
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
	//		Log("##### GP.Flying.Tick  "$ FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"   new Lifespan:"$ Lifespan );
		}

		Global.Tick( TimeDelta );
	}
Begin:
//	log("Adding Impulse of: " $ Velocity);
//	log("Setting Speed to: " $ Speed);
	Velocity = Speed * vector(Rotation);
	RandSpin(30000);
	Speed = VSize(Velocity);
		
	if ( Velocity.Z > 600 )
	{
		Velocity.Z = 0.5 * (600 + Velocity.Z);
	}
//	Log("Velocity:"$Velocity);
	bBounce = True;
//	Log("####### GP.Flying.Begin  about to sleep for Lifespan-0.1.  Lifespan:"$ Lifespan $" #####################");
	Sleep(Lifespan-0.1);
	Explode(Location,Normal(-Velocity));
}

simulated event Explode(vector HitLocation, vector HitNormal)
{
	Super.Explode(HitLocation,HitNormal);
	bHidden=true;
}

simulated function WarnBots()
{
	bBeingHandled = false;
	Super.WarnBots ( );
}

simulated function bool IsMP()
{
	return ((Level.NetMode != NM_Standalone) || 
			(Level.Game == none) || 
			ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer')
			);
}


// Decompiled with UE Explorer.
defaultproperties
{
    ImpactEffectSnow=Class'ZombieEffects.explosion_grenade'
    ImpactEffectMP=Class'ZombieEffects.explosion_grenade'
    Elasticity=0.2500000
    RollBounceHorizCoeff=0.5000000
    GrenadeFlashClass=Class'GrenadeLightFlash'
    DPLifespan=3.0000000
    ProjectileSkin=Texture'CBT_DYN_Weapons.Grenade.Grenade'
    VelocityImpactCoeff=0.8500000
    LifespanAfterPHYSNone=4.0000000
    MinDestructibleBreakSpeed=500.0000000
    ImpactDamage=10
    Speed=1000.0000000
    MaxSpeed=2000.0000000
    Damage=115.0000000
    DamageRadius=480.0000000
    InnerDamageRadius=144.0000000
    FringeDamageRadius=600.0000000
    MomentumTransfer=45000.0000000
    MyDamageType=Class'DamageTypeHEGrenade'
    AmbientGlow=250
    CollisionRadius=9.0000000
    CollisionHeight=5.0000000
    bRotateToDesired=true
}