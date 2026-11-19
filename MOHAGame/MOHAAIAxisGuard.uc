class MOHAAIAxisGuard extends MOHAAIPawn
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    bIgnoreAffordance=true
    // Reference: OirInstance'Default__MOHAAIAxisGuard.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    // Reference: FixedFireOIRImpl'Default__MOHAAIAxisGuard.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAAIAxisGuard.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAAIAxisGuard.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAAIAxisGuard.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__MOHAAIAxisGuard.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAAIAxisGuard.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    // Reference: AxonScriptEventObserverComponent'Default__MOHAAIAxisGuard.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAIAxisGuard.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: MOHARagdollSkelComponent'Default__MOHAAIAxisGuard.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAAIAxisGuard.MyLightEnvironment'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAAIAxisGuard.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__MOHAAIAxisGuard.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAAIAxisGuard.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAAIAxisGuard.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    CollisionComponent=MOHACollisionCylinder
}