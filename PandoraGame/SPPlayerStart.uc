class SPPlayerStart extends PlayerStart;

enum EMPTeam
{
    EMPTeam_All,                    // 0
    EMPTeam_1,                      // 1
    EMPTeam_2,                      // 2
    EMPTeam_MAX                     // 3
};

/** There can be team specific starting points. */
var() private const SPPlayerStart.EMPTeam TeamsThatCanStartHere;

function SPPlayerStart.EMPTeam GetTeamsThatCanStartHere()
{
    return TeamsThatCanStartHere;
    //return ReturnValue;    
}
