class MOHAVehicleDriverPawn extends Pawn
    config(Game)
    hidecategories(Navigation);

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    inDamage = 0;
    //return;    
}

defaultproperties
{
    ControllerClass=Class'MOHAVehicleController'
    // Reference: CylinderComponent'Default__MOHAVehicleDriverPawn.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=0.0000000
        CollisionRadius=0.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAVehicleDriverPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__MOHAVehicleDriverPawn.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    bCollideActors=false
    bCollideWorld=false
    bBlockActors=false
    bNoEncroachCheck=true
    CollisionComponent=CollisionCylinder
    CollisionType=0
}