extends RefCounted

# ============================================================
# ASSET REGISTRY — LOVE GARDEN MASTER TEXTURE LOADER
# Godot 4.x
#
# This script centralizes all texture-pack paths.
# Do not load texture packs randomly from other scripts anymore.
# ============================================================


# ============================================================
# BASE PATHS
# ============================================================

const PACK_BASE: String = "res://assets/love_garden/texture_packs/"

const TINY_BASE: String = PACK_BASE + "tiny_wonder/Tiny Wonder Farm Free/"
const SMALLBURG_BASE: String = PACK_BASE + "smallburg/assets/"
const LRK_BASE: String = PACK_BASE + "bitglow_lrk/"
const BEDROOM_BASE: String = PACK_BASE + "bitglow_bedroom/"
const BATHROOM_BASE: String = PACK_BASE + "bitglow_bathroom/"
const INTERIOR_FREE_BASE: String = PACK_BASE + "interior_free/interior free/"


# ============================================================
# LOADING STATUS
# ============================================================

var missing_paths: Array = []


# ============================================================
# TINY WONDER FARM
# Outside farm world, crops, bridges, props, furniture backup
# ============================================================

var tiny_spring_farm_tilemap: Texture2D
var tiny_farm_bridges: Texture2D
var tiny_farm_inside: Texture2D
var tiny_farm_objects: Texture2D
var tiny_farm_furniture: Texture2D
var tiny_farm_items: Texture2D
var tiny_farm_plants: Texture2D
var tiny_character_walk_idle: Texture2D
var tiny_character_portrait_female: Texture2D
var tiny_character_portrait_male: Texture2D


# ============================================================
# SMALLBURG
# Exterior village, housing system, terrain, shops, characters
# ============================================================

var smallburg_outside_assets: Texture2D
var smallburg_outside_assets_shadows: Texture2D
var smallburg_terrain_spring: Texture2D
var smallburg_terrain_spring_with_shadows: Texture2D
var smallburg_beach_spring_terrain: Texture2D

var smallburg_house_walls_default: Texture2D
var smallburg_house_walls_pink: Texture2D
var smallburg_house_walls_brown: Texture2D
var smallburg_house_walls_brown_light: Texture2D
var smallburg_house_walls_blue: Texture2D
var smallburg_house_walls_green: Texture2D
var smallburg_house_walls_green_light: Texture2D
var smallburg_house_walls_teal: Texture2D
var smallburg_house_walls_yellow: Texture2D
var smallburg_house_walls_red: Texture2D
var smallburg_house_walls_red_light: Texture2D
var smallburg_house_walls_orange: Texture2D
var smallburg_house_walls_grey: Texture2D
var smallburg_house_walls_shadows: Texture2D

var smallburg_house_roofs: Texture2D
var smallburg_house_doors: Texture2D
var smallburg_house_interiors_assets: Texture2D
var smallburg_house_interiors_assets_export: Texture2D

var smallburg_flower_gardens_wood_plants: Texture2D
var smallburg_flower_gardens_ciment_soil: Texture2D

var smallburg_market_stall: Texture2D
var smallburg_market_stall_shadow: Texture2D
var smallburg_fishmarket_stall: Texture2D
var smallburg_fishmarket_stall_closed: Texture2D
var smallburg_potion_stall: Texture2D
var smallburg_potion_stall_shadow: Texture2D
var smallburg_gear_stall: Texture2D
var smallburg_ore_crystals_stall: Texture2D
var smallburg_ore_crystals_stall_shadows: Texture2D


# ============================================================
# BITGLOW LIVING ROOM + KITCHEN
# Living room, kitchen, cabinets, doors, windows, floors, walls
# ============================================================

var lrk_cabinets: Texture2D
var lrk_decorations: Texture2D
var lrk_doors_windows_stairs: Texture2D
var lrk_floors_walls: Texture2D
var lrk_kitchen: Texture2D
var lrk_livingroom: Texture2D


# ============================================================
# BITGLOW BEDROOM
# Bedroom furniture, beds, wardrobes, decorations
# ============================================================

var bedroom_beds: Texture2D
var bedroom_decorations: Texture2D
var bedroom_wardrobes: Texture2D


# ============================================================
# BITGLOW BATHROOM
# Bathroom fixtures, textiles, cabinets
# ============================================================

var bathroom_cabinets: Texture2D
var bathroom_fixtures: Texture2D
var bathroom_textiles: Texture2D


# ============================================================
# INTERIOR FREE
# Small fallback interior sheet
# ============================================================

var interior_free_sheet: Texture2D


# ============================================================
# PUBLIC LOAD
# ============================================================

func load_all() -> void:
	missing_paths.clear()

	load_tiny_wonder()
	load_smallburg()
	load_bitglow_lrk()
	load_bitglow_bedroom()
	load_bitglow_bathroom()
	load_interior_free()

	print_asset_report()


func tex(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D

	missing_paths.append(path)
	return null


# ============================================================
# LOAD GROUPS
# ============================================================

func load_tiny_wonder() -> void:
	tiny_spring_farm_tilemap = tex(TINY_BASE + "tilemaps/spring farm tilemap.png")
	tiny_farm_bridges = tex(TINY_BASE + "tilemaps/farm bridges free.png")
	tiny_farm_inside = tex(TINY_BASE + "tilemaps/farm inside free.png")

	tiny_farm_objects = tex(TINY_BASE + "objects&items/farm objects free.png")
	tiny_farm_furniture = tex(TINY_BASE + "objects&items/furniture free.png")
	tiny_farm_items = tex(TINY_BASE + "objects&items/items free.png")
	tiny_farm_plants = tex(TINY_BASE + "objects&items/plants free.png")

	tiny_character_walk_idle = tex(TINY_BASE + "characters/main character/walk and idle.png")
	tiny_character_portrait_female = tex(TINY_BASE + "characters/main character/portrait female.png")
	tiny_character_portrait_male = tex(TINY_BASE + "characters/main character/portrait male.png")


func load_smallburg() -> void:
	smallburg_outside_assets = tex(SMALLBURG_BASE + "tileset_v2/SmallBurg_outside_assets.png")
	smallburg_outside_assets_shadows = tex(SMALLBURG_BASE + "tileset_v2/SmallBurg_outside_assets_shadows.png")
	smallburg_terrain_spring = tex(SMALLBURG_BASE + "tileset_v2/terrain/smallburg_terrain_spring.png")
	smallburg_terrain_spring_with_shadows = tex(SMALLBURG_BASE + "tileset_v2/terrain/smallburg_terrain_spring_with_shadows.png")
	smallburg_beach_spring_terrain = tex(SMALLBURG_BASE + "tileset_v2/terrain/smallburg_beach_spring_terrain.png")

	smallburg_house_walls_default = tex(SMALLBURG_BASE + "housing/walls/house_building_assets.png")
	smallburg_house_walls_pink = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_pink.png")
	smallburg_house_walls_brown = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_brown.png")
	smallburg_house_walls_brown_light = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_brown_light.png")
	smallburg_house_walls_blue = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_blue.png")
	smallburg_house_walls_green = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_green.png")
	smallburg_house_walls_green_light = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_green_light.png")
	smallburg_house_walls_teal = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_teal.png")
	smallburg_house_walls_yellow = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_yellow.png")
	smallburg_house_walls_red = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_red.png")
	smallburg_house_walls_red_light = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_red_light.png")
	smallburg_house_walls_orange = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_orange.png")
	smallburg_house_walls_grey = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_grey.png")
	smallburg_house_walls_shadows = tex(SMALLBURG_BASE + "housing/walls/house_building_assets_shadows.png")

	smallburg_house_roofs = tex(SMALLBURG_BASE + "housing/roofs/housing_system_roofs.png")
	smallburg_house_doors = tex(SMALLBURG_BASE + "housing/house_doors.png")
	smallburg_house_interiors_assets = tex(SMALLBURG_BASE + "housing/house_interiors_assets.png")
	smallburg_house_interiors_assets_export = tex(SMALLBURG_BASE + "housing/house_interiors_assets-export.png")

	smallburg_flower_gardens_wood_plants = tex(SMALLBURG_BASE + "tileset_v2/flower_gardens/flower_gardens_wood_plants.png")
	smallburg_flower_gardens_ciment_soil = tex(SMALLBURG_BASE + "tileset_v2/flower_gardens/flower_gardens_ciment_soil.png")

	smallburg_market_stall = tex(SMALLBURG_BASE + "commerce/marketplace/commerce_marketplace_stall.png")
	smallburg_market_stall_shadow = tex(SMALLBURG_BASE + "commerce/marketplace/commerce_marketplace_stall_shadow.png")
	smallburg_fishmarket_stall = tex(SMALLBURG_BASE + "commerce/fishmarket/commerce_fishmarket_stall.png")
	smallburg_fishmarket_stall_closed = tex(SMALLBURG_BASE + "commerce/fishmarket/commerce_fishmarket_stall_closed.png")
	smallburg_potion_stall = tex(SMALLBURG_BASE + "commerce/potions/commerce_potion_stall.png")
	smallburg_potion_stall_shadow = tex(SMALLBURG_BASE + "commerce/potions/commerce_potion_stall_shadow.png")
	smallburg_gear_stall = tex(SMALLBURG_BASE + "commerce/gear/waepon_gear_stall.png")
	smallburg_ore_crystals_stall = tex(SMALLBURG_BASE + "commerce/ores/commerce_ore_crystals_stall.png")
	smallburg_ore_crystals_stall_shadows = tex(SMALLBURG_BASE + "commerce/ores/commerce_ore_crystals_stall_shadows.png")


func load_bitglow_lrk() -> void:
	lrk_cabinets = tex(LRK_BASE + "cabinets_LRK.png")
	lrk_decorations = tex(LRK_BASE + "decorations_LRK.png")
	lrk_doors_windows_stairs = tex(LRK_BASE + "doorswindowsstairs_LRK.png")
	lrk_floors_walls = tex(LRK_BASE + "floorswalls_LRK.png")
	lrk_kitchen = tex(LRK_BASE + "kitchen_LRK.png")
	lrk_livingroom = tex(LRK_BASE + "livingroom_LRK.png")


func load_bitglow_bedroom() -> void:
	bedroom_beds = tex(BEDROOM_BASE + "beds_BR.png")
	bedroom_decorations = tex(BEDROOM_BASE + "decorations_BR.png")
	bedroom_wardrobes = tex(BEDROOM_BASE + "wardrobes_BR.png")


func load_bitglow_bathroom() -> void:
	bathroom_cabinets = tex(BATHROOM_BASE + "cabinets_BA.png")
	bathroom_fixtures = tex(BATHROOM_BASE + "fixtures_BA.png")
	bathroom_textiles = tex(BATHROOM_BASE + "textiles_BA.png")


func load_interior_free() -> void:
	interior_free_sheet = tex(INTERIOR_FREE_BASE + "interior free.png")


# ============================================================
# REPORT
# ============================================================

func print_asset_report() -> void:
	if missing_paths.size() == 0:
		print("ASSET REGISTRY: all registered texture paths loaded successfully.")
		return

	print("ASSET REGISTRY WARNING: missing paths:")
	for path in missing_paths:
		print(" - " + str(path))
