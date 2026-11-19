class MOHACinematicTank extends SkeletalMeshActor
    abstract
    native
    hidecategories(Navigation);

var() export editinline SkeletalMeshComponent leftTreadMeshComponent;
var() export editinline SkeletalMeshComponent rightTreadMeshComponent;
var() export editinline SkeletalMeshComponent turretMeshComponent;

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__MOHACinematicTank.LeftTreadMeshComponent0'
    begin object name=LeftTreadMeshComponent0 class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHACinematicTank.SkeletalMeshComponent0'
    end object
    leftTreadMeshComponent=LeftTreadMeshComponent0
    // Reference: SkeletalMeshComponent'Default__MOHACinematicTank.RightTreadMeshComponent0'
    begin object name=RightTreadMeshComponent0 class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHACinematicTank.SkeletalMeshComponent0'
    end object
    rightTreadMeshComponent=RightTreadMeshComponent0
    // Reference: SkeletalMeshComponent'Default__MOHACinematicTank.TurretMeshComponent0'
    begin object name=TurretMeshComponent0 class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHACinematicTank.SkeletalMeshComponent0'
    end object
    turretMeshComponent=TurretMeshComponent0
    // Reference: SkeletalMeshComponent'Default__MOHACinematicTank.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__MOHACinematicTank.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHACinematicTank.MyLightEnvironment'
        Rotation=(Pitch=0,Yaw=-16384,Roll=16384)
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHACinematicTank.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MOHACinematicTank.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    Components[3]=LeftTreadMeshComponent0
    Components[4]=RightTreadMeshComponent0
    Components[5]=TurretMeshComponent0
    CollisionComponent=SkeletalMeshComponent0
}