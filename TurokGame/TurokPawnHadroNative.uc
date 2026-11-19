class TurokPawnHadroNative extends TurokPawnDino
    abstract
    native
    config(Game)
    hidecategories(Navigation);

// Export UTurokPawnHadroNative::execTryPlayFootStepSound(FFrame&, void* const)
native simulated function TryPlayFootStepSound(name JointName);

event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x1D
    if(TurokAIControllerGiganoto(InstigatedBy) != none)
    {
        Damage = Health;
    }
    super(TurokPawn).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

defaultproperties
{
    // Reference: TurokRadialShakeComponent'Default__TurokPawnHadroNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    // Reference: TurokAISteer'Default__TurokPawnHadroNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnHadroNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnHadroNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnHadroNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnHadroNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnHadroNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokAnimLadderController'Default__TurokPawnHadroNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnHadroNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnHadroNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnHadroNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnHadroNative.Arrow'
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