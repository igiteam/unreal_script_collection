class TurokPawnPlant extends TurokPawn
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokAISteer'Default__TurokPawnPlant.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnPlant.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnPlant.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnPlant.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnPlant.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnPlant.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mArrowTakeDamageSndCue=SoundCue'SndProxy.SndProxy_DeathScream'
    mFireTakeDamageSndCue=SoundCue'SndProxy.SndProxy_DeathScream'
    // Reference: TurokAnimLadderController'Default__TurokPawnPlant.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnPlant.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnPlant.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnPlant.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    mDefaultTraceTypeFlags=0
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnPlant.Arrow'
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
    CollisionComponent=CollisionCylinder
}