class GFxUDKFrontEnd_Screen extends GFxUDKFrontEnd_View within GFxMoviePlayer
    config(UI);

var config string ViewTitle;
var GFxClikWidget BackBtn;
var GFxObject TitleMC;
var GFxObject FooterMC;
var GFxObject LogoMC;
var GFxObject HelpTxt;
var GFxObject InfoTxt;
var string AcceptButtonHelpText;
var string CancelButtonHelpText;
var string AcceptButtonImage;
var string CancelButtonImage;

function FocusIn_BackButton(EventData ev)
{
    // End:0x31
    if(InfoTxt != none)
    {
        InfoTxt.SetText("");
    }
    //return;    
}

function UpdateHelpButtonImages()
{
    // End:0x51
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
    {
        AcceptButtonImage = "ps3_a_png";
        CancelButtonImage = "ps3_b_png";        
    }
    else
    {
        // End:0xA1
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
        {
            AcceptButtonImage = "xbox_a_png";
            CancelButtonImage = "xbox_b_png";
        }
    }
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    switch(WidgetName)
    {
        // End:0x119
        case 'Help':
            HelpTxt = Widget.GetObject("textField");
            UpdateHelpButtonImages();
            HelpTxt.SetString("htmlText", (((((("<img vspace='-5' src='" $ AcceptButtonImage) $ "'>") @ AcceptButtonHelpText) @ "&nbsp;&nbsp;<img vspace='-5' src='") $ CancelButtonImage) $ "'>") @ CancelButtonHelpText);
            bWasHandled = true;
            // End:0x371
            break;
        // End:0x1A1
        case 'Title':
            // End:0x19E
            if(TitleMC == none)
            {
                TitleMC = Widget;
                TitleMC.GetObject("textField").SetText(ViewTitle);
                bWasHandled = true;
            }
            // End:0x371
            break;
        // End:0x2A1
        case 'back':
            BackBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
            BackBtn.SetString("label", "BACK");
            BackBtn.AddEventListener('CLIK_press', Select_Back);
            BackBtn.AddEventListener('CLIK_focusIn', FocusIn_BackButton);
            bWasHandled = true;
            // End:0x371
            break;
        // End:0x2CF
        case 'footer':
            FooterMC = Widget;
            bWasHandled = true;
            // End:0x371
            break;
        // End:0x32E
        case 'Info':
            // End:0x32B
            if(InfoTxt == none)
            {
                InfoTxt = Widget.GetObject("textField");
                bWasHandled = true;
            }
            // End:0x371
            break;
        // End:0x36B
        case 'logo':
            // End:0x368
            if(LogoMC == none)
            {
                LogoMC = Widget;
                bWasHandled = true;
            }
            // End:0x371
            break;
        // End:0xFFFF
        default:
            // End:0x371
            break;
            break;
    }
    // End:0x3B0
    if(!bWasHandled)
    {
        bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }
    return bWasHandled;
    //return ReturnValue;    
}

defaultproperties
{
    AcceptButtonHelpText="SELECT"
    CancelButtonHelpText="BACK"
    AcceptButtonImage="pc_enter_png"
    CancelButtonImage="pc_esc_png"
    SubWidgetBindings=/* Array type was not detected. */
}