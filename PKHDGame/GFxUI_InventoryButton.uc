class GFxUI_InventoryButton extends GFxClikWidget within GFxMoviePlayer;

var string Content;
var GFxObject IconMC;

function SetContent(string newContent)
{
    Content = newContent;
    //return;    
}

function SetIconMC(GFxObject iconClip)
{
    IconMC = iconClip;
    //return;    
}

defaultproperties
{
    Content="none"
}