class SPSquadActorFactoryAI extends SPActorFactoryAI
    native
    config(Editor)
    editinlinenew
    collapsecategories;

var(SquadSize) int m_iNumSquadMembers;
var array<SPAIController> squadMembers;
/** Type of squad to select name from */
var() export editinline SPSquadSelector SquadType;
var SPSquad mySquad;

simulated event AssignSquad(SPAIController spawnedMember)
{
    local SPTeamInfo myTeam;
    local name squadName;

    // End:0x0D
    if(SquadType == none)
    {
        return;
    }
    myTeam = spawnedMember.GetTeam();
    // End:0x30
    if(myTeam == none)
    {
        return;
    }
    // End:0x50
    if(!SquadType.IsAssociatedWithTeam(myTeam))
    {
        return;
    }
    squadName = myTeam.GetPreDefinedSquadName(SquadType.GetSelectedSquadIdx());
    myTeam.AddToSquad(spawnedMember, squadName);
    // End:0xBC
    if(mySquad == none)
    {
        mySquad = spawnedMember.m_squad;
    }
    //return;    
}

function PostBeginPlay()
{
    //return;    
}
