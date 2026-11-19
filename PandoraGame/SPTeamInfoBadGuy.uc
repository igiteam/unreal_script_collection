class SPTeamInfoBadGuy extends SPTeamInfo
    abstract;

enum eSPSquad_BadGuy
{
    ESPSquad_BadGuy_None,           // 0
    ESPSquad_BadGuy_01,             // 1
    ESPSquad_BadGuy_02,             // 2
    ESPSquad_BadGuy_03,             // 3
    ESPSquad_BadGuy_04,             // 4
    ESPSquad_BadGuy_05,             // 5
    ESPSquad_BadGuy_06,             // 6
    ESPSquad_BadGuy_07,             // 7
    ESPSquad_BadGuy_08,             // 8
    ESPSquad_BadGuy_09,             // 9
    eSPSquad_BadGuy_10,             // 10
    eSPSquad_BadGuy_11,             // 11
    eSPSquad_BadGuy_12,             // 12
    eSPSquad_BadGuy_13,             // 13
    eSPSquad_BadGuy_14,             // 14
    eSPSquad_BadGuy_15,             // 15
    eSPSquad_BadGuy_16,             // 16
    ESPSquad_BadGuy_Maximus,        // 17
    eSPSquad_BadGuy_MAX             // 18
};

var array<name> m_badguySquadNames;

event name GetPreDefinedSquadName(int Idx)
{
    // End:0x29
    if((Idx > 0) && Idx < m_badguySquadNames.Length)
    {
        return m_badguySquadNames[Idx];
    }
    return 'Default';
    //return ReturnValue;    
}
