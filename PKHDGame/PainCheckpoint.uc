class PainCheckpoint extends PainItemBaseSkelMesh
    placeable
    hidecategories(Navigation)
    classgroup(PK_Gameplay);

var(Checkpoint) SoundCue CheckpointSound;
var(Checkpoint) bool InitiallyEnabled;
var array<PainPRI> TouchedPRIs;

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    bAlwaysRelevant = InitiallyEnabled;
    //return;    
}

simulated function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    return false;
    //return ReturnValue;    
}

function OnForceCheckpointTouch(SeqAct_ForceCheckpointTouch Action)
{
    local PKPlayerController PKPC;
    local PKPlayerPawn P;

    PKPC = PKPlayerController(Action.Instigator);
    // End:0x74
    if(PKPC != none)
    {
        P = PKPlayerPawn(PKPC.Pawn);        
    }
    else
    {
        P = PKPlayerPawn(Action.Instigator);
    }
    // End:0xF1
    if(P != none)
    {
        PlayerTouch(P, PainPRI(P.PlayerReplicationInfo));        
    }
    //return;    
}

simulated function PlayerTouch(PKPlayerPawn P, PainPRI PRI)
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0x54 [Loop If]
    if(Idx < TouchedPRIs.Length)
    {
        // End:0x46
        if(TouchedPRIs[Idx] == PRI)
        {
            return;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x0B;
    }
    TouchedPRIs.InsertItem(0, PRI);
    // End:0xAF
    if(CheckpointSound != none)
    {
        P.PlaySound(CheckpointSound, false, false, false, Location);
    }
    // End:0x12D
    if(P.Health < P.HealthMax)
    {
        PRI.Difficulty.static.RestoreHealthInCheckpoint(P);
    }
    // End:0x172
    if(TouchedPRIs.Length < WorldInfo.GRI.PRIArray.Length)
    {
        return;
    }
    DisableCheckpoint();
    //return;    
}

simulated function EnableCheckpoint()
{
    SetHidden(false);
    ShowLight(true);
    bAlwaysRelevant = true;
    TouchedPRIs.Length = 0;
    //return;    
}

simulated function DisableCheckpoint()
{
    ShowLight(false);
    SetHidden(true);
    bAlwaysRelevant = false;
    TouchedPRIs.Length = 0;
    //return;    
}

simulated function Destroyed()
{
    TouchedPRIs.Length = 0;
    super(PainItemBase).Destroyed();
    //return;    
}

simulated function bool IsCheckpointEnabled()
{
    return !bHidden;
    //return ReturnValue;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super.OnToggleHidden(Action);
    // End:0x59
    if(Action.InputLinks[0].bHasImpulse)
    {
        bAlwaysRelevant = false;        
    }
    else
    {
        // End:0x9F
        if(Action.InputLinks[1].bHasImpulse)
        {
            bAlwaysRelevant = true;            
        }
        else
        {
            bAlwaysRelevant = !bHidden;
        }
    }
    //return;    
}

defaultproperties
{
    CheckpointSound=SoundCue'a_Checkpoint.Cue.Checkpoint'
    // Reference: SkeletalMeshComponent'Default__PainCheckpoint.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItemBaseSkelMesh.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'ps_all_Levels.Mesh.e_checkpoint'
        // Reference: AnimNodeSequence'Default__PainCheckpoint.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItemBaseSkelMesh.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'ps_all_Levels.Anim.as_checkpoint'
        ReplacementPrimitive=none
        CastShadow=false
        bCastDynamicShadow=false
        bAcceptsLights=false
        bAcceptsDynamicLights=false
        Scale=2.2500000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="e_checkpoint"
    BindParticles[0]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_checkpointcircle',ParticleScale=1.7000000,BoneName="kolo")
    BindParticles[1]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_checkpointpentagram',ParticleScale=1.7000000,BoneName="jeden")
    BindParticles[2]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_checkpointpentagram',ParticleScale=1.7000000,BoneName="drugi")
    BindParticles[3]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_checkpointAura',ParticleScale=2.0000000,BoneName="Root")
    // Reference: CylinderComponent'Default__PainCheckpoint.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBaseSkelMesh.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
        Translation=(X=0.0000000,Y=0.0000000,Z=45.0000000)
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainCheckpoint.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBaseSkelMesh.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    bWaitForEffects=true
    BindedLightArchetype=EvilLightActor'ps_all_Levels.Archetypes.ar_checkpointLight'
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    bHidden=true
    CollisionComponent=CollisionCylinder
}