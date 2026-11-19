class UIScene_MPScoreboardObjective extends UIScene_MPScoreboard
    native
    hidecategories(Object,UIRoot,Object);

// Export UUIScene_MPScoreboardObjective::execUpdateTeamInfo(FFrame&, void* const)
native function UpdateTeamInfo(bool TeamListsHaveBeenBuilt);

event SetupLabels()
{
    local int I;

    super.SetupLabels();
    I = 0;
    J0x0D:

    // End:0x5D [Loop If]
    if(I < TOTALPLAYERS)
    {
        m_Players[I].Objectives = UILabel(FindChild(m_PlayerWidgetName[I].Objectives, true));
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

defaultproperties
{
    // Reference: UIComp_Event'Default__UIScene_MPScoreboardObjective.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}