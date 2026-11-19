class R6ScopeRifleMAC11 extends R6ScopeRifle
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6ScopeRifleMAC11.ScopeMountMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ScopeMountMAC11'
        bAcceptsDecalsDuringGameplay=false
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_ScopeMountMeshFP=ScopeMountMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6ScopeRifleMAC11.ScopeMountMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_ScopeMountMAC11'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_ScopeMountMeshTP=ScopeMountMeshComponentTP
}