class SPMaterialEffectSingle extends Actor
    notplaceable;

var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;
var Canvas m_Canvas;
var Material m_MaterialEffect;
var MaterialInstanceConstant m_MaterialEffectConstant;
var bool m_bMaterialActive;

function DBG_MsgEM(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

function PostBeginPlay()
{
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    CreateMaterialEffect();
    //return;    
}

function Tick(float DeltaTime)
{
    //return;    
}

function CreateMaterialEffect()
{
    //return;    
}
