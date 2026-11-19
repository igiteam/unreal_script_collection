class SeqAct_PlayerControllerVariableChanger extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() float MinRespawnDelay;

event Activated()
{
    local SeqVar_Object ObjVar;
    local PlayerController PC;

    // End:0x237
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0x8B
        if(PlayerController(ObjVar.GetObjectValue()) != none)
        {
            PC = PlayerController(ObjVar.GetObjectValue());            
        }
        else
        {
            // End:0x109
            if(Pawn(ObjVar.GetObjectValue()) != none)
            {
                PC = PlayerController(Pawn(ObjVar.GetObjectValue()).Controller);
            }
        }
        // End:0x1E9
        if(PC != none)
        {
            // End:0x172
            if(InputLinks[0].bHasImpulse)
            {
                PC.MinRespawnDelay = self.MinRespawnDelay;                
            }
            else
            {
                // End:0x1E6
                if(InputLinks[1].bHasImpulse)
                {
                    PC.MinRespawnDelay = PC.Class.default.MinRespawnDelay;
                }
            }
            // End:0x236
            continue;
        }
        ScriptLog(("WARNING: PlayerController/Pawn expected in Players for" @ string(self)) @ ".");        
    }    
    //return;    
}

defaultproperties
{
    MinRespawnDelay=3.0000000
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Set defaults",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Player Controller Variable Changer"
}