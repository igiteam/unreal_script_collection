class SeqAct_FlashlightNumeralPuzzleControl extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvFlashlightNumeralPuzzle_Base FlashlightNumeralPuzzle;

event Activated()
{
    local SeqVar_Object ObjVar;

    // End:0x63
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "FlashlightNumeralPuzzle")
    {
        PublishLinkedVariableValues();
        self.FlashlightNumeralPuzzle = FlashlightNumeralPuzzle;        
    }    
    // End:0xB1
    if(InputLinks[0].bHasImpulse)
    {
        FlashlightNumeralPuzzle.bIsPuzzleActive = true;
        PopulateLinkedVariableValues();
    }
    // End:0xFE
    if(InputLinks[1].bHasImpulse)
    {
        FlashlightNumeralPuzzle.bIsPuzzleActive = false;
        PopulateLinkedVariableValues();
    }
    // End:0x164
    if(FlashlightNumeralPuzzle.bIsPuzzleActive && InputLinks[2].bHasImpulse)
    {
        FlashlightNumeralPuzzle.CheckEndPuzzle();
    }
    // End:0x1E8
    if(InputLinks[3].bHasImpulse)
    {
        FlashlightNumeralPuzzle.TurnOffAll();
        FlashlightNumeralPuzzle.bSymbolMadeCorrectly = false;
        FlashlightNumeralPuzzle.bIsPuzzleActive = true;
    }
    // End:0x22A
    if(InputLinks[4].bHasImpulse)
    {
        FlashlightNumeralPuzzle.TurnOnCorrectOnly();
    }
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Check symbol",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[3]=(LinkDesc="Turn all lights off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[4]=(LinkDesc="Turn only correct lights on",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="FlashlightNumeralPuzzle",LinkVar="None",PropertyName="FlashlightNumeralPuzzle",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="FlashlightNumeralPuzzle Control"
}