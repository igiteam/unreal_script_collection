class SPKAsset extends KAsset
    native
    nativereplication;

var repnotify float DrawScaleX;
var repnotify float DrawScaleY;
var repnotify float DrawScaleZ;
var export editinline SPKynapseComponent KynapseComponent;
/** Set from the owner during initialization. apparently required to initialize a spawned physics asset, no method to initialize from script that I can find.. (pawn has one) */
var(Kynapse) bool bUseExpensivePathBlocking;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority)
        DrawScaleX, DrawScaleY, 
        DrawScaleZ;
}

// Export USPKAsset::execInitPhysics(FFrame&, void* const)
native function bool InitPhysics();

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    DrawScaleX = DrawScale3D.X;
    DrawScaleY = DrawScale3D.Y;
    DrawScaleZ = DrawScale3D.Z;
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local Vector newDrawScale3D;

    // End:0x30
    if(VarName == 'bWakeOnLevelStart')
    {
        // End:0x2D
        if(bWakeOnLevelStart)
        {
            SkeletalMeshComponent.WakeRigidBody();
        }        
    }
    else
    {
        // End:0xBD
        if(((VarName == 'DrawScaleX') || VarName == 'DrawScaleY') || VarName == 'DrawScaleZ')
        {
            newDrawScale3D.X = DrawScaleX;
            newDrawScale3D.Y = DrawScaleY;
            newDrawScale3D.Z = DrawScaleZ;
            SetDrawScale3D(newDrawScale3D);            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}
