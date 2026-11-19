//=============================================================================
// SASProjectedDecal
//=============================================================================

class SASProjectedDecal extends Projector;

var() float mLifetime;				// life span of decal in seconds
var() float PushBack;
var() bool  RandomOrient;

var int		tickCount;
var float	ExpireTime;

var array<Texture>	mDamageDecals;
var array<EProjectorBlending> mDecalBlendMode;

var(Sound) class<SASDamageSoundArray>	mRicochetClass;	
var(Sound) class<SASDamageSoundArray>	mRicochetClassSecondary;
var(Sound) float	mRicochetVolMin;
var(Sound) float	mRicochetVolMax;
var(Sound) float	mRicochetPitchMin;
var(Sound) float	mRicochetPitchMax;
var(Sound) float	mRicochetRadius;
var(Sound) float	mRicochetAINoiseLevel;

var	bool			mbNotInGermanBuild;


////////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
simulated event PreBeginPlay ()
{
	//if ( mbNotInGermanBuild && IsGermanBuild() )
	//{
	//	Destroy();
	//	return;
	//}

	Super.PreBeginPlay ();

//	Disable ( 'Tick' );
	SetDecalRotation ();
	if( Owner!=None )
	{
		if( Owner.bStatic==False && SASDamageableMesh(Owner)==None )
		{
//			Log ("Attaching dynamic decal to " $Owner );
			CalcLocalTranform(Owner);
		}
	}
	ExpireTime=Level.TimeSeconds + mLifetime;

	PlayRicochetSounds();
}


///////////////////////////////////////////////////////////////////////////////
// Reset
//
// Destroy on restarting level.
simulated function Reset()
{
	Destroy();
}


////////////////////////////////////////////////////////////////////////////////
// SetProjTexture
//
simulated function SetProjTexture()
{
	local int					randTex;
	local EProjectorBlending	blendMode;

	if ( mDamageDecals.Length > 0 )
	{
		randTex = Rand( mDamageDecals.Length );
		ProjTexture = mDamageDecals[randTex];

		// Set the blend mode if defined for this decal array element. Otherwise just leave it
		// on the default.
		if ( mDecalBlendMode.Length > randTex )
		{
			blendMode = mDecalBlendMode[randTex];
			if ( blendMode != PB_None )
			{
				FrameBufferBlendingOp = blendMode;
			}
		}
	}
	else
	{
		ProjTexture = None;
	}
}


////////////////////////////////////////////////////////////////////////////////
// PlayRicochetSounds 
//
function PlayRicochetSounds()
{
	if ( mRicochetClass != None )
	{
		PlaySingleRicochetSound( mRicochetClass, SLOT_None );

		// Tell the AI
		if ( mRicochetAINoiseLevel > 0.0 )
		{
			MakeNoise( mRicochetAINoiseLevel, NOISE_Ricochet );
		}
	}

	if ( mRicochetClassSecondary != None )
	{
		PlaySingleRicochetSound( mRicochetClassSecondary, SLOT_Misc );
	}
}


////////////////////////////////////////////////////////////////////////////////
// PlaySingleRicochetSound 
//
simulated function PlaySingleRicochetSound(
	class<SASDamageSoundArray>	ricochetClass,
	ESoundSlot					slot )
{
	local int		numSounds;
	local Sound		randSound;

	numSounds = ricochetClass.Default.mSounds.Length;
	if ( numSounds > 0 )
	{
		randSound = ricochetClass.Default.mSounds[ Rand( numSounds ) ];
		
		// Make the noise.
		PlaySound( 
			randSound, 
			slot, 
			RandRange( mRicochetVolMin, mRicochetVolMax ), 
			true, 
			mRicochetRadius, 
			RandRange( mRicochetPitchMin, mRicochetPitchMax ), 
			true );
	}
}


////////////////////////////////////////////////////////////////////////////////
// PostBeginPlay 
//
// Overrides Projector.PostBeginPlay(). We don't call AttachProjector immediately
// because first we want to fill in the DecalAttachActor field which will save us 
// doing another heavyweight line trace to find what we've hit. 
simulated event PostBeginPlay ()
{
	if ( mbNotInGermanBuild && IsGermanBuild() )
	{
		// In german build, blood decals should not appear. 
		ProjTexture = None;
	
		SetCollision(false, false, false);

		StartTime = Level.TimeSeconds;
	}
	else
	{
		if ( ProjTexture == None )
		{
			SetProjTexture();
		}

		Super.PostBeginPlay();

		if ( Level.bDropDetail )
		{
			LifeSpan *= 0.5;
		}

	//	Enable('Tick');
		tickCount = 0;
	}
}



////////////////////////////////////////////////////////////////////////////////
// SetDecalRotation
//
simulated function SetDecalRotation ()
{
    local Vector RX, RY, RZ;
    local Rotator R;

	if ( RandomOrient )
    {
        R.Yaw = 0;
        R.Pitch = 0;
        R.Roll = Rand ( 65535 );
        GetAxes ( R, RX, RY, RZ );
        RX = RX >> Rotation;
        RY = RY >> Rotation;
        RZ = RZ >> Rotation;
        R = OrthoRotation ( RX, RY, RZ );
        SetRotation ( R );
    }
    SetLocation ( Location - Vector ( Rotation ) * PushBack );
}

////////////////////////////////////////////////////////////////////////////////
// Tick
//
// A bit of a hack....  If we destroy in PostBeginPlay, it doesn't get a chance to spawn on the client
// However with this we only take a few ticks and then it's destroyed.  Could be improved, perhaps
// with a circular buffer of preojectedDecal references, but for now this works on both SP and MP.
simulated event Tick ( float deltaTime )
{
	// Destroy if we don't have projected texture set. (This is expected - decals can be used
	// just to play a ricochet sound).
	if ( ProjTexture == None )
	{
		Destroy();
		return;
	}

	if( Owner!=None )
	{
		if( Owner.bStatic==False && SASDamageableMesh(Owner)==None )
		{
			if(Level.TimeSeconds > ExpireTime)
			{
				AbandonProjector ( 1 );
				Destroy ();
				Disable ( 'Tick' );
				return;
			}
			if( Owner.Velocity.x>0 || Owner.Velocity.y>0 || Owner.Velocity.z>0 )
			{
				DetachProjector();
				ApplyLocalTranform(Owner);
				AttachProjector();
			}
			return;
		}
	}
	if ( tickCount > 5 )
	{
		AbandonProjector ( LifeSpan * Level.DecalStayScale );
		Destroy ();
		Disable ( 'Tick' );
	}
	tickCount++;
}

////////////////////////////////////////////////////////////////////////////////
// defaultproperties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mLifetime=120.0000000
    PushBack=1.0000000
    RandomOrient=true
    mRicochetVolMin=0.7000000
    mRicochetVolMax=0.9000000
    mRicochetPitchMin=0.9500000
    mRicochetPitchMax=1.1000000
    mRicochetRadius=120.0000000
    FrameBufferBlendingOp=2
    FOV=1
    MaxTraceDistance=10
    bProjectParticles=false
    bProjectActor=false
    bClipStaticMesh=true
    bGradient=true
    bAttachToOwner=true
    LifeSpan=60.0000000
    DrawScale=0.1300000
    RemoteRole=2
    bStatic=false
    bNetTemporary=true
    bAlwaysRelevant=true
    bNetInitialRotation=true
    bGameRelevant=true
}