class SPDAction_SpawnPHAT extends SPDAction_SpawnActor
    native
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) SkeletalMesh SkelMesh;
var(SPDAction) PhysicsAsset PhysAsset;
var(SPDAction) float PhysicsWeight;
var(SPDAction) bool PhysicsEnable;
var(SPDAction) bool MatchBoneOrientationOfOriginal;
var(SPDAction) bool bNoEncroachCheck;

// Export USPDAction_SpawnPHAT::execInitPhysics(FFrame&, void* const)
native function bool InitPhysics(SkeletalMeshComponent SmComponent, float Weight);

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDPhysSkel newActor;

    newActor = SPDPhysSkel(CreateActor(Manager, Actor, DamageInfo));
    // End:0x14D
    if(newActor != none)
    {
        newActor.SkeletalMeshComponent.SetPhysicsWeight(PhysicsWeight);
        newActor.InitSkeletalMesh(newActor.SkeletalMeshComponent, SkelMesh, PhysAsset, vect(0.0000000, 0.0000000, 0.0000000), vect(1.0000000, 1.0000000, 1.0000000));
        FindBestSpotForSpawnLocation(newActor);
        // End:0xC3
        if(MatchBoneOrientationOfOriginal)
        {
            MatchActorBoneOrientations(Actor, newActor);
        }
        // End:0x128
        if(PhysicsEnable)
        {
            newActor.SetPhysics(10);
            InitPhysics(newActor.SkeletalMeshComponent, PhysicsWeight);
            newActor.SkeletalMeshComponent.WakeRigidBody();
            AddVelocity(Actor, newActor);
        }
        newActor.DisablePathBlocking(newActor.m_pathBlockInfo, bDisablePathBlocking);
    }
    return 1;
    //return ReturnValue;    
}

function Actor CreateActor(SPDProcessManager Manager, Actor Actor, SPDDamage DamageInfo)
{
    local Actor newActor;
    local editinline SkeletalMeshComponent Mesh;

    newActor = super(SPDAction_Spawn).CreateActor(Manager, Actor, DamageInfo);
    // End:0x70
    if(newActor != none)
    {
        newActor.bNoEncroachCheck = bNoEncroachCheck;
        Mesh = newActor.GetSkeletalMeshComponent();
        // End:0x70
        if(Mesh != none)
        {
            Mesh.SetTickGroup(2);
        }
    }
    return newActor;
    //return ReturnValue;    
}

defaultproperties
{
    PhysicsWeight=1.0000000
    PhysicsEnable=true
    NewActorClass=Class'SPDPhysSkel'
    NewActorClassMP=Class'SPDPhysSkelMP'
    Action="Spawn PHAT Asset - Skel with phys."
}