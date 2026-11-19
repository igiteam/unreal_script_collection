class TurokFEBootFlowIntro extends TurokUISceneController
    native;

var bool bBlockInput;
var @NULL TheBG;
var float fTimer;
var @NULL mFEAudio;
var @NULL Movie;
var @NULL mMovieTexture;

// Export UTurokFEBootFlowIntro::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCInitialized()
{
    local class<Class> FEAudioClass;
    local @NULL script, anim_clr;

    anim_clr.R = byte(255);
    anim_clr.G = byte(255);
    anim_clr.B = byte(255);
    anim_clr.A = 0;
    bBlockInput = true;
    FEAudioClass = class<TurokFEAudio>(DynamicLoadObject("TurokEngine.TurokFEAudio", Class'Core.Class'));
    // End:0xA2
    if(FEAudioClass != none)
    {
        mFEAudio = new (self) FEAudioClass;
    }
    TheBG = UIImage(Scene.FindChild(name("BGImage")));
    // End:0x24B
    if(TheBG != none)
    {
        Class'TurokEngine.TurokUI'.static.InitScriptCtrl(TheBG);
        // End:0x24B
        if(TheBG.ScriptCtrl != none)
        {
            script = Class'TurokEngine.TurokUI'.static.AddScript(TheBG, "intro");
            // End:0x197
            if(script != none)
            {
                script.AddColorKey(0.0000000, anim_clr);
                anim_clr.A = byte(255);
                script.AddColorKey(1.0000000, anim_clr).SetDelegate(IntroComplete);
            }
            script = Class'TurokEngine.TurokUI'.static.AddScript(TheBG, "exit");
            // End:0x22C
            if(script != none)
            {
                script.AddColorKey(0.0000000, anim_clr);
                anim_clr.A = 0;
                script.AddColorKey(1.0000000, anim_clr).SetDelegate(ExitComplete);
            }
            Class'TurokEngine.TurokUI'.static.PlayScript(TheBG, "intro");
        }
    }
    //return;    
}

event SCTick(float DeltaTime)
{
    fTimer += DeltaTime;
    // End:0x32
    if((fTimer >= 5.0000000) && !bBlockInput)
    {
        CloseMenu();
    }
    // End:0x74
    if((TheBG != none) && TheBG.ScriptCtrl != none)
    {
        TheBG.ScriptCtrl.Tick(TheBG);
    }
    //return;    
}

event SCCleanUpOnExit()
{
    mFEAudio = none;
    // End:0x29
    if(TheBG != none)
    {
        TheBG.ScriptCtrl = none;
        TheBG = none;
    }
    SceneClient = none;
    //return;    
}

event bool SCInputKey_LogoVideo(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    // End:0x0B
    if(bBlockInput)
    {
        return true;
    }
    EatInput = false;
    // End:0x52
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x36
            case 'XboxTypeS_A':
            // End:0x4F
            case 'Enter':
                CloseMenu();
                // End:0x52
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return EatInput;
        //return ReturnValue;        
    }
}

function IntroComplete()
{
    bBlockInput = false;
    //return;    
}

function ExitComplete()
{
    SceneClient.OpenSceneController("MainMenu", 0);
    //return;    
}

function CloseMenu()
{
    bBlockInput = true;
    // End:0x31
    if(TheBG != none)
    {
        Class'TurokEngine.TurokUI'.static.PlayScript(TheBG, "exit");
    }
    //return;    
}

defaultproperties
{
    SceneName="TurokFEBootFlow.Intro.Intro"
}