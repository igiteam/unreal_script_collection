class TurokCheckpointVolume extends Volume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,CheckpointVolume);

var private array mPlayerIds;

// Export UTurokCheckpointVolume::execRegisterController(FFrame&, void* const)
native function RegisterController(@NULL Controller);

// Export UTurokCheckpointVolume::execDeregisterController(FFrame&, void* const)
native function DeregisterController(@NULL Controller);

function Reset()
{
    super(Actor).Reset();
    mPlayerIds.Length = 0;
    //return;    
}

event Touch(@NULL Actor, @NULL HitLocation, @NULL HitNormal)
{
    // End:0x85
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x62
        if((Pawn(Actor) != none) && TurokPlayerController(Pawn(Actor).Controller) != none)
        {
            RegisterController(TurokPlayerController(Pawn(Actor).Controller));
        }
        // End:0x85
        if(HaveAllPlayersTouchedVolume())
        {
            TriggerEventClass(Class'TurokSeqEvent_CheckpointTouch', Actor);
        }
    }
    //return;    
}

event UnTouch(@NULL Actor)
{
    // End:0x33
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x33
        if(HaveAllPlayersTouchedVolume())
        {
            TriggerEventClass(Class'TurokSeqEvent_CheckpointTouch', Actor);
        }
    }
    //return;    
}

function bool ()
{
    local @NULL C;

    // End:0x49
    foreach WorldInfo.AllControllers(Class'TurokPlayerController', C)
    {
        // End:0x48
        if(mPlayerIds.Find(self) == @NULL)
        {
            @NULL
            /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
                
            */

            /*@Error*/;
            // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
            // 3 & Type:Switch Position:0x02F
            // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
            // 3 & Type:Switch Position:0x02F
}

defaultproperties
{
    // Reference: BrushComponent'Default__TurokCheckpointVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    bAlwaysRelevant=true
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
    SupportedEvents=/* Array type was not detected. */
}