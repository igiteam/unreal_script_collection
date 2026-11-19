class R6ScopeSniperCMounted extends R6ScopeSniperC
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6ScopeSniperCMounted.ScopeMountMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_Scope_Mount_MP5N'
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_ScopeMountMeshFP=ScopeMountMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6ScopeSniperCMounted.ScopeMountMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ScopeMountMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_Scope_Mount_MP5N'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_ScopeMountMeshTP=ScopeMountMeshComponentTP
}