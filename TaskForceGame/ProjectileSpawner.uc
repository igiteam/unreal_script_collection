//
// ProjectileSpawner.uc
//
// Projectile spawner object that creates a type of projectile.
//

class ProjectileSpawner extends Actor
	placeable;


//var class<Projectile> ProjectileClass;
var(Projectile) class<ProjectileAmmo> ProjectileAmmoType;
var(Projectile) float Speed;
var(Projectile) float LifeTime;

function PreBeginPlay ( )
{
	if ( ProjectileAmmoType != None )
	{
		//log ( "ProjectileSpawner - DLOing"@ProjectileAmmoType.default.ProjectileClass );
		DynamicLoadObject ( string ( ProjectileAmmoType.default.ProjectileClass ), class'Class' );

		if( ProjectileAmmoType.default.ProjectileClass.default.StaticMesh != None )
			Level.AddPrecacheStaticMesh( ProjectileAmmoType.default.ProjectileClass.default.StaticMesh );
	}
}

function Trigger( actor Other, pawn EventInstigator )
{
	local Projectile P;

	if( ProjectileAmmoType != None )
	{
		P = Spawn(ProjectileAmmoType.default.ProjectileClass,,, Location,Rotation);

		if( P != None )
		{
			//P.MyDamageType=ProjectileAmmoType.default.MyDamageType;
			P.Speed = P.Default.Speed * Speed; 
			P.LifeSpan = LifeTime;
			if( SFRMProjectile(P) != None && SFRMProjectile(P).ProjectileFireSound != None )
				P.PlaySound(SFRMProjectile(P).ProjectileFireSound, SLOT_Misc);
		}
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    Speed=1.0000000
    Lifetime=5.0000000
    bDirectional=true
}