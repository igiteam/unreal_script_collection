class EvilTeamInfo extends TeamInfo
    hidecategories(Navigation,Movement,Collision);

var Color BaseTeamColor[9];
var int AISize;
var EvilGameObjective HomeBase;
var EvilCarriedObject TeamFlag;
var string Faction;

function Initialize(int NewTeamIndex)
{
    TeamIndex = NewTeamIndex;
    TeamColor = BaseTeamColor[NewTeamIndex % 9];
    //return;    
}

function bool AddToTeam(Controller Other)
{
    // End:0x11
    if(Other == none)
    {
        return false;
    }
    // End:0x68
    if(!Other.IsA('EvilAIController') && Other.PlayerReplicationInfo == none)
    {
        ScriptTrace();
        return false;
    }
    // End:0xD7
    if(Other.IsA('EvilAIController'))
    {
        AISize++;
        EvilPawn(Other.Pawn).AITeamInfo = self;        
    }
    else
    {
        Size++;
        Other.PlayerReplicationInfo.SetPlayerTeam(self);
    }
    return true;
    //return ReturnValue;    
}

function RemoveFromTeam(Controller Other)
{
    // End:0x2E
    if(Other.IsA('EvilAIController'))
    {
        AISize--;
    }
    Size--;
    // End:0x57
    if(Size == 0)
    {
        Score = 0.0000000;
    }
    // End:0x152
    if(Other != none)
    {
        // End:0xC2
        if(Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.SetPlayerTeam(none);            
        }
        else
        {
            // End:0x152
            if(Other.IsA('EvilAIController') && EvilPawn(Other.Pawn) != none)
            {
                EvilPawn(Other.Pawn).AITeamInfo = none;
            }
        }
    }
    //return;    
}

defaultproperties
{
    BaseTeamColor[0]=(R=255,G=64,B=64,A=255)
    BaseTeamColor[1]=(R=64,G=64,B=255,A=255)
    BaseTeamColor[2]=(R=65,G=255,B=64,A=255)
    BaseTeamColor[3]=(R=255,G=255,B=0,A=255)
    BaseTeamColor[4]=(R=0,G=255,B=255,A=255)
    BaseTeamColor[5]=(R=255,G=0,B=255,A=255)
    BaseTeamColor[6]=(R=255,G=255,B=255,A=255)
    BaseTeamColor[7]=(R=0,G=0,B=0,A=255)
    BaseTeamColor[8]=(R=127,G=127,B=127,A=255)
}