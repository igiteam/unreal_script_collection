class TPGameDMSearch_DataStore extends UIDataStore_OnlineGameSearch;

/**
 * @return	TRUE if a server list query was started but has not completed yet.
 */
function bool HasOutstandingQueries()
{
	local bool bResult;
	local int i;

	for ( i = 0; i < GameSearchCfgList.Length; i++ )
	{
		if ( GameSearchCfgList[i].Search != None && GameSearchCfgList[i].Search.bIsSearchInProgress )
		{
			bResult = true;
			break;
		}
	}

	return bResult;
}

