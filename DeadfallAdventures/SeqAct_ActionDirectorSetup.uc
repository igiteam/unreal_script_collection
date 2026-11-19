class SeqAct_ActionDirectorSetup extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() AIDirectorFixedParams Parameters;

event Activated()
{
    local WorldInfo WI;
    local EvilGame CurrentGame;
    local int I;
    local array<EvilPawn> TargetList;
    local EvilPawn Target;

    WI = GetWorldInfo();
    CurrentGame = EvilGame(WI.Game);
    // End:0x11A
    if(VariableLinks.Length > 0)
    {
        I = 0;
        J0x60:

        // End:0x11A [Loop If]
        if(I < VariableLinks[0].LinkedVariables.Length)
        {
            Target = EvilPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[I]).GetObjectValue());
            // End:0x10C
            if(Target != none)
            {
                TargetList.AddItem(Target);                
            }
            I++;
            // [Loop Continue]
            goto J0x60;
        }
    }
    CurrentGame.AIDirectorInstance.UpdateFixedParameters(Parameters, TargetList);
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
    Parameters=(MaximumShootingIntensity=1.0000000,MinNumberOfShootingActors=-1,MaximumThrowingIntensity=0.0000000,MinNumberOfThrowingActors=1,DelayBetweenStartShooting=0.2500000)
    ObjName="AI Action Director Setup"
}