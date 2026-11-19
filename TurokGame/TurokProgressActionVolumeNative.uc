class TurokProgressActionVolumeNative extends TurokActionVolume
    abstract
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

var private bool mEnabled;
var private bool mInitialEnabled;
var private int mControllerCount;
var init private array mPlayerIds;
var class<Class> mProgressMessageClass;

function PostBeginPlay()
{
    mInitialEnabled = mEnabled;
    //return;    
}

function Reset()
{
    mEnabled = mInitialEnabled;
    super(Actor).Reset();
    //return;    
}

event bool IsEnabled()
{
    return mEnabled;
    //return ReturnValue;    
}

event SetEnableStatus(bool IsEnabled)
{
    mEnabled = IsEnabled;
    //return;    
}

// Export UTurokProgressActionVolumeNative::execRegisterController(FFrame&, void* const)
native function RegisterController(@NULL Controller);

// Export UTurokProgressActionVolumeNative::execDeregisterController(FFrame&, void* const)
native function DeregisterController(@NULL Controller);

// Export UTurokProgressActionVolumeNative::execIsOccupied(FFrame&, void* const)
native function bool IsOccupied();

// Export UTurokProgressActionVolumeNative::execGetNumPlayersInVolume(FFrame&, void* const)
native function int GetNumPlayersInVolume();

// Export UTurokProgressActionVolumeNative::execIsPlayerInVolume(FFrame&, void* const)
native function bool IsPlayerInVolume(int PlayerID);

// Export UTurokProgressActionVolumeNative::execNotifyMatchStarted(FFrame&, void* const)
native function NotifyMatchStarted();

// Export UTurokProgressActionVolumeNative::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

// Export UTurokProgressActionVolumeNative::execIsLookingRightDirection(FFrame&, void* const)
native function bool IsLookingRightDirection(@NULL Controller);

defaultproperties
{
    mEnabled=true
    mAllowMultipleActors=true
    // Reference: DrawSphereComponent'Default__TurokProgressActionVolumeNative.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    // Reference: BrushComponent'Default__TurokProgressActionVolumeNative.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    bAlwaysRelevant=true
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
    SupportedEvents=/* Array type was not detected. */
}