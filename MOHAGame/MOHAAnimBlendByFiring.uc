class MOHAAnimBlendByFiring extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum EBlendByFireIndices
{
    BBFIRE_NOTFIRING,               // 0
    BBFIRE_FIRING,                  // 1
    BBFIRE_MAX                      // 2
};

var() float BlendTime;

defaultproperties
{
    bPlayActiveChild=true
    Children=/* Array type was not detected. */
}