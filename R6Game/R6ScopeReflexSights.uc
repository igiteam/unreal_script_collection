class R6ScopeReflexSights extends R6Scope
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    m_SupportedZoomTypes=/* ERROR: System.ArgumentOutOfRangeException */
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSights.ScopeMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_Reflex'
        bAcceptsDecalsDuringGameplay=false
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_ScopeMeshFP=ScopeMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6ScopeReflexSights.ScopeMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_Reflex'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_ScopeMeshTP=ScopeMeshComponentTP
    m_szDescription="REFLEX SIGHTS"
}