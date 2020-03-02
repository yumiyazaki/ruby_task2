require './brave'
require './monster'
require './games_controller'

# GameControllerクラスをインスタンス化
games_controller = GamesController.new

# それぞれのクラスをインスタンス化
terry = Brave.new(name: "テリー", hp: 500, offense: 150, defense: 100)
slime = Monster.new(name: "スライム", hp: 250, offense: 200, defense: 100)

# GameControllerクラスのbattleメソッドを使用
games_controller.battle(brave: terry, monster: slime)
