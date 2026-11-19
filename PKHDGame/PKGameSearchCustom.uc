class PKGameSearchCustom extends PKGameSearchCommon;

struct PendingORFilter
{
    var string Id;
    var OnlineGameSearch.EOnlineGameSearchEntryType Type;
    var OnlineGameSearch.EOnlineGameSearchComparisonType Operator;
    var string Value;
    var bool bRawFilter;

    structdefaultproperties
    {
        Id=""
        Type=EOnlineGameSearchEntryType.OGSET_Property
        Operator=EOnlineGameSearchComparisonType.OGSCT_Equals
        Value=""
        bRawFilter=false
    }
};

struct PendingANDFilter
{
    var array<PendingORFilter> ORFilters;
    var name GroupName;

    structdefaultproperties
    {
        ORFilters=none
        GroupName="None"
    }
};

var array<PendingANDFilter> PendingFilters;

function name AddANDFilter(optional name GroupName)
{
    local int I;

    // End:0x41
    if(GroupName == 'None')
    {
        GroupName = name("PendingFilter" $ string(PendingFilters.Length));
    }
    // End:0xC5
    if(PendingFilters.Find('GroupName', GroupName) == -1)
    {
        I = PendingFilters.Length;
        PendingFilters.Length = I + 1;
        PendingFilters[I].GroupName = GroupName;
    }
    return GroupName;
    //return ReturnValue;    
}

function AddORFilter(name GroupName, coerce string FilterId, OnlineGameSearch.EOnlineGameSearchEntryType FilterType, OnlineGameSearch.EOnlineGameSearchComparisonType FilterOperator, coerce string FilterValue)
{
    local int I, J;

    I = PendingFilters.Find('GroupName', GroupName);
    // End:0x3E
    if(I == -1)
    {
        return;
    }
    J = PendingFilters[I].ORFilters.Length;
    PendingFilters[I].ORFilters.Length = J + 1;
    PendingFilters[I].ORFilters[J].Id = FilterId;
    PendingFilters[I].ORFilters[J].Type = FilterType;
    PendingFilters[I].ORFilters[J].Operator = FilterOperator;
    PendingFilters[I].ORFilters[J].Value = FilterValue;
    //return;    
}

function AddRawORFilter(name GroupName, coerce string FilterKey, OnlineGameSearch.EOnlineGameSearchComparisonType FilterOperator, coerce string FilterValue)
{
    local int I, J;

    I = PendingFilters.Find('GroupName', GroupName);
    // End:0x3E
    if(I == -1)
    {
        return;
    }
    J = PendingFilters[I].ORFilters.Length;
    PendingFilters[I].ORFilters.Length = J + 1;
    PendingFilters[I].ORFilters[J].Id = FilterKey;
    PendingFilters[I].ORFilters[J].Operator = FilterOperator;
    PendingFilters[I].ORFilters[J].Value = FilterValue;
    PendingFilters[I].ORFilters[J].bRawFilter = true;
    //return;    
}

function CommitFilters()
{
    local PendingORFilter CurORFilter;
    local int I, J;

    I = 0;
    J0x0B:

    // End:0x305 [Loop If]
    if(I < PendingFilters.Length)
    {
        // End:0x53
        if(PendingFilters[I].ORFilters.Length == 0)
        {            
        }
        else
        {
            // End:0x7C
            if(AdditionalSearchCriteria != "")
            {                
                AdditionalSearchCriteria $= "&&";
            }            
            AdditionalSearchCriteria $= "(";
            // End:0x2DE
            foreach PendingFilters[I].ORFilters(CurORFilter, J)
            {
                // End:0xF8
                if(J != 0)
                {                    
                    AdditionalSearchCriteria $= "||";
                }
                // End:0x14C
                if(CurORFilter.bRawFilter)
                {                    
                    AdditionalSearchCriteria $= CurORFilter.Id;                    
                }
                else
                {                    
                    AdditionalSearchCriteria $= (GetFilterPropertyName(CurORFilter.Id, CurORFilter.Type));
                }
                switch(CurORFilter.Operator)
                {
                    // End:0x1EA
                    case 0:                        
                        AdditionalSearchCriteria $= "==";
                        // End:0x2AC
                        break;
                    // End:0x20B
                    case 1:                        
                        AdditionalSearchCriteria $= "!=";
                        // End:0x2AC
                        break;
                    // End:0x22B
                    case 2:                        
                        AdditionalSearchCriteria $= ">";
                        // End:0x2AC
                        break;
                    // End:0x24C
                    case 3:                        
                        AdditionalSearchCriteria $= ">=";
                        // End:0x2AC
                        break;
                    // End:0x26C
                    case 4:                        
                        AdditionalSearchCriteria $= "<";
                        // End:0x2AC
                        break;
                    // End:0x28D
                    case 5:                        
                        AdditionalSearchCriteria $= "<=";
                        // End:0x2AC
                        break;
                    // End:0xFFFF
                    default:                        
                        AdditionalSearchCriteria $= "==";
                        // End:0x2AC
                        break;
                        break;
                }                
                AdditionalSearchCriteria $= CurORFilter.Value;                
            }                        
            AdditionalSearchCriteria $= ")";
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function ResetFilters()
{
    AdditionalSearchCriteria = default.AdditionalSearchCriteria;
    PendingFilters.Length = 0;
    //return;    
}

function string GetFilterPropertyName(string FilterId, OnlineGameSearch.EOnlineGameSearchEntryType FilterType)
{
    switch(FilterType)
    {
        // End:0x27
        case 0:
            return "p" $ FilterId;
        // End:0x3B
        case 1:
            return "s" $ FilterId;
        // End:0x4A
        case 2:
            return FilterId;
        // End:0xFFFF
        default:
            return "";
            break;
    }
    //return ReturnValue;    
}

defaultproperties
{
    GameSettingsClass=Class'PKGameSettingsCommon'
    FilterQuery=(OrClauses=none)
}