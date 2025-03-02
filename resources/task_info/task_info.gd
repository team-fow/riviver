class_name TaskInfo
extends Resource

@export var task_name: String
@export var task_description: String
@export var task_checker: GDScript

enum REWARD_TYPE {MATERIALS, CARDS, WORLD_EFFECT}
@export var reward_type: REWARD_TYPE 
@export var material_rewards: Array[int] # Index of this array corresponds to the int represented by a MaterialType in Player
@export var card_rewards: Array[String] # A list of the cards that this task rewards the player with. Reference the resource library for card strings

var tile: Tile # The tile this task is attached to
var completed: bool # Whether this task has been completed or not
var reward_collected: bool # Whether the reward for this task has been collected


# Checks whether the task has been completed
func check_completed() -> bool:
	completed = task_checker.check_completed(self)
	return completed


func give_reward() -> void:
	reward_collected = true
	match reward_type:
		REWARD_TYPE.MATERIALS:
			material_rewards.resize(6)
			for material in Player.MaterialType:
				var val = Player.MaterialType[material]
				Game.player.add_material(val, material_rewards[val]) 
		REWARD_TYPE.CARDS:
			for card in card_rewards:
				print("Card Reward: " + card)
				Game.player.hand.add_card(card)
		REWARD_TYPE.WORLD_EFFECT:
			pass


# Creates and returns a copy of this resource
func clone(new_tile: Tile = self.tile) -> TaskInfo:
	var copy: TaskInfo = TaskInfo.new()
	copy.task_name = task_name
	copy.task_description = task_description
	copy.task_checker = task_checker.new()
	copy.reward_type = reward_type
	copy.material_rewards = material_rewards
	copy.card_rewards = card_rewards
	copy.tile = new_tile
	copy.completed = false
	copy.reward_collected = false
	
	return copy
