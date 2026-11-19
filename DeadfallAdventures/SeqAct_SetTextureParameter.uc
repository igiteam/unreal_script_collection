class SeqAct_SetTextureParameter extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Texture NewTexture;
var() name ParamName;
var() InterpActor InInterpActor;

event Activated()
{
    // End:0x75
    if(InInterpActor != none)
    {
        MaterialInstance(InInterpActor.StaticMeshComponent.Materials[0]).SetTextureParameterValue(ParamName, NewTexture);
    }
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Set Texture Parameter"
}