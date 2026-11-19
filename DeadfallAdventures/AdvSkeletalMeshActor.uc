class AdvSkeletalMeshActor extends SkeletalMeshActor
    hidecategories(Navigation)
    implements(EvilWeaponFireTargetInterface);

var() bool bIsWeaponFireTarget;
var() bool bIsFriendlyWeaponFireTarget;

simulated function bool IsWeaponFireTarget()
{
    return bIsWeaponFireTarget;
    //return ReturnValue;    
}

simulated function SetWeaponFireTarget(bool bInWeaponFireTarget)
{
    bIsWeaponFireTarget = bInWeaponFireTarget;
    //return;    
}

simulated function bool IsFriendlyWeaponFireTarget()
{
    return bIsFriendlyWeaponFireTarget;
    //return ReturnValue;    
}

defaultproperties
{
    bIsWeaponFireTarget=true
    bIsFriendlyWeaponFireTarget=true
    // Reference: SkeletalMeshComponent'Default__AdvSkeletalMeshActor.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__AdvSkeletalMeshActor.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvSkeletalMeshActor.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvSkeletalMeshActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__AdvSkeletalMeshActor.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    CollisionComponent=SkeletalMeshComponent0
}