class PKStartupMessage extends UTStartupMessage;

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    return ((Rand(10) > 5) ? SoundNodeWave'a_LuciferMP.WAV.lucifer-comemychildren' : SoundNodeWave'a_LuciferMP.WAV.Lucifer_fight');
    //return ReturnValue;    
}
