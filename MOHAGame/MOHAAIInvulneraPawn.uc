class MOHAAIInvulneraPawn extends MOHAAIPawn
    config(Game)
    hidecategories(Navigation);

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    // End:0x1A
    if(InstigatedBy.IsA('PlayerController'))
    {
        return;
    }
    inDamage = 0;
    Momentum = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

defaultproperties
{
    KynapseControllerClass=Class'MOHAAIInvulneraController'
    // Reference: OirInstance'Default__MOHAAIInvulneraPawn.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    // Reference: FixedFireOIRImpl'Default__MOHAAIInvulneraPawn.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAAIInvulneraPawn.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAAIInvulneraPawn.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAAIInvulneraPawn.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__MOHAAIInvulneraPawn.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAAIInvulneraPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    // Reference: AxonScriptEventObserverComponent'Default__MOHAAIInvulneraPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAIInvulneraPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: MOHARagdollSkelComponent'Default__MOHAAIInvulneraPawn.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAAIInvulneraPawn.MyLightEnvironment'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAAIInvulneraPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__MOHAAIInvulneraPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAAIInvulneraPawn.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAAIInvulneraPawn.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    CollisionComponent=MOHACollisionCylinder
}