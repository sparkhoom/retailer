class Product < ActiveRecord::Base
  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
                    presence: true

  validates :image_url, allow_blank: true, format: { with: %r{\.(gif|jpg|png)\Z}i, message: 'must be a URL for GIF, JPG or PNG image.' } 

  scope :filter_by_title, lambda { |keyword|
    where("lower(title) like?", "%#{keyword.downcase}")
  }

  scope :above_or_equal_to_price, lambda { |price| 
    where("price >= ?", price) 
  }

  scope :below_or_equal_to_price, lambda { |price|
    where("price <=?", price)
  }

  scope :recent, -> {
    order(:updated_at)
  }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all

    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.above_or_equal_to_price(params[:min_price].to_f) if params[:min_price]
    products = products.below_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
    products = products.recent(params[:recent]) if params[:recent].present?

    products
  end
end
