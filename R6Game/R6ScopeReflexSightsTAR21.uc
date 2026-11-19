class R6ScopeReflexSightsTAR21 extends R6ScopeReflexSights
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSightsTAR21.ScopeMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6ScopeReflexSights.ScopeMeshComponentFP'
    begin object name="ScopeMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ReflexMars'
    end object
    m_ScopeMeshFP=ScopeMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSightsTAR21.ScopeMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6ScopeReflexSights.ScopeMeshComponentTP'
    begin object name="ScopeMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ReflexMars'
    end object
    m_ScopeMeshTP=ScopeMeshComponentTP
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSightsTAR21.ScopeMountMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ScopeMountTAR21'
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_ScopeMountMeshFP=ScopeMountMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSightsTAR21.ScopeMountMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ScopeMountTAR21'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_ScopeMountMeshTP=ScopeMountMeshComponentTP
}