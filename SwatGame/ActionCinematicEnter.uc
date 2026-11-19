class ActionCinematicEnter extends Action
	native;

// execute
latent function Variable execute()
{
	Super.execute();
	cinematicEnter();
	
    if( parentScript.Level.GetLocalPlayerController() != None )
    	PlayerController(parentScript.Level.GetLocalPlayerController().Pawn.Controller).myHud.bHideHud = true;

	return None;
}

native static function cinematicEnter();

// editorDisplayString
function editorDisplayString(out string s)
{
	s = "Enter cinematic mode";
}








// Decompiled with UE Explorer.
defaultproperties
{
    actionDisplayName="Cinematic Mode: Enter"
    actionHelp="Enter cinematic mode"
    category="Cinematic"
}