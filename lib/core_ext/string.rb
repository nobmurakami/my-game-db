class String
  #レシーバ自身の文字列から先頭と末尾の空白文字を除去する
  def strip_all_space!
    gsub!(/(^[[:space:]]+)|([[:space:]]+$)/, '')
  end

  #文字列の先頭と末尾の空白文字を除去した新しい文字列を返す
  def strip_all_space
    self_clone = clone
    self_clone.strip_all_space!
    self_clone
  end
end