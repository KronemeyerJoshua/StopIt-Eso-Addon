StopIt = {
	name = "StopIt!",
	version = "0.55",
};


function StopIt.OnAddOnLoaded(_,addOnName)
	if (addOnName ~= StopIt.name) then return end

    -- These are the scenes we know still work correctly when FRAME_PLAYER_FRAGMENT is removed
	TARGETED_SCENES = {
		'inventory',
		'stats',
		'skills',
		'questJournal',
		'achievements',
		'leaderboards',
		'loreLibrary',
		'collectionsBook',
		'dlcBook',
		'friendsList',
		'ignoreList',
		'groupMenuKeyboard',
		'guildHome',
		'guildRoster',
		'guildRanks',
		'guildHeraldry',
		'guildHistory',
		'guildCreate',
		'campaignOverview',
		'campaignBrowser',
		'mailInbox',
		'guildBrowserKeyboard',
		'mailSend',
		'notifications',
		'gameMenuInGame',
		'helpCustomerSupport',
		'helpEmotes',
		'helpTutorials',
		'championPerks',
		'antiquityJournalKeyboard'
	}


    -- Removing FRAME_PLAYER_FRAGMENT from targeted scenes
	for k, v in pairs(TARGETED_SCENES) do
		SCENE_MANAGER:GetScene(v):RemoveFragment(FRAME_PLAYER_FRAGMENT)
	end
	-- Special Cases
	SCENE_MANAGER:GetScene('championPerks'):RemoveFragment(END_IN_WORLD_INTERACTIONS_FRAGMENT)
	SCENE_MANAGER:GetScene('cadwellsAlmanac'):RemoveFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)

	-- Allows normal camera movement during collections menu
	SCENE_MANAGER:GetScene('collectionsBook'):RemoveFragment(ITEM_PREVIEW_KEYBOARD:GetFragment())

	-- OVERRIDING GLOBAL VARS TO REMOVE FRAME_PLAYER_FRAGMENT FOR THIRD PARTY ADDONS
	for k, v in pairs (FRAGMENT_GROUP) do
    	if FRAGMENT_GROUP[k].FRAME_PLAYER_FRAGMENT ~= nil then
    		FRAGMENT_GROUP[k].remove(FRAME_PLAYER_FRAGMENT)
    	end
	end

	--Unregister Loaded Callback
    EVENT_MANAGER:UnregisterForEvent(StopIt.name, EVENT_ADD_ON_LOADED)
end

-- GARKINS NonstopHarvest
function StopIt.ShowHook(self)
    EndPendingInteraction()
    self:OnShown()
    return true
end

ZO_PreHook(END_IN_WORLD_INTERACTIONS_FRAGMENT, "Show", StopIt.ShowHook)
-- END GARKINS Nonstop Harvest

EVENT_MANAGER:UnregisterForEvent("IngameSceneManager", EVENT_NEW_MOVEMENT_IN_UI_MODE)
EVENT_MANAGER:RegisterForEvent(StopIt.name, EVENT_ADD_ON_LOADED, StopIt.OnAddOnLoaded)
-- Disable mount from setting UI mode to false
EVENT_MANAGER:UnregisterForEvent("IngameSceneManager", EVENT_MOUNTED_STATE_CHANGED)