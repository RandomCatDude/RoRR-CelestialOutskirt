mods.on_all_mods_loaded(function() for _, m in pairs(mods) do if type(m) == "table" and m.RoRR_Modding_Toolkit then for _, c in ipairs(m.Classes) do if m[c] then _G[c] = m[c] end end end end end)

PATH = _ENV["!plugins_mod_folder_path"]
NAMESPACE = "kitty"

function __initialize()
	sEnvironmentSkyIslands = Resources.sprite_load(NAMESPACE, "EnvironmentSkyIslands", path.combine(PATH, "sEnvironmentSkyIslands.png"))
	sGroundStripSkyIslands = Resources.sprite_load(NAMESPACE, "GroundStripSkyIslands", path.combine(PATH, "sGroundStripSkyIslands.png"))
	-- used by the stage itself
	Resources.sprite_load(NAMESPACE, "SkyIslandsBacking", path.combine(PATH, "sSkyIslandsBacking.png"))
	Resources.sprite_load(NAMESPACE, "SkyIslandsBGPetrichor", path.combine(PATH, "sSkyIslandsBGPetrichor.png"))

	local skyIslands = Stage.new(NAMESPACE, "skyIslands")
	skyIslands:add_room(path.combine(PATH, "skyIslands_1.rorlvl"))
	skyIslands:add_room(path.combine(PATH, "skyIslands_2.rorlvl"))
	skyIslands:set_index(2) -- stage 2

	local umbraA_card = Monster_Card.new(NAMESPACE, "umbraA")
	local umbraB_card = Monster_Card.new(NAMESPACE, "umbraB")
	local umbraC_card = Monster_Card.new(NAMESPACE, "umbraC")
	local umbraD_card = Monster_Card.new(NAMESPACE, "umbraD")

	umbraA_card.spawn_cost = 150
	umbraA_card.object_id = gm.constants.oUmbraA
	umbraB_card.spawn_cost = 150
	umbraB_card.object_id = gm.constants.oUmbraB
	umbraC_card.spawn_cost = 150
	umbraC_card.object_id = gm.constants.oUmbraC
	umbraD_card.spawn_cost = 150
	umbraD_card.object_id = gm.constants.oUmbraD

	skyIslands:clear_monsters()
	skyIslands:add_monster({"lemurian",
							"jellyfish",
							"shiningGolem",
							"bramble",
							"templeGuard",
							"evolvedLemurian",
							"magmaWorm",
							"colossus",
							"lynxTribe",
							"wanderingVagrant"})
	skyIslands:add_monster_loop({umbraA_card, umbraB_card, umbraC_card, umbraD_card})

	skyIslands.spawn_interactables = Stage.find("ror", "dampCaverns").spawn_interactables -- steal these from this stage cause im lazy
	skyIslands.interactable_spawn_points = 800
	skyIslands.music_id = gm.constants.musicStage3
	skyIslands.teleporter_index = 0 -- subimage of the fake tp where you start in the stage

	skyIslands:set_log_icon(sEnvironmentSkyIslands)
	skyIslands:set_log_view_start(2400, 1800)

	skyIslands:set_title_screen_properties(sGroundStripSkyIslands)
end
if hotload then
	__initialize()
end
hotload = true

local DEBUG_force_outskirts = false

gui.add_to_menu_bar(function()
	DEBUG_force_outskirts = ImGui.Checkbox("(DEBUG) Force every stage", DEBUG_force_outskirts)
end)

gm.pre_script_hook(gm.constants.stage_goto, function(self, other, result, args)
	if DEBUG_force_outskirts then
		args[1].value = Stage.find(NAMESPACE, "skyIslands").value
	end
end)
