require './message_dialog'

class Character
  # MessageDialogのinclude
  include MessageDialog

  # attr_readerの記述でゲッターを省略することができる
  attr_reader :offense, :defense
  #セッターゲッターを一括定義
  attr_accessor :hp, :name

  #new演算子から渡された引数を受け取る
  #引数に**を記述:ハッシュしか受け取れなくなる
  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
  end
end
