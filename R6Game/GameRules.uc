class GameRules extends Info
    notplaceable
    hidecategories(lighting,Movement,Collision);

var GameRules NextGameRules;

function AddGameRules(GameRules GR)
{
    // End:0x19
    if(NextGameRules == none)
    {
        NextGameRules = GR;        
    }
    else
    {
        NextGameRules.AddGameRules(GR);
    }
    return;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
    // End:0x2D
    if(NextGameRules != none)
    {
        return NextGameRules.FindPlayerStart(Player, InTeam, incomingName);
    }
    return none;
    return;
}

function string GetRules()
{
    local string ResultSet;

    // End:0x28
    if(NextGameRules == none)
    {
        ResultSet = ResultSet $ NextGameRules.GetRules();
    }
    return ResultSet;
    return;
}

function bool HandleRestartGame()
{
    // End:0x22
    if((NextGameRules != none) && NextGameRules.HandleRestartGame())
    {
        return true;
    }
    return false;
    return;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    // End:0x26
    if(NextGameRules != none)
    {
        return NextGameRules.CheckEndGame(Winner, Reason);
    }
    return true;
    return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x21
    if(NextGameRules != none)
    {
        return NextGameRules.CheckScore(Scorer);
    }
    return false;
    return;
}

function bool OverridePickupQuery(Pawn other, class<Inventory> ItemClass, Actor Pickup, out byte bAllowPickup)
{
    // End:0x36
    if((NextGameRules != none) && NextGameRules.OverridePickupQuery(other, ItemClass, Pickup, bAllowPickup))
    {
        return true;
    }
    return false;
    return;
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x36
    if((NextGameRules != none) && NextGameRules.PreventDeath(Killed, Killer, DamageType, HitLocation))
    {
        return true;
    }
    return false;
    return;
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
    // End:0x25
    if(NextGameRules != none)
    {
        NextGameRules.ScoreObjective(Scorer, Score);
    }
    return;
}

function ScoreKill(Controller Killer, Controller Killed)
{
    // End:0x25
    if(NextGameRules != none)
    {
        NextGameRules.ScoreKill(Killer, Killed);
    }
    return;
}

function bool CriticalPlayer(Controller other)
{
    // End:0x27
    if((NextGameRules != none) && NextGameRules.CriticalPlayer(other))
    {
        return true;
    }
    return false;
    return;
}

function NetDamage(int OriginalDamage, out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
    // End:0x3E
    if(NextGameRules != none)
    {
        NextGameRules.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    return;
}
