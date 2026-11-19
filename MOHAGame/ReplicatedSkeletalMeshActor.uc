class ReplicatedSkeletalMeshActor extends SkeletalMeshActor
    native
    nativereplication
    hidecategories(Navigation);

var repnotify bool bPlaySkeletalMeshAnimation;
var repnotify SkeletalMesh ReplicatedSkeletalMeshActorRepMesh;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        ReplicatedSkeletalMeshActorRepMesh, bPlaySkeletalMeshAnimation;
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x25
    if(SkeletalMeshComponent != none)
    {
        ReplicatedSkeletalMeshActorRepMesh = SkeletalMeshComponent.SkeletalMesh;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x56
    if(VarName == 'bPlaySkeletalMeshAnimation')
    {
        SkeletalMeshComponent.SetSkeletalMesh(SkeletalMeshComponent.SkeletalMesh);
        // End:0x49
        if(!bPlaySkeletalMeshAnimation)
        {
            StopAnim();            
        }
        else
        {
            StartAnim();
        }        
    }
    else
    {
        // End:0x81
        if(VarName == 'ReplicatedSkeletalMeshActorRepMesh')
        {
            SkeletalMeshComponent.SetSkeletalMesh(ReplicatedSkeletalMeshActorRepMesh);            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated function StopAnim()
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    SeqNode.StopAnim();
    bPlaySkeletalMeshAnimation = false;
    SetHidden(true);
    //return;    
}

simulated function StartAnim()
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0000000);
    bPlaySkeletalMeshAnimation = true;
    SetHidden(false);
    //return;    
}

simulated function ToggleAnim()
{
    local AnimNodeSequence SeqNode;

    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    // End:0x49
    if(SeqNode.bPlaying)
    {
        SeqNode.StopAnim();
        bPlaySkeletalMeshAnimation = false;        
    }
    else
    {
        SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0000000);
        bPlaySkeletalMeshAnimation = true;
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        StartAnim();        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            StopAnim();            
        }
        else
        {
            // End:0x7F
            if(Action.InputLinks[2].bHasImpulse)
            {
                ToggleAnim();
            }
        }
    }
    //return;    
}

event OnSetSkeletalMesh(SeqAct_SetSkeletalMesh Action)
{
    // End:0x69
    if((Action.NewSkeletalMesh != none) && Action.NewSkeletalMesh != SkeletalMeshComponent.SkeletalMesh)
    {
        SkeletalMeshComponent.SetSkeletalMesh(Action.NewSkeletalMesh);
        ReplicatedSkeletalMeshActorRepMesh = Action.NewSkeletalMesh;
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__ReplicatedSkeletalMeshActor.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__ReplicatedSkeletalMeshActor.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__ReplicatedSkeletalMeshActor.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__ReplicatedSkeletalMeshActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__ReplicatedSkeletalMeshActor.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    RemoteRole=1
    bHidden=true
    bCollideActors=false
    NetUpdateFrequency=0.1000000
    CollisionComponent=SkeletalMeshComponent0
    CollisionType=0
}