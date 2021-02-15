crumb :root do
  link "Home", root_path
end

crumb :user do
  link User.find(params[:id]).name, user_path
  parent :root
end

crumb :favorite_list do
  link "お気に入りのゲーム", favorite_user_path
  parent :user
end

crumb :want_list do
  link "プレイ予定のゲーム", want_to_play_user_path
  parent :user
end

crumb :playing_list do
  link "プレイ中のゲーム", playing_user_path
  parent :user
end

crumb :played_list do
  link "プレイ済みのゲーム", played_user_path
  parent :user
end

crumb :platforms do
  link '機種'
  parent :root
end

crumb :platform do
  link Platform.find(params[:id]).name, platform_path
  parent :platforms
end

crumb :genres do
  link 'ジャンル'
  parent :root
end

crumb :genre do
  link Genre.find(params[:id]).name, genre_path
  parent :genres
end

crumb :companies do
  link '会社'
  parent :root
end

crumb :company do
  link Company.find(params[:id]).name, company_path
  parent :companies
end

crumb :tags do
  link 'タグ'
  parent :root
end

crumb :tag do
  link Tag.find(params[:id]).name, tag_path
  parent :tags
end

crumb :search do
  link '詳細検索', games_path
  parent :root
end

crumb :add_game do
  link 'ゲームを追加', new_game_path
  parent :root
end

crumb :game do
  link Game.find(params[:id]).title, game_path
  parent :root
end

crumb :edit_game do
  link '編集', edit_game_path
  parent :game
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).