class UICond_IsLayoutCustomizable extends SequenceCondition;

event Activated()
{
    local DataStoreClient dsc;
    local SkyUIDataStore_FrontEnd ds;
    local LocalPlayer LP;
    local SkyPlayerControllerBase SPC;
    local OnlineProfileSettings Settings;
    local int layoutindex;

    dsc = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x1F9
    if(dsc != none)
    {
        ds = SkyUIDataStore_FrontEnd(dsc.FindDataStore('SkyFrontEnd'));
        // End:0x1F9
        if(ds != none)
        {
            LP = Class'Engine.UIInteraction'.static.GetLocalPlayer(PlayerIndex);
            // End:0x1F9
            if(LP != none)
            {
                SPC = SkyPlayerControllerBase(LP.Actor);
                // End:0x1F9
                if((SPC != none) && SkyPlayerInput(SPC.PlayerInput) != none)
                {
                    Settings = SPC.GetProfileSettings();
                    // End:0x1F9
                    if(Settings != none)
                    {
                        // End:0x1F9
                        if(Settings.GetProfileSettingValueId(57 + int(ds.CurrentLayout), layoutindex))
                        {
                            // End:0x15E
                            if(int(ds.CurrentLayout) == int(0))
                            {
                                // End:0x15B
                                if(layoutindex == SkyPlayerInput(SPC.PlayerInput).OnFootLayouts.Length)
                                {
                                    ActivateOutputLink(0);
                                    return;
                                }                                
                            }
                            else
                            {
                                // End:0x1AD
                                if(int(ds.CurrentLayout) == int(1))
                                {
                                    // End:0x1AA
                                    if(layoutindex == SkyPlayerInput(SPC.PlayerInput).InAirLayouts.Length)
                                    {
                                        ActivateOutputLink(0);
                                        return;
                                    }                                    
                                }
                                else
                                {
                                    // End:0x1F9
                                    if(int(ds.CurrentLayout) == int(2))
                                    {
                                        // End:0x1F9
                                        if(layoutindex == SkyPlayerInput(SPC.PlayerInput).InAAGunLayouts.Length)
                                        {
                                            ActivateOutputLink(0);
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    ActivateOutputLink(1);
    //return;    
}

event bool IsValidLevelSequenceObject()
{
    return false;
    //return ReturnValue;    
}
