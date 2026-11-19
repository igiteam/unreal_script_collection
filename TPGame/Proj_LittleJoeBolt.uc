class Proj_LittleJoeBolt extends TPProjectile
									config(Game);

var config float HeadShotTimer;
var config float ChestShotTimer;
var config float ArmShotTimer;
var config float LegShotTimer;
var config float StuckLifeTime;

function Init(vector Direction)
{
    Super.TPInit(Direction, false);
}

function Timer()
{
	if (Pawn(Owner) != none)
		Owner.TakeDamage(Pawn(Owner).Health,InstigatorController,Location,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if ( Other == Instigator )
		return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
        if (Other.IsA('Pawn'))
            SpawnHitEffects(HitLocation);
		else
			Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
		SetCollision(false,false);
		//Shutdown();
	}
}

simulated function SpawnHitEffects(Vector TraceLoc)
{
	local actor HitActor;
	local vector HitLocation, HitNormal;
	local ImpactInfo Impact;
    local vector StartTrace, EndTrace;
	local TPPhysicalMaterial tpphysmat;
	local TPPawn tppawn;
	local vector LocOffset;
	local rotator RotOffset;

	HitNormal = normal(Velocity * -1);
	
    StartTrace = TraceLoc + HitNormal*100;
    EndTrace   = TraceLoc - HitNormal*100;


	HitActor = Trace(HitLocation,HitNormal,EndTrace,StartTrace,true,vect(0,0,0), HitInfo, TRACEFLAG_Bullet);

	Impact.HitActor		= HitActor;
	Impact.HitLocation	= HitLocation;
	Impact.HitNormal	= HitNormal;
	Impact.RayDir		= Normal(HitLocation-StartTrace);
	Impact.HitInfo		= HitInfo;

	if (Impact.HitInfo.PhysMaterial == none)
	{
		Impact.HitInfo.PhysMaterial = DefaultPhysMaterial;
	}

	tpphysmat = TPPhysicalMaterial(Impact.HitInfo.PhysMaterial);

	if (HitActor != none)
	{
		if (!Impact.HitActor.IsA('Pawn') || Impact.HitActor.IsA('SVehicle'))
		{
			HandleImpactSound( tpphysmat, MyDamageType, self, Impact.HitLocation );
		}
		else if (Impact.HitActor.IsA('Pawn'))
		{
			tppawn = TPPawn(Impact.HitActor);
			if (tppawn != None)
			{
				LifeSpan=0.0;
				;
				tppawn.Mesh.TransformToBoneSpace(Impact.HitInfo.BoneName, Impact.HitLocation, rotator(Velocity), LocOffset, RotOffset);
				tppawn.Mesh.AttachComponent(StaticMeshComponent, Impact.HitInfo.BoneName, LocOffset, RotOffset);
				SetPhysics(PHYS_None);
				
				TPPawn(Impact.HitActor).PrePokeActor(Impact.RayDir);
				Impact.HitInfo.HitComponent.AddImpulse (Impact.RayDir * 200, Impact.HitLocation, Impact.HitInfo.BoneName);
				
				SetOwner(tppawn);

				switch (tppawn.GetHitZone(HitInfo.BoneName))
				{
					case HZ_Head:
						if (HeadShotTimer <= 0)
							tppawn.TakeDamage(tppawn.Health,InstigatorController,Impact.HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
						else
							SetTimer(HeadShotTimer, false);
						break;
					case HZ_Chest:
						if (ChestShotTimer <= 0)
							tppawn.TakeDamage(tppawn.Health,InstigatorController,Impact.HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
						else
							SetTimer(ChestShotTimer, false);
						break;
					case HZ_Arm:
						if (ArmShotTimer <= 0)
							tppawn.TakeDamage(tppawn.Health,InstigatorController,Impact.HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
						else
							SetTimer(ArmShotTimer, false);
						break;
					case HZ_Leg:
						if (LegShotTimer <= 0)
							tppawn.TakeDamage(tppawn.Health,InstigatorController,Impact.HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
						else
							SetTimer(LegShotTimer, false);
						break;
					case HZ_None:
						tppawn.TakeDamage(tppawn.Health,InstigatorController,Impact.HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
						break;
				}
			}

			HandleImpactParticles( tpphysmat, MyDamageType, Impact);
		}
	}
}

simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	SpawnHitEffects(Location);

	Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	SetPhysics(PHYS_None);
	SetLocation(HitLocation);
	
	MakeNoise(TPWeapon(Owner).m_ProjectileImpactLoudness, AudioEventType_NORMAL_EXPLODING_DEFAULT );

	LifeSpan = StuckLifeTime;
}

