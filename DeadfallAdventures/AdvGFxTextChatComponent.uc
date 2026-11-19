class AdvGFxTextChatComponent extends Object;

var AdvPreGameGRI AdvGRI;
var AdvPreGameLobbyPRI PRI;
var array<string> Messages;
var array<GFxObject> TextTF;
var GFxObject InputText;
var int LastVisibleLine;

function Initialize(GFxObject BaseObj, AdvPreGameLobbyPRI localPRI, AdvPreGameGRI GRI)
{
    local int I;
    local GFxObject TextField;

    AdvGRI = GRI;
    PRI = localPRI;
    // End:0x65
    if(PRI != none)
    {
        PRI.__OnPlayerMessage__Delegate = PlayerMessageReceived;
    }
    I = 1;
    J0x70:

    // End:0xF2 [Loop If]
    if(I <= 8)
    {
        TextField = GFxClikWidget(BaseObj.GetObject("text" $ string(I), Class'GFxUI.GFxClikWidget'));
        TextTF.AddItem(TextField);        
        ++I;
        // [Loop Continue]
        goto J0x70;
    }
    InputText = GFxClikWidget(BaseObj.GetObject("chatInput", Class'GFxUI.GFxClikWidget'));
    UpdateChat();
    //return;    
}

function OnChatDown()
{
    ++LastVisibleLine;
    // End:0x3A
    if(LastVisibleLine >= Messages.Length)
    {
        LastVisibleLine = Messages.Length - 1;
    }
    UpdateChat();
    //return;    
}

function OnChatUp()
{
    --LastVisibleLine;
    // End:0x6D
    if(LastVisibleLine < TextTF.Length)
    {
        // End:0x56
        if(Messages.Length < TextTF.Length)
        {
            LastVisibleLine = Messages.Length - 1;            
        }
        else
        {
            LastVisibleLine = TextTF.Length - 1;
        }
    }
    UpdateChat();
    //return;    
}

simulated function PlayerMessageReceived(string PlayerName, string PlayerMessage)
{
    // End:0x26
    if(LastVisibleLine == (Messages.Length - 1))
    {
        ++LastVisibleLine;
    }
    Messages.AddItem((("<Color:R=1.0,G=0.6,B=0.15>" $ PlayerName) $ ":</Color> ") $ PlayerMessage);    
    UpdateChat();
    //return;    
}

simulated function UpdateChat()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x107 [Loop If]
    if(I < TextTF.Length)
    {
        // End:0xC2
        if((LastVisibleLine - I) >= 0)
        {
            TextTF[I].SetBool("html", true);
            TextTF[I].SetString("htmlText", Messages[LastVisibleLine - I]);            
        }
        else
        {
            TextTF[I].SetString("htmlText", " ");
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

reliable client simulated function SendMessage()
{
    local string msg;

    // End:0xC8
    if((PRI != none) && InputText.GetInt("focused") > 0)
    {
        msg = InputText.GetText();
        // End:0xC8
        if(msg != "")
        {
            InputText.SetString("text", "");
            PRI.SendPlayerMessage(msg);
        }
    }
    //return;    
}

defaultproperties
{
    LastVisibleLine=-1
}