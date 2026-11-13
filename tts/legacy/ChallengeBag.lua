-- Challenge Bag object script recovered from the original Dark Magic save.

function onLoad()
    self.createButton({
        click_function = "challenge",
        function_owner = self,
        label = "Challenge",
        position = {3, 1, 0},
        rotation = {0, 270, 0},
        width = 1600,
        height = 800,
        font_size = 340,
        color = {0.5, 0.5, 0.5},
        font_color = {1, 1, 1},
    })
end

function challenge()
    if self.getQuantity() < 1 then
        return
    end
    self.shuffle()
    self.takeObject({
        position = {x = 3, y = 7, z = 0},
        callback_function = take_callback,
    })
    self.reset()
    self.setDescription("Empty")
end

function take_callback(objectSpawned)
    if objectSpawned.name == "Go Game Piece White" then
        print("White wins the challenge.")
    elseif objectSpawned.name == "Go Game Piece Black" then
        print("Black wins the challenge.")
    end
end

function onObjectEnterContainer(bag, object)
    local black, white = 0, 0
    for _, piece in pairs(bag.getObjects()) do
        if piece.name == "Go Game Piece White" then
            white = white + 1
        elseif piece.name == "Go Game Piece Black" then
            black = black + 1
        end
    end
    self.setDescription("Black: " .. black .. ", White: " .. white)
end
