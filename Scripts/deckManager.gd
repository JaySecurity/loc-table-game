extends Node2D

#class_name DeckManager

# Path to the CSV file
@export var csv_path: String
# Path to the Card scene
@export var card_scene: PackedScene
@export var card_data_res:= preload("res://Scripts/cardData.gd")

# Array to hold all card resources
var deck: Array = []

# Called when the node enters the scene tree for the first time.
func _ready()->void:
    load_cards_from_csv()
    for i in range(3):
      var new_card = card_scene.instantiate()
      new_card.data = deck[i]
      new_card.global_position = Vector2(300+(200*i), 845)
      add_sibling.call_deferred(new_card)


func load_cards_from_csv()->void:
    var file := FileAccess.open(csv_path, FileAccess.READ)

    if file:
        var csv_text := file.get_as_text()
        file.close()

        # Split the CSV text into lines
        var lines := csv_text.split("\n")
        # Skip the header line (assuming the first line is header)
        for line in lines:
            line = line.strip_edges()  # Remove leading/trailing whitespace
            if line.length() <1:
                continue
            # Split the line into fields
            var fields := line.split(",")

            # Create a new CardData resource
            var card_data  = card_data_res.new()
            card_data.name = fields[0].strip_escapes().trim_prefix('"').trim_suffix('"')
            card_data.tag = fields[1].strip_escapes().trim_prefix('"').trim_suffix('"')
            card_data.influence = fields[2].to_int()
            card_data.innovation = fields[3].to_int()
            card_data.devSkills = fields[4].to_int()
            card_data.community = fields[5].to_int()
            card_data.wealth = fields[6].to_int()
            card_data.impact = fields[7].to_int()

            # Add the card data to the deck
            deck.append(card_data)
    else:
        print("Failed to open CSV file")

func generate_random_card()->void:
    if deck.size() == 0:
        print("Deck is empty!")
        return

    # Get a random card data from the deck
    var random_index := randi() % deck.size()
    var random_card_data: CardData = deck[random_index]

    # Instance a new card scene
    var card_instance: Node2D  = card_scene.instantiate()

    # Set the card data
    card_instance.set("card_data", random_card_data)

    # Add the card to the scene tree
    #add_child(card_instance)

    # Optionally, set the position of the card
    card_instance.global_position = Vector2(200, 200)  # Adjust position as needed
