//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_LauncherFGM148 extends HDWeap_MissileLauncher;

simulated function Projectile ProjectileFire()
{
	local HDProj_FGM148Missile	SpawnedProjectile;
	local Projectile            BaseProj;
	BaseProj = Super.ProjectileFire();
	SpawnedProjectile = HDProj_FGM148Missile(BaseProj);
	if ( SpawnedProjectile != None )
	{
	   SpawnedProjectile.TrackStep = 0;
       SpawnedProjectile.SetLocation(SpawnedProjectile.Location+vect(0,0,100));
	}
	return BaseProj;
}

