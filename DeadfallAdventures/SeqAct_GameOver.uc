class SeqAct_GameOver extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPawn P;

    // End:0x15F
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xA9
        if(AdvPlayerController(ObjVar.GetObjectValue()) != none)
        {
            P = AdvPawn(AdvPlayerController(ObjVar.GetObjectValue()).Pawn);            
        }
        else
        {
            P = AdvPawn(ObjVar.GetObjectValue());
        }
        // End:0x15E
        if(P != none)
        {
            Class'Engine.Engine'.static.GetAudioDevice().bAllSoundsAsUI = true;
            AdvPlayerController(P.Controller).ProcessGameOver();
        }        
    }    
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Game Over"
}