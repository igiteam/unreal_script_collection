class SkyTeamRivalInfo extends Object
    native;

struct native s_TeamRivalEnemyInfo
{
    var() name EnemyGangName;
    var() float ThreatMultiplier;

    structdefaultproperties
    {
        EnemyGangName="None"
        ThreatMultiplier=1.0000000
    }
};

struct native s_TeamRivalInfo
{
    var() name GangName;
    var() array<name> EnemyGangs;
    var() array<s_TeamRivalEnemyInfo> EnemyGangsInfo;

    structdefaultproperties
    {
        GangName="None"
        EnemyGangs=none
        EnemyGangsInfo=none
    }
};

var array<s_TeamRivalInfo> TeamRivalList;

// Export USkyTeamRivalInfo::execIsTeamARival(FFrame&, void* const)
native simulated function bool IsTeamARival(name FirstGang, name SecondGang);

// Export USkyTeamRivalInfo::execGetEnemyRivalThreatMultiplier(FFrame&, void* const)
native simulated function float GetEnemyRivalThreatMultiplier(name FirstGang, name SecondGang);

simulated function SetRivalries(out array<s_TeamRivalInfo> inRivals)
{
    local int I, J, K, NewId;

    J = 0;
    J0x07:

    // End:0xD8 [Loop If]
    if(J < inRivals.Length)
    {
        I = 0;
        J0x1E:

        // End:0x78 [Loop If]
        if(I < TeamRivalList.Length)
        {
            // End:0x6E
            if(TeamRivalList[I].GangName == inRivals[J].GangName)
            {
                TeamRivalList.Remove(I, 1);
                // [Explicit Break]
                goto J0x78;
            }
            I++;
            // [Loop Continue]
            goto J0x1E;
        }
        J0x78:

        NewId = TeamRivalList.Add(1);
        TeamRivalList[NewId] = inRivals[J];
        K = 0;
        J0xA3:

        // End:0xCE [Loop If]
        if(K < TeamRivalList[NewId].EnemyGangs.Length)
        {
            K++;
            // [Loop Continue]
            goto J0xA3;
        }
        J++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
