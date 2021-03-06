module ApplicationHelper
  def show_error_message(message = '不能为空！')
    ['<small class="error">', message, '</small>'].join.html_safe
  end

  def flash_class(type)
    { notice: 'success',
      alert:  'info',
      error:  'warning' }[type]
  end

  def form_params(parent, child)
    child.new_record? ? [parent, child] : child
  end

  def topic_info(topic)
    info = ["<small class='details'>"]
    # info << badge_for(topic.forum) unless params[:controller] == 'forums' &&
    #                                       params[:action]     == 'show'
    info << info_for(topic.user)   unless params[:controller] == 'users'
    info << time_for(topic)<< '</small>' 
    info << vote_for(topic) 
    info.join.html_safe
  end

  def event_info(event)
    info = ["<small class='details'>"]
  #  info << link_to(event.event_type, '#', class: 'badge')    
    info << info_for(event.user)   unless params[:controller] == 'users'
    info << time_for(event)<< '</small>' 
    info << vote_for(event) 
    info.join.html_safe
  end

  def comment_info(comment)
    info = ["<small class='details'>"]
    if comment.topic
      info << badge_for(comment.topic) unless params[:controller] == 'topics'
    elsif comment.event
      info << badge_for(comment.event) unless params[:controller] == 'event'
    end
    info << info_for(comment.user)   unless params[:controller] == 'users'
    info << time_for(comment)
    info << owner_buttons_for(comment) if current_user == comment.user
    info << '</small>'    
    info << vote_for(comment)
    info.join.html_safe
  end

  def participant_info(participant)
    if participant.status_pay==1
      is_paid ='已付款'
    else
      is_paid='未付款'
    end
    info = ["<small class='details'>"]
    info << link_to( is_paid, '#', class: 'badge')   
    info << info_for(participant.user)
    info << ' | 购买数量:' + participant.goods_amount.to_s + 'kg'

   #info << '参加人数' + participant.people_amount.to_s
    #info << owner_buttons_for(participant) if current_user == participant.user
    info << time_for(participant)<< '</small>' 
    info.join.html_safe
  end

  def badge_for(object)
    link_text = object.try(:title) || object.name
    link_to(link_text, object, class: 'badge')
  end

  def info_for(user)
     link_text = image_tag(user.avatar, class:'user-thumb') + ' ' + user.username 
     link_to(link_text, profile_path(user))
  end

  def time_for(object)
    ' ' + time_ago_in_words(object.created_at) + ' '+t(:before)+' '
  end

  def vote_for(object)
    ' '
    # '<a href="#"><i class="fa fa-thumbs-o-up"></i>2</a> <a href="#" style="margin-left:50px"><i class="fa fa-thumbs-o-down"></i>3</a>'
  end 

  def owner_buttons_for(comment)
    link_to('<i class="fa fa-pencil"></i>'.html_safe, edit_comment_path(comment)) + ' | ' +
    link_to('<i class="fa fa-times"></i>'.html_safe, comment, method: :delete)
  end

  def markdown(text, options= {links: true})
    render_options = {
      filter_html:     true,
      hard_wrap:       true,
      no_links:        !options[:links],
      highlight: true
    }
    renderer = Redcarpet::Render::HTML.new(render_options)

    extensions = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true,
      highlight:          true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end
end
