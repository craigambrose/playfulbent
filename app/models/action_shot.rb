# == Schema Information
#
# Table name: action_shots
#
#  id           :integer(4)      not null, primary key
#  parent_id    :integer(4)
#  content_type :string(255)
#  filename     :string(255)
#  thumbnail    :string(255)
#  size         :integer(4)
#  width        :integer(4)
#  height       :integer(4)
#  review_id    :integer(4)
#  title        :string(255)
#

class ActionShot < ActiveRecord::Base
  belongs_to :review
  has_attachment :content_type => :image, 
                 :storage => :s3, 
                 :max_size => 500.kilobytes,
                 :resize_to => '600>x1000>',
                 :thumbnails => {
                   :thumb => [73,73]
                 }

  validates_as_attachment
  validates_presence_of :review, :if => :is_parent?
  
  def display_name
    title.blank? ? "#{user.name} using the #{product.name}" : title
  end
  
  def user
    review.user
  end
  
  def product
    review.product
  end
  
  protected
  
    def is_parent?
      !parent
    end

end
