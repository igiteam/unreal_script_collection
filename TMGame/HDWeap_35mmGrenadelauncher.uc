/**
*
*/
class	HDWeap_35mmGrenadelauncher	extends HDWeap_TurretBase;

// do not reload
simulated function Reload()
{
	return;
}

/**
* If we are locked on, we need to set the Seeking projectiles LockedTarget.
*/

simulated function DrawWeaponCrosshair( Hud HUD )
{
//	local Actor TargetActor;
	local float CenterSize;
//	local HDPlatform_DerrickWheels HDW;
//    local InterpActor              InA;

	CenterSize = TMHUD(HUD).ConfiguredCrosshairScaling * 128.0*HUD.Canvas.ClipX/1280 * 1.5;
	Hud.Canvas.SetPos(0.5*(HUD.Canvas.ClipX - CenterSize), 0.5*(HUD.Canvas.ClipY - CenterSize));
    Hud.Canvas.DrawTile(Texture2D'UI.Tex.crosshair_3', CenterSize, CenterSize, 128, 0, 128, 128);

	//GetDesiredAimPoint(TargetActor);
    //HDW = HDPlatform_DerrickWheels(TargetActor);
//    InA = InterpActor(TargetActor);
//    if(HDW != none)
//    {
//        if(HDW.GetMesh().SkeletalMesh == SkeletalMesh'Tank_m1a2.Mesh.Veh_tank_m1a2')
//        {
//          	Hud.Canvas.DrawTile(Texture2D'Tank99.Texture.TankCrossHairs', CenterSize, CenterSize, 128, 0, 128, 128);
//        }
//        else
//        {
//            Hud.Canvas.DrawTile(Texture2D'Tank99.Texture.TankCrossHairs', CenterSize, CenterSize, 0, 128, 128, 128);
//        }
//    }
//    else if(InA != none)
//    {
//       if(InA.StaticMeshComponent.StaticMesh == StaticMesh'bea_build.Mesh.bea_fort_large_a'
//           || InA.StaticMeshComponent.StaticMesh == StaticMesh'bea_build.Mesh.bea_fort_small01_a')
//           {
//             Hud.Canvas.DrawTile(Texture2D'Tank99.Texture.TankCrossHairs', CenterSize, CenterSize, 128, 0, 128, 128);
//           }
//       else
//       {
//           Hud.Canvas.DrawTile(Texture2D'Tank99.Texture.TankCrossHairs', CenterSize, CenterSize, 0, 0, 128, 128);
//       }
//    }
//    else
//    {
//        Hud.Canvas.DrawTile(Texture2D'Tank99.Texture.TankCrossHairs', CenterSize, CenterSize, 0, 0, 128, 128);
//    }
}

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

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    local TGTurret TGT;
	local AnimNodeSequence WeapNode;
	local AnimTree Tree;
    TGT = TGTurret(Instigator);

	if (TGT.Mesh != None && TGT.Mesh.bAttached)
	{
	// do not play on a dedicated server
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if ( SkelMesh == None )
	{
		SkelMesh = TGT.Mesh;
	}

	if( SkelMesh == none)
	{
	  return;
	}
	// Check we have access to mesh and animations
//	if( SkelMesh == none || GetWeaponAnimNodeSeq() == none )
//	{
//		return;
//	}

	if(fDesiredDuration > 0.0)
	{
		// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
		SkelMesh.PlayAnim(Sequence, 0.0, bLoop);
	}
	else
	{
		//Try getting an animtree first
		Tree = AnimTree(SkelMesh.Animations);
		if (Tree != None)
		{
			WeapNode = AnimNodeSequence(Tree.Children[0].Anim);
		}
		else
		{
			WeapNode = AnimNodeSequence(SkelMesh.Animations);
		}

		WeapNode.SetAnim(Sequence);
		WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
	}
	}
}

/**
* We override GetProjectileClass to swap in a Seeking Rocket if we are locked on.
*/

function class<Projectile> GetProjectileClass()
{
	return WeaponProjectiles[CurrentFireMode];
}


