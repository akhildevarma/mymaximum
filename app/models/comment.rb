class Comment < ActiveRecord::Base
  MAX_TREE_DEPTH = 5
  belongs_to :user
  has_many :flagged_comments
  belongs_to :referenceable, polymorphic: true
  # attr_accessor :title, :body, :referenceable_type, :referenceable_id, :user_id
  has_closure_tree order: 'created_at DESC'
  after_create :reply_comment_notification, if: Proc.new { |c| c.parent_id.present? }

  scope :active_comments, ->(comment_id) {
   where(
    id: find_by(
      { id: comment_id, deleted: false }
    ).self_and_ancestors_ids.sort
   ).
   where.not(
      id: FlaggedComment.where(comment_id: comment_id).select(:comment_id)
   ).
   hash_tree
  }

  scope :descendant_comments, ->(parent_comment_id,user_id) {
  	where(
      id: find_by({id: parent_comment_id, deleted: false}).
        self_and_descendants.
        map(&:id).sort
      ).
      where.not(id: FlaggedComment.where(user_id: user_id).select(:comment_id)).
      order(:created_at, created_at: :desc).
      hash_tree
  }

  def self.parse_emails(comments={})
		emails = []
		comments.map do |comment, nested_comments|
			emails << comment.user.email
			emails << parse_emails(nested_comments) if nested_comments.size > 0
		end
		emails.flatten.uniq
	end

	def descendants_count(user_id)
		self.descendants.where.not(id: FlaggedComment.where(user_id: user_id).select(:comment_id)).size
	end

  def max_tree_reached?
    (self.depth + 1) == MAX_TREE_DEPTH
  end

  def reference
    referenceable
  end

  private

  def reply_comment_notification
    Delayed::Job.enqueue(CommentsJob.new(self.id))
  end
end
