class R6GadgetMotionSensor extends R6GadgetExplosive
    native
    config(GadgetsConfig)
    hidecategories(lighting);

// Export UR6GadgetMotionSensor::execGetUseAnimTime(FFrame&, void* const)
native function float GetUseAnimTime();

// Export UR6GadgetMotionSensor::execGetThrowTime(FFrame&, void* const)
native final function float GetThrowTime();

// Export UR6GadgetMotionSensor::execCanUseGadget(FFrame&, void* const)
native simulated function bool CanUseGadget();

simulated function name GetGadgetAttachSocket(bool bFPMesh)
{
    // End:0x12
    if(bFPMesh)
    {
        return 'R65_TripWire_LHand';        
    }
    else
    {
        return 'R65_BCharge_LHand';
    }
    return;
}

function SetDettachTimer()
{
    SetTimer(GetThrowTime(), false, 'DettachGadget');
    return;
}

function ExplosiveExploded()
{
    return;
}

state Setting
{
    function EndUseGadget()
    {
        m_iAmmo--;
        // End:0x1A
        if(m_iAmmo <= 0)
        {
            m_bExhausted = true;
        }
        EndUseGadget();
        m_Explosive = none;
        GotoState('Ready');
        return;
    }
    stop;
}

defaultproperties
{
    m_ExplosiveClass=Class'R6MotionSensor'
    m_pDetonator=none
    m_pDetonatorTP=none
    m_iMaxAmmoNormal=3
    m_iMaxAmmoVeteran=3
    m_iMaxAmmoElite=3
    m_iMaxAmmoMP=3
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_MotionSensor"
    // Reference: StaticMeshComponent'Default__R6GadgetMotionSensor.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetExplosive.GadgetMeshTP'
    begin object name="GadgetMeshTP"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Motion_Sensor'
    end object
    m_MeshTP=GadgetMeshTP
    ItemName="MOTION SENSOR"
    // Reference: StaticMeshComponent'Default__R6GadgetMotionSensor.GadgetMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6GadgetExplosive.GadgetMesh'
    begin object name="GadgetMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Motion_Sensor'
    end object
    m_Mesh=GadgetMesh
    // Reference: SpriteComponent'Default__R6GadgetMotionSensor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6GadgetExplosive.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
}