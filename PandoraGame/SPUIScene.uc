class SPUIScene extends UIScene
    native;

var SoundCue SoundScroll;
var SoundCue SoundConfirm;
var float FadeTime;
var(Presentation) const float fadeInTimeEd;
var(Presentation) const float fadeOutTimeEd;
var(Presentation) const float fadeDelayTime;
var(Flags) bool bFadeIn;
var(Flags) bool bFadeOut;
var bool bFadeInactive;
var(Presentation) float InactiveFadeValue;
var(Presentation) float FadeInactiveTime;
var float FadeInactiveStart;
var float FadeStartValue;
/** A list of font pools associated with this scene */
var(Fonts) editinlineuse array<editinlineuse SPFontPool> SceneFontPool;

// Export USPUIScene::execGetFontPool(FFrame&, void* const)
native function SPFontPool GetFontPool(name FontTag);

// Export USPUIScene::execFadeIn(FFrame&, void* const)
native function FadeIn(float FadeInTime, optional float FadeInDelay);

// Export USPUIScene::execFadeOut(FFrame&, void* const)
native function FadeOut(float FadeOutTime, optional float FadeOutDelay);

// Export USPUIScene::execChildFadeIn(FFrame&, void* const)
native function ChildFadeIn(UIObject Obj, float FadeInTime, optional float FadeInDelay);

// Export USPUIScene::execChildFadeOut(FFrame&, void* const)
native function ChildFadeOut(UIObject Obj, float FadeOutTime, optional float FadeOutDelay);

// Export USPUIScene::execPtIntersectsUIObject(FFrame&, void* const)
native function bool PtIntersectsUIObject(UIObject Obj, float X, float Y);

// Export USPUIScene::execGetPandoraPlayerOwner(FFrame&, void* const)
native function PandoraPlayerController GetPandoraPlayerOwner(optional int Index);

// Export USPUIScene::execStringToName(FFrame&, void* const)
native function name StringToName(string Str);

event QuickMenuUpdate()
{
    local PandoraPlayerController PC;

    PC = GetPandoraPlayerOwner();
    // End:0x45
    if((PC != none) && PC.bQuickMenuOn)
    {
        PC.QuickMenuUpdate();
    }
    //return;    
}

event FadeCompleted()
{
    // End:0x1D
    if(Opacity <= 0.0000000)
    {
        SetVisibility(false);        
    }
    else
    {
        SetVisibility(true);
    }
    //return;    
}

function bool IsFadeIn()
{
    return bFadeIn;
    //return ReturnValue;    
}

function bool IsFadeOut()
{
    return bFadeOut;
    //return ReturnValue;    
}

function FadeInactive()
{
    // End:0x2D
    if(FadeInactiveTime > 0.0000000)
    {
        bFadeInactive = true;
        FadeInactiveStart = 0.0000000;
        FadeStartValue = Opacity;
    }
    //return;    
}

final function string TrimWhitespace(string InString)
{
    local int StartIdx, EndIdx;
    local string FinalString;

    StartIdx = 0;
    J0x07:

    // End:0x3B [Loop If]
    if(StartIdx < Len(InString))
    {
        // End:0x31
        if(Asc(Mid(InString, StartIdx, 1)) != 32)
        {
            // [Explicit Break]
            goto J0x3B;
        }
        StartIdx++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x3B:

    EndIdx = Len(InString) - 1;
    J0x4B:

    // End:0x79 [Loop If]
    if(EndIdx >= 0)
    {
        // End:0x6F
        if(Asc(Mid(InString, EndIdx, 1)) != 32)
        {
            // [Explicit Break]
            goto J0x79;
        }
        EndIdx--;
        // [Loop Continue]
        goto J0x4B;
    }
    J0x79:

    // End:0xA9
    if(StartIdx <= EndIdx)
    {
        FinalString = Mid(InString, StartIdx, (EndIdx - StartIdx) + 1);
    }
    return FinalString;
    //return ReturnValue;    
}

final function string StripInvalidUsernameCharacters(string UserName)
{
    UserName = TrimWhitespace(UserName);
    UserName = Repl(UserName, "?", "");
    UserName = Repl(UserName, "'", "");
    return UserName;
    //return ReturnValue;    
}

static function ShowScreenWarningMessage(string Message)
{
    local SPGameUISceneClient SceneClient;

    SceneClient = SPGameUISceneClient(GetSceneClient());
    // End:0x1E
    if(SceneClient == none)
    {
        return;
    }
    // End:0x44
    if(!IsConsole(1))
    {
        SceneClient.ShowScreenWarningMessage(Message);
    }
    //return;    
}

static function ClearScreenWarningMessage()
{
    local SPGameUISceneClient SceneClient;

    SceneClient = SPGameUISceneClient(GetSceneClient());
    // End:0x1E
    if(SceneClient == none)
    {
        return;
    }
    // End:0x3F
    if(!IsConsole(1))
    {
        SceneClient.ClearScreenWarningMessage();
    }
    //return;    
}
