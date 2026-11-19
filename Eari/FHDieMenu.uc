class FHDieMenu extends GFxMoviePlayer;

var GFxObject textBox1;
var GFxObject textBox2;

var float SurvivalTimeInSeconds;
var float PlayerScore;

function Init(optional LocalPlayer player)
{
	super.Init(player);
    Start();
    Advance(0);

	textBox1 = GetVariableObject("_root.framework.timeDisplay.dynamictext1");
	textBox1.SetText("Time: " $ int(SurvivalTimeInSeconds) $ " seconds");

	textBox2 = GetVariableObject("_root.framework.scoreDisplay.dynamictext2");
	textBox2.SetText("Score: " $ int(PlayerScore));
}


// Decompiled with UE Explorer.
defaultproperties
{
    MovieInfo=SwfMovie'FH_scaleform_resources.FHDebugBox'
}