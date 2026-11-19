//=============================================================================
// ACTION_CounterAdd.uc
//
// Script action to add a specified value to a counter. 
//=============================================================================

class ACTION_SetLightBrightness extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) float NewLightBrightness;
var(Action) edfindable Actor WhichActor;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if (WhichActor == None)
		LogHuman("No actor in "$self$" in "$mOwnerScript);
		
	if (!WhichActor.bDynamicLight)
		LogHuman("Not a dynamic light in "$self$" in "$mOwnerScript);
		
	WhichActor.LightBrightness = NewLightBrightness;

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString$NewLightBrightness$WhichActor;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Set Light Brightness"
}