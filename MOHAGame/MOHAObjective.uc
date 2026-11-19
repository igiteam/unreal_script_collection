class MOHAObjective extends EALAObjective
    native
    placeable
    hidecategories(Navigation);

var(Objective) SoundCue RadioSoundCue;
var(Objective) SoundCue DiscRadioSoundCue;
var SoundCue SuccessSoundCue;
var SoundCue DefaultSoundCue;
var(Objective) float fRadioMixTime;
var(Objective) float fDiscRadioMixTime;
var transient int SavedOrder;

function EALAObjectiveManager GetObjectiveManager()
{
    // End:0x1B
    if(MOHAGameInfo(WorldInfo.Game) == none)
    {
        return none;
    }
    return MOHAGameInfo(WorldInfo.Game).GlobalObjectiveManager;
    //return ReturnValue;    
}

final function TriggerEventClassToTop(class<SequenceEvent> InClass, Actor InInstigator, int ActivateIndex)
{
    local int idx;
    local array<int> ActivateIndices;

    ActivateIndices[ActivateIndices.Length] = ActivateIndex;
    idx = 0;
    J0x19:

    // End:0x74 [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        // End:0x6A
        if(ClassIsChildOf(GeneratedEvents[idx].Class, InClass))
        {
            GeneratedEvents[idx].CheckActivate(self, InInstigator, false, ActivateIndices, true);
        }
        idx++;
        // [Loop Continue]
        goto J0x19;
    }
    //return;    
}

function FireObjectiveRestored()
{
    switch(ObjectiveStatus)
    {
        // End:0x1C
        case 1:
            TriggerEventClassToTop(Class'SeqEvent_ObjectiveRestored', self, 0);
            // End:0x4D
            break;
        // End:0x31
        case 2:
            TriggerEventClassToTop(Class'SeqEvent_ObjectiveRestored', self, 1);
            // End:0x4D
            break;
        // End:0x47
        case 3:
            TriggerEventClassToTop(Class'SeqEvent_ObjectiveRestored', self, 2);
            // End:0x4D
            break;
        // End:0xFFFF
        default:
            // End:0x4D
            break;
            break;
    }
    //return;    
}

event RestoreObjective()
{
    local MOHAObjectiveManager ObjectiveManager;

    // End:0x12
    if(int(ObjectiveStatus) == int(0))
    {
        return;
    }
    ObjectiveManager = MOHAObjectiveManager(GetObjectiveManager());
    // End:0x34
    if(ObjectiveManager == none)
    {
        return;
    }
    // End:0x4D
    if(!ObjectiveManager.AddObjectiveQuiet(self))
    {
    }
    FireObjectiveRestored();
    //return;    
}

function SoundCue GetObjectiveDiscRadioSoundCue()
{
    // End:0x14
    if(DiscRadioSoundCue != none)
    {
        return DiscRadioSoundCue;        
    }
    else
    {
        return DefaultSoundCue;
    }
    //return ReturnValue;    
}

function float GetObjectiveDiscRadioMixTime()
{
    // End:0x14
    if(DiscRadioSoundCue != none)
    {
        return fDiscRadioMixTime;        
    }
    else
    {
        return default.fDiscRadioMixTime;
    }
    //return ReturnValue;    
}

function SoundCue GetNewObjectiveRadioSoundCue()
{
    // End:0x14
    if(RadioSoundCue != none)
    {
        return RadioSoundCue;        
    }
    else
    {
        return DefaultSoundCue;
    }
    //return ReturnValue;    
}

function float GetNewObjectiveRadioMixTime()
{
    // End:0x14
    if(RadioSoundCue != none)
    {
        return fRadioMixTime;        
    }
    else
    {
        return default.fRadioMixTime;
    }
    //return ReturnValue;    
}

function SoundCue GetDefaultSoundCue()
{
    return DefaultSoundCue;
    //return ReturnValue;    
}

function SoundCue GetSuccessSoundCue()
{
    return SuccessSoundCue;
    //return ReturnValue;    
}

function float GetDefaultMixTime()
{
    return 4.0000000;
    //return ReturnValue;    
}

defaultproperties
{
    SuccessSoundCue=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned'
    DefaultSoundCue=SoundCue'Aud_GCm_FakeWAV.Items.Objective_Text'
    fRadioMixTime=4.0000000
    fDiscRadioMixTime=4.0000000
    // Reference: SpriteComponent'Default__MOHAObjective.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'MOHAEngineMaterials.Objective'
    end object
    Components[0]=Sprite
}