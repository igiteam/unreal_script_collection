/**
*
*/
class	HDWeap_Missle_HJ8	extends HDWeap_TurretBase;

var editinline  export  HDTelescope     Telescope;

// do not reload
simulated function Reload()
{
	return;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Telescope.Owner = Self;
}

simulated function DrawWeaponCrosshair( Hud HUD )
{
	Telescope.DrawWeaponCrosshair(HUD);
}

simulated function PreloadTextures(bool bForcePreload)
{
	Super.PreloadTextures(bForcePreload);
    Telescope.PreloadTextures(bForcePreload);
}

/**
* If we are locked on, we need to set the Seeking projectiles LockedTarget.
*/

simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
	local SkeletalMeshComponent MeshComponent;
    local TGTurret TGT;

    TGT = TGTurret(Instigator);
    if(TGT == None)
        return none;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		MeshComponent = TGT.Mesh;
		if ( MeshComponent != none && !bDummyWeapon )
		{
			MeshComponent.GetSocketWorldLocationAndRotation( 'Muzzle', RealStartLoc,,0);
		}
		else
		{
			RealStartLoc = GetPhysicalFireStartLoc();
		}

		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
		if(DummyWeaponDamage > 0.0)
		{
		    SpawnedProjectile.Damage = DummyWeaponDamage;
        }

		if( SpawnedProjectile != none && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
		}

		KickBack(2.0f, 1.85f, 0.8f, 0.5f, 8.0f, 5.0f, 3);

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

//simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
//{
//    local TGTurret TGT;
//	local AnimNodeSequence WeapNode;
//	local AnimTree Tree;
//    TGT = TGTurret(Instigator);
//
//	if (TGT.Mesh != None && TGT.Mesh.bAttached)
//	{
//	// do not play on a dedicated server
//	if( WorldInfo.NetMode == NM_DedicatedServer )
//	{
//		return;
//	}
//
//	if ( SkelMesh == None )
//	{
//		SkelMesh = TGT.Mesh;
//	}
//
//	if( SkelMesh == none)
//	{
//	  return;
//	}
//	// Check we have access to mesh and animations
////	if( SkelMesh == none || GetWeaponAnimNodeSeq() == none )
////	{
////		return;
////	}
//
//	if(fDesiredDuration > 0.0)
//	{
//		// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
//		SkelMesh.PlayAnim(Sequence, 0.0, bLoop);
//	}
//	else
//	{
//		//Try getting an animtree first
//		Tree = AnimTree(SkelMesh.Animations);
//		if (Tree != None)
//		{
//			WeapNode = AnimNodeSequence(Tree.Children[0].Anim);
//		}
//		else
//		{
//			WeapNode = AnimNodeSequence(SkelMesh.Animations);
//		}
//
//		WeapNode.SetAnim(Sequence);
//		WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
//	}
//	}
//}

/**
* We override GetProjectileClass to swap in a Seeking Rocket if we are locked on.
*/

function class<Projectile> GetProjectileClass()
{
	return WeaponProjectiles[CurrentFireMode];
}


