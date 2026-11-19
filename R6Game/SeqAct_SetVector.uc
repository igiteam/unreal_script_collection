class SeqAct_SetVector extends SequenceAction
    hidecategories(Object);

var() Vector DefaultValue;

event Activated()
{
    local bool bIgnoreDefault;
    local SeqVar_Vector VectVar;
    local Vector Value;

    // End:0x38
    foreach LinkedVariables(Class'SeqVar_Vector', VectVar, "Value")
    {
        bIgnoreDefault = true;
        Value += VectVar.VectValue;        
    }    
    // End:0x4F
    if(!bIgnoreDefault)
    {
        Value = DefaultValue;
    }
    // End:0x7F
    foreach LinkedVariables(Class'SeqVar_Vector', VectVar, "Target")
    {
        VectVar.VectValue = Value;        
    }    
    return;
}

defaultproperties
{
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Vector',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Vector',LinkedVariables=none,LinkDesc="Value",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Vector"
    ObjCategory="Set Variable"
}