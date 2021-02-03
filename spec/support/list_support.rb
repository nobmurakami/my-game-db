module ListSupport
  def check_create_list(game, button)
    expect {
      click_on(button)
    }.to change { List.count }.by(1)
    expect(current_path).to eq game_path(game)
  end

  def check_move_list(game, button)
    expect {
      click_on(button)
    }.to change { List.count }.by(0)
    expect(current_path).to eq game_path(game)
  end

  def check_delete_list(game, button)
    expect {
      click_on(button)
    }.to change { List.count }.by(-1)
    expect(current_path).to eq game_path(game)
  end

  def check_game_in_user_list(game, user, list)
    visit user_path(user)
    click_on(list)
    expect(page).to have_content(game.title)
  end

  def check_game_not_in_user_list(game, user, list)
    visit user_path(user)
    click_on(list)
    expect(page).not_to have_content(game.title)
  end
end