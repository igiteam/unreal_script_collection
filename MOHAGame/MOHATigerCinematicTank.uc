class MOHATigerCinematicTank extends MOHACinematicTank
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__MOHATigerCinematicTank.LeftTreadMeshComponent0'
    begin object name=LeftTreadMeshComponent0
        SkeletalMesh=SkeletalMesh'GCm_Vcl_DE_Tiger.SkeletalMesh.DE_Tiger_Rigged_L_Treads'
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHATigerCinematicTank.SkeletalMeshComponent0'
        ForcedLodModel=1
    end object
    leftTreadMeshComponent=LeftTreadMeshComponent0
    // Reference: SkeletalMeshComponent'Default__MOHATigerCinematicTank.RightTreadMeshComponent0'
    begin object name=RightTreadMeshComponent0
        SkeletalMesh=SkeletalMesh'GCm_Vcl_DE_Tiger.SkeletalMesh.DE_Tiger_Rigged_R_Treads'
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHATigerCinematicTank.SkeletalMeshComponent0'
        ForcedLodModel=1
    end object
    rightTreadMeshComponent=RightTreadMeshComponent0
    // Reference: SkeletalMeshComponent'Default__MOHATigerCinematicTank.TurretMeshComponent0'
    begin object name=TurretMeshComponent0
        SkeletalMesh=SkeletalMesh'GCm_Vcl_DE_Tiger.SkeletalMesh.DE_Tiger_Rigged_Turret'
        ParentAnimComponent=SkeletalMeshComponent'Default__MOHATigerCinematicTank.SkeletalMeshComponent0'
        ForcedLodModel=1
    end object
    turretMeshComponent=TurretMeshComponent0
    // Reference: SkeletalMeshComponent'Default__MOHATigerCinematicTank.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'GCm_Vcl_DE_Tiger.SkeletalMesh.DE_Tiger_Rigged_Body'
        // Reference: AnimNodeSequence'Default__MOHATigerCinematicTank.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        ForcedLodModel=1
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHATigerCinematicTank.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHATigerCinematicTank.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MOHATigerCinematicTank.FaceAudioComponent'
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