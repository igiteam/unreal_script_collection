class UIAction_MOHAGetCellValue extends UIAction_GetCellValue
    native
    hidecategories(Object);

var() int SubArrayIndex;

defaultproperties
{
    SubArrayIndex=-1
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Index",LinkVar="None",PropertyName="CollectionIndex",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    VariableLinks[4]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Markup",LinkVar="None",PropertyName="CellFieldMarkup",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[5]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="String Value",LinkVar="None",PropertyName="CellFieldStringValue",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[6]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Image Value",LinkVar="None",PropertyName="CellFieldImageValue",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[7]=(ExpectedType=Class'Engine.SeqVar_UIRange',LinkedVariables=none,LinkDesc="Range Value",LinkVar="None",PropertyName="CellFieldRangeValue",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[8]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Int Value",LinkVar="None",PropertyName="CellFieldIntValue",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[9]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Float Value",LinkVar="None",PropertyName="CellFieldFloatValue",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[10]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="SubIndex",LinkVar="None",PropertyName="SubArrayIndex",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="MOHA Get Cell Value"
}