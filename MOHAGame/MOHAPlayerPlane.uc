class MOHAPlayerPlane extends MOHAPlayerPlaneBase
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__MOHAPlayerPlane.InteriorStaticMesh'
    begin object name=InteriorStaticMesh
        StaticMesh=StaticMesh'Gcm_Vh_US_C47.US_C47_interior_Axmesh'
        bCastDynamicShadow=false
        CollideActors=false
        BlockRigidBody=false
        NoPhysx=true
    end object
    planeInterior=InteriorStaticMesh
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlane.ExteriorSkeletalMesh'
    begin object name=ExteriorSkeletalMesh
        SkeletalMesh=SkeletalMesh'Gcm_Vh_US_C47.SkeletalMesh.US_C47_exterior_rigged'
        CastShadow=false
        bCastDynamicShadow=false
        bAcceptsLights=false
        bAcceptsDynamicLights=false
    end object
    planeExterior=ExteriorSkeletalMesh
    // Reference: StaticMeshComponent'Default__MOHAPlayerPlane.windowMesh'
    begin object name=windowMesh
        StaticMesh=StaticMesh'Gcm_Vh_US_C47.US_C47_windows_Axmesh'
        bCastDynamicShadow=false
        CollideActors=false
        BlockRigidBody=false
        NoPhysx=true
    end object
    planeWindows=windowMesh
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlane.destructionMeshComponent'
    begin object name=destructionMeshComponent
        SkeletalMesh=SkeletalMesh'Gcm_Vh_US_C47.SkeletalMesh.c47_breakApart'
        // Reference: AnimNodeSequence'Default__MOHAPlayerPlane.destructionMeshComponent.AnimNodeSeq1'
        begin object name=AnimNodeSeq1
        end object
        Animations=AnimNodeSeq1
        CastShadow=false
        bCastDynamicShadow=false
    end object
    destructionMesh=destructionMeshComponent
    normalFlakPSys=ParticleSystem'HUS_vfx_planeExp.grenadeplaneExp'
    heroFlakPSys=ParticleSystem'HUS_vfx_planeExp.grenadeplaneExp'
    normalFlakSoundCue=SoundCue'Aud_GCm_FakeWAV.explosions.Flak6'
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlane.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'Gcm_Vh_US_C47.SkeletalMesh.US_C47_interior_rigged'
        // Reference: AnimNodeSequence'Default__MOHAPlayerPlane.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAPlayerPlane.MyLightEnvironment'
        CastShadow=false
        bCastDynamicShadow=false
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAPlayerPlane.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MOHAPlayerPlane.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    Components[3]=InteriorStaticMesh
    Components[4]=windowMesh
    Components[5]=destructionMeshComponent
    Components[6]=ExteriorSkeletalMesh
    CollisionComponent=SkeletalMeshComponent0
}