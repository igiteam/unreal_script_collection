class SPTeamInfoCreature extends SPTeamInfo
    abstract
    native;

enum eSPSquad_Creature
{
    ESPSquad_Creature_None,         // 0
    ESPSquad_Creature_01,           // 1
    ESPSquad_Creature_02,           // 2
    ESPSquad_Creature_03,           // 3
    ESPSquad_Creature_04,           // 4
    ESPSquad_Creature_05,           // 5
    ESPSquad_Creature_06,           // 6
    ESPSquad_Creature_07,           // 7
    ESPSquad_Creature_08,           // 8
    ESPSquad_Creature_09,           // 9
    eSPSquad_Creature_10,           // 10
    eSPSquad_Creature_11,           // 11
    eSPSquad_Creature_12,           // 12
    eSPSquad_Creature_13,           // 13
    eSPSquad_Creature_14,           // 14
    eSPSquad_Creature_15,           // 15
    eSPSquad_Creature_16,           // 16
    ESPSquad_Creature_Maximus,      // 17
    eSPSquad_Creature_MAX           // 18
};

var array<name> m_creatureSquadNames;

event name GetPreDefinedSquadName(int Idx)
{
    // End:0x29
    if((Idx > 0) && Idx < m_creatureSquadNames.Length)
    {
        return m_creatureSquadNames[Idx];
    }
    return 'Default';
    //return ReturnValue;    
}
