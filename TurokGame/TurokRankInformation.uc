class TurokRankInformation extends Object
    native;

struct native TextureDimensions
{
    var float mX;
    var float mY;
    var float mWidth;
    var float mHeight;

    structdefaultproperties
    {
        mX=0.0000000
        mY=0.0000000
        mWidth=0.0000000
        mHeight=0.0000000
    }
};

struct native IconChevronDimensions
{
    var @NULL mDimensions;
    var float mDevicePosX;
    var float mDevicePosY;

    structdefaultproperties
    {
        mDimensions=(mX=0.0000000,mY=0.0000000,mWidth=0.0000000,mHeight=0.0000000)
        mDevicePosX=0.0000000
        mDevicePosY=0.0000000
    }
};

struct native IconDeviceDimensions
{
    var @NULL mDimensions;
    var float mChevronOffsetX;
    var float mChevronOffsetY;

    structdefaultproperties
    {
        mDimensions=(mX=0.0000000,mY=0.0000000,mWidth=0.0000000,mHeight=0.0000000)
        mChevronOffsetX=0.0000000
        mChevronOffsetY=0.0000000
    }
};

var array mChevronIcons;
var array mDeviceIcons;
var array mTeamIcons;
var @NULL mDeadIcon;
var @NULL mIconTexture;
var const array kRankTitleHashes;

// Export UTurokRankInformation::execDrawDeadIcon(FFrame&, void* const)
native function DrawDeadIcon(@NULL pHud, const int kX, const int kY, const float kScale);

// Export UTurokRankInformation::execDrawTeamIcon(FFrame&, void* const)
native function DrawTeamIcon(@NULL pHud, const int kTeamIndex, const int kX, const int kY, const float kScale);

// Export UTurokRankInformation::execDrawRankIcon(FFrame&, void* const)
native function DrawRankIcon(@NULL pHud, const int kRank, const int kX, const int kY, const float kScale);

// Export UTurokRankInformation::execSetRankIcon(FFrame&, void* const)
native function SetRankIcon(@NULL pRankImage, @NULL pDeviceImage, const int kRank, const int kX, const int kY, const float kScale);

// Export UTurokRankInformation::execGetChevronIndexFromRank(FFrame&, void* const)
native function int GetChevronIndexFromRank(const int kRank);

// Export UTurokRankInformation::execGetDeviceIndexFromRank(FFrame&, void* const)
native function int GetDeviceIndexFromRank(const int kRank);

// Export UTurokRankInformation::execGetChevronDimensionsByRank(FFrame&, void* const)
native function @NULL GetChevronDimensionsByRank(const int kRank);

// Export UTurokRankInformation::execGetDeviceDimensionsByRank(FFrame&, void* const)
native function @NULL GetDeviceDimensionsByRank(const int kRank);

// Export UTurokRankInformation::execGetDimensionsForRank(FFrame&, void* const)
native function GetDimensionsForRank(const int kRank, const float kScale, out @NULL dimensions);

// Export UTurokRankInformation::execGetDimensionsForTeam(FFrame&, void* const)
native function GetDimensionsForTeam(const int kTeam, const float kScale, out @NULL dimensions);

// Export UTurokRankInformation::execGetDimensionsForDeadIcon(FFrame&, void* const)
native function GetDimensionsForDeadIcon(const float kScale, out @NULL dimensions);

defaultproperties
{
    mChevronIcons=/* Array type was not detected. */
    mDeviceIcons=/* Array type was not detected. */
    mTeamIcons=/* Array type was not detected. */
    mDeadIcon=(mX=152.0000000,mY=12.0000000,mWidth=70.0000000,mHeight=69.0000000)
    mIconTexture=Texture2D'TurokHudMultiplayer.RankIcons_HD'
    kRankTitleHashes=/* Array type was not detected. */
}