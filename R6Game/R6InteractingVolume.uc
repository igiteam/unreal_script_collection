class R6InteractingVolume extends Actor
    native
    notplaceable
    hidecategories(lighting);

var export editinline CylinderComponent CylinderComponent;
var Actor m_pInteract;
var float m_fHeight;
var float m_fRadius;
var bool m_bEnabled;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bEnabled;
}

// Export UR6InteractingVolume::execEnableCollide(FFrame&, void* const)
native final function EnableCollide(bool bEnable);

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    return m_pInteract.GetInteractDesc(eDesc, PC);
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    return m_pInteract.GetBusyInteractDesc(eDesc, PC);
    return;
}

defaultproperties
{
    // Reference: CylinderComponent'Default__R6InteractingVolume.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    m_bEnabled=true
    bNoDelete=true
    bAlwaysRelevant=true
    bCollideActors=true
    bNoSelect=true
    Components[0]=CollisionCylinder
    RemoteRole=1
    TickGroup=1
    NetUpdateFrequency=0.1000000
    CollisionComponent=CollisionCylinder
}