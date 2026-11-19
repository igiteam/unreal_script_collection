class SPTeamInfoAlly extends SPTeamInfo
    abstract;

enum eSPSquad_Allies
{
    ESPSquad_Allies_None,           // 0
    ESPSquad_Allies_01,             // 1
    ESPSquad_Allies_02,             // 2
    ESPSquad_Allies_03,             // 3
    ESPSquad_Allies_04,             // 4
    ESPSquad_Allies_05,             // 5
    ESPSquad_Allies_06,             // 6
    ESPSquad_Allies_07,             // 7
    ESPSquad_Allies_08,             // 8
    ESPSquad_Allies_09,             // 9
    eSPSquad_Allies_10,             // 10
    eSPSquad_Allies_11,             // 11
    eSPSquad_Allies_12,             // 12
    eSPSquad_Allies_13,             // 13
    eSPSquad_Allies_14,             // 14
    eSPSquad_Allies_15,             // 15
    eSPSquad_Allies_16,             // 16
    ESPSquad_Allies_Maximus,        // 17
    eSPSquad_Allies_MAX             // 18
};

var array<name> m_alliesSquadNames;

event name GetPreDefinedSquadName(int Idx)
{
    // End:0x29
    if((Idx > 0) && Idx < m_alliesSquadNames.Length)
    {
        return m_alliesSquadNames[Idx];
    }
    return 'Default';
    //return ReturnValue;    
}
