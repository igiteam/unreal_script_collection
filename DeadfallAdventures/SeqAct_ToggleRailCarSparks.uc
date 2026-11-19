class SeqAct_ToggleRailCarSparks extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local AdvRailCar_MineCart_Base Target;

    Target = AdvRailCar_MineCart_Base(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x12D
    if(Target != none)
    {
        // End:0xA6
        if(InputLinks[0].bHasImpulse)
        {
            Target.SetRailCarSparkSpawn(true);            
        }
        else
        {
            // End:0xEB
            if(InputLinks[1].bHasImpulse)
            {
                Target.SetRailCarSparkSpawn(false);                
            }
            else
            {
                // End:0x12D
                if(InputLinks[2].bHasImpulse)
                {
                    Target.ToggleRailCarSparkSpawn();
                }
            }
        }
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Toggle RailCar Sparks"
}