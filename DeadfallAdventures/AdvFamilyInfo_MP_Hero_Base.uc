class AdvFamilyInfo_MP_Hero_Base extends AdvFamilyInfo_MainHero;

var int TeamIndex;
var string SkinType;
var array<SoundCue> ReloadShouts;
var array<SoundCue> GrenadeShouts;
var array<SoundCue> DynamiteShouts;
var AdvClassInfo_MP_Base.EThrowWeaponType ThrowWeaponType;

static function int getTeamIndex()
{
    return default.TeamIndex;
    //return ReturnValue;    
}

defaultproperties
{
    AnimSets[0]=AnimSet'an_MainHero.AS_MainHero_01'
    AnimSets[1]=AnimSet'an_MainHero.Anims.AS_MainHero_AimOffsets'
    AnimSets[2]=AnimSet'an_MainHero.AS_MainHero_PST'
    AnimSets[3]=AnimSet'an_Common.AS_AimOffsets'
    AnimSets[4]=AnimSet'an_Common.AS_Character_Death'
    AnimSets[5]=AnimSet'an_marshall.Anim.an_Marshall_01'
    AnimSets[6]=AnimSet'an_MainHero.as_Multiplayer_Mummy_01'
    SoundGroupClass=Class'AdvPawnSoundGroupMP_Default'
}