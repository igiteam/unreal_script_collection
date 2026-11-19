class TurokSkeletonInVolumeWatcher extends Info
    native
    hidecategories(Navigation,Movement,Collision);

var() array mBoneNames;

// Export UTurokSkeletonInVolumeWatcher::execIsPointInSkelVolume(FFrame&, void* const)
native function int IsPointInSkelVolume(@NULL Point, @NULL Volume);

function Tick(float DeltaTime)
{
    local @NULL TurokPawn, skelVolume;
    local int boneCount;
    local @NULL BoneLocation;
    local int testResult;

    TurokPawn = TurokPawn(Owner);
    // End:0xF9
    if((TurokPawn != none) && !TurokPawn.bDeleteMe)
    {
        // End:0xF9
        if(mBoneNames.Length > 0)
        {
            // End:0xF8
            foreach AllActors(Class'TurokSkeletalVolume', skelVolume)
            {
                // End:0xF7
                if(skelVolume.mbVolumeEnabled)
                {
                    boneCount = 0;
                    J0x66:

                    // End:0xF7 [Loop If]
                    if(boneCount < mBoneNames.Length)
                    {
                        BoneLocation = TurokPawn.Mesh.GetBoneLocation(mBoneNames[boneCount]);
                        testResult = IsPointInSkelVolume(BoneLocation, skelVolume);
                        // End:0xED
                        if(testResult != 0)
                        {
                            TurokPawn.NotifySkelInVolume(skelVolume, mBoneNames[boneCount], BoneLocation);
                        }
                        boneCount++;
                        // [Loop Continue]
                        goto J0x66;
                    }
                }                
            }            
        }
    }
    //return;    
}

event Destroyed()
{
    super(Actor).Destroyed();
    //return;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokSkeletonInVolumeWatcher.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}