require './character'

class Monster < Character

  POWER_UP_RATE = 1.5
  CALC_HALF_HP = 0.5

  # **paramsにすることでハッシュ形式の引数しか受け付けないようにできる
  def initialize(**params)
    # キャラクタークラスのinitializeメソッドに処理を渡す
    # 通常のメソッドと同様に引数を渡すことができる
    super(
      name: params[:name],
      hp: params[:hp],
      offense: params[:offense],
      defense: params[:defense]
    )
    # 親クラスで定義していない処理はそのまま残す
    @transform_flag = false
    @transform_trigger = params[:hp] * CALC_HALF_HP
  end

  def attack(brave)
    if @hp <= @transform_trigger && @transform_flag == false
      @transform_flag = true
      transform
    end

    #ダメージ計算処理の呼び出し
    damage = calculate_damage(brave)

    #ダメージ反映処理の呼び出し
    cause_damage(target: brave, damage: damage)

    #attack_messageの呼び出し
    attack_message(target: brave)
    # damage_messageの呼び出し
    damage_message(target: brave, damage: damage)
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
    target.hp = 0 if target.hp < 0
    # puts "#{target.name}は#{damage}のダメージを受けた"
  end

  def transform
    transform_name = "ドラゴン"

    #transform_messageを呼び出し
    transform_message(origin_name: @name, transform_name: transform_name)

    @offense *= POWER_UP_RATE
    @name = transform_name
  end
end
