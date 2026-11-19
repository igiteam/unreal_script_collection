class TPWeaponAttachment extends Actor
	native
	abstract
	dependson(TPPhysicalMaterialProperty);



/** Weapon SkelMesh */
var	MeshComponent	Mesh;

/** Name of the socket on the pawn to attach this attachment to */
var name AttachSocketName;

/** Holds the name of the socket to attach a muzzle flash too */
var name					MuzzleFlashSocket;
/** Muzzle flash staticmesh, attached to weapon mesh */
var	StaticMeshComponent		MuzzleFlashMesh;

/** Muzzle flash PSC and Templates*/
var ParticleSystemComponent	MuzzleFlashPSC;
var ParticleSystem			MuzzleFlashPSCTemplate;
var color					MuzzleFlashColor;

var class<TPWeapon> WeaponClass;

var	TPPhysicalMaterial	DefaultPhysMaterial;

simulated function PostBeginPlay()
{
	local SkeletalMeshComponent SkelMesh;

	Super.PostBeginPlay();

	SkelMesh = SkeletalMeshComponent(Mesh);
	if (SkelMesh != None)
	{
		SkelMesh.bUpdateSkelWhenNotRendered = false;
		SkelMesh.bIgnoreControllersWhenNotRendered = true;
		SkelMesh.SetDepthPriorityGroup(SDPG_World);
	}
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
	PSC.SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
	PSC.SetVectorParameter('MFlashScale',Vect(0.5,0.5,0.5));
}

simulated function AttachTo(TPPawn OwnerPawn)
{
	local SkeletalMeshComponent SKMesh;

	if (OwnerPawn.Mesh != None)
	{
		// Attach Weapon mesh to player skelmesh
		if ( Mesh != None )
		{
			OwnerPawn.Mesh.AttachComponent(Mesh, AttachSocketName);
			SetOwner(OwnerPawn);
			// Weapon Mesh Shadow
			Mesh.SetShadowParent(OwnerPawn.Mesh);
			Mesh.SetLightEnvironment(OwnerPawn.LightEnvironment);
		}

		SKMesh = SkeletalMeshComponent(Mesh);
		if (SKMesh != None && MuzzleFlashSocket != '')
		{
			// Muzzle Flash mesh
			if (MuzzleFlashMesh != None)
			{
				SKMesh.AttachComponentToSocket(MuzzleFlashMesh, MuzzleFlashSocket);
			}

			if (MuzzleFlashPSCTemplate != None)
			{
				MuzzleFlashPSC = new(self) class'ParticleSystemComponent';
				SKMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
				MuzzleFlashPSC.DeactivateSystem();
			}
		}
	}
}

/**
 * Detach weapon from skeletal mesh
 */
simulated function DetachFrom( SkeletalMeshComponent MeshCpnt )
{
	local SkeletalMeshComponent SKMesh;

	// Weapon Mesh Shadow
	if ( Mesh != None )
	{
		Mesh.SetShadowParent(None);
		Mesh.SetLightEnvironment(None);
	}

	if ( MeshCpnt != None )
	{
		// detach weapon mesh from player skelmesh
		if ( Mesh != None )
		{
			MeshCpnt.DetachComponent( mesh );
		}
	}


	SKMesh = SkeletalMeshComponent(Mesh);
	if (SKMesh != none)
	{
		// Muzzle Flash Mesh
		if ( MuzzleFlashMesh != None )
			SKMesh.DetachComponent( MuzzleFlashMesh );

		if (MuzzleFlashPSC != none)
			SKMesh.DetachComponent( MuzzleFlashPSC );
	}
}

simulated event CauseMuzzleFlash()
{
	if (MuzzleFlashPSC != none)
	{
		MuzzleFlashPSC.DeactivateSystem();
		if ( MuzzleFlashPSC.bWasDeactivated )
		{
			MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
			SetMuzzleFlashParams(MuzzleFlashPSC);
			MuzzleFlashPSC.ActivateSystem();
		}
	}

	if (MuzzleFlashMesh != none)
	{
		MuzzleFlashMesh.SetHidden(false);
	}
}

simulated event StopMuzzleFlash()
{
	if ( MuzzleFlashPSC != none )
	{
		MuzzleFlashPSC.DeactivateSystem();
	}
}

simulated event WeaponFireEffects(vector HitLocation)
{
	CauseMuzzleFlash();
}

simulated event StopFireEffects()
{
	StopMuzzleFlash();
}

simulated function SpawnHitEffects(Vector HitLocation)
{
	local actor HitActor;
	local vector NewHitLoc, HitNormal;
	local ImpactInfo Impact;
	local TPPhysicalMaterial tpphysmat;
	local TraceHitInfo HitInfo;
	local float DistanceCheck;

	HitNormal = Normal(Owner.Location - HitLocation);
	DistanceCheck = VSize(Owner.Location - HitLocation);
	
	// We dont need to spawn particles anymore cause the server has it.
	if (DistanceCheck > 700)
	{
		return;
	}
	
    HitActor = Trace(NewHitLoc, HitNormal, (HitLocation - (HitNormal * 32)), HitLocation + (HitNormal * 32), true,, HitInfo, TRACEFLAG_Bullet);
		
	//HitActor = Trace(HitLocation,HitNormal,EndTrace,StartTrace,true,vect(0,0,0), HitInfo, TRACEFLAG_Bullet);

	Impact.HitActor		= HitActor;
	Impact.HitLocation	= HitLocation;
	Impact.HitNormal	= HitNormal;
	Impact.RayDir		= -HitNormal;
	Impact.HitInfo		= HitInfo;
	
	;	

	if (Impact.HitInfo.PhysMaterial == none)
	{
		Impact.HitInfo.PhysMaterial = DefaultPhysMaterial;
	}

	tpphysmat = TPPhysicalMaterial(Impact.HitInfo.PhysMaterial);
	
	if (HitActor != none)
	{
		if (!Impact.HitActor.IsA('Pawn') || (Impact.HitActor.IsA('SVehicle') && !Impact.HitActor.IsA('Turret')))
		{
			HandleImpactParticles( tpphysmat, WeaponClass.default.WeaponDamageType, Impact);
			//HandleImpactSound( tpphysmat, WeaponClass.default.WeaponDamageType, self, Impact.HitLocation );
		}
	}
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

