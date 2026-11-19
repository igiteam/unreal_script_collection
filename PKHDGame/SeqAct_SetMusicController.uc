class SeqAct_SetMusicController extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var(MusicSetup) editinline array<editinline MusicTrackStruct> AmbientMusic;
var(MusicSetup) editinline array<editinline MusicTrackStruct> BattleMusic;

event Activated()
{
    local bool bNewEnabled, bForce;
    local PKGameSP Game;
    local int I;

    Game = PKGameSP(GetWorldInfo().Game);
    // End:0x43
    if(Game == none)
    {
        return;
    }
    // End:0x74
    if(InputLinks[0].bHasImpulse)
    {
        bNewEnabled = true;        
    }
    else
    {
        // End:0xA2
        if(InputLinks[1].bHasImpulse)
        {
            bNewEnabled = false;
        }
    }
    // End:0x477
    if(bNewEnabled)
    {
        bForce = (AmbientMusic.Length != Game.AmbientMusic.Length) || BattleMusic.Length != Game.BattleMusic.Length;
        I = 0;
        J0x120:

        // End:0x1F4 [Loop If]
        if((!bForce && I < AmbientMusic.Length) && I < Game.AmbientMusic.Length)
        {
            bForce = AmbientMusic[I].TheSoundCue != Game.AmbientMusic[I].TheSoundCue;
            ++I;
            // [Loop Continue]
            goto J0x120;
        }
        I = 0;
        J0x1FF:

        // End:0x2D3 [Loop If]
        if((!bForce && I < BattleMusic.Length) && I < Game.BattleMusic.Length)
        {
            bForce = BattleMusic[I].TheSoundCue != Game.BattleMusic[I].TheSoundCue;
            ++I;
            // [Loop Continue]
            goto J0x1FF;
        }
        Game.AmbientMusic.Remove(0, Game.AmbientMusic.Length);
        Game.BattleMusic.Remove(0, Game.BattleMusic.Length);
        I = 0;
        J0x35E:

        // End:0x3E5 [Loop If]
        if(I < AmbientMusic.Length)
        {
            // End:0x3D7
            if(AmbientMusic[I].TheSoundCue != none)
            {
                Game.AmbientMusic.AddItem(AmbientMusic[I]);
            }
            ++I;
            // [Loop Continue]
            goto J0x35E;
        }
        I = 0;
        J0x3F0:

        // End:0x477 [Loop If]
        if(I < BattleMusic.Length)
        {
            // End:0x469
            if(BattleMusic[I].TheSoundCue != none)
            {
                Game.BattleMusic.AddItem(BattleMusic[I]);
            }
            ++I;
            // [Loop Continue]
            goto J0x3F0;
        }
    }
    Game.SetMusicController(bNewEnabled, bForce);
    //return;    
}

defaultproperties
{
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks=none
    ObjName="Music Setup"
}