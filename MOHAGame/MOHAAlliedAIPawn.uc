class MOHAAlliedAIPawn extends MOHAAIPawn
    native
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    KynapseControllerClass=Class'MOHAAlliedAIController'
    NPCtoNPCDamageMult=0.1000000
    // Reference: OirInstance'Default__MOHAAlliedAIPawn.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    RandomHeadMeshes[0]=(Freq=0.1500000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Boyd.SkeletalMesh.US_Boyd_Head_Rigged')
    RandomHeadMeshes[1]=(Freq=0.1500000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Matt.SkeletalMesh.US_Matt_Head_Rigged')
    RandomHeadMeshes[2]=(Freq=0.1400000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Nathan.SkeletalMesh.US_Nathan_Head_Rigged')
    RandomHeadMeshes[3]=(Freq=0.1400000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Tom.SkeletalMesh.US_Tom_Head_Rigged')
    RandomHeadMeshes[4]=(Freq=0.1400000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Toby.SkeletalMesh.US_Toby_Head_Rigged')
    RandomHeadMeshes[5]=(Freq=0.1400000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Bobby.SkeletalMesh.US_Bobby_Head_Rigged')
    RandomHeadMeshes[6]=(Freq=0.1400000,Mesh=SkeletalMesh'GCm_Chr_Head_US_Jose.SkeletalMesh.US_Jose_Head_Rigged')
    DetachableBodyParts[0]=(Probability=0.3300000,BoneName="Helmet",SecondaryBoneName="Neck1",SpawnedBodyPartClass=Class'MOHADetachedHelmet',BoneControlName="HelmetControl",SpawnedMesh=StaticMesh'GCm_Chr_Helmets.StaticMesh.US_SoldierAirborne_Helmet',BoneControl=none,MinSpawnVelocity=(X=300.0000000,Y=-25.0000000,Z=200.0000000),MaxSpawnVelocity=(X=450.0000000,Y=25.0000000,Z=400.0000000),MinRotationRate=50.0000000,MaxRotationRate=75.0000000,rRotCorrection=(Pitch=0,Yaw=16384,Roll=-16384),bDetachOnExplosion=true,HitSound_PC=SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Helmet',HitSound_NPC=SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Helmet_NPC',bCachedDetached=false)
    // Reference: FixedFireOIRImpl'Default__MOHAAlliedAIPawn.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAAlliedAIPawn.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAAlliedAIPawn.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAAlliedAIPawn.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__MOHAAlliedAIPawn.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAAlliedAIPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    PawnSide=1
    // Reference: AxonScriptEventObserverComponent'Default__MOHAAlliedAIPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAlliedAIPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    Health=125
    // Reference: MOHARagdollSkelComponent'Default__MOHAAlliedAIPawn.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAAlliedAIPawn.MyLightEnvironment'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAAlliedAIPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__MOHAAlliedAIPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAAlliedAIPawn.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAAlliedAIPawn.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    ActorType=8
    CollisionComponent=MOHACollisionCylinder
}