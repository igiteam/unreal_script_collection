class SkyAnimBlendBySecondaryItemUse extends SkyAnimBlendBase
    native;

enum UseState
{
    US_TakeOut,                     // 0
    US_Hold,                        // 1
    US_GetRid,                      // 2
    US_MAX                          // 3
};

var transient SkyAnimBlendBySecondaryItemUse.UseState CurrentState;
