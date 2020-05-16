class SubmissionsResolver < ApplicationQuery
  property :course_id
  property :status
  property :sort_direction
  property :level_id
  property :coach_id

  def submissions
    applicable_submissions
      .includes(:startup_feedback, founders: :user, target: :target_group)
      .distinct
      .order("created_at #{sort_direction_string}")
  end

  def authorized?
    return false if current_user.faculty.blank?

    current_user.faculty.courses.where(id: course).exists?
  end

  def sort_direction_string
    case sort_direction
      when 'Ascending'
        'ASC'
      when 'Descending'
        'DESC'
      else
        raise "#{sort_direction} is not a valid sort direction"
    end
  end

  def course
    @course ||= Course.find(course_id)
  end

  def applicable_submissions
    by_level = if level_id.present?
      course.levels.where(id: level_id).first.timeline_events
    else
      course.timeline_events
    end

    by_level_and_status = case status
      when 'Pending'
        by_level.pending_review
      when 'Reviewed'
        by_level.evaluated_by_faculty
      else
        raise "Unexpected status '#{status}' encountered when resolving submissions"
    end

    by_level_status_and_coach = if coach_id.present?
      by_level_and_status.joins(founders: { startup: :faculty_startup_enrollments }).where(faculty_startup_enrollments: { faculty_id: coach_id })
    else
      by_level_and_status
    end

    by_level_status_and_coach.from_founders(students)
  end

  def students
    @students ||= Founder.where(startup_id: course.startups)
  end
end
