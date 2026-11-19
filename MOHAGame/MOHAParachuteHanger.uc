class MOHAParachuteHanger extends StaticMeshActor
    hidecategories(Navigation);

event OnParachuteCollision(MOHAParachuteActor parachuteActor)
{
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__MOHAParachuteHanger.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
    end object
    StaticMeshComponent=StaticMeshComponent0
    BlockRigidBody=false
    Components[0]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
    CollisionType=0
}