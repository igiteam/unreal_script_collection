class MOHADrawGlassComponentNative extends PrimitiveComponent
    abstract
    native
    editinlinenew
    hidecategories(Object,Advanced,Collision,Physics);

var private native const Pointer mParts;
var private native const Pointer mpGlassRender;
var private native const Pointer mpAdapter;
var private native int mPartsNbH;
var private native int mPartsNbV;
var private native float mPaneSize;
var private native int mPanesAlive;
var private native Vector mTopLeft;
var private native Vector mRight;
var private native Vector mDown;
var private native Vector mOut;
var private native int mHitsNb;
var private native float mPlaneD;
var private native bool mSupported;
var private native bool mMarked;
var() MaterialInstance Material;
var() float GlassWidth;
var() float GlassHeight;
var() float PaneSize;
var() float MaxImpulse;
var() float MainImpulse;
var() float MainXResist;
var() float SecondImpulse;
var() float SecondXResist;
var() float SecondYResist;
var() float MainYPosResist;
var() float MainYNegResist;
var() float RandomQuotaMainImpulse;
var() float RandomQuotaSecondImpulse;

// Export UMOHADrawGlassComponentNative::execOnTick(FFrame&, void* const)
native function OnTick(float DeltaTime, Vector PlayerPosition);

// Export UMOHADrawGlassComponentNative::execOnWhizEvent(FFrame&, void* const)
native function OnWhizEvent(Vector From, Vector To, float Speed, SoundCue Sound);

// Export UMOHADrawGlassComponentNative::execInitGlass(FFrame&, void* const)
native function InitGlass();

// Export UMOHADrawGlassComponentNative::execRegisterWhiz(FFrame&, void* const)
native function RegisterWhiz();

// Export UMOHADrawGlassComponentNative::execBlowOut(FFrame&, void* const)
native function BlowOut(Vector Direction);

defaultproperties
{
    GlassWidth=256.0000000
    GlassHeight=256.0000000
    PaneSize=25.0000000
    MaxImpulse=10.0000000
    MainImpulse=20.0000000
    MainXResist=15.0000000
    SecondImpulse=2.0000000
    SecondXResist=2.5000000
    SecondYResist=2.5000000
    MainYPosResist=15.0000000
    MainYNegResist=15.0000000
    RandomQuotaMainImpulse=1.0000000
    RandomQuotaSecondImpulse=1.0000000
    CullDistance=10000.0000000
    bAllowApproximateOcclusion=true
    bAcceptsDecalsDuringGameplay=false
    bCastDynamicShadow=false
    bAcceptsLights=true
    bAcceptsDynamicLights=false
}