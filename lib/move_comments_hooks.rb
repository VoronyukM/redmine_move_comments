class HelpdeskHooks < Redmine::Hook::Listener
  
  # render partial for 'Move the comment to another issue'
  def view_journals_notes_form_after_notes(context={})
    action_view = ActionView::Base.new(File.dirname(__FILE__) + '/../app/views/')
    action_view.render(
      :partial => "notes_edit"
    )
  end
 

end
