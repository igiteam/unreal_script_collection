class R6ScopeReflexSightsP90 extends R6ScopeReflexSights
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSightsP90.ScopeMountMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ScopeMountP90'
        bAcceptsDecalsDuringGameplay=false
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_ScopeMountMeshFP=ScopeMountMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSightsP90.ScopeMountMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ScopeMountP90'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_ScopeMountMeshTP=ScopeMountMeshComponentTP
}