{
    "knight": {
      "name": "knight",
      "symbol": "♞",
      "moves": [
        {"step": [-2,-1]},
        {"step": [-1,-2]},
        {"step": [ 2,-1]},
        {"step": [ 1,-2]},
        {"step": [-1, 2]},
        {"step": [-2, 1]},
        {"step": [ 1, 2]},
        {"step": [ 2, 1]}
      ]
    },
    "rook": {
      "name": "rook",
      "symbol": "♜",
      "moves": [
        {"step": [ 1, 0], "repeat": "infinity"},
        {"step": [ 0, 1], "repeat": "infinity"},
        {"step": [-1, 0], "repeat": "infinity"},
        {"step": [ 0,-1], "repeat": "infinity"}
      ]
    },
    "bishop": {
      "name": "bishop",
      "symbol": "♝",
      "moves": [
        {"step": [ 1, 1], "repeat": "infinity"},
        {"step": [-1, 1], "repeat": "infinity"},
        {"step": [-1,-1], "repeat": "infinity"},
        {"step": [ 1,-1], "repeat": "infinity"}
      ]
    },
    "queen": {
      "name": "queen",
      "symbol": "♛",
      "moves": [
        {"step": [ 1, 0], "repeat": "infinity"},
        {"step": [ 0, 1], "repeat": "infinity"},
        {"step": [-1, 0], "repeat": "infinity"},
        {"step": [ 0,-1], "repeat": "infinity"},
        {"step": [ 1, 1], "repeat": "infinity"},
        {"step": [-1, 1], "repeat": "infinity"},
        {"step": [-1,-1], "repeat": "infinity"},
        {"step": [ 1,-1], "repeat": "infinity"}
      ]
    },
    "king": {
      "name": "king",
      "symbol": "♚",
      "moves": [
        {"step": [-1,-1]},
        {"step": [-1, 0]},
        {"step": [-1, 1]},
        {"step": [ 0,-1]},
        {"step": [ 0, 1]},
        {"step": [ 1,-1]},
        {"step": [ 1, 0]},
        {"step": [ 1, 1]}
      ]
    },
    "pawn": {
      "name": "pawn",
      "symbol": "🜘",
      "moves": [
        {"step": [ 1,-1]},
		{"step": [-1,-1]}
      ]
    }
}