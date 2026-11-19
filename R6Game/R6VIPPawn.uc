class R6VIPPawn extends R6PlayerPawn
    native
    config(Character)
    hidecategories(lighting);

var R6EquipmentTemplate m_VIPEquipmentTemplate;

// Export UR6VIPPawn::execLoadEquipmentTemplate(FFrame&, void* const)
native function bool LoadEquipmentTemplate(string strTemplate);

function int GetRopeWeapon()
{
    return 0;
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    PossessedBy(C, bVehicleTransition);
    // End:0x73
    if((GetGameManager().IsMultiplayer() && int(WorldInfo.NetMode) != int(NM_Client)) && m_RadarPawnRepInfo != none)
    {
        m_RadarPawnRepInfo.m_bVIP = true;
        m_RadarPawnRepInfo.NetUpdateFrequency = 2.0000000;
    }
    return;
}

defaultproperties
{
    m_VIPEquipmentTemplate=R6EquipmentTemplate'EquipmentTemplates.AssassinVIPEquipment'
    m_CharacterTemplate=R6CharacterTemplate'RS5Chara_assassin.Template.VIP_template'
}