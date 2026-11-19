class TurokPawnAnkylosaurus extends TurokPawnDino
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokRadialShakeComponent'Default__TurokPawnAnkylosaurus.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    // Reference: TurokAISteer'Default__TurokPawnAnkylosaurus.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
        mMinSteerSpeedRate=0.5000000
        mSteeringPreset=/* Array type was not detected. */
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnAnkylosaurus.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
        mAIGoal=/* Array type was not detected. */
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnAnkylosaurus.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mTerrainFollowType=3
    // Reference: TurokPathController'Default__TurokPawnAnkylosaurus.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnAnkylosaurus.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnAnkylosaurus.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mTerrainSampleRadius=60.0000000
    mTerrainSinkHeight=4.0000000
    // Reference: TurokAnimLadderController'Default__TurokPawnAnkylosaurus.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    GroundSpeed=350.0000000
    BaseEyeHeight=100.0000000
    EyeHeight=100.0000000
    // Reference: SkeletalMeshComponent'Default__TurokPawnAnkylosaurus.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnAnkylosaurus.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnAnkylosaurus.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=80.0000000
        CollisionRadius=60.0000000
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnAnkylosaurus.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=TurokAISteerComponent
    Components[3]=TurokAIPlannerComponent
    Components[4]=TurokPathControllerComponent
    Components[5]=TurokTargetingSystemComponent
    Components[6]=MyLightEnvironment
    Components[7]=TurokSkeletalMeshComponent
    Components[8]=TurokSoundControllerComponent
    Components[9]=ladderController
    Physics=1
    CollisionComponent=CollisionCylinder
}