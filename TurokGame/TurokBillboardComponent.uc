class TurokBillboardComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Object,StaticMeshComponent)
    autoexpandcategories(Collision,Rendering,Lighting);

var(Generation) float mWidth;
var(Generation) float mHeight;
var @NULL mBillboardData;
var int mSerializeVersion;
var bool sDisplayBillboard;

defaultproperties
{
    mWidth=50.0000000
    mHeight=100.0000000
    mSerializeVersion=-1
    sDisplayBillboard=true
    bAcceptsDecals=false
    bAcceptsDecalsDuringGameplay=false
    bCastDynamicShadow=false
    LightingChannels=(bInitialized=true,BSP=true,Static=true)
}