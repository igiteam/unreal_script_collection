class MOHAParatrooperPawn extends MOHAParatrooperPawnNative
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    bInitialSpawnIsParachuting=true
    bSetInitialRotation=true
    landingAnimationName="ad_land1"
    descendAnimationName="ad_idle"
    MaxDescendSpeed=900.0000000
    MaxLateralSpeed=800.0000000
    KynapseControllerClass=Class'MOHAAIController'
    bSpawnDefaultController=false
    // Reference: OirInstance'Default__MOHAParatrooperPawn.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    // Reference: FixedFireOIRImpl'Default__MOHAParatrooperPawn.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAParatrooperPawn.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAParatrooperPawn.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAParatrooperPawn.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__MOHAParatrooperPawn.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAParatrooperPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    // Reference: MOHAAirdropComponent'Default__MOHAParatrooperPawn.MyAirdropComponent'
    begin object name=MyAirdropComponent class=Class'MOHAAirdropComponent'
    end object
    AirdropComponent=MyAirdropComponent
    SocketName="Reference"
    RefBoneName="Spine"
    fAnimRate=1.0000000
    // Reference: AxonScriptEventObserverComponent'Default__MOHAParatrooperPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAParatrooperPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    ControllerClass=Class'MOHAITPController'
    // Reference: MOHARagdollSkelComponent'Default__MOHAParatrooperPawn.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        Animations=AnimNodeSequence'Default__MOHAParatrooperPawn.MeshSequenceB'
        bForceDiscardRootMotion=false
        LightEnvironment=none
        bCastDynamicShadow=false
        BlockRigidBody=false
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAParatrooperPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__MOHAParatrooperPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAParatrooperPawn.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAParatrooperPawn.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    Components[8]=MyAirdropComponent
    CollisionComponent=MOHACollisionCylinder
}