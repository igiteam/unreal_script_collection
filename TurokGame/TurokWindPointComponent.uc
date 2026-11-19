class TurokWindPointComponent extends ActorComponent
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native TurokWindPointSettings
{
    var private @NULL mSourcePosition;
    var float mForce;
    var float mSpeed;
    var float mGustLength;
    var float mTimeBetweenGusts;

    structdefaultproperties
    {
        mSourcePosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mForce=6000000.0000000
        mSpeed=400.0000000
        mGustLength=200.0000000
        mTimeBetweenGusts=0.5000000
    }
};

var(WindSettings) editinline @NULL mSettings;
var(WindSettings) @NULL mRelativeOffset;

defaultproperties
{
    mSettings=(mSourcePosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),mForce=6000000.0000000,mSpeed=400.0000000,mGustLength=200.0000000,mTimeBetweenGusts=0.5000000)
}