class Brave
  # attr_readerの記述でゲッターを省略することができる
  attr_reader :name, :offense, :defense
  #セッターゲッターを一括定義
  attr_accessor :hp

  SPECIAL_ATTACK_CONSTANT = 1.5

  #new演算子から渡された引数を受け取る
  #引数に**を記述:ハッシュしか受け取れなくなる
  def initialize(**params)
    #格パラメータをハッシュで取得
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
  end

  def attack(monster)
    puts "#{@name}の攻撃"

    attack_type = decision_attack_type
    #キーワード引数を設定
    damage = calculate_damage(target: monster, attack_type: attack_type)

    #ダメージをHPに反映させる
    #キーワード引数を設定
    cause_damage(target: monster, damage: damage)

    puts "#{monster.name}の残りHPは#{monster.hp}だ"
  end

  private

  def decision_attack_type
    attack_num = rand(4)

    if attack_num == 0
      puts "必殺攻撃"
      "special_attack"
    else
      puts "通常攻撃"
      "normal_attack"
    end
  end

  #ダメージ計算メソッド
  def calculate_damage(**params)
    # 変数に格納することによって将来ハッシュのキーに変更があった場合でも変更箇所が少なくて済む
    target = params[:target]
    attack_type = params[:attack_type]

    if attack_type == "special_attack"
      calculate_special_attack - target.defense
    else
      @offense - target.defense
    end
  end

  #HPにダメージを反映させる
  def cause_damage(**params)
    # 変数に格納することによって将来ハッシュのキーに変更があった場合でも変更箇所が少なくて済む
    damage = params[:damage]
    target = params[:target]

    target.hp -= damage

    #もしターゲットのHPがマイナスになるなら0を代入
    target.hp = 0 if target.hp < 0

    puts "#{target.name}は#{damage}のダメージを受けた"
  end

  def calculate_special_attack
    @offense * SPECIAL_ATTACK_CONSTANT
  end

end





class Monster
  # attr_readerの記述でゲッターを省略することができる
  attr_reader :offense, :defense
  #セッターゲッターを一括定義
  attr_accessor :hp, :name

  POWER_UP_RATE = 1.5
  CALC_HALF_HP = 0.5

  # **paramsにすることでハッシュ形式の引数しか受け付けないようにできる
  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
    @transform_flag = false
    @transform_trigger = params[:hp] * CALC_HALF_HP
  end

  def attack(brave)
    if @hp <= @transform_trigger && @transform_flag == false
      @transform_flag = true
      transform
    end
    puts "#{@name}の攻撃"

    #ダメージ計算処理の呼び出し
    damage = calculate_damage(brave)

    #ダメージ反映処理の呼び出し
    cause_damage(target: brave, damage: damage)

    puts "#{brave.name}の残りHPは#{brave.hp}だ"

  end

  private
  #ダメージ計算処理
  def calculate_damage(target)
    @offense - target.defense
  end

  #ダメージ反映処理
  def cause_damage(**params)
    #引数で受け取った値を変数に格納
    damage = params[:damage]
    target = params[:target]

    target.hp -= damage
    puts "#{target.name}は#{damage}のダメージを受けた"
  end

  def transform
    transform_name = "ドラゴン"

    puts <<~EOS
    #{@name}は怒っている
    #{@name}は#{transform_name}に変身した
    EOS

    @offense *= POWER_UP_RATE
    @name = transform_name
  end

end


# それぞれのクラスをインスタンス化
brave = Brave.new(name: "テリー", hp: 500, offense: 150, defense: 100)
monster = Monster.new(name: "スライム", hp: 250, offense: 200, defense: 100)

#攻撃処理(ループ)
loop do
  brave.attack(monster)
  break if monster.hp <= 0

  monster.attack(brave)
  break if brave.hp <= 0
end

#勝敗の判定
battle_result = brave.hp > 0
#勇者が勝利した場合の処理
if battle_result
  exp = (monster.offense + monster.defense) * 2
  gold = (monster.offense + monster.defense) * 3
  puts "#{brave.name}はたたかいに勝った"
  puts "#{exp}の経験値と#{gold}ゴールドを獲得した"
else
  puts "#{brave.name}はたたかいに負けた"
  puts "目の前が真っ暗になった"
end
