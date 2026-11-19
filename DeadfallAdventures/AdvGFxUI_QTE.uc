class AdvGFxUI_QTE extends UTGFxTweenableMoviePlayer
    config(UI);

var GFxObject Buttons;
var GFxObject ButtonUI;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    Buttons = GetVariableObject("_root.AdvButtons");
    ButtonUI = GetVariableObject("_root.AdvButtons.ButtonUI.Button");
    ButtonUI.SetFloat("_xscale", ButtonUI.GetFloat("_xscale") * 0.4000000);
    ButtonUI.SetFloat("_yscale", ButtonUI.GetFloat("_yscale") * 0.4000000);
    return true;
    //return ReturnValue;    
}

function ShowButton(EvilTypes.EGameButtons Button)
{
    local string Texture, Prefix;

    // End:0x4D
    if(GetPC().WorldInfo.IsConsoleBuild(2))
    {
        Prefix = "ps3_";        
    }
    else
    {
        // End:0xC9
        if(GetPC().WorldInfo.IsConsoleBuild(1) || AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            Prefix = "xbox_";            
        }
        else
        {
            Prefix = "pc_";
        }
    }
    switch(Button)
    {
        // End:0x100
        case 0:
            Texture = "a";
            // End:0x217
            break;
        // End:0x115
        case 3:
            Texture = "b";
            // End:0x217
            break;
        // End:0x12A
        case 1:
            Texture = "x";
            // End:0x217
            break;
        // End:0x13F
        case 2:
            Texture = "y";
            // End:0x217
            break;
        // End:0x159
        case 5:
            Texture = "select";
            // End:0x217
            break;
        // End:0x16F
        case 6:
            Texture = "l2";
            // End:0x217
            break;
        // End:0x185
        case 7:
            Texture = "l1";
            // End:0x217
            break;
        // End:0x19B
        case 8:
            Texture = "r2";
            // End:0x217
            break;
        // End:0x1B1
        case 9:
            Texture = "r1";
            // End:0x217
            break;
        // End:0x1C8
        case 16:
            Texture = "lup";
            // End:0x217
            break;
        // End:0x1E1
        case 17:
            Texture = "ldown";
            // End:0x217
            break;
        // End:0x1FA
        case 18:
            Texture = "lleft";
            // End:0x217
            break;
        // End:0x214
        case 19:
            Texture = "lright";
            // End:0x217
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x2C0
    if(Len(Texture) > 0)
    {
        ButtonUI.SetVisible(true);
        ButtonUI.SetString("source", ("img://UI_AdvHUD." $ Prefix) $ Texture);
        Buttons.GotoAndPlay("show");        
    }
    else
    {
        ButtonUI.SetVisible(false);
    }
    //return;    
}

defaultproperties
{
    MovieInfo=SwfMovie'UI_AdvHUD.AdvQTE'
    bOnlyOwnerFocusable=true
    bDiscardNonOwnerInput=true
}