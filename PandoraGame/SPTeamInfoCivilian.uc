class SPTeamInfoCivilian extends SPTeamInfo;

enum eSPSquad_Civilian
{
    ESPSquad_Civilian_None,         // 0
    ESPSquad_Civilian_01,           // 1
    ESPSquad_Civilian_02,           // 2
    ESPSquad_Civilian_03,           // 3
    ESPSquad_Civilian_04,           // 4
    ESPSquad_Civilian_05,           // 5
    ESPSquad_Civilian_06,           // 6
    ESPSquad_Civilian_07,           // 7
    ESPSquad_Civilian_08,           // 8
    ESPSquad_Civilian_09,           // 9
    eSPSquad_Civilian_10,           // 10
    eSPSquad_Civilian_11,           // 11
    eSPSquad_Civilian_12,           // 12
    eSPSquad_Civilian_13,           // 13
    eSPSquad_Civilian_14,           // 14
    eSPSquad_Civilian_15,           // 15
    eSPSquad_Civilian_16,           // 16
    ESPSquad_Civilian_Maximus,      // 17
    eSPSquad_Civilian_MAX           // 18
};

var array<name> m_civilianSquadNames;

event name GetPreDefinedSquadName(int Idx)
{
    // End:0x29
    if((Idx > 0) && Idx < m_civilianSquadNames.Length)
    {
        return m_civilianSquadNames[Idx];
    }
    return 'Default';
    //return ReturnValue;    
}
