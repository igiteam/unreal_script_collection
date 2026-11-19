class SeqAct_ConvertUnrRot extends SeqAct_SetSequenceVariable
    forcescriptorder(true)
    hidecategories(Object);

var() float UnrRot;
var() float Deg;
var float Result;
var() bool UnrRot2Deg;

event Activated()
{
    // End:0x51
    if(self.UnrRot2Deg)
    {
        self.Result = 0.0054932 * self.UnrRot;        
    }
    else
    {
        self.Result = 182.0444000 * self.Deg;
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    UnrRot2Deg=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="UnrRot",LinkVar="None",PropertyName="UnrRot",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Deg",LinkVar="None",PropertyName="Deg",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Result",LinkVar="None",PropertyName="Result",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Convert Unreal Rotation"
}