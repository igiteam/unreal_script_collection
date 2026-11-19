class CCTestPawn extends MOHAAlliedAIPawn
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: OirInstance'Default__CCTestPawn.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    // Reference: FixedFireOIRImpl'Default__CCTestPawn.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__CCTestPawn.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__CCTestPawn.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__CCTestPawn.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__CCTestPawn.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__CCTestPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    // Reference: AxonScriptEventObserverComponent'Default__CCTestPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__CCTestPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: MOHARagdollSkelComponent'Default__CCTestPawn.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__CCTestPawn.MyLightEnvironment'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__CCTestPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__CCTestPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__CCTestPawn.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__CCTestPawn.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    CollisionComponent=MOHACollisionCylinder
}