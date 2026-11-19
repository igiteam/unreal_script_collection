class MorphTestActor extends SkeletalMeshActor
    hidecategories(Navigation);

var() Actor LookAtActor;
var() float MinMorphDistance;
var() float MaxMorphDistance;

event Tick(float DeltaSeconds)
{
    local SkelControlLookAt LookControl;
    local MorphNodeWeight WeightNode;
    local float LookAtDist, ResultWeight;

    // End:0x184
    if(LookAtActor != none)
    {
        LookControl = SkelControlLookAt(SkeletalMeshComponent.FindSkelControl('LookAtControl'));
        // End:0x96
        if(LookControl != none)
        {
            LookControl.TargetLocation = LookAtActor.Location;
        }
        WeightNode = MorphNodeWeight(SkeletalMeshComponent.FindMorphNode('WeightNode'));
        // End:0x184
        if(WeightNode != none)
        {
            LookAtDist = VSize(Location - LookAtActor.Location);
            ResultWeight = FClamp((LookAtDist - MinMorphDistance) / (MaxMorphDistance - MinMorphDistance), 0.0000000, 1.0000000);
            WeightNode.SetNodeWeight(1.0000000 - ResultWeight);
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__MorphTestActor.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        Animations=none
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MorphTestActor.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MorphTestActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MorphTestActor.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    CollisionComponent=SkeletalMeshComponent0
}