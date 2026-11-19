class SPDAction_Spawn extends SPDAction
    abstract
    native
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(SPDAction) bool AttachToSpawner;
var(SPDAction) bool InheritLinearVelocity;
var(SPDAction) bool bCheckForSpawnCollision;
var(SPDAction) float LinearVelocityScale;
var(SPDAction) Vector PositionOffset;
var(SPDAction) name SocketName;
var(SPDAction) export editinline array<export editinline SPDGenericActionList> OnSpawnActionsLists;
var class<Actor> NewActorClass;
var class<Actor> NewActorClassMP;

// Export USPDAction_Spawn::execSocketNameToBoneName(FFrame&, void* const)
native function name SocketNameToBoneName(SkeletalMeshComponent Mesh, name SName);

// Export USPDAction_Spawn::execFindSpawnSpot(FFrame&, void* const)
native function FindSpawnSpot(Actor daActor);

simulated function FindBestSpotForSpawnLocation(Actor daActor)
{
    // End:0x1B
    if(bCheckForSpawnCollision == true)
    {
        FindSpawnSpot(daActor);
    }
    //return;    
}

function AddOnSpawnActions(Actor newActor, SPDProcessManager Manager)
{
    local int Idx;
    local editinline SPActorDestructComponent spComponent;
    local SPDestructibleProperties spProperties;

    // End:0x66
    if(Manager.HasActions(OnSpawnActionsLists))
    {
        Idx = 0;
        J0x23:

        // End:0x63 [Loop If]
        if(Idx < OnSpawnActionsLists.Length)
        {
            Manager.AddActionList(OnSpawnActionsLists[Idx], newActor);
            Idx++;
            // [Loop Continue]
            goto J0x23;
        }        
    }
    else
    {
        spComponent = SPActorDestructComponent(newActor.GetActorDestructComponent());
        // End:0x10C
        if(spComponent != none)
        {
            spProperties = spComponent.GetProperties();
            // End:0x10C
            if(spProperties != none)
            {
                Idx = 0;
                J0xB8:

                // End:0x10C [Loop If]
                if(Idx < spProperties.OnSpawnActionList.Length)
                {
                    Manager.AddActionList(spProperties.OnSpawnActionList[Idx], newActor);
                    Idx++;
                    // [Loop Continue]
                    goto J0xB8;
                }
            }
        }
    }
    //return;    
}

function AddVelocity(Actor oldActor, Actor newActor)
{
    local editinline MeshComponent MeshComp;

    // End:0x91
    if(InheritLinearVelocity)
    {
        newActor.Velocity = oldActor.Velocity * LinearVelocityScale;
        MeshComp = newActor.GetSkeletalMeshComponent();
        // End:0x66
        if(MeshComp == none)
        {
            MeshComp = newActor.GetStaticMeshComponent();
        }
        // End:0x91
        if(MeshComp != none)
        {
            MeshComp.SetRBLinearVelocity(newActor.Velocity);
        }
    }
    //return;    
}

function AttachIt(Actor inOldActor, Actor newActor, Vector SpawnLocation, Rotator SpawnRotation)
{
    local bool HavePosition;
    local Vector Location;
    local Rotator Rotation;
    local editinline SkeletalMeshComponent SkelMesh;
    local name BoneName;
    local Actor oldActor;

    HavePosition = false;
    // End:0x51
    if((SPLifeForceHolder(inOldActor) != none) && SPLifeForceHolder(inOldActor).ParentActor != none)
    {
        oldActor = SPLifeForceHolder(inOldActor).ParentActor;        
    }
    else
    {
        oldActor = inOldActor;
    }
    // End:0xFE
    if(SocketName != 'None')
    {
        SkelMesh = oldActor.GetSkeletalMeshComponent();
        // End:0xFE
        if(SkelMesh != none)
        {
            HavePosition = SkelMesh.GetSocketWorldLocationAndRotation(SocketName, Location, Rotation);
            // End:0xFE
            if(HavePosition)
            {
                BoneName = SocketNameToBoneName(SkelMesh, SocketName);
                newActor.SetBase(oldActor,, SkelMesh, BoneName);
            }
        }
    }
    // End:0x137
    if(!HavePosition)
    {
        newActor.SetHardAttach(true);
        newActor.SetBase(oldActor);
    }
    //return;    
}

function GetSpawnPosition(Actor inOldActor, SPDDamage DamageInfo, out Vector SpawnLocation, out Rotator SpawnRotation)
{
    local Quat QRot;
    local editinline SkeletalMeshComponent SkelMesh;
    local bool HavePosition;
    local Actor Actor;

    HavePosition = false;
    // End:0x51
    if((SPLifeForceHolder(inOldActor) != none) && SPLifeForceHolder(inOldActor).ParentActor != none)
    {
        Actor = SPLifeForceHolder(inOldActor).ParentActor;        
    }
    else
    {
        Actor = inOldActor;
    }
    // End:0xED
    if(SocketName != 'None')
    {
        SkelMesh = Actor.GetSkeletalMeshComponent();
        // End:0xED
        if(SkelMesh != none)
        {
            HavePosition = SkelMesh.GetSocketWorldLocationAndRotation(SocketName, SpawnLocation, SpawnRotation);
            // End:0xED
            if(HavePosition)
            {
                QRot = QuatFromRotator(SpawnRotation);
                SpawnLocation = QuatRotateVector(QRot, PositionOffset) + SpawnLocation;
            }
        }
    }
    // End:0x18A
    if(!HavePosition)
    {
        // End:0x130
        if(Actor != none)
        {
            SpawnLocation = Actor.Location;
            SpawnRotation = Actor.Rotation;            
        }
        else
        {
            SpawnLocation = DamageInfo.Location;
            SpawnRotation = DamageInfo.Rotation;
        }
        QRot = QuatFromRotator(SpawnRotation);
        SpawnLocation = QuatRotateVector(QRot, PositionOffset) + SpawnLocation;
    }
    //return;    
}

function Actor CreateActorInternal(SPDProcessManager Manager, Vector SpawnLocation, Rotator SpawnRotation, Actor baseActor)
{
    local Actor newActor;

    newActor = Manager.SPSpawn(NewActorClass, baseActor,, SpawnLocation, SpawnRotation);
    return newActor;
    //return ReturnValue;    
}

function Actor CreateActor(SPDProcessManager Manager, Actor Actor, SPDDamage DamageInfo)
{
    local Actor newActor;
    local Vector SpawnLocation;
    local Rotator SpawnRotation;

    // End:0x30
    if(int(Manager.GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        // End:0x30
        if(NewActorClassMP == none)
        {
        }
    }
    GetSpawnPosition(Actor, DamageInfo, SpawnLocation, SpawnRotation);
    newActor = CreateActorInternal(Manager, SpawnLocation, SpawnRotation, Actor);
    // End:0xCC
    if(newActor != none)
    {
        AddOnSpawnActions(newActor, Manager);
        // End:0xB8
        if(AttachToSpawner)
        {
            AttachIt(Actor, newActor, SpawnLocation, SpawnRotation);
        }
        AddVelocity(Actor, newActor);
    }
    return newActor;
    //return ReturnValue;    
}

defaultproperties
{
    bCheckForSpawnCollision=true
    LinearVelocityScale=1.0000000
    NewActorClass=Class'Engine.Actor'
    Action="THIS SHOULD NOT BE USED"
}