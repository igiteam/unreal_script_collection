class SeqAct_ActionDirectorSetup extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() AIDirectorFixedParams Parameters;

event Activated()
{
    local WorldInfo WI;
    local EvilGame CurrentGame;

    WI = GetWorldInfo();
    CurrentGame = EvilGame(WI.Game);
    CurrentGame.AIDirectorInstance.UpdateFixedParameters(Parameters);
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    Parameters=(MaximumShootingIntensity=1.0000000,MinNumberOfShootingActors=-1)
    ObjName="AI Action Director Setup"
}