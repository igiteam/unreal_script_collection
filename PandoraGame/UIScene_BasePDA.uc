class UIScene_BasePDA extends UIScene_BaseFrontEnd;

struct TextPage
{
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() string pageName;
    var transient UILabel pageObj;

    structdefaultproperties
    {
        pageName=""
        pageObj=none
    }
};

/** VARIABLE DECLARATIONS */
var(PDA) array<TextPage> msgPages;
var(PDA) string lblPageUpDownName;
var noexport transient UILabel lblPageUpDown;
var transient int currPage;

event InitScene()
{
    super.InitScene();
    InitPages();
    // End:0x41
    if((myGameInfo != none) && myGameInfo.IsInShellLevel(CurrLevelName))
    {
        bPauseGameWhileActive = false;
    }
    //return;    
}

function InitPages()
{
    local int I;

    currPage = 0;
    I = 0;
    J0x0E:

    // End:0xDD [Loop If]
    if(I < msgPages.Length)
    {
        msgPages[I].pageObj = UILabel(FindChild(name(msgPages[I].pageName), true));
        // End:0xD3
        if(msgPages[I].pageObj != none)
        {
            // End:0xAD
            if(I == currPage)
            {
                msgPages[I].pageObj.SetVisibility(true);
                // [Explicit Continue]
                goto J0xD3;
            }
            msgPages[I].pageObj.SetVisibility(false);
        }
        J0xD3:

        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    lblPageUpDown = UILabel(FindChild(name(lblPageUpDownName), true));
    // End:0x124
    if((lblPageUpDown != none) && msgPages.Length > 1)
    {
        lblPageUpDown.SetVisibility(true);
    }
    //return;    
}

function PrevPage()
{
    local int I;

    // End:0x2D
    if(msgPages.Length > 1)
    {
        currPage--;
        // End:0x2D
        if(currPage < 0)
        {
            currPage = msgPages.Length - 1;
        }
    }
    I = 0;
    J0x34:

    // End:0xC8 [Loop If]
    if(I < msgPages.Length)
    {
        // End:0xBE
        if(msgPages[I].pageObj != none)
        {
            // End:0x98
            if(I == currPage)
            {
                msgPages[I].pageObj.SetVisibility(true);
                // [Explicit Continue]
                goto J0xBE;
            }
            msgPages[I].pageObj.SetVisibility(false);
        }
        J0xBE:

        I++;
        // [Loop Continue]
        goto J0x34;
    }
    //return;    
}

function NextPage()
{
    local int I;

    // End:0x2A
    if(msgPages.Length > 1)
    {
        currPage++;
        // End:0x2A
        if(currPage >= msgPages.Length)
        {
            currPage = 0;
        }
    }
    I = 0;
    J0x31:

    // End:0xC5 [Loop If]
    if(I < msgPages.Length)
    {
        // End:0xBB
        if(msgPages[I].pageObj != none)
        {
            // End:0x95
            if(I == currPage)
            {
                msgPages[I].pageObj.SetVisibility(true);
                // [Explicit Continue]
                goto J0xBB;
            }
            msgPages[I].pageObj.SetVisibility(false);
        }
        J0xBB:

        I++;
        // [Loop Continue]
        goto J0x31;
    }
    //return;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    // End:0x7F
    if(IsInputCancel(EventParms))
    {
        // End:0x6B
        if(PreviousMenuScene != none)
        {
            PlayUISound('SceneClosed');
            ActivateRemoteEvent(OnExitRemoteEventName);
            PreviousMenuScene.SetVisibility(true);
            PreviousMenuScene.FadeIn(fadeInTimeEd);
        }
        SceneClient.CloseScene(self);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x23
    if(ProcessCancelInput(EventParms))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    myPC.PlayAmBxScript("menu_pda", 0);
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    myPC.StopAmBxScript("menu_pda");
    //return;    
}
