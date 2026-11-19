class TurokCollectable extends Actor
    abstract
    native
    placeable
    hidecategories(Navigation);

var @NULL mCollectVolume;
var @NULL mBoxSize;
var bool mPickedUp;
var int mPickUpHash;
var int mCollectedHash;
var @NULL mCollectedImage;
var @NULL mImageUV;
var @NULL mImageSize;
var export editinline @NULL mCollectableMesh;
var(Collectable) int mCollectableId;

function SaveGame(@NULL PC)
{
    local @NULL db;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0x71
    if((db != none) && db.GetSignedInProfile() != none)
    {
        PC.WritePersonalStats(db.GetSignedInProfile());
        db.WriteSignedInProfile(None);
    }
    //return;    
}

// Export UTurokCollectable::execGetSaveBitfieldFromProfile(FFrame&, void* const)
native static function int GetSaveBitfieldFromProfile(@NULL Profile);

// Export UTurokCollectable::execGetSaveBitfield2FromProfile(FFrame&, void* const)
native static function int GetSaveBitfield2FromProfile(@NULL Profile);

simulated event PostBeginPlay()
{
    CheckIfAlreadyPickedUp();
    //return;    
}

function CheckIfAlreadyPickedUp()
{
    local int saveField, collectableIdField;
    local @NULL db, Profile;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0xB7
    if(db != none)
    {
        Profile = TurokOnlineProfile(db.GetSignedInProfile());
        // End:0xB7
        if(Profile != none)
        {
            // End:0x74
            if(mCollectableId <= 31)
            {
                saveField = GetSaveBitfieldFromProfile(Profile);
                collectableIdField = mCollectableId;                
            }
            else
            {
                saveField = GetSaveBitfield2FromProfile(Profile);
                collectableIdField = mCollectableId - 31;
            }
            // End:0xB7
            if(((1 << collectableIdField) & saveField) != 0)
            {
                DisableCollectable();
            }
        }
    }
    //return;    
}

function DisableCollectable()
{
    mPickedUp = true;
    mCollectVolume.mPickedUp = true;
    HideCollectable();
    //return;    
}

function HideCollectable()
{
    mCollectableMesh.SetHidden(true);
    //return;    
}

event PickedUp()
{
    //return;    
}

defaultproperties
{
    mBoxSize=(X=256.0000000,Y=256.0000000,Z=256.0000000)
    // Reference: StaticMeshComponent'Default__TurokCollectable.MeshComponent0'
    begin object name=MeshComponent0 class=Class'Engine.StaticMeshComponent'
        DisableRigidBodySupport=true
        CullDistance=4000.0000000
        CollideActors=false
    end object
    mCollectableMesh=MeshComponent0
    Components[0]=MeshComponent0
}