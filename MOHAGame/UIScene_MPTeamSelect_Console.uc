class UIScene_MPTeamSelect_Console extends UIScene_MPTeamSelect
    native
    hidecategories(Object,UIRoot,Object);

// Export UUIScene_MPTeamSelect_Console::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

// Export UUIScene_MPTeamSelect_Console::execUpdateTeamInfo(FFrame&, void* const)
native function UpdateTeamInfo();

// Export UUIScene_MPTeamSelect_Console::execHandleInputKey(FFrame&, void* const)
native function bool HandleInputKey(int ControllerId, name Key, Object.EInputEvent Event, float AmountDepressed);

event SetupLabels()
{
    super.SetupLabels();
    __OnInputKey__Delegate = HandleInputKey;
    //return;    
}

function bool OnShowGamerCard(UIScreenObject obj)
{
    local UILabelButton localObj;
    local LocalPlayer playerObj;
    local GameReplicationInfo localGRI;
    local PlayerReplicationInfo LocalPRI;
    local int I;

    localGRI = GetWorldInfo().GRI;
    // End:0x1F6
    if(localGRI != none)
    {
        I = 0;
        J0x2B:

        // End:0xC3 [Loop If]
        if(I < localGRI.PRIArray.Length)
        {
            LocalPRI = localGRI.PRIArray[I];
            // End:0xAB
            if((LocalPRI != none) && PlayerController(LocalPRI.Owner) != none)
            {
                playerObj = LocalPlayer(PlayerController(LocalPRI.Owner).Player);
            }
            // End:0xB9
            if(playerObj != none)
            {
                // [Explicit Break]
                goto J0xC3;
            }
            I++;
            // [Loop Continue]
            goto J0x2B;
        }
        J0xC3:

        localObj = UILabelButton(obj);
        // End:0x1F6
        if((localObj != none) && playerObj != none)
        {
            I = 0;
            J0xF2:

            // End:0x1F3 [Loop If]
            if(I < TEAMSIZE)
            {
                // End:0x175
                if((AllyTeam[I].PlayerName == localObj) && AllyTeam[I].PRI != none)
                {
                    ShowGamercard(playerObj.ControllerId, AllyTeam[I].PRI.UniqueId);
                    return true;
                }
                // End:0x1E9
                if((AxisTeam[I].PlayerName == localObj) && AxisTeam[I].PRI != none)
                {
                    ShowGamercard(playerObj.ControllerId, AxisTeam[I].PRI.UniqueId);
                    return true;
                }
                I++;
                // [Loop Continue]
                goto J0xF2;
            }            
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: UIComp_Event'Default__UIScene_MPTeamSelect_Console.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}