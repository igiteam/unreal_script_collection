class UTMutator extends Mutator
    abstract
    hidecategories(Navigation,Movement,Collision);

function bool MutatorIsAllowed()
{
    return (EvilGame(WorldInfo.Game) != none) && super.MutatorIsAllowed();
    //return ReturnValue;    
}

function UTMutator GetNextUTMutator()
{
    local Mutator M;
    local UTMutator UTMut;

    M = NextMutator;
    J0x13:

    // End:0x82 [Loop If]
    if(M != none)
    {
        UTMut = UTMutator(M);
        // End:0x57
        if(UTMut != none)
        {
            return UTMut;
        }
        M = M.NextMutator;
        // [Loop Continue]
        goto J0x13;
    }
    return none;
    //return ReturnValue;    
}

function bool ReplaceWith(Actor Other, string aClassName)
{
    local Actor A;
    local class<Actor> aClass;
    local PickupFactory OldFactory, NewFactory;

    // End:0x12
    if(aClassName == "")
    {
        return true;
    }
    aClass = class<Actor>(DynamicLoadObject(aClassName, Class'Core.Class'));
    // End:0x182
    if(aClass != none)
    {
        A = Spawn(aClass, Other.Owner,, Other.Location, Other.Rotation);
        // End:0x182
        if(A != none)
        {
            OldFactory = PickupFactory(Other);
            NewFactory = PickupFactory(A);
            // End:0x182
            if((OldFactory != none) && NewFactory != none)
            {
                OldFactory.ReplacementFactory = NewFactory;
                NewFactory.OriginalFactory = OldFactory;
            }
        }
    }
    return A != none;
    //return ReturnValue;    
}

function ProcessSpeechRecognition(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words)
{
    local UTMutator UTMut;

    UTMut = GetNextUTMutator();
    // End:0x54
    if(UTMut != none)
    {
        UTMut.ProcessSpeechRecognition(Speaker, Words);
    }
    //return;    
}
