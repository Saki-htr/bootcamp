# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :sender, class_name: "User"

  enum kind: {
    came_comment: 0,
    checked:      1,
    mentioned:    2,
    submitted:    3,
    answered:     4,
    announced:    5
  }

  scope :unreads, -> { where(read: false).order(created_at: :desc) }

  def self.came_comment(comment, reciever, message)
    Notification.create!(
      kind:    0,
      user:    reciever,
      sender:  comment.sender,
      path:    comment.commentable.path,
      message: message,
      read:    false
    )
  end

  def self.checked(check)
    Notification.create!(
      kind:    1,
      user:    check.reciever,
      sender:  check.sender,
      path:    check.checkable.path,
      message: "#{check.sender.login_name}さんが#{check.checkable.title}を確認しました。",
      read:    false
    )
  end

  def self.mentioned(comment, reciever)
    Notification.create!(
      kind:    2,
      user:    reciever,
      sender:  comment.sender,
      path:    comment.commentable.path,
      message: "#{comment.sender.login_name}さんからメンションがきました。",
      read:    false
    )
  end

  def self.submitted(subject, reciever, message)
    Notification.create!(
      kind:    3,
      user:    reciever,
      sender:  subject.user,
      path:    subject.path,
      message: message,
      read:    false
    )
  end

  def self.came_answer(answer)
    Notification.create!(
      kind:    4,
      user:    answer.reciever,
      sender:  answer.sender,
      path:    Rails.application.routes.url_helpers.polymorphic_path(answer.question),
      message: "#{answer.user.login_name}さんから回答がありました。",
      read:    false
    )
  end

  def self.post_announcement(announce, reciever)
    Notification.create!(
      kind:    5,
      user:    reciever,
      sender:  announce.sender,
      path:    Rails.application.routes.url_helpers.polymorphic_path(announce),
      message: "#{announce.user.login_name}さんからお知らせです！",
      read:    false
    )
  end
end
