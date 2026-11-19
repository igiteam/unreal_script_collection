class PKPlayerSoundGroup extends EvilPlayerSoundGroup;

var SoundCue MPJumpingSound;

static function SoundCue GetJumpSound(name MaterialType)
{
    // End:0x68
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && default.MPJumpingSound != none)
    {
        return default.MPJumpingSound;
    }
    return default.DefaultJumpingSound;
    //return ReturnValue;    
}

static function bool PlayTakeHitSound(Pawn P, int Damage, class<DamageType> DamageType)
{
    // End:0x4A
    if(ClassIsChildOf(DamageType, Class'EvilGame.EvilDmgType_Melee'))
    {
        P.PlaySound(default.HitSounds[0]);        
    }
    else
    {
        // End:0x95
        if(ClassIsChildOf(DamageType, Class'PKDmgType_NunSpell'))
        {
            P.PlaySound(default.HitSounds[2]);            
        }
        else
        {
            // End:0x176
            if((((ClassIsChildOf(DamageType, Class'PKDmgType_SMG') || ClassIsChildOf(DamageType, Class'PKDmgType_Uzi')) || ClassIsChildOf(DamageType, Class'PKDmgType_Stake')) || ClassIsChildOf(DamageType, Class'PKDmgType_StakeBurning')) || ClassIsChildOf(DamageType, Class'PKDmgType_Bolt'))
            {
                P.PlaySound(default.HitSounds[1]);
                P.PlaySound(default.HitSounds[0]);                
            }
            else
            {
                // End:0x1F5
                if((ClassIsChildOf(DamageType, Class'PKDmgType_Poison') || ClassIsChildOf(DamageType, Class'PKDmgType_PoisonSlowdown')) || ClassIsChildOf(DamageType, Class'PKDmgType_PoisonDrowning'))
                {
                    P.PlaySound(default.HitSounds[2]);                    
                }
                else
                {
                    // End:0x23B
                    if(DamageType != Class'Engine.DmgType_Fell')
                    {
                        P.PlaySound(default.HitSounds[0]);
                    }
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

static function PlayDyingSound(Pawn P)
{
    P.PlaySound(default.DyingSound);
    //return;    
}

defaultproperties
{
    MPJumpingSound=SoundCue'a_PlayerMP.Cue.Jump'
    DefaultJumpingSound=SoundCue'a_Player.Cue.hero_jump'
    FallingDamageLandSound=SoundCue'a_Player.Cue.hero_jumpend'
    DyingSound=SoundCue'a_Player.Cue.hero_death'
    HitSounds[0]=SoundCue'a_Player.Cue.hero_hurt'
    HitSounds[1]=SoundCue'a_ImpactsFlesh.Cue.bullet-body'
    HitSounds[2]=SoundCue'a_Player.Cue.hero_poison'
}