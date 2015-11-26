class HelpdeskHooks < Redmine::Hook::Listener
  
  # render partial for 'Move the comment to another issue'
  def view_journals_notes_form_after_notes(context={})
    action_view = ActionView::Base.new(File.dirname(__FILE__) + '/../app/views/')
    action_view.render(
      :partial => "notes_edit"
    )
  end
 
  # fetch 'new_issue_id' param and move the journal to another issue if presented
  def controller_journals_edit_post(context={})
    new_issue_id = context[:params]['new_issue_id']
    if new_issue_id.present?
      current_journal = context[:journal]
      journal = Journal.new(:journalized_id => new_issue_id, :journalized_type => current_journal.journalized_type, :user_id => current_journal.user_id, :notes => current_journal.notes, :private_notes => current_journal.private_notes, :created_on => current_journal.created_on)
      journal.save
      # erase notes for current journal or delete it if it has no details
      if current_journal.details.empty?
        current_journal.destroy
      else
        current_journal.update_attributes(:notes => nil)
      end
    end
  end

end
