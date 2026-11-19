class SeqAct_EndOfGame extends SeqAct_EndOfLevel
    hidecategories(Object);

event Activated()
{
    local PainGRI_SP GRI;

    GRI = PainGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super.Activated();
    GRI.EndOfGame();
    //return;    
}

defaultproperties
{
    ObjName="End of game"
}