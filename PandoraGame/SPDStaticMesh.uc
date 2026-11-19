class SPDStaticMesh extends StaticMeshActor
    native;

var repnotify SPDestructibleProperties DCRepProperties;
var(DestructComponent) const editconst export editinline SPActorDestructComponent DestructComponent;
var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
var export editinline DrawSphereComponent RenderComponent;
var export editinline DrawSphereComponent PreviewSphere;
var(Collision) PathBlockingInfo m_pathBlockInfo;
var export editinline SPKynapseComponent KynapseComponent;
/** Used to replicate mesh to clients */
var(Kynapse) bool bUseExpensivePathBlocking;
var repnotify StaticMesh ReplicatedMesh;
var repnotify MaterialInterface ReplicatedMaterial;
var repnotify Vector ReplicatedMeshTranslation;
var repnotify Rotator ReplicatedMeshRotation;
var repnotify Vector ReplicatedMeshScale3D;
var repnotify float ReplicatedDrawScaleX;
var repnotify float ReplicatedDrawScaleY;
var repnotify float ReplicatedDrawScaleZ;

replication
{
    // Pos:0x000
    if(bNetInitial || bNetDirty
        DCRepProperties;

    // Pos:0x011
    if(bNetDirty
        ReplicatedDrawScaleX, ReplicatedDrawScaleY, 
        ReplicatedDrawScaleZ, ReplicatedMaterial, 
        ReplicatedMesh, ReplicatedMeshRotation, 
        ReplicatedMeshScale3D, ReplicatedMeshTranslation;
}

simulated event ReplicatedEvent(name VarName)
{
    local Vector newDrawScale3D;

    // End:0x8C
    if(VarName == 'DCRepProperties')
    {
        DestructComponent.SetProperties(DCRepProperties);
        DestructComponent.MinCollisionVelocity = DCRepProperties.MinCollisionVelocity;
        DestructComponent.MaxCollisionVelocity = DCRepProperties.MaxCollisionVelocity;
        DestructComponent.HitPoints = DCRepProperties.HitPoints;        
    }
    else
    {
        // End:0x108
        if(VarName == 'ReplicatedMesh')
        {
            StaticMeshComponent.SetStaticMesh(ReplicatedMesh);
            newDrawScale3D.X = ReplicatedDrawScaleX;
            newDrawScale3D.Y = ReplicatedDrawScaleY;
            newDrawScale3D.Z = ReplicatedDrawScaleZ;
            SetDrawScale3D(newDrawScale3D);            
        }
        else
        {
            // End:0x138
            if(VarName == 'ReplicatedMaterial')
            {
                StaticMeshComponent.SetMaterial(0, ReplicatedMaterial);                
            }
            else
            {
                // End:0x167
                if(VarName == 'ReplicatedMeshTranslation')
                {
                    StaticMeshComponent.SetTranslation(ReplicatedMeshTranslation);                    
                }
                else
                {
                    // End:0x196
                    if(VarName == 'ReplicatedMeshRotation')
                    {
                        StaticMeshComponent.SetRotation(ReplicatedMeshRotation);                        
                    }
                    else
                    {
                        // End:0x1C5
                        if(VarName == 'ReplicatedMeshScale3D')
                        {
                            StaticMeshComponent.SetScale3D(ReplicatedMeshScale3D);                            
                        }
                        else
                        {
                            // End:0x252
                            if(((VarName == 'ReplicatedDrawScaleX') || VarName == 'ReplicatedDrawScaleY') || VarName == 'ReplicatedDrawScaleZ')
                            {
                                newDrawScale3D.X = ReplicatedDrawScaleX;
                                newDrawScale3D.Y = ReplicatedDrawScaleY;
                                newDrawScale3D.Z = ReplicatedDrawScaleZ;
                                SetDrawScale3D(newDrawScale3D);                                
                            }
                            else
                            {
                                super(Actor).ReplicatedEvent(VarName);
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function OnSetStaticMesh(SeqAct_SetStaticMesh Action)
{
    // End:0x7C
    if((Action.NewStaticMesh != none) && Action.NewStaticMesh != StaticMeshComponent.StaticMesh)
    {
        StaticMeshComponent.SetStaticMesh(Action.NewStaticMesh);
        ReplicatedMesh = Action.NewStaticMesh;
        ForceNetRelevant();
    }
    // End:0x98
    if(bHidden == true)
    {
        SetHiddenFlag(bHidden);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local SPDestructibleProperties spProperties;

    super(Actor).PostBeginPlay();
    // End:0x1C6
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x130
        if(DestructComponent != none)
        {
            spProperties = DestructComponent.GetProperties();
            // End:0x130
            if(spProperties != none)
            {
                // End:0x125
                if((int(Role) == int(ROLE_Authority)) && spProperties != none)
                {
                    // DebugMode: 0
                    assert(DestructComponent.MinCollisionVelocity == spProperties.MinCollisionVelocity);
                    // DebugMode: 0
                    assert(DestructComponent.MaxCollisionVelocity == spProperties.MaxCollisionVelocity);
                    // DebugMode: 0
                    assert(DestructComponent.HitPoints == spProperties.HitPoints);
                    // DebugMode: 0
                    assert(DestructComponent.OnlyDestroyedByKismet == DestructComponent.default.OnlyDestroyedByKismet);
                    // DebugMode: 0
                    assert(DestructComponent.AutoTrigger == DestructComponent.default.AutoTrigger);
                }
                DCRepProperties = spProperties;
            }
        }
        ReplicatedMesh = StaticMeshComponent.StaticMesh;
        ReplicatedDrawScaleX = DrawScale3D.X;
        ReplicatedDrawScaleY = DrawScale3D.Y;
        ReplicatedDrawScaleZ = DrawScale3D.Z;
        ReplicatedMeshScale3D = StaticMeshComponent.Scale3D;
        ReplicatedMeshTranslation = StaticMeshComponent.Translation;
        ReplicatedMeshRotation = StaticMeshComponent.Rotation;
    }
    // End:0x1E2
    if(bHidden == true)
    {
        SetHiddenFlag(bHidden);
    }
    //return;    
}

simulated function Destroyed()
{
    DestructComponent.ClientOnlyCauseDestruction();
    m_pathBlockInfo.movingState = 3;
    UpdateOverlappingNavigation(0.0000000, m_pathBlockInfo);
    super(Actor).Destroyed();
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    TakeFallingDamage();
    //return;    
}

function TakeFallingDamage()
{
    local int Damage;

    Damage = DestructComponent.SpeedToDamage(Velocity.Z);
    // End:0x60
    if(Damage > 0)
    {
        TakeDamageAndProcEffects(float(Damage), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
    }
    //return;    
}

event OnSetMaterial(SeqAct_SetMaterial Action)
{
    StaticMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    // End:0x66
    if(Action.MaterialIndex == 0)
    {
        ReplicatedMaterial = Action.NewMaterial;
        ForceNetRelevant();
    }
    //return;    
}
