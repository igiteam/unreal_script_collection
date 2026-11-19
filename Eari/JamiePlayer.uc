class JamiePlayer extends UTPawn;

var SkeletalMeshComponent clarkesMesh;

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	return super.CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);

	GetActorEyesViewPoint( out_CamLoc, out_CamRot );
	//Mesh.GetSocketWorldLocationAndRotation('Camera', out_CamLoc, bitBucket, 0);
	//Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', out_CamLoc, bitBucket, 0);

	//out_CamLoc.X += 20;
	//out_CamLoc.Y += 100;
	//out_CamLoc.X -= 20;
	//out_CamLoc.X -= 100;
	//Mesh.GetSocketWorldLocationAndRotation('RightShoulderSocket', rightShoulderLocation, bitBucket, 0);
	return true;
}

simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
}



// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__JamiePlayer.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__JamiePlayer.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__JamiePlayer.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__JamiePlayer.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__JamiePlayer.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__JamiePlayer.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__JamiePlayer.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__JamiePlayer.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__JamiePlayer.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__JamiePlayer.clarkesMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'clarkesMesh'
    begin object name="clarkesMesh" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'ClarkePackage.Clarke56'
        AnimTreeTemplate=AnimTree'ClarkePackage.ClarkeAnimTree'
        AnimSets[0]=AnimSet'ClarkePackage.Anims'
        MinDistFactorForKinematicUpdate=0.2000000
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=true
        bHasPhysicsAssetInstance=true
        bPerBoneMotionBlur=true
        bOverrideAttachmentOwnerVisibility=true
        bChartDistanceFactor=true
        bCacheAnimSequenceNodes=false
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__JamiePlayer.MyLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_Untitled3
        RBDominanceGroup=20
        bUseOnePassLightingOnTranslucency=true
        BlockRigidBody=true
        RBCollideWithChannels=(Untitled3=true)
        Translation=(X=0.0000000,Y=0.0000000,Z=8.0000000)
        Scale=1.0750000
    end object
    Mesh=clarkesMesh
    // Reference: CylinderComponent'Default__JamiePlayer.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UTGame.Default__UTPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__JamiePlayer.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Arrow'
    // Archetype: ArrowComponent'UTGame.Default__UTPawn.Arrow'
    begin object name="Arrow"
        ReplacementPrimitive=none
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    // Reference: SkeletalMeshComponent'Default__JamiePlayer.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__JamiePlayer.MyLightEnvironment'
    end object
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=clarkesMesh
    CollisionComponent=CollisionCylinder
}