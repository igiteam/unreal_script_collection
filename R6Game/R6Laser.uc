class R6Laser extends R6UnderbarrelOption
    native
    notplaceable
    hidecategories(lighting);

var export editinline StaticMeshComponent m_LaserMeshFP;
var export editinline StaticMeshComponent m_LaserMeshTP;
var export editinline R6LaserSightComponent m_LaserRayMeshFP;
var export editinline R6LaserSightComponent m_LaserRayMeshTP;
var name m_LaserSocketName;
var name m_LaserSightSocketName;
var bool m_bForceLaserRot;
var bool m_bLaserRayAttachedFirstPerson;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6Laser.LaserMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="LaserMeshComponentFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_Laser'
        bAcceptsDecalsDuringGameplay=false
        CollideActors=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_LaserMeshFP=LaserMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6Laser.LaserMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="LaserMeshComponentTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Attachments.W_Laser'
        m_bWeaponComponent=true
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
        m_bDontSupportNearPlane=true
    end object
    m_LaserMeshTP=LaserMeshComponentTP
    // Reference: R6LaserSightComponent'Default__R6Laser.LaserSightComponentFP'
    begin object name="LaserSightComponentFP" class=Class'Engine.R6LaserSightComponent'
        m_DotMaterial=Material'RS5Weapons.LaserDotMaterial'
        StaticMesh=StaticMesh'RS5Weapons.Misc.LaserRayCylinder'
        CastShadow=false
        CollideActors=false
        m_eComponentVisibility=1
        m_bIsVisibleInScope=true
    end object
    m_LaserRayMeshFP=LaserSightComponentFP
    // Reference: R6LaserSightComponent'Default__R6Laser.LaserSightComponentTP'
    begin object name="LaserSightComponentTP" class=Class'Engine.R6LaserSightComponent'
        m_DotMaterial=Material'RS5Weapons.LaserDotMaterial'
        StaticMesh=StaticMesh'RS5Weapons.Misc.LaserRayCylinder'
        CastShadow=false
        CollideActors=false
        m_eComponentVisibility=2
        m_bIsVisibleInScope=true
        m_bDontSupportNearPlane=true
    end object
    m_LaserRayMeshTP=LaserSightComponentTP
    m_LaserSocketName="R65_AM_Laser"
    m_LaserSightSocketName="R65_FXM_Laser"
    m_szDescription="LASER"
}