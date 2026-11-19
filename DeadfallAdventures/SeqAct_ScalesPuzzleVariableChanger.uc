class SeqAct_ScalesPuzzleVariableChanger extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvScalesPuzzle_base ScalesPuzzle;
var int CoinsRequired;
var int TotalCoins;
var int CoinsReq;
var int AdditionalCoins;
var int CoinsPlaced;

event Activated()
{
    local SeqVar_Object ObjVar;
    local SeqVar_Int IntVar;

    // End:0xB1
    if(InputLinks[0].bHasImpulse || InputLinks[1].bHasImpulse)
    {
        // End:0xB0
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "ScalesPuzzle")
        {
            PublishLinkedVariableValues();
            CoinsPlaced = ScalesPuzzle.CoinsAtScales;
            PopulateLinkedVariableValues();            
        }        
    }
    // End:0x21E
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x11F
        foreach LinkedVariables(Class'Engine.SeqVar_Int', IntVar, "CoinsRequired")
        {
            PublishLinkedVariableValues();
            CoinsReq = CoinsRequired;            
        }        
        // End:0x174
        foreach LinkedVariables(Class'Engine.SeqVar_Int', IntVar, "TotalCoins")
        {
            PublishLinkedVariableValues();
            AdditionalCoins = TotalCoins - CoinsRequired;            
        }        
        // End:0x212
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "ScalesPuzzle")
        {
            PublishLinkedVariableValues();
            ScalesPuzzle.CoinsRequired = CoinsReq;
            ScalesPuzzle.CoinsHeld = CoinsReq + AdditionalCoins;
            PopulateLinkedVariableValues();            
        }        
        ActivateOutputLink(0);
    }
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="UpdateByDmgTaken",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="ScalesPuzzle",LinkVar="None",PropertyName="ScalesPuzzle",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="CoinsRequired",LinkVar="None",PropertyName="CoinsRequired",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="TotalCoins",LinkVar="None",PropertyName="TotalCoins",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="CoinsPlaced",LinkVar="None",PropertyName="CoinsPlaced",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Scales Puzzle Variable Changer"
}