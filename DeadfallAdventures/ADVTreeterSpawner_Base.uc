class ADVTreeterSpawner_Base extends SkeletalMeshActor
    abstract
    hidecategories(Navigation)
    implements(SpawnPointInterface);

var() const editconst export editinline EvilRadiusComponent RadiusComponent;
var AnimNodeSequence SeqNode;
var name IdleClosedAnimName;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    //return;    
}

function OpenSpawner()
{
    SeqNode.SetAnim('Spawn');
    SeqNode.PlayAnim();
    //return;    
}

function OnAnimEnd(AnimNodeSequence InSeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x76
    if(InSeqNode.AnimSeqName == 'Spawn')
    {
        InSeqNode.SetAnim('IdleOpen');
        InSeqNode.PlayAnim(true);
    }
    //return;    
}

function EnableSpawn()
{
    //return;    
}

function DisableSpawn()
{
    //return;    
}

function bool IsSpawnEnabled()
{
    return true;
    //return ReturnValue;    
}

function ActivateSpawn()
{
    //return;    
}

function DeactivateSpawn(optional float Time = 0.0000000)
{
    //return;    
}

function bool IsSpawnActive()
{
    return true;
    //return ReturnValue;    
}

function bool DeactivateAfterEachSpawn()
{
    return false;
    //return ReturnValue;    
}

function bool CanSpawn()
{
    return true;
    //return ReturnValue;    
}

function bool CanOnlySpawnWhenInvisible()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: EvilRadiusComponent'Default__ADVTreeterSpawner_Base.RadiusComponent0'
    begin object name=RadiusComponent0 class=Class'EvilGame.EvilRadiusComponent'
        ReplacementPrimitive=none
    end object
    RadiusComponent=RadiusComponent0
    IdleClosedAnimName="IdleClosed"
    // Reference: SkeletalMeshComponent'Default__ADVTreeterSpawner_Base.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__ADVTreeterSpawner_Base.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__ADVTreeterSpawner_Base.MyLightEnvironment'
        BlockZeroExtent=false
        Translation=(X=0.0000000,Y=0.0000000,Z=-80.0000000)
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__ADVTreeterSpawner_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__ADVTreeterSpawner_Base.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    Components[3]=none
    Components[4]=RadiusComponent0
    bProjTarget=false
    CollisionComponent=SkeletalMeshComponent0
}