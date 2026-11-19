class UTSeqEvent_GameEnded extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

var Actor Winner;
var Actor ActualWinner;

event Activated()
{
    local EvilGame Game;

    Game = EvilGame(GetWorldInfo().Game);
    // End:0xEF
    if(Game != none)
    {
        Winner = Game.EndGameFocus;
        ActualWinner = Game.GameReplicationInfo.Winner;
        // End:0xEF
        if(PlayerReplicationInfo(ActualWinner) != none)
        {
            ActualWinner = Controller(ActualWinner.Owner);
        }
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    bPlayerOnly=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Focus Actor",LinkVar="None",PropertyName="Winner",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Winning Player/Team",LinkVar="None",PropertyName="ActualWinner",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Game Ended"
}