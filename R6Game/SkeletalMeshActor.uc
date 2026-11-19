class SkeletalMeshActor extends Actor
    native
    placeable
    hidecategories(lighting);

var(Display) export editinline SkeletalMeshComponent SkeletalMeshComponent;
var Vector m_vOriginalLoc;
var Rotator m_rOriginalRot;
var bool m_bWasAttached;
var name m_AttachedPawnSocket;
var repnotify SkeletalMesh ReplicatedMesh;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        ReplicatedMesh;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && bNetDirty)
        m_AttachedPawnSocket;
}

function PostBeginPlay()
{
    // End:0x1F
    if(SkeletalMeshComponent != none)
    {
        ReplicatedMesh = SkeletalMeshComponent.SkeletalMesh;
    }
    PostBeginPlay();
    return;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x23
    if(VarName == 'ReplicatedMesh')
    {
        SkeletalMeshComponent.SetSkeletalMesh(ReplicatedMesh);
    }
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    // End:0x5C
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x59
        if(!SeqNode.IsPlaying())
        {
            SeqNode.StartAnim();
        }        
    }
    else
    {
        // End:0x9B
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0x98
            if(SeqNode.IsPlaying())
            {
                SeqNode.StopAnim();
            }            
        }
        else
        {
            // End:0xED
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0xDB
                if(SeqNode.IsPlaying())
                {
                    SeqNode.StopAnim();                    
                }
                else
                {
                    SeqNode.StartAnim();
                }
            }
        }
    }
    return;
}

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    SkeletalMeshComponent.AnimSets = InAnimSets;
    SeqNode.SetAnim('None');
    return;
}

event SetAnimPosition(out R6ScriptedAnimInfo AnimInfo, bool bFireNotifies)
{
    local AnimNodeSequence SeqNode;
    local editinline SkeletalMeshComponent pOld;

    // End:0x26
    if((SkeletalMeshComponent.Animations == none) || AnimInfo.m_bIsFacial)
    {
        return;
    }
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    // End:0x112
    if(SeqNode.m_AnimLeaf.m_AnimSeqName != AnimInfo.m_AnimName)
    {
        pOld = GetGAnimTreeSkelComponent();
        SetGAnimTreeSkelComponent(SkeletalMeshComponent);
        SeqNode.SetAnim(AnimInfo.m_AnimName);
        SetGAnimTreeSkelComponent(pOld);
        SeqNode.SetNoFailCollision(AnimInfo.m_bNoFailCollision);
        SeqNode.SetRootMotion(0, AnimInfo.m_eRootMotion[0]);
        SeqNode.SetRootMotion(1, AnimInfo.m_eRootMotion[1]);
        SeqNode.SetRootMotion(2, AnimInfo.m_eRootMotion[2]);
    }
    SeqNode.SetPosition(AnimInfo.m_fAnimPos, bFireNotifies);
    return;
}

event OnSetSkeletalMesh(SeqAct_SetSkeletalMesh Action)
{
    // End:0x54
    if((Action.NewSkeletalMesh != none) && Action.NewSkeletalMesh != SkeletalMeshComponent.SkeletalMesh)
    {
        SkeletalMeshComponent.SetSkeletalMesh(Action.NewSkeletalMesh);
    }
    return;
}

event OnSetMaterial(SeqAct_SetMaterial Action)
{
    SkeletalMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    return;
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    Attachment.SetBase(self,, SkeletalMeshComponent, Action.BoneName);
    return;
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__SkeletalMeshActor.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SkeletalMeshComponent0" class=Class'SkeletalMeshComponent'
        AnimTreeTemplate=AnimNodeSequence'Default__SkeletalMeshActor.AnimNodeSeq0'
        BlockRigidBody=false
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    bNoDelete=true
    UseCharacterLights=true
    bCollideActors=true
    bProjTarget=true
    m_bTickOnlyWhenVisible=true
    bEdShouldSnap=true
    Components[0]=SkeletalMeshComponent0
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    CollisionComponent=SkeletalMeshComponent0
}