class TurokAnimImpactSystem extends Object
    native
    editinlinenew;

struct native ImpactAttachmentInfo
{
    var bool mEnabled;
    var byte mBodyPart;
    var export editinline @NULL mComponent;

    structdefaultproperties
    {
        mEnabled=false
        mBodyPart=0
        mComponent=none
    }
};

var() @NULL mTemplate;
var array mAttachments;

// Export UTurokAnimImpactSystem::execAttachComponentToHitRegion(FFrame&, void* const)
native function AttachComponentToHitRegion(@NULL Component, byte hitRegion);

function (byte hitRegion)
{
    local int Index;

    Index = mAttachments.Find(, @NULL);
    @NULL
    @NULL
    Index
    0    
    mAttachments[Index].mEnabled = true;
    //return;    
    @NULL
    default.@NULL
    @NULL
}

function (byte hitRegion)
{
    local int Index;

    Index = mAttachments.Find(, @NULL);
    @NULL
    @NULL
    Index
    0    
    mAttachments[Index].mEnabled = false;
    //return;    
    @NULL
    default.@NULL
    @NULL
}
