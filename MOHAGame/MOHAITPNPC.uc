class MOHAITPNPC extends MOHAHumanSkelMeshActor
    abstract
    native
    hidecategories(Navigation);

var() bool bIsBehindPlayer;
var() bool bPersistsAfterAnimDone;
var bool bStartingPreview;
var bool bStartingGameAnimation;
var bool bPaused;
var() name planeAttachBone;
var float currentAnimPos;
var float totalAnimLength;
var name ITPanimName;
var AnimNodeSequence AnimNode;

function ContinueAnim()
{
    // End:0x0E
    if(bPaused == false)
    {
        return;
    }
    bPaused = false;
    PlayControlledAnim(ITPanimName, 1.0000000, currentAnimPos);
    //return;    
}

function PauseAnim()
{
    local float normPosition;

    // End:0x0E
    if(bPaused == true)
    {
        return;
    }
    // End:0xB2
    if((((AnimNode != none) && AnimNode.AnimSeq != none) && AnimNode.AnimSeq.SequenceName == ITPanimName) && totalAnimLength > 0.0000000)
    {
        normPosition = AnimNode.GetNormalizedPosition();
        currentAnimPos = normPosition * totalAnimLength;
        bPaused = true;
        PlayControlledAnim(ITPanimName, 0.0000000, currentAnimPos);        
    }
    //return;    
}

function PlayControlledAnim(name AnimName, float fSpeed, float fPosition)
{
    // End:0x0F
    if(AnimName != ITPanimName)
    {
    }
    // End:0xD3
    if(AnimNode == none)
    {
        AnimNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        // End:0x93
        if((AnimNode == none) && SkeletalMeshComponent.Animations.IsA('AnimTree'))
        {
            AnimNode = AnimNodeSequence(AnimTree(SkeletalMeshComponent.Animations).Children[0].Anim);
        }
        // End:0xD3
        if(AnimNode == none)
        {
            AnimNode = AnimNodeSequence(SkeletalMeshComponent.Animations.FindAnimNode(AnimName));
            // End:0xD3
            if(AnimNode == none)
            {
                return;
            }
        }
    }
    // End:0x198
    if(AnimNode != none)
    {
        // End:0x14E
        if((AnimNode.AnimSeq != none) && AnimNode.AnimSeq.SequenceName == AnimName)
        {
            AnimNode.bPlaying = true;
            AnimNode.bLooping = false;
            AnimNode.Rate = fSpeed;            
        }
        else
        {
            AnimNode.SetAnim(AnimName);
            // End:0x198
            if(AnimNode.AnimSeq != none)
            {
                AnimNode.PlayAnim(false, fSpeed, fPosition);
            }
        }
    }
    //return;    
}

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    local MOHAPlayerPlaneBase heroPlane;
    local Vector NewLoc;
    local Rotator NewRot;

    super(SkeletalMeshActor).BeginAnimControl(InAnimSets);
    currentAnimPos = 0.0000000;
    bStartingGameAnimation = true;
    // End:0x6C
    if((SkeletalMeshComponent.Animations != none) && AnimNodeSequence(SkeletalMeshComponent.Animations) != none)
    {
        AnimNodeSequence(SkeletalMeshComponent.Animations).bCauseActorAnimEnd = true;
    }
    // End:0x102
    if((Base != none) && MOHAPlayerPlaneBase(Base) != none)
    {
        heroPlane = MOHAPlayerPlaneBase(Base);
        // End:0xFF
        if(heroPlane.SkeletalMeshComponent.GetSocketWorldLocationAndRotation(planeAttachBone, NewLoc, NewRot) != false)
        {
            SetHardAttach(true);
            SetRelativeLocation(vect(0.0000000, 0.0000000, 0.0000000));
            SetRotation(NewRot);
            heroPlane.AddNPCToPlane(self);            
        }        
    }
    //return;    
}

simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x12
    if(!bPersistsAfterAnimDone)
    {
        SetHidden(true);
    }
    //return;    
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies)
{
    // End:0x3F
    if(bStartingGameAnimation && InPosition < 0.0001000)
    {
        super(SkeletalMeshActor).SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies);
        return;        
    }
    else
    {
        // End:0x91
        if(bStartingGameAnimation == true)
        {
            bStartingGameAnimation = false;
            ITPanimName = InAnimSeqName;
            PlayControlledAnim(InAnimSeqName, 1.0000000, 0.0000000);
            totalAnimLength = SkeletalMeshComponent.GetAnimLength(ITPanimName);
        }
    }
    //return;    
}

defaultproperties
{
    bStartingPreview=true
    bStartingGameAnimation=true
    planeAttachBone="Reference"
    totalAnimLength=-1.0000000
    // Reference: MOHASkeletalMeshComponent'Default__MOHAITPNPC.PawnHeadMeshComponent'
    begin object name=PawnHeadMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHAITPNPC.SkeletalMeshComponent0'
        bUpdateSkelWhenNotRendered=true
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAITPNPC.MyLightEnvironment'
        CullingType=3
        CastShadow=false
        bCastDynamicShadow=false
    end object
    headMeshComponent=PawnHeadMeshComponent
    // Reference: SkeletalMeshComponent'Default__MOHAITPNPC.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__MOHAITPNPC.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        bUpdateSkelWhenNotRendered=true
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAITPNPC.MyLightEnvironment'
        CullingType=3
        CastShadow=false
        bCastDynamicShadow=false
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAITPNPC.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MOHAITPNPC.MyFaceAudioComponent'
    begin object name=MyFaceAudioComponent
    end object
    FacialAudioComp=MyFaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    // Reference: AudioComponent'Default__MOHAITPNPC.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    Components[2]=FaceAudioComponent
    Components[3]=FaceAudioComponent
    Components[4]=PawnHeadMeshComponent
    Components[5]=SkeletalMeshComponent0
    CollisionComponent=SkeletalMeshComponent0
}