class TPProjectile extends Projectile
	native;

// Ambient Sound of the Projectile
var SoundCue AmbientSound;

// Tracer Params
var EmitterSpawnable TracerEmitter;
var ParticleSystem TracerTemplate;
var bool bUseTracer;
var name TracerStartParamName, TracerEndParamName;
var float TracerLength;

// Internal
var vector StartLocation;
var bool bReflected;
var bool bInstantKillOnHeadShot;	// Set in TPWeapon::ProjectileFire()
var TraceHitInfo HitInfo;		// Used in Traces so we can get pawns hit detection to work properly
var int ReflectCount;

// Mesh Component
var StaticMeshComponent StaticMeshComponent;
var	const protected TPPhysicalMaterial DefaultPhysMaterial;

simulated function PostBeginPlay()
{
	local AudioComponent AmbientComponent;

	super.PostBeginPlay();

	// Set its Ambient Sound
	if (AmbientSound != None )
	{
		AmbientComponent = CreateAudioComponent(AmbientSound, true, true);

		if ( AmbientComponent != None )
			AmbientComponent.bShouldRemainActiveIfDropped = true;
		//AttachComponent(AmbientComponent);
	}

	// This should be called in PostBeginPlay on weapons that need a projectile spawned in multiplayer
	// Call it in child classes of projectile that need it
	//SpawnTracer();

	if (Speed > 0)
		LifeSpan = 32768 / Speed;
}

/* TPInit()
initialize velocity and rotation of projectile
*/
function TPInit(vector Direction, bool bOwnerWeapon, optional bool bOwnerTurret = false)
{
	if( Owner != None )
	{
		if (bOwnerWeapon && TPWeapon(Owner) != None )
			MakeNoise(TPWeapon(Owner).m_FiringLoudness, AudioEventType_SMALL_ARMS_FIRING );
		else if (bOwnerTurret)
		{
			if( Turret(Owner) != None )
			{
				MakeNoise(Turret(Owner).m_ProjectileLoudness, AudioEventType_CREW_SERVED_WEAPON_FIRING);
			}
			else if( TPAiController(Owner) != None && Turret(TPAiController(Owner).Pawn) != None )
			{
				if( Turret(TPAiController(Owner).Pawn) != None )
				{
					MakeNoise(Turret(TPAiController(Owner).Pawn).m_ProjectileLoudness, AudioEventType_CREW_SERVED_WEAPON_FIRING);
				}
			}
		}
	}
	
	super.Init(Direction);
}

native final function TPInitCode(bool bOwnerWeapon, bool bOwnerTurret, vector Direction);

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local TPPawn tpOther;
	local TPPawn tpInstigator;

	if ( Other == Instigator )
		return;

	tpOther = TPPawn(Other);
	tpInstigator = TPPawn(Instigator);
//`log(self @ "projectile touched" @ Other);

    if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
        if (tpOther != None)
		{
			SpawnHitEffects(HitLocation);
			if (tpOther.TeamAssignment == TPTEAM_ENEMY && bInstantKillOnHeadShot && ((tpOther.GetHitZone(HitInfo.BoneName) == HZ_Head) || (tpOther.GetApproxHitZone(HitLocation) == HZ_Head)) )
				Damage = tpOther.Health;

			if (tpInstigator != None && tpInstigator.TeamAssignment != tpOther.TeamAssignment
				&& TPPlayerController(tpInstigator.Controller) != None)
			{
				if (WorldInfo.NetMode == NM_Standalone) // only in standalone
					TPPlayerController(tpInstigator.Controller).HitEnemyWithBullet();
				else if (Role == ROLE_Authority) // only on the server
					TPPlayerReplicationInfo(TPPlayerController(tpInstigator.Controller).PlayerReplicationInfo).IncrementBulletsHitThisRound();
			}
		}
		else if (!Other.IsA('Brush'))
		{
			SpawnHitEffects(HitLocation);
		}

		// If the projectile spawned inside an enemy, InstigatorController is "none" here, so we need to set it to its correct value
		if (Instigator != None && InstigatorController == None)
		{
			InstigatorController = Instigator.Controller;
		}

        Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
//`log("calling shutdown 1");		
		Shutdown();
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	//Don't call hurt radius as this tanks our framerate here, and doesn't really add anything useful
	//if (Damage > 0 && DamageRadius > 0)
	//	HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	
	//`log( "Projectile Explode:: MakeNoise(TPWeapon(Owner).m_ProjectileImpactLoudness: " @ TPWeapon(Owner).m_ProjectileImpactLoudness @ ", 'NORMAL_EXPLODING_DEFAULT' ) -----------------------------------------------------" );

	if(Owner != none)
	{
        if (Owner.IsA('TPWeapon'))
		   MakeNoise(TPWeapon(Owner).m_ProjectileImpactLoudness, AudioEventType_NORMAL_EXPLODING_DEFAULT );
	    else if (Owner.IsA('Turret'))
		   MakeNoise(Turret(Owner).m_ProjectileLoudness, AudioEventType_NORMAL_EXPLODING_DEFAULT );
	}

	//MakeNoise(1.0, 'NORMAL_EXPLODING_DEFAULT');
//`log("calling shutdown 2");		

	ShutDown();
}

native simulated function SpawnTracer();
// {
// 	if (WorldInfo.NetMode != NM_DedicatedServer)
// 	{
// 		if (TracerEmitter == none)
// 		{
// 			StartLocation = Location;
// 			TracerEmitter = Spawn(class'EmitterSpawnable',Instigator,, Location, rotator(Velocity));
// 			TracerEmitter.SetTemplate(TracerTemplate);
// 			AttachComponent(TracerEmitter.ParticleSystemComponent);
// 		}
// 
// 		if (StaticMeshComponent != none)
// 		{
// 			AttachComponent(StaticMeshComponent);
// 		}
// 	}
// 	//TracerEmitter.LifeSpan = LifeSpan;
// 	//TracerEmitter.SetVectorParameter(TracerStartParamName, Location);
// 	//TracerEmitter.SetVectorParameter(TracerEndParamName, Location);
// }

simulated function SpawnHitEffects(Vector TraceLoc)
{
	local actor HitActor;
	local vector HitLocation, HitNormal;
	local ImpactInfo Impact;
    local vector StartTrace, EndTrace;
	local TPPhysicalMaterial tpphysmat;
	local TPPhysicalMaterialProperty MatProperty;
	//local DecalLifetimeDataAge LifetimeData;
	local Material DecalMat, ExitDecalMat;
	local vector WallThickness;
	local int PickedDecal;	
	local float DecalSize;
	local DecalComponent Decal;
	local TPPawn tppawn;
	local Turret pTurret;
	local Bool bValidDecal;


	//local float DecalDepthBias;

	bValidDecal = FALSE;
	
	HitNormal = normal(Velocity * -1);
	
    StartTrace = TraceLoc + HitNormal*100;
    EndTrace   = TraceLoc - HitNormal*100;


	HitActor = Trace(HitLocation,HitNormal,EndTrace,StartTrace,true,vect(0,0,0), HitInfo, TRACEFLAG_Bullet);

	Impact.HitActor		= HitActor;
	Impact.HitLocation	= HitLocation;
	Impact.HitNormal	= HitNormal;
	Impact.RayDir		= Normal(HitLocation-StartTrace);
	Impact.HitInfo		= HitInfo;
	
	//`log(self @ "spawn hit effects - Hit.Item=" @ HitInfo.Item @ "Hit.LevelIndex=" @ HitInfo.LevelIndex);	

	if (Impact.HitInfo.PhysMaterial == none)
	{
		Impact.HitInfo.PhysMaterial = DefaultPhysMaterial;
	}

	tpphysmat = TPPhysicalMaterial(Impact.HitInfo.PhysMaterial);
	
	if (HitActor != none)
	{
		if (!Impact.HitActor.IsA('Pawn') || (Impact.HitActor.IsA('SVehicle') && !Impact.HitActor.IsA('Turret')))
		{
			if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				if (TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_HITEFFECTS))
					HandleImpactParticles( tpphysmat, MyDamageType, Impact);

				HandleImpactSound( tpphysmat, MyDamageType, self, Impact.HitLocation );
			}

			if (tpphysmat != None)
			{
				MatProperty = TPPhysicalMaterialProperty(tpphysmat.PhysicalMaterialProperty);
				
				if (MatProperty != None)
				{
					PickedDecal = Rand(MatProperty.BulletDecals.Length);
					DecalMat = MatProperty.BulletDecals[PickedDecal].DecalMaterial;
					ExitDecalMat = MatProperty.BulletDecals[PickedDecal].ExitDecalInfo.DecalMaterial;
					if (MatProperty.BulletDecals.Length > 0)
						bValidDecal = TRUE;
				}
			}

			if (DecalMat != none && Owner != none && bValidDecal)
			{
				if (Owner.IsA('Turret'))
				{
					pTurret = Turret(Owner);
					if (pTurret.Driver != None)
					{
						//LifetimeData = new(pTurret.Driver) class'DecalLifetimeDataAge';
						//LifetimeData.LifeSpan = 15.0;
					}
					else
						return;
				}
                else
				{
					//LifetimeData = new(Owner.Owner) class'DecalLifetimeDataAge';
					//LifetimeData.LifeSpan = 25.0;
				}
				
				DecalSize = (FRand() * (MatProperty.BulletDecals[PickedDecal].MaxSize - MatProperty.BulletDecals[PickedDecal].MinSize)) + MatProperty.BulletDecals[PickedDecal].MinSize;
				
				//DecalDepthBias = -0.0002 * FRand();
				
				
// 				if (ImpactedActor != none)
// 				{
// 					Decal = ImpactedActor.AddDecal(DecalMat,Impact.HitLocation,rotator(-Impact.HitNormal),Rand(40)-20, DecalSize,DecalSize,20,false,HitInfo.HitComponent,/*LifetimeData*/None, true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, HitInfo.BoneName/*HitBone*/, HitInfo.Item/*HitNodeIndex*/, HitInfo.LevelIndex/*HitLevelIndex*/, DecalDepthBias);
// 				}
// 				else
// 				{
// 					Decal = Impact.HitActor.AddDecal(DecalMat,Impact.HitLocation,rotator(-Impact.HitNormal),Rand(40)-20, DecalSize,DecalSize,20,false,HitInfo.HitComponent,/*LifetimeData*/None, true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, HitInfo.BoneName/*HitBone*/, HitInfo.Item/*HitNodeIndex*/, HitInfo.LevelIndex/*HitLevelIndex*/, DecalDepthBias);
// 				}

				// Decals are now SP only
				if ( WorldInfo.NetMode == NM_Standalone )
				{
					Decal = WorldInfo.MyDecalManager.SpawnDecal(DecalMat,Impact.HitLocation,rotator(-Impact.HitNormal),DecalSize,DecalSize,20,false,Rand(40)-20,HitInfo.HitComponent,true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, HitInfo.BoneName/*HitBone*/, HitInfo.Item/*HitNodeIndex*/, HitInfo.LevelIndex/*HitLevelIndex*/);

				
					if (Decal != none )
					{
						Impact.HitActor.AttachComponent(Decal);
						if (Role == ROLE_Authority) // Is this ok?
							TPGameReplicationInfo(WorldInfo.GRI).BulletDecalManager.Add(Decal);
					}

					if (MatProperty.BulletDecals[PickedDecal].UseExitDecalInfo && ExitDecalMat != none)
					{
						DecalSize = (FRand() * (MatProperty.BulletDecals[PickedDecal].ExitDecalInfo.MaxSize - MatProperty.BulletDecals[PickedDecal].ExitDecalInfo.MinSize)) + MatProperty.BulletDecals[PickedDecal].ExitDecalInfo.MinSize;
					
						WallThickness.X = MatProperty.BulletDecals[PickedDecal].ExitDecalInfo.WallThickness;
						
	// 					if (ImpactedActor != none) impact.HitActor.LastRenderTime // Mesh maybe
	// 					{
	// 						Decal = ImpactedActor.AddDecal(ExitDecalMat,Impact.HitLocation + (WallThickness >> rotator(-Impact.HitNormal) ),rotator(Impact.HitNormal),Rand(40)-20, DecalSize,DecalSize,20,false,HitInfo.HitComponent,/*LifetimeData*/None, true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, HitInfo.BoneName/*HitBone*/, HitInfo.Item/*HitNodeIndex*/, HitInfo.LevelIndex/*HitLevelIndex*/, DecalDepthBias);
	// 					}
	// 					else
	// 					{
	// 						Decal = Impact.HitActor.AddDecal(ExitDecalMat,Impact.HitLocation + (WallThickness >> rotator(-Impact.HitNormal) ),rotator(Impact.HitNormal),Rand(40)-20, DecalSize,DecalSize,20,false,HitInfo.HitComponent,/*LifetimeData*/None, true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, HitInfo.BoneName/*HitBone*/, HitInfo.Item/*HitNodeIndex*/, HitInfo.LevelIndex/*HitLevelIndex*/, DecalDepthBias);
	// 					}

						Decal = WorldInfo.MyDecalManager.SpawnDecal(ExitDecalMat,Impact.HitLocation + (WallThickness >> rotator(-Impact.HitNormal) ),rotator(Impact.HitNormal),DecalSize,DecalSize,20,false,Rand(40)-20,HitInfo.HitComponent,true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, HitInfo.BoneName/*HitBone*/, HitInfo.Item/*HitNodeIndex*/, HitInfo.LevelIndex/*HitLevelIndex*/);

						if (Decal != none)
						{
							Impact.HitActor.AttachComponent(Decal);
							if (Role == ROLE_Authority) // Is this ok?
								TPGameReplicationInfo(WorldInfo.GRI).BulletDecalManager.Add(Decal);
						}
						

						Impact.HitLocation += (WallThickness >> rotator(-Impact.HitNormal) );
						Impact.HitNormal *= -1; 
					}
				
				}
				if (TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_HITEFFECTS))
					tpphysmat.SpawnImpactParticles( None, Impact );
				
			}
		}
		else if (Impact.HitActor.IsA('Pawn'))
		{
			tppawn = TPPawn(Impact.HitActor);
			if (tppawn != None)
			{
				TPPawn(Impact.HitActor).PrePokeActor(Impact.RayDir);
				Impact.HitInfo.HitComponent.AddImpulse (Impact.RayDir * 200, Impact.HitLocation, Impact.HitInfo.BoneName);
			}

			if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				if (TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_HITEFFECTS))
					HandleImpactParticles( tpphysmat, MyDamageType, Impact);

				HandleImpactSound( tpphysmat, MyDamageType, self, Impact.HitLocation );
			}
		}
	
	}
}


simulated function Shutdown()
{
	//Sanjay: Just hide the projectile and destroy it, turning off physics and collision is just too costly here.
	//SetPhysics(PHYS_None);

//`log(self @ "shutdown");

	if (TracerEmitter != none)
	{
		TracerEmitter.Destroy();
	}

	HideProjectile();
	//SetCollision(false,false);
	Destroy();	
}

simulated function HandleImpactParticles( TPPhysicalMaterial PhysMaterial, class<DamageType> ImpactDamageType, ImpactInfo Impact)
{
	if( PhysMaterial == None )
	{
		PhysMaterial = DefaultPhysMaterial;
	}

//	`log("TPProjectile::HandleImpactParticles");

	PhysMaterial.SpawnImpactParticles( ImpactDamageType, Impact );
}

simulated function HandleImpactSound( TPPhysicalMaterial	PhysMaterial,
								   class<DamageType>	ImpactDamageType,
								   Actor				dummyActor,
								   Vector				soundPos )
{
	if( PhysMaterial == None )
	{
		PhysMaterial = DefaultPhysMaterial;
	}

	PhysMaterial.PlayImpactSound( ImpactDamageType, dummyActor, soundPos );
}

simulated function HideProjectile()
{
	local MeshComponent ComponentIt;
	foreach ComponentList(class'MeshComponent',ComponentIt)
	{
		ComponentIt.SetHidden(true);
	}
}

simulated function Tick(float dt)
{
	super.Tick(dt);
		
	//if (TracerEmitter != none && bUseTracer)
	//{
	//	TracerEmitter.SetVectorParameter(TracerStartParamName, Location);
	//	if (VSize(Location-StartLocation) > TracerLength)
	//		TracerEmitter.SetVectorParameter(TracerEndParamName, Location - (Normal(Velocity) * TracerLength));
	//	else
	//		TracerEmitter.SetVectorParameter(TracerEndParamName, Location);
	//}
}

function Ricochet(vector HitNormal)
{
	local vector Reflection;

	LifeSpan *= 0.25;
	Damage = 0;
	bReflected = true;
	StartLocation = Location;
	Reflection = MirrorVectorByNormal(Normal(Velocity),HitNormal);
    SetRotation(rotator(Reflection));
	Velocity = Normal(Reflection) * Speed;
	SetPhysics(PHYS_Falling);
}

simulated singular function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	//local vector NormVelocity;

	//NormVelocity = Normal(Velocity);

    //if (bReflected)
	//{
	//	ShutDown();
	//	return;
	//}
	ImpactedActor = Wall;
	SpawnHitEffects(Location); 
	ImpactedActor = none;

    if (Wall.IsA('KActor') || Wall.IsA('KAsset') || Wall.IsA('TPBaseVehicle') || Wall.IsA('SPDStaticMesh'))
	{
		Wall.TakeDamage(Damage,InstigatorController,Location,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
//`log("calling shutdown 3");		
		Shutdown();
		return;
	}



	//if (HitNormal dot NormVelocity > -0.75)
	//	Ricochet(HitNormal);
	//else
//`log("calling explode because I hit" @ wall);	
if( wall.isa('StaticMeshActor') )
{
	//`log("mesh="  @ StaticMeshActor(wall).StaticMeshComponent.StaticMesh);
}
		Explode(Location, HitNormal);
}

simulated event Landed( vector HitNormal, actor FloorActor )
{
	super.Landed(HitNormal, FloorActor);
	Destroy();
}

simulated function Destroyed()
{
	super.Destroyed();
	if (TracerEmitter != none)
		TracerEmitter.Destroy();
}

