class R6ExplosiveBreaching extends R6Explosive
    native
    config(ExplosivesConfig)
    notplaceable
    hidecategories(lighting);

var R6InteractiveDoor m_pDoor;
var config float m_fImpulseOnDoor;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_pDoor;
}

event Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
{
    AdjustToWall(HitNormal, FloorActor, vLocation);
    return;
}

simulated function Destroyed()
{
    // End:0x5E
    if(m_pDoor != none)
    {
        // End:0x36
        if(m_pDoor.m_aCharge[0] == self)
        {
            m_pDoor.m_aCharge[0] = none;            
        }
        else
        {
            // End:0x5E
            if(m_pDoor.m_aCharge[1] == self)
            {
                m_pDoor.m_aCharge[1] = none;
            }
        }
    }
    Destroyed();
    return;
}

simulated function ExplodeR6Explosive()
{
    // End:0x221
    if(m_pDoor != none)
    {
        // End:0x6B
        if((m_pDoor.m_aCharge[0] != none) && m_pDoor.m_aCharge[0] != self)
        {
            m_pDoor.m_aCharge[0].ResetDetonator();
            m_pDoor.m_aCharge[0].Destroy();
        }
        // End:0xCB
        if((m_pDoor.m_aCharge[1] != none) && m_pDoor.m_aCharge[1] != self)
        {
            m_pDoor.m_aCharge[0].ResetDetonator();
            m_pDoor.m_aCharge[1].Destroy();
        }
        // End:0x193
        if(m_pDoor.m_pDoubleDoor != none)
        {
            // End:0x139
            if(m_pDoor.m_pDoubleDoor.m_aCharge[0] != none)
            {
                m_pDoor.m_aCharge[0].ResetDetonator();
                m_pDoor.m_pDoubleDoor.m_aCharge[0].Destroy();
            }
            // End:0x193
            if(m_pDoor.m_pDoubleDoor.m_aCharge[1] != none)
            {
                m_pDoor.m_aCharge[0].ResetDetonator();
                m_pDoor.m_pDoubleDoor.m_aCharge[1].Destroy();
            }
        }
        m_pDoor.m_vLastImpulseEffect = m_vNormal * m_fImpulseOnDoor;
        m_pDoor.TakeDamage(m_pDoor.m_iHealth, m_pDoor.m_iHealth, Instigator.Controller, Instigator.Controller.Location, m_pDoor.GetCenter(), m_fImpulseOnDoor * m_vNormal, m_damageType);
    }
    ExplodeR6Explosive();
    return;
}

defaultproperties
{
    m_fImpulseOnDoor=1500.0000000
    // Reference: StaticMeshComponent'Default__R6ExplosiveBreaching.ExplosiveMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6Explosive.ExplosiveMesh'
    begin object name="ExplosiveMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.W_Gad_BreachingCharge'
    end object
    m_Mesh=ExplosiveMesh
    m_explosionParams=R6ExplosionParams'KellerExplosions.ExplosiveBreachingCharge'
    m_SoundExplosionParams=R6SoundExplosionParams'RS5Sound.E_BreachingChargeExplosion'
    m_damageType=Class'R6DamageTypeBreachingCharge'
    // Reference: SpriteComponent'Default__R6ExplosiveBreaching.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6Explosive.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=ExplosiveMesh
    // Reference: CylinderComponent'Default__R6ExplosiveBreaching.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=10.0000000
        CollisionRadius=5.0000000
        CollideActors=true
        BlockActors=true
    end object
    Components[2]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}