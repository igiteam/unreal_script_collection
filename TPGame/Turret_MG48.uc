class Turret_MG48 extends Turret
	config(Game);

// Animation stuff
var AnimNodeBlendList IdleOrFire;
var class<TPProjectile>	PlayerControlledProjectileClass, AIControlledProjectileClass;


simulated function CacheAnimNodes()
{
    Super.CacheAnimNodes();

    IdleOrFire = AnimNodeBlendList(Mesh.Animations.FindAnimNode('IdleOrFire'));
    IdleOrFire.SetActiveChild(0, 0.1);
}

// Clear references to anim nodes.
simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();
	IdleOrFire = None;
}

simulated function StartFire(byte FireModeNum)
{
    Super.StartFire(FireModeNum);
    if (!bNeedsToCool)
        IdleOrFire.SetActiveChild(1, 0.1);
}

simulated function StopFire(byte FireModeNum)
{
    Super.StopFire(FireModeNum);
    IdleOrFire.SetActiveChild(0, 0.1);
}

function bool StopFiring()
{
	if  (IdleOrFire == None)
	{
	    IdleOrFire = AnimNodeBlendList(Mesh.Animations.FindAnimNode('IdleOrFire'));
	}
	IdleOrFire.SetActiveChild(0, 0.1);
	return Super.StopFiring();
}

function bool DriverEnter(Pawn P)
{
	if(P.Controller.IsA('TPPlayerController'))
		ProjectileClass=PlayerControlledProjectileClass;
	else 
	    ProjectileClass=AIControlledProjectileClass;
    
    return Super.DriverEnter(P);    
}

