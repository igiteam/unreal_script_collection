class SeqAct_PostProcessBase extends SequenceAction
    abstract
    forcescriptorder(true)
    hidecategories(Object);

function GetPostProcessEffects(out array<PostProcessEffect> PostProcessEffects, name PostProcessEffectName, optional Class MatchingPostProcessEffectClass = Class'Engine.PostProcessEffect')
{
    local WorldInfo WorldInfo;
    local PostProcessEffect PostProcessEffect;
    local PlayerController PlayerController;
    local LocalPlayer LocalPlayer;

    WorldInfo = GetWorldInfo();
    // End:0x195
    if(WorldInfo != none)
    {
        // End:0x194
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PlayerController)
        {
            LocalPlayer = LocalPlayer(PlayerController.Player);
            // End:0x193
            if((LocalPlayer != none) && LocalPlayer.PlayerPostProcess != none)
            {
                PostProcessEffect = LocalPlayer.PlayerPostProcess.FindPostProcessEffect(PostProcessEffectName);
                // End:0x193
                if((PostProcessEffect != none) && (PostProcessEffect.Class == MatchingPostProcessEffectClass) || ClassIsChildOf(PostProcessEffect.Class, MatchingPostProcessEffectClass))
                {
                    PostProcessEffects.AddItem(PostProcessEffect);                    
                }
            }            
        }        
    }
    //return;    
}

function EvilPlayerController GetEPC()
{
    local WorldInfo WorldInfo;
    local PlayerController PlayerController;
    local LocalPlayer LocalPlayer;

    WorldInfo = GetWorldInfo();
    // End:0xC7
    if(WorldInfo != none)
    {
        // End:0xC6
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PlayerController)
        {
            LocalPlayer = LocalPlayer(PlayerController.Player);
            // End:0xC5
            if((LocalPlayer != none) && EvilPlayerController(PlayerController) != none)
            {                
                return EvilPlayerController(PlayerController);
            }            
        }        
    }
    return none;
    //return ReturnValue;    
}

event Activated()
{
    //return;    
}

defaultproperties
{
    ObjName="SeqAct_PostProcessBase"
}