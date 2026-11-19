class SPDAction_SpawnRigidBody extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) StaticMesh Mesh;
var(SPDAction) float PhysicsWeight;
var(SPDAction) bool PhysicsEnable;
var(SPDAction) bool bNoEncroachCheck;
var(SPDAction) bool bUseExpensivePathBlocking;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDRigidBody newActor;

    newActor = SPDRigidBody(CreateActor(Manager, Actor, DamageInfo));
    // End:0xFB
    if(newActor != none)
    {
        newActor.StaticMeshComponent.SetStaticMesh(Mesh);
        FindBestSpotForSpawnLocation(newActor);
        // End:0x94
        if(PhysicsEnable)
        {
            newActor.SetPhysics(10);
            newActor.StaticMeshComponent.WakeRigidBody();
        }
        // End:0xD6
        if(bUseExpensivePathBlocking)
        {
            // End:0xD6
            if(newActor.KynapseComponent != none)
            {
                newActor.KynapseComponent.ChangeExpensivePathBlocking(bUseExpensivePathBlocking);
            }
        }
        newActor.DisablePathBlocking(newActor.m_pathBlockInfo, bDisablePathBlocking);
    }
    return 1;
    //return ReturnValue;    
}

function Actor CreateActor(SPDProcessManager Manager, Actor Actor, SPDDamage DamageInfo)
{
    local Actor newActor;

    newActor = super(SPDAction_Spawn).CreateActor(Manager, Actor, DamageInfo);
    // End:0x3D
    if(newActor != none)
    {
        newActor.bNoEncroachCheck = bNoEncroachCheck;
    }
    return newActor;
    //return ReturnValue;    
}

defaultproperties
{
    PhysicsWeight=1.0000000
    PhysicsEnable=true
    NewActorClass=Class'SPDRigidBody'
    Action="Spawn Rigid body Static Mesh"
}