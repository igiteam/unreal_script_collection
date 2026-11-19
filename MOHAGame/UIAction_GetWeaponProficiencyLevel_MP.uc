class UIAction_GetWeaponProficiencyLevel_MP extends UIAction_GetWeaponProficiencyLevel
    hidecategories(Object);

function Activated()
{
    local MOHAMultiplayerController MMPController;

    // End:0x34
    foreach GetWorldInfo().DynamicActors(Class'MOHAMultiplayerController', MMPController)
    {
        // End:0x33
        if(MMPController.IsLocalPlayerController())
        {
            // End:0x34
            break;
        }        
    }    
    // End:0x42
    if(MMPController == none)
    {
        return;
    }
    // End:0x7D
    if(WeaponTypeIndex != -1)
    {
        WeaponLevel = MMPController.m_MPPlayerStats.GetUpgradeLevelByType(byte(WeaponTypeIndex));        
    }
    else
    {
        return;
    }
    //return;    
}

defaultproperties
{
    ObjName="Get Weapon Proficiency Level MP"
}