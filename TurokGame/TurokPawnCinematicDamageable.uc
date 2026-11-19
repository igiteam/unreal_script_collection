class TurokPawnCinematicDamageable extends TurokPawnCinematic
    native
    config(Pawn)
    hidecategories(Navigation);

// Export UTurokPawnCinematicDamageable::execOnCinemaActorDead(FFrame&, void* const)
protected native function OnCinemaActorDead();

event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x15
    if(float(Health) <= 0.0000000)
    {
        return;
    }
    Health -= Damage;
    // End:0x43
    if(float(Health) <= 0.0000000)
    {
        Health = 0;
        OnCinemaActorDead();
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokAISteer'Default__TurokPawnCinematicDamageable.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnCinematicDamageable.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnCinematicDamageable.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnCinematicDamageable.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnCinematicDamageable.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnCinematicDamageable.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokAnimLadderController'Default__TurokPawnCinematicDamageable.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnCinematicDamageable.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnCinematicDamageable.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnCinematicDamageable.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnCinematicDamageable.Arrow'
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