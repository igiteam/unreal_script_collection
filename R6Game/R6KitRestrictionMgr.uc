class R6KitRestrictionMgr extends Object
    native;

const MAX_KIT_RESTRICTIONS = 5;

enum eKitRestrCat
{
    eKitRestrCat_PISTOLS,           // 0
    eKitRestrCat_SMGS,              // 1
    eKitRestrCat_ASSAULT,           // 2
    eKitRestrCat_SHOTGUNS,          // 3
    eKitRestrCat_LMGS,              // 4
    eKitRestrCat_SNIPER,            // 5
    eKitRestrCat_EXPLOSIVES,        // 6
    eKitRestrCat_GADGETS,           // 7
    eKitRestrCat_MAX                // 8
};

struct R6KitRestrictionList
{
    var array<R6KitRestrictionInfo> m_array;

    structdefaultproperties
    {
        m_array=none
    }
};

var bool m_bInit;
var array<R6KitRestrictionList> m_FullKitRestrictionList;
var array<R6KitRestrictionInfo> m_arKitRestrictions;
