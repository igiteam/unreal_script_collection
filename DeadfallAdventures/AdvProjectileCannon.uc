class AdvProjectileCannon extends Actor
    placeable
    hidecategories(Navigation)
    classgroup(Adventurer);

var() export editinline StaticMeshComponent Mesh;
var() class<Projectile> ProjectileClass;
var() export editinline ArrowComponent FireDirection;
var() float FiringInterval;

function OnFireCannon(SeqAct_FireCannon Action)
{
    // End:0x106
    if(!bStatic)
    {
        // End:0x77
        if(Action.InputLinks[0].bHasImpulse)
        {
            self.FireProjectile();
            SetTimer(FiringInterval, true, 'FireProjectile');            
        }
        else
        {
            // End:0xC4
            if(Action.InputLinks[1].bHasImpulse)
            {
                SetTimer(0.0000000, false, 'FireProjectile');                
            }
            else
            {
                // End:0x106
                if(Action.InputLinks[2].bHasImpulse)
                {
                    FireProjectile();
                }
            }
        }
    }
    //return;    
}

function FireProjectile()
{
    local Projectile SpawnedProjectile;
    local Rotator TotalRotation;

    TotalRotation = Rotation + FireDirection.Rotation;
    SpawnedProjectile = Spawn(ProjectileClass, self,, Location, TotalRotation,, true);
    // End:0xC6
    if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
    {
        SpawnedProjectile.Init(Vector(TotalRotation));
    }
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvProjectileCannon.MyMesh'
    begin object name=MyMesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'EngineMeshes.Cube'
        ReplacementPrimitive=none
        Scale=0.1500000
    end object
    Mesh=MyMesh
    ProjectileClass=Class'AdvProjectile_Spear'
    FiringInterval=1.0000000
    Components[0]=none
    Components[1]=MyMesh
    CollisionComponent=MyMesh
}