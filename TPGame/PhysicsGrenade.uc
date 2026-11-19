class PhysicsGrenade extends KAsset
	native;

var() float CookTime;					// How much time before the grenade blows up
var() float ImpulseForce;				// How much force to apply to nearby objects
var() float AffectedRadius;				// What radius the zone effects
var() float DamageCaused;				// How much damage does this do.
var() bool bExplodeOnImpact;			// Should this grenade explode upon rigid body collision?
var GrenadeSplashZone DamageZone;
//var array<MaterialImpactEffect> ImpactEffects;	// Material Impact Sound Effects
var AudioComponent CollideAudioCmpt;
var Material ScorchMaterial;
var ParticleSystem ExplParticles;

var vector DecalNormal;
//var EffectsVolume EffectsVolume;
var private bool bExploded;				// Keeps track of whether the grenade exploded

// type of dame to apply to the affected radius
var() class<DamageType> 	MyDamageType;

var	bool	m_bHasPawnRegisteredToHotTossMe;
var Pawn	m_PawnThatRegisteredToHotTossMe;
var TPPlayerController		controllerOwner;


// Danger Event management
// remember location and position of last danger events propagated
var const 	vector 		m_Event1Spot;
var const 	float 		m_Event1Time;
var const	pawn		m_Event1Other;
var const	float		m_Event1ThreatLevel;
var const 	vector 		m_Event2Spot;
var const 	float 		m_Event2Time;
var const	pawn		m_Event2Other;
var const	float		m_Event2ThreatLevel;

//***********************************************************************
// CPP TEXT
//***********************************************************************

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated event ReplicatedEvent( name VarName )
{
      super.ReplicatedEvent(VarName);

	  // This var is replicated as soon as it becomes visible to the client.
      if (VarName == 'ReplicatedMesh')
      {
		if ( Owner != none && Pawn(Owner) != none )
		{
			// Set the rotation and velocity so it doesn't "jump" around the world
			SkeletalMeshComponent.SetRBPosition(Pawn(Owner).Weapon.Mesh.GetPosition());
			SkeletalMeshComponent.SetRBRotation(Pawn(Owner).Weapon.Mesh.Rotation);
			SkeletalMeshComponent.SetRBLinearVelocity(Grenade_Persistent(Pawn(Owner).Weapon).ThrowForce >> Pawn(Owner).Controller.Rotation, true);
			SkeletalMeshComponent.SetRBAngularVelocity(vect(0,20,5) >> Pawn(Owner).Controller.Rotation, true);

		}	
      }
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	// Temp sound for now
	CollideAudioCmpt.SoundCue = SoundCue'S_Wpn_Grenade.Common.Grenade_Land_Cue';
	AttachComponent(CollideAudioCmpt);

	SkeletalMeshComponent.WakeRigidBody();
	SkeletalMeshComponent.SetNotifyRigidBodyCollision(true);
}

function bool HaveGoneBoom()
{
	return bExploded;
}

function Activate(float myCookTime, float myImpulseForce, float myAffectedRadius, float myDamageCaused,
								  bool mybExplodeOnImpact = false, optional class<DamageType> actDamageType = class'TPDamageTypeImpactGrenade',
								  optional ParticleSystem myParticleSystem = None)
{	
	CookTime = myCookTime;

	// If our cook time was not set yet, we must use the default cook time or we will never detonate.
	if ( CookTime ~= 0 || CookTime < 0 )
	{
		CookTime = class'Grenade_Persistent'.default.CookTime;
	}

	ImpulseForce = myImpulseForce;
	AffectedRadius = myAffectedRadius;
	DamageCaused = myDamageCaused;
	bExplodeOnImpact = mybExplodeOnImpact;
	MyDamageType = actDamageType;
	if (myParticleSystem != None)
		ExplParticles = myParticleSystem;

	GotoState('Cooking');
}

simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
					const out CollisionImpactData RigidCollisionData, int ContactIndex )
{

	//local int Picked;
	DecalNormal += RigidCollisionData.ContactInfos[0].ContactNormal;

	//`log("Hit "@HitComponent);
	//Picked = Rand(TPPhysicalMaterialProperty(ContactInfos[0].PhysMaterial[1].PhysicalMaterialProperty).GrenadeSounds.Length);
	//CollideAudioCmpt.SoundCue = TPPhysicalMaterialProperty(ContactInfos[0].PhysMaterial[1].PhysicalMaterialProperty).GrenadeSounds[Picked].SoundCue;

	//`log(ContactInfos[0].PhysMaterial[1]);
	if (!CollideAudioCmpt.bWasPlaying)
		CollideAudioCmpt.Play();

	//force the explosion if bExplodeOnImpact is set
	if (bExplodeOnImpact && IsInState('Cooking'))
	{
		ForceExplosion();
	}
	
	//MakeDangerEvent(1.0, 'GRENADE_OUT');
	MakeDangerEvent(1.0);
}

state Cooking
{
	function BeginState(Name PreviousStateName)
	{
	//	`log("Cooking started!"@CookTime);
		SetTimer(CookTime);
	}

	function Timer()
	{
		Explode();
	}
}

simulated function Explode()
{
	local DecalComponent D;
	//local rotator DecalRotation;
	//local DecalLifetimeDataAge LifetimeData;

	//`log(" ChadAI - Grenade:: Explode fn Called bExploded: " @ bExploded @ " Role: " @ Role @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


	if (bExploded == true) //already exploded, so don't do this a second time
	{
		return;
	}

	bExploded = true;

	if (Role == Role_Authority)
	{
		DamageZone = Spawn(class'GrenadeSplashZone',Owner,,SkeletalMeshComponent.GetPosition(), rot(0,0,0));
		DamageZone.ImpulseForce = ImpulseForce;
		DamageZone.DamageCaused = DamageCaused;
		DamageZone.AffectedRadius = AffectedRadius;
		DamageZone.DamageType = MyDamageType;
		DamageZone.controllerOwner = controllerOwner;
		if (ExplParticles != None)
			DamageZone.Emitters[0] = ExplParticles;

		DamageZone.ImpactNearbyObjects();

		//LifetimeData = new(Owner.Owner) class'DecalLifetimeDataAge';
		//LifetimeData.LifeSpan = 9999.0;

		//D = Owner.AddDecal(ScorchMaterial,SkeletalMeshComponent.GetPosition()+vect(0,0,20),/*DecalRotation*/rotator(-Normal(DecalNormal)),Rand(360), 400,400,400,false,None,None,/*LifetimeData*/, true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, ''/*HitBone*/, -1/*HitNodeIndex*/, -1/*HitLevelIndex*/);
		D = WorldInfo.MyDecalManager.SpawnDecal( ScorchMaterial, SkeletalMeshComponent.GetPosition()+vect(0,0,20),/*DecalRotation*/rotator(-Normal(DecalNormal)), 400,400,400,false,Rand(360),None,true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, ''/*HitBone*/,-1/*HitNodeIndex*/, -1/*HitLevelIndex*/);
		D.NearPlane = -200;
	
		Destroy();
	}
	else
	{
		//`log(" ChadAI - Grenade:: Explode fn Called Role != Role_Authority This Is Bad -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
}

//pre: you can only call this when the object is in the cooking state
simulated function ForceExplosion()
{
	ClearTimer();
	Timer();
}

event TakeDamage(int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType,HitInfo,DamageCauser);

	if (!bExploded)
	{
		//Since a live grenade has taken damage, clear the timer and execute the explosion function
		//`log("Live grenade took damage, boom!");
		ForceExplosion();
	}
}

/* Inform other creatures that you've made a noise
 they might hear (they are sent a HearNoise message)
 Senders of MakeNoise should have an instigator if they are not pawns.
*/
//native final function MakeDangerEvent( float Badness, optional Name DangerEventType );
native final function MakeDangerEvent( float Badness ); // not need for an danger type because there is only grenades //, optional Name DangerEventType );

// checks to see if the grenade has already been registered to be hot tossed and if not registers it
function bool RegisterToHotToss( Pawn HotTosser )
{
	//`log(" ChadAI - Pawn: " @ HotTosser @ " RegisterToHotToss me. Have I already been registered: " @ m_bHasPawnRegisteredToHotTossMe @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if( !m_bHasPawnRegisteredToHotTossMe )
	{
		//`log(" ChadAI - Pawn: " @ HotTosser @ " RegisterToHotToss No one has registered so register the calling pawn to hot toss me -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		m_bHasPawnRegisteredToHotTossMe = true;
		m_PawnThatRegisteredToHotTossMe = HotTosser;

		return true;
	}
	else if( m_PawnThatRegisteredToHotTossMe == HotTosser )
	{
		//`log(" ChadAI - Pawn: " @ HotTosser @ " RegisterToHotToss This pawn has all ready registered to hot toss me -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		return true;
	}

	//`log(" ChadAI - Pawn: " @ HotTosser @ " RegisterToHotToss another pawn: " @ m_PawnThatRegisteredToHotTossMe @ " has registered to hot toss me -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	return false;	
}

function UnRegisterToHotToss( Pawn HotTosser )
{
	if( m_PawnThatRegisteredToHotTossMe == HotTosser )
	{
		m_bHasPawnRegisteredToHotTossMe = false;
		m_PawnThatRegisteredToHotTossMe = None;
	}
}


