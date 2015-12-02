class MoveCommentsHooks < Redmine::Hook::Listener
  
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
    # this attribute will be analyzed in any case
    context[:journal].class.module_eval { attr_accessor :wrong_new_issue_id}
    context[:journal].wrong_new_issue_id = nil
    if new_issue_id.present?
      current_journal = context[:journal]
      issue_id = nil
      begin
        issue = Issue.find(new_issue_id)
        if issue
          issue_id = issue.id
        end
      rescue
      end
      if !issue_id
        context[:journal].wrong_new_issue_id = new_issue_id # this will be analyzed later for showing the error message
	return
      end
      journal = Journal.new(:journalized_id => issue_id, :journalized_type => current_journal.journalized_type, :user_id => current_journal.user_id, :notes => current_journal.notes, :private_notes => current_journal.private_notes, :created_on => current_journal.created_on)
      journal.save
      # erase notes for current journal or delete it if it has no details
      if current_journal.details.empty?
        current_journal.destroy
      else
        current_journal.update_attributes(:notes => nil)
      end
    end
  end
  
  def view_journals_update_js_bottom(context={})

    wrong_new_issue_id = context[:journal].wrong_new_issue_id
    if !wrong_new_issue_id.nil?
      action_view = ActionView::Base.new(File.dirname(__FILE__) + '/../app/views/')
      action_view.render(
      :partial => "notes_error",
      :locals => {
        :wrong_new_issue_id => wrong_new_issue_id}
      ) 
    end
  end
 
end
