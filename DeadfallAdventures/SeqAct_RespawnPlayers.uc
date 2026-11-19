class SeqAct_RespawnPlayers extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvPlayerPawn TargetPawn;
var AdvPlayerController TargetController;

event Activated()
{
    local AdvPlayerController PC;

    // End:0x3B9
    if(AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none)
    {
        // End:0x364
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
        {
            // End:0x177
            if(AdvPlayerControllerMP(PC).MyAdvPlayerPawnMP.IsAliveAndWell())
            {
                // End:0x14F
                if(AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI).CanWriteStats())
                {
                    AdvPlayerControllerMP(PC).IncrementGlobalIntStat(139);
                }
                AdvPlayerControllerMP(PC).IncreaseSurvivalScoreModifier();
            }
            // End:0x2B7
            if((PC.IsInState('SurvivalWounded') || PC.IsInState('Spectating')) || PC.IsInState('Dead'))
            {
                // End:0x258
                if(PC.IsInState('SurvivalWounded'))
                {
                    AdvPlayerControllerMP(PC).ServerRescuePawn(PC.MyAdvPlayerPawnMP);                    
                }
                else
                {
                    // End:0x2B7
                    if(PC.IsInState('Spectating') || PC.IsInState('Dead'))
                    {
                        ForceRespawn(PC);
                    }
                }
            }
            AdvPlayerControllerMP(PC).DisableAIWallSee(PC.Pawn);
            AdvPlayerControllerMP(PC).PrepareSurvivalWaveEndMessage();
            AdvPRI(PC.PlayerReplicationInfo).WavesCount++;            
        }        
        AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PrepareClientAIWallView(false);
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

reliable server simulated function ForceRespawn(Controller PC)
{
    AdvPlayerControllerMP(PC).ServerGoToState('Dead');
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Survival End Wave"
}