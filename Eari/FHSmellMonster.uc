// A Smell Monster knows nothing about the player until
// the player gets close, at which point the hunt begins.
// If the player gets far enough away, the smell monster
// may forget about him.

class FHSmellMonster extends FHMonster
    placeable;

function SpawnDefaultController()
    {
	local FHMonsterController monsterController;
	Super.SpawnDefaultController();
	monsterController = Spawn(class'FHSmellMonsterController', self);
	monsterController.SetPawn(self);
    }


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__FHSmellMonster.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__FHMonster.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__FHSmellMonster.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__FHMonster.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__FHSmellMonster.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__FHMonster.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__FHSmellMonster.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__FHMonster.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__FHSmellMonster.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__FHMonster.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__FHSmellMonster.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__FHMonster.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__FHSmellMonster.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__FHMonster.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__FHSmellMonster.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__FHMonster.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__FHSmellMonster.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__FHMonster.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__FHSmellMonster.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__FHMonster.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    // Reference: CylinderComponent'Default__FHSmellMonster.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__FHMonster.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__FHSmellMonster.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Arrow'
    // Archetype: ArrowComponent'Default__FHMonster.Arrow'
    begin object name="Arrow"
        ReplacementPrimitive=none
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    // Reference: SkeletalMeshComponent'Default__FHSmellMonster.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__FHMonster.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHSmellMonster.MyLightEnvironment'
    end object
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=SkeletalMeshComponent0
    CollisionComponent=CollisionCylinder
}