require 'redmine'
require 'move_comments_hooks'

Redmine::Plugin.register :redmine_move_comments do
  name 'Redmine Move Comments plugin'
  author 'Mikhail Voronyuk'
  description 'Redmine move comments plugin'
  version '0.0.1'
  requires_redmine :version_or_higher => '2.4.0'
end
