class FHPlayerInput extends UTPlayerInput within FHPlayerController;

var Pawn fhPlayer;

simulated exec function Duck()
{
	local Vector temp;
	if( fhPlayer != none)
	{
		temp = fhPlayer.Mesh.Translation;
		temp.Z = -60;
		fhPlayer.Mesh.SetTranslation(temp);
	}
	super.Duck();
}

simulated exec function UnDuck()
{
	local Vector temp;
	super.UnDuck();
	if( fhPlayer != none)
	{
		temp = fhPlayer.Mesh.Translation;
		temp.Z = -87;
		fhPlayer.Mesh.SetTranslation(temp);
	}
}

function SetPlayer(Pawn p)
{
	fhPlayer = p;
}


