class SkyPawn_Boss extends SkyPawn
    native
    config(Game);

enum E_BOSS_MODE
{
    BOSS_MODE_DEFAULT,              // 0
    BOSS_MODE_SPECIAL_MOVE_1,       // 1
    BOSS_MODE_SPECIAL_MOVE_2,       // 2
    BOSS_MODE_SPECIAL_MOVE_3,       // 3
    BOSS_PAWN_ATTACKING_PRIMARY,    // 4
    BOSS_PAWN_ATTACKING_SECONDARY,  // 5
    BOSS_MAX                        // 6
};

var transient bool bLastPrimaryAttackCausedDamage;
var transient bool bLastSecondaryAttackCausedDamage;
var transient MaterialInstanceConstant MatInstConst;
var export editinline AudioComponent AmbientSound;
var(Sounds) SoundCue AmbientLoopingSound;
var(Sounds) name AmbientLoopingSoundSocket;
var SkyPawn_Boss.E_BOSS_MODE BossMode;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x40
    if(AmbientSound != none)
    {
        AmbientSound.SoundCue = AmbientLoopingSound;
        Mesh.AttachComponentToSocket(AmbientSound, AmbientLoopingSoundSocket);
    }
    //return;    
}

auto state Start_State
{Begin:

    GotoState('Boss_Idle');
    stop;        
}

state Boss_Idle
{Begin:

    Sleep(0.2500000);
    goto 'Begin';
    stop;        
}
