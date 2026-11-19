/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_Feed extends NanoUIPage_List;

/** How many unread posts there currently are */
var int NumUnreadPosts;

/** Callback to compare two feed posts to sort them by time */
function int SortSoonestToOldest_Timestamp( NanoUIListItem_Base A, NanoUIListItem_Base B )
{
	local NanoUIListItem_FeedPost PostA, PostB;

	PostA = NanoUIListItem_FeedPost(A);
	PostB = NanoUIListItem_FeedPost(B);

	if(PostA.Timestamp == "")
	{
		if(PostB.Timestamp == "")
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	else
	{
		if(PostB.Timestamp == "")
		{
			return 1;
		}
		else
		{
			return class'NanoTypes'.static.GetSecondsBetweenTimestamps(PostB.Timestamp, PostA.TimeStamp);
		}
	}
}

/** Sort all posts, newest first */
function SortFeedPosts()
{
	Items.Sort(SortSoonestToOldest_Timestamp);
}

/** Create an empty datum */
function NanoUIListItem_FeedPost CreateItemFromDatum(MCPDatum Datum, string LastCheckTimestamp)
{
	local NanoUIListItem_FeedPost NewPostItem;

	NewPostItem = new(self) class'NanoUIListItem_FeedPost';
	NewPostItem.FromUserName = Datum.ID;
	NewPostItem.Timestamp = Datum.Timestamp;

	// Check timestamp to indicate if its unread
	if(class'NanoTypes'.static.GetSecondsBetweenTimestamps(NewPostItem.Timestamp, LastCheckTimestamp) < 0)
	{
		NewPostItem.bUnread = true;
	}

	return NewPostItem;
}




function RebuildPostFeed(bool bMarkFeedChecked)
{
	local NanoUIListItem_FeedPost NewPostItem;
	local NanoMCP NMCP;
	local MCPDatum Datum;
	local string NameString, LastCheckTimestamp;

	NMCP = GetNanoMCP();
	LastCheckTimestamp = NMCP.GetLastCheckedFeedTimestamp();

	EmptyItemList();
	NumUnreadPosts = 0;

	foreach NMCP.MCPData( Datum )
	{
		NewPostItem = None;

		// Ignore entries with no timestamp
		if(Datum.Timestamp == "")
		{
			continue;
		}

		//// STATUS
		if( Datum.Key == class'NanoMCPKeys'.default.Status )
		{
			if(Datum.Value != "")
			{
				NewPostItem = CreateItemFromDatum(Datum, LastCheckTimestamp);
				NewPostItem.PostType = FPT_Status;
				NewPostItem.PostText = "'"$Datum.Value$"'";
			}
		}
		//// MOTD
		else if( Datum.Key == class'NanoMCPKeys'.default.MOTD )
		{
			if(Datum.Value != "")
			{
				NewPostItem = CreateItemFromDatum(Datum, LastCheckTimestamp);
				NewPostItem.PostType = FPT_MOTD;
				NewPostItem.PostText = "MOTD:"@Datum.Value;
				NewPostItem.bImportant = TRUE;			
			}
		}
		//// BOMB
		else if( Datum.Key == class'NanoMCPKeys'.default.RebelSuperBombForge_FoundBy || Datum.Key == class'NanoMCPKeys'.default.RebelSuperBombForge_LastUsedBy || Datum.Key == class'NanoMCPKeys'.default.RebelSuperBombForge_UnlockedBy )
		{
			if(Datum.Value != "")
			{
				NewPostItem = CreateItemFromDatum(Datum, LastCheckTimestamp);
				NewPostItem.FromUserName = Datum.Value; // This is a 'global' entry - the person that found it is the value, not the ID
				NewPostItem.PostType = FPT_Bomb;

				if( Datum.Key == class'NanoMCPKeys'.default.RebelSuperBombForge_FoundBy )
				{
					NewPostItem.PostText = "Found the Rebel Bomb!";
				}
				else if( Datum.Key == class'NanoMCPKeys'.default.RebelSuperBombForge_LastUsedBy )
				{
					NewPostItem.PostText = "Used the Rebel Bomb!";
				}
				else if( Datum.Key == class'NanoMCPKeys'.default.RebelSuperBombForge_UnlockedBy )
				{
					NewPostItem.PostText = "Unlocked the Rebel Bomb!";
				}

				// important if it was you that found/used it
				NewPostItem.bImportant = (Datum.Value == class'NanoTypes'.static.GetLocalPlayerUserName()); 
			}
		}
		//// CALL FOR HELP
		else if( Datum.Key == class'NanoMCPKeys'.default.FeedEvent_RequestedMobileHelp )
		{
			NewPostItem = CreateItemFromDatum(Datum, LastCheckTimestamp);
			NewPostItem.PostType = FPT_CallForHelp;
			NewPostItem.PostText = "Made a call for help!";
		}
		//// DEAL
		else if( Datum.Key == class'NanoMCPKeys'.default.MadeDealWith )
		{
			if(Datum.Value != "")
			{
				NewPostItem = CreateItemFromDatum(Datum, LastCheckTimestamp);
				NewPostItem.PostType = FPT_Deal;
				NewPostItem.PostText = "Has made a deal with "$Datum.Value$". Details were not disclosed.";
			}
		}
		//// HANDPRINT
		else if( Datum.Key == class'NanoMCPKeys'.default.RebelHandUsedBy )
		{
			NewPostItem = CreateItemFromDatum(Datum, LastCheckTimestamp);
			NewPostItem.PostType = FPT_Handprint;

			if(Datum.Value != "")
			{
				// See if it was your handprint that was taken!
				if(Datum.ID == class'NanoTypes'.static.GetLocalPlayerUserName())
				{
					NewPostItem.bImportant = TRUE;
					NewPostItem.PostText = "You had your handprint taken by "$Datum.Value$"! You should place another!";
				}
				else
				{
					NewPostItem.PostText = "Had their handprint taken by "$Datum.Value$".";
				}
			}
			else
			{
				// abort, don't want to make an item for this
				NewPostItem = None;
			}
		}
		// BOUNTY
		else if( Datum.Key == class'NanoMCPKeys'.default.BountyOn )
		{
			if(Datum.Value != "")
			{
				NewPostItem = CreateItemFromDatum(Datum, LastCheckTimestamp);
				NewPostItem.PostType = FPT_Bounty;

				// see if the bounty was put on you!
				if(Datum.Value == class'NanoTypes'.static.GetLocalPlayerUserName())
				{
					NameString = "your";
					NewPostItem.bImportant = TRUE;
				}
				else
				{
					NameString = Datum.Value$"'s";
				}

				NewPostItem.PostText = "Put a bounty on "$NameString$" head. Who will be the first player to claim it?";
			}
		}

		// if we made a new item, add it to the list
		if(NewPostItem != None)
		{
			AddListItem(NewPostItem);

			// Add to count if unread
			if(NewPostItem.bUnread)
			{
				NumUnreadPosts++;
			}
		}
	}

	SortFeedPosts();
	UpdateVisibleList(); // regen the visible list now we hae sorted them

	`log("RebuildPostFeed: "@Items.Length@"Posts,"@NumUnreadPosts@"Unread");

	// Set when we last checked the feed
	if(bMarkFeedChecked)
	{
		NMCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.LastCheckedFeed, "" );
	}
}

///// NanoUIPage_Base interface

function DrawPage()
{
	Super.DrawPage();

	DrawButtonHelpBar(PageUIOrigin.X, PageUIOrigin.Y, "BOUNTY", TRUE, "", FALSE);
}

function PageShown()
{
	RebuildPostFeed(TRUE);

	Super.PageShown();
}

function PageHidden()
{
	// Do this so that message on-screen goes away when closing menu
	RebuildPostFeed(FALSE);

	Super.PageHidden();
}

///// NanoUIPage_List interface

/** Equip specified plan */
simulated function OnSelectItem( NanoUIListItem_Base Item )
{
	local NanoUIListItem_FeedPost PostItem;
	local NanoMCP NMCP;

	PostItem = NanoUIListItem_FeedPost(Item);

	// Cannot put bounty on yourself!
	if(PostItem.FromUserName != class'NanoTypes'.static.GetLocalPlayerUserName())
	{
		NMCP = GetNanoMCP();

		NMCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.BountyOn, PostItem.FromUserName );
		RebuildPostFeed(TRUE); // show new bounty notice on feed	
	}
}

defaultproperties
{
	PageName="FEED"

	ListOffset=(X=65,Y=20)
	ListItemSpacing=60.0

	MaxItemsToDraw=8
}