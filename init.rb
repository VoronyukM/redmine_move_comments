require 'redmine'

Redmine::Plugin.register :redmine_move_comments do
  name 'Redmine move comments'
  author 'Mikhail Voronyuk'
  description 'Redmine move comments plugin'
  version '0.0.1'
  requires_redmine :version_or_higher => '2.4.0'
end
