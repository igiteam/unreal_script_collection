class R6RainbowPawnGabrielScripted extends R6RainbowPawnGabriel
    native
    config(Character)
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.SyringeMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.SyringeMeshComponentTP'
    begin object name="SyringeMeshComponentTP"
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_SyringeComponentTP=SyringeMeshComponentTP
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.HeadMesh'
    begin object name="HeadMesh"
        AnimTreeTemplate=AnimTree'AnimTreePlayer.LightPlayerTree'
    end object
    m_HeadMesh=HeadMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.TorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.TorsoMesh'
    begin object name="TorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_TorsoMesh=TorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.LegsMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.LegsMesh'
    begin object name="LegsMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_LegsMesh=LegsMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HairMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.HairMesh'
    begin object name="HairMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_HairMesh=HairMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.ArmorTorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.ArmorTorsoMesh'
    begin object name="ArmorTorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_ArmorTorsoMesh=ArmorTorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.ArmorShoulderMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.ArmorShoulderMesh1'
    begin object name="ArmorShoulderMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_ArmorShoulderMesh1=ArmorShoulderMesh1
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.ArmorShoulderMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.ArmorShoulderMesh2'
    begin object name="ArmorShoulderMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_ArmorShoulderMesh2=ArmorShoulderMesh2
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.ArmorLegsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.ArmorLegsMesh1'
    begin object name="ArmorLegsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_ArmorLegsMesh1=ArmorLegsMesh1
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.ArmorLegsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.ArmorLegsMesh2'
    begin object name="ArmorLegsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_ArmorLegsMesh2=ArmorLegsMesh2
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.ArmorArmsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.ArmorArmsMesh1'
    begin object name="ArmorArmsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_ArmorArmsMesh1=ArmorArmsMesh1
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.ArmorArmsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.ArmorArmsMesh2'
    begin object name="ArmorArmsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_ArmorArmsMesh2=ArmorArmsMesh2
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.GasMaskMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawnGabriel.GasMaskMesh'
    begin object name="GasMaskMesh"
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_pGasMaskMesh=GasMaskMesh
    // Reference: StaticMeshComponent'Default__R6RainbowPawnGabrielScripted.SnakeCamMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6RainbowPawnGabriel.SnakeCamMeshTP'
    begin object name="SnakeCamMeshTP"
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnGabrielScripted.HeadMesh'
    end object
    m_pSnakeCamMeshTP=SnakeCamMeshTP
    m_ThirdPersonAnimSets[0]=AnimSet'Anims_General_Chopper.Idle.Jung'
    m_ThirdPersonAnimSets[1]=AnimSet'Anims_General_Chopper.Idle.Gabriel'
    m_helicopterSittingAnims[0]="HeliIdle"
    Mesh=HeadMesh
    // Reference: CylinderComponent'Default__R6RainbowPawnGabrielScripted.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6RainbowPawnGabriel.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6RainbowPawnGabrielScripted.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6RainbowPawnGabriel.Arrow'
    begin object name="Arrow"
    end object
    Components[1]=Arrow
    Components[2]=HeadMesh
    Components[3]=TorsoMesh
    Components[4]=LegsMesh
    Components[5]=HairMesh
    Components[6]=ArmorTorsoMesh
    Components[7]=ArmorShoulderMesh1
    Components[8]=ArmorShoulderMesh2
    Components[9]=ArmorLegsMesh1
    Components[10]=ArmorLegsMesh2
    Components[11]=ArmorArmsMesh1
    Components[12]=ArmorArmsMesh2
}